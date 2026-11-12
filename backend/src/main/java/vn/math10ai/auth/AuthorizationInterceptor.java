package vn.math10ai.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Component
public class AuthorizationInterceptor implements HandlerInterceptor {
    private final AuthRepository authRepository;

    public AuthorizationInterceptor(AuthRepository authRepository) {
        this.authRepository = authRepository;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        Object value = request.getSession(false) == null ? null : request.getSession(false).getAttribute(AuthController.SESSION_KEY);
        if (value == null) {
            String fallbackUser = request.getHeader("X-Auth-User");
            if (fallbackUser != null && !fallbackUser.isBlank()) {
                var found = authRepository.findByUsername(fallbackUser.trim())
                        .filter(a -> "ACTIVE".equals(a.status()))
                        .map(a -> new SessionUser(a.id(), a.username(), a.fullName(), a.role(), a.teacherId()))
                        .orElse(null);
                if (found != null) {
                    request.getSession(true).setAttribute(AuthController.SESSION_KEY, found);
                    value = found;
                }
            }
        }

        if (!(handler instanceof HandlerMethod method)) return true;
        RequireRoles requirement = method.getMethodAnnotation(RequireRoles.class);
        if (requirement == null) requirement = method.getBeanType().getAnnotation(RequireRoles.class);
        if (requirement == null) return true;

        if (!(value instanceof SessionUser user)) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Cần đăng nhập.");
        for (String role : requirement.value()) if (role.equals(user.role())) return true;
        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
    }
}
