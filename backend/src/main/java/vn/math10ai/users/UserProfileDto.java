package vn.math10ai.users;

public record UserProfileDto(int id, String username, String fullName, String email, String role,
                             Integer teacherId, String teacherName, String status, String createdAt) {}
