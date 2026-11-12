package vn.math10ai.users;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.SessionUser;

@Service
public class UserService {
    private final UserRepository repository;
    private final JdbcTemplate jdbc;
    public UserService(UserRepository repository, JdbcTemplate jdbc) { this.repository=repository; this.jdbc=jdbc; }
    public List<UserDto> list(Integer teacherId) { return teacherId == null ? repository.listAll() : repository.studentsOf(teacherId); }
    public UserDto create(UserRequest request) {
        validateTeacher(request.role(), request.teacherId());
        int id=repository.insert(request, BCrypt.hashpw(request.password(), BCrypt.gensalt(12)));
        return list(null).stream().filter(u->u.id()==id).findFirst().orElseThrow();
    }
    public UserDto createStudent(SessionUser teacher, StudentCreateRequest request) {
        UserRequest student = new UserRequest(request.username(), request.password(), request.fullName(),
                request.email(), "STUDENT", teacher.id());
        return create(student);
    }
    public UserDto update(int id, UserRequest request) {
        validateTeacher(request.role(), request.teacherId());
        if(repository.update(id,request,BCrypt.hashpw(request.password(),BCrypt.gensalt(12)))==0)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy tài khoản.");
        return list(null).stream().filter(u->u.id()==id).findFirst().orElseThrow();
    }
    public void status(int id, StatusRequest request) {
        if("STUDENT".equals(jdbc.query("SELECT role FROM dbo.USERS WHERE user_id=?", rs->rs.next()?rs.getString(1):null,id)) && request.teacherId()!=null)
            requireTeacher(request.teacherId());
        if(repository.updateStatusAndTeacher(id,request)==0)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy tài khoản.");
    }
    public void assignTeacher(int studentId,Integer teacherId){if(teacherId!=null)requireTeacher(teacherId);if(repository.assignTeacher(studentId,teacherId)==0)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy học sinh.");}

    public UserProfileDto getProfile(int id) {
        UserProfileDto profile = repository.getProfile(id);
        if (profile == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy hồ sơ người dùng.");
        return profile;
    }

    public UserDto updateProfile(int id, ProfileUpdateRequest request) {
        String hash = null;
        if (request.password() != null && !request.password().isBlank()) {
            if (request.password().trim().length() < 6) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mật khẩu mới phải có ít nhất 6 ký tự.");
            }
            hash = BCrypt.hashpw(request.password().trim(), BCrypt.gensalt(12));
        }
        if (repository.updateProfile(id, request.fullName(), request.email(), hash) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy tài khoản để cập nhật.");
        }
        return list(null).stream().filter(u -> u.id() == id).findFirst().orElseThrow();
    }
    public void delete(int id) {
        if (repository.delete(id) == 0) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng để xóa.");
    }
    private void validateTeacher(String role,Integer teacherId){ if("STUDENT".equals(role)&&teacherId!=null)requireTeacher(teacherId); }
    private void requireTeacher(int id){
        Boolean activeTeacher=jdbc.queryForObject(
                "SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.USERS WHERE user_id=? AND role='TEACHER' AND status='ACTIVE') THEN 1 ELSE 0 END AS BIT)",
                Boolean.class,id);
        if(!Boolean.TRUE.equals(activeTeacher))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Giáo viên phụ trách không hợp lệ.");
    }
}
