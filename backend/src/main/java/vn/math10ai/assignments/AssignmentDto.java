package vn.math10ai.assignments;

public record AssignmentDto(
    int id,
    Integer teacherId,
    String teacherName,
    int lessonId,
    String lessonTitle,
    String type,
    String targetType,
    String targetValue,
    String deadline,
    String note,
    String status,
    String createdAt,
    int submissionCount,
    boolean isSubmitted
) {}
