package vn.math10ai.users;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserRepository {
    private final JdbcTemplate jdbc;
    public UserRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }
    private static final org.springframework.jdbc.core.RowMapper<UserDto> MAPPER = (rs, n) -> new UserDto(
            rs.getInt("user_id"), rs.getString("username"), rs.getString("full_name"), rs.getString("email"),
            rs.getString("role"), (Integer) rs.getObject("teacher_id"), rs.getString("status"));
    private static final String COLUMNS = "user_id, username, full_name, email, role, teacher_id, status";
    public List<UserDto> listAll() { return jdbc.query("SELECT " + COLUMNS + " FROM dbo.USERS ORDER BY role, full_name", MAPPER); }
    public List<UserDto> studentsOf(int teacherId) { return jdbc.query("SELECT " + COLUMNS + " FROM dbo.USERS WHERE role='STUDENT' AND teacher_id=? ORDER BY full_name", MAPPER, teacherId); }
    public int insert(UserRequest u, String hash) {
        return jdbc.queryForObject("INSERT dbo.USERS(username,password_hash,full_name,email,role,teacher_id,status) OUTPUT INSERTED.user_id VALUES(?,?,?,?,?,?, 'ACTIVE')",
                Integer.class, u.username().trim(), hash, u.fullName().trim(), u.email().trim(), u.role(), u.role().equals("STUDENT") ? u.teacherId() : null);
    }
    public int update(int id, UserRequest u, String hash) {
        return jdbc.update("UPDATE dbo.USERS SET username=?,password_hash=?,full_name=?,email=?,role=?,teacher_id=? WHERE user_id=?",
                u.username().trim(), hash, u.fullName().trim(), u.email().trim(), u.role(), u.role().equals("STUDENT") ? u.teacherId() : null, id);
    }
    public int updateStatusAndTeacher(int id, StatusRequest request) {
        return jdbc.update("UPDATE dbo.USERS SET status=?,teacher_id=CASE WHEN role='STUDENT' THEN COALESCE(?,teacher_id) ELSE NULL END WHERE user_id=?",
                request.status(), request.teacherId(), id);
    }
    public int assignTeacher(int studentId,Integer teacherId){return jdbc.update("UPDATE dbo.USERS SET teacher_id=? WHERE user_id=? AND role='STUDENT'",teacherId,studentId);}

    public UserProfileDto getProfile(int id) {
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.role, u.teacher_id, "
                + "t.full_name AS teacher_name, u.status, CONVERT(VARCHAR(19), u.created_at, 120) AS created_at "
                + "FROM dbo.USERS u "
                + "LEFT JOIN dbo.USERS t ON u.teacher_id = t.user_id "
                + "WHERE u.user_id = ?";
        return jdbc.query(sql, (rs, n) -> new UserProfileDto(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("role"),
                (Integer) rs.getObject("teacher_id"),
                rs.getString("teacher_name"),
                rs.getString("status"),
                rs.getString("created_at")
        ), id).stream().findFirst().orElse(null);
    }

    public int updateProfile(int id, String fullName, String email, String passwordHash) {
        if (passwordHash != null && !passwordHash.isBlank()) {
            return jdbc.update("UPDATE dbo.USERS SET full_name = ?, email = COALESCE(NULLIF(?, ''), email), password_hash = ? WHERE user_id = ?",
                    fullName.trim(), email != null ? email.trim() : null, passwordHash, id);
        } else {
            return jdbc.update("UPDATE dbo.USERS SET full_name = ?, email = COALESCE(NULLIF(?, ''), email) WHERE user_id = ?",
                    fullName.trim(), email != null ? email.trim() : null, id);
        }
    }
    public int delete(int id) {
        Integer fallbackAdmin = jdbc.query("SELECT TOP 1 user_id FROM dbo.USERS WHERE role='ADMIN' AND user_id != ?", rs -> rs.next() ? rs.getInt(1) : null, id);
        jdbc.update("UPDATE dbo.USERS SET teacher_id = NULL WHERE teacher_id = ?", id);
        jdbc.update("DELETE FROM dbo.ATTEMPTS WHERE student_id = ?", id);
        if (fallbackAdmin != null) {
            jdbc.update("UPDATE dbo.TOPICS SET created_by = ? WHERE created_by = ?", fallbackAdmin, id);
            jdbc.update("UPDATE dbo.LESSONS SET teacher_id = ? WHERE teacher_id = ?", fallbackAdmin, id);
            jdbc.update("UPDATE dbo.QUESTIONS SET created_by = ? WHERE created_by = ?", fallbackAdmin, id);
        }
        jdbc.update("UPDATE dbo.QUESTIONS SET reviewed_by = NULL WHERE reviewed_by = ?", id);
        return jdbc.update("DELETE FROM dbo.USERS WHERE user_id = ?", id);
    }
}
