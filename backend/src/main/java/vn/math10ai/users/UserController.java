package vn.math10ai.users;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserService service;
    public UserController(UserService service) { this.service=service; }

    private SessionUser resolveCurrentUser(SessionUser user, HttpServletRequest request) {
        if (user != null) return user;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("math10.user") instanceof SessionUser su) {
            return su;
        }
        String fallback = request.getHeader("X-Auth-User");
        if (fallback != null && !fallback.isBlank()) {
            return service.list(null).stream()
                    .filter(u -> u.username().equalsIgnoreCase(fallback.trim()))
                    .findFirst()
                    .map(u -> new SessionUser(u.id(), u.username(), u.fullName(), u.role(), u.teacherId()))
                    .orElse(null);
        }
        return null;
    }

    @GetMapping("/profile")
    public UserProfileDto getProfile(@SessionAttribute(name = "math10.user", required = false) SessionUser user,
                                     HttpServletRequest request) {
        SessionUser current = resolveCurrentUser(user, request);
        if (current == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Cần đăng nhập.");
        return service.getProfile(current.id());
    }

    @PutMapping("/profile")
    public SessionUser updateProfile(@SessionAttribute(name = "math10.user", required = false) SessionUser user,
                                     @Valid @RequestBody ProfileUpdateRequest requestBody,
                                     HttpServletRequest request) {
        SessionUser current = resolveCurrentUser(user, request);
        if (current == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Cần đăng nhập.");
        UserDto updated = service.updateProfile(current.id(), requestBody);
        SessionUser updatedSession = new SessionUser(updated.id(), updated.username(), updated.fullName(), updated.role(), updated.teacherId());
        HttpSession session = request.getSession(true);
        session.setAttribute("math10.user", updatedSession);
        return updatedSession;
    }

    @GetMapping @RequireRoles({"ADMIN","TEACHER"})
    public List<UserDto> list(@SessionAttribute("math10.user") SessionUser user) { return service.list("TEACHER".equals(user.role())?user.id():null); }
    @GetMapping("/students") @RequireRoles({"ADMIN","TEACHER"})
    public List<UserDto> listStudents(@SessionAttribute("math10.user") SessionUser user) { return service.list("TEACHER".equals(user.role())?user.id():null); }
    @PostMapping @RequireRoles({"ADMIN"}) @ResponseStatus(HttpStatus.CREATED)
    public UserDto create(@Valid @RequestBody UserRequest request) { return service.create(request); }
    @PostMapping("/students") @RequireRoles({"TEACHER"}) @ResponseStatus(HttpStatus.CREATED)
    public UserDto createStudent(@SessionAttribute("math10.user") SessionUser teacher,
                                 @Valid @RequestBody StudentCreateRequest request) {
        return service.createStudent(teacher, request);
    }
    @PutMapping("/{id}") @RequireRoles({"ADMIN"})
    public UserDto update(@PathVariable int id,@Valid @RequestBody UserRequest request) { return service.update(id,request); }
    @RequestMapping(value = "/{id}/status", method = {RequestMethod.PATCH, RequestMethod.PUT, RequestMethod.POST}) @RequireRoles({"ADMIN"}) @ResponseStatus(HttpStatus.NO_CONTENT)
    public void status(@PathVariable int id,@Valid @RequestBody StatusRequest request) { service.status(id,request); }
    @PutMapping("/{id}/teacher") @RequireRoles({"ADMIN"}) @ResponseStatus(HttpStatus.NO_CONTENT)
    public void assignTeacher(@PathVariable int id,@RequestBody AssignmentRequest request){service.assignTeacher(id,request.teacherId());}
    @DeleteMapping("/{id}") @RequireRoles({"ADMIN"}) @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable int id) { service.delete(id); }
}
