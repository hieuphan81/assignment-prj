package vn.math10ai.users;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UserRequest(@NotBlank @Size(max = 50) String username,
    @NotBlank @Size(min = 6, max = 200) String password,
                          @NotBlank @Size(max = 120) String fullName,
                          @NotBlank @Email @Size(max = 254) String email,
                          @NotBlank @Pattern(regexp = "ADMIN|TEACHER|STUDENT") String role,
                          Integer teacherId) {}
