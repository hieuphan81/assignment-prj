package vn.math10ai.users;
public record UserDto(int id, String username, String fullName, String email, String role,
                      Integer teacherId, String status) {}
