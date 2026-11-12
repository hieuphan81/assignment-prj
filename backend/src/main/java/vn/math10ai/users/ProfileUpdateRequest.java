package vn.math10ai.users;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ProfileUpdateRequest(
    @NotBlank(message = "Họ và tên không được để trống")
    @Size(min = 2, max = 120, message = "Họ và tên từ 2 đến 120 ký tự")
    String fullName,

    String email,

    String password
) {}
