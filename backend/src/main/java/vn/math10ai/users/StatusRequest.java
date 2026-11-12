package vn.math10ai.users;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.NotBlank;
public record StatusRequest(@NotBlank @Pattern(regexp = "ACTIVE|INACTIVE|LOCKED") String status, Integer teacherId) {}
