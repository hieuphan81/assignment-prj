package vn.math10ai.auth;

import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AuthRepository {
    private final JdbcTemplate jdbc;
    public AuthRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    public Optional<Account> findByUsername(String username) {
        return jdbc.query("SELECT user_id, username, password_hash, full_name, role, teacher_id, status FROM dbo.USERS WHERE username = ?",
                rs -> rs.next() ? Optional.of(new Account(rs.getInt("user_id"), rs.getString("username"),
                        rs.getString("password_hash"), rs.getString("full_name"), rs.getString("role"),
                        (Integer) rs.getObject("teacher_id"), rs.getString("status"))) : Optional.empty(), username);
    }

    public record Account(int id, String username, String passwordHash, String fullName, String role,
                          Integer teacherId, String status) {}
}
