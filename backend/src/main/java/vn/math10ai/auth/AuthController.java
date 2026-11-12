package vn.math10ai.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.Map;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.users.UserRequest;
import vn.math10ai.users.UserService;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    public static final String SESSION_KEY = "math10.user";
    private final AuthRepository users;
    private final UserService accountService;
    public AuthController(AuthRepository users, UserService accountService) { this.users = users; this.accountService = accountService; }

    @PostMapping("/register")
    @org.springframework.web.bind.annotation.ResponseStatus(HttpStatus.CREATED)
    public SessionUser register(@Valid @RequestBody RegistrationRequest request, HttpServletRequest servletRequest) {
        String role = "TEACHER".equalsIgnoreCase(request.role()) ? "TEACHER" : "STUDENT";
        try {
            accountService.create(new UserRequest(request.username(), request.password(), request.fullName(),
                    request.email(), role, null));
        } catch (DuplicateKeyException ex) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Tên đăng nhập hoặc email đã được sử dụng.");
        }
        return login(new LoginRequest(request.username(), request.password()), servletRequest);
    }

    @PostMapping("/login")
    public SessionUser login(@Valid @RequestBody LoginRequest request, HttpServletRequest servletRequest) {
        var account = users.findByUsername(request.username().trim())
                .filter(a -> "ACTIVE".equals(a.status()))
                .filter(a -> a.passwordHash() != null && a.passwordHash().startsWith("$2")
                        && BCrypt.checkpw(request.password(), a.passwordHash()))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Tên đăng nhập hoặc mật khẩu không đúng."));
        HttpSession previous = servletRequest.getSession(false);
        if (previous != null) previous.invalidate();
        HttpSession session = servletRequest.getSession(true);
        SessionUser user = new SessionUser(account.id(), account.username(), account.fullName(), account.role(), account.teacherId());
        session.setAttribute(SESSION_KEY, user);
        session.setMaxInactiveInterval(60 * 60 * 4);
        return user;
    }

    @GetMapping("/me")
    public SessionUser me(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session != null ? session.getAttribute(SESSION_KEY) : null;
        if (user instanceof SessionUser current) return current;
        String fallback = request.getHeader("X-Auth-User");
        if (fallback != null && !fallback.isBlank()) {
            return users.findByUsername(fallback.trim())
                    .filter(a -> "ACTIVE".equals(a.status()))
                    .map(a -> {
                        SessionUser su = new SessionUser(a.id(), a.username(), a.fullName(), a.role(), a.teacherId());
                        request.getSession(true).setAttribute(SESSION_KEY, su);
                        return su;
                    })
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Cần đăng nhập."));
        }
        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Cần đăng nhập.");
    }

    @PostMapping("/logout")
    public Map<String, String> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        return Map.of("message", "Đã đăng xuất.");
    }
}
