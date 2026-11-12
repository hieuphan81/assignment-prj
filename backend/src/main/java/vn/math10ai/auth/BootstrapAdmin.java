package vn.math10ai.auth;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Component;

@Component
public class BootstrapAdmin implements CommandLineRunner {
 private final JdbcTemplate jdbc;
 @Value("${math10.bootstrap.username:}") private String username;
 @Value("${math10.bootstrap.password:}") private String password;
 @Value("${math10.bootstrap.name:Quản trị hệ thống}") private String fullName;
 @Value("${math10.bootstrap.email:admin@math10.local}") private String email;
 public BootstrapAdmin(JdbcTemplate jdbc){this.jdbc=jdbc;}
 @Override public void run(String... args){if(username==null||username.isBlank()||password==null||password.length()<12)return;Integer count=jdbc.queryForObject("SELECT COUNT(*) FROM dbo.USERS WHERE username=?",Integer.class,username.trim());if(count!=null&&count==0)jdbc.update("INSERT dbo.USERS(username,password_hash,full_name,email,role,status) VALUES(?,?,?,?, 'ADMIN','ACTIVE')",username.trim(),BCrypt.hashpw(password,BCrypt.gensalt(12)),fullName,email);}
}
