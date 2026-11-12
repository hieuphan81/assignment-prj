package vn.math10ai.auth;

public record SessionUser(int id, String username, String fullName, String role, Integer teacherId) {
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getFullName() { return fullName; }
    public String getRole() { return role; }
    public Integer getTeacherId() { return teacherId; }
    public String getInitial() {
        if (fullName == null || fullName.isBlank()) return "U";
        return fullName.trim().substring(0, 1).toUpperCase();
    }
}
