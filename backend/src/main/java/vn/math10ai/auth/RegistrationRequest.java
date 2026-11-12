package vn.math10ai.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegistrationRequest(@NotBlank @Size(max = 120) String fullName,
                                  @NotBlank @Size(max = 50) String username,
                                  @NotBlank @Email @Size(max = 254) String email,
                                  @NotBlank @Size(min = 6, max = 200) String password,
                                  String role) {}
