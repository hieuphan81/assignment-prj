package vn.math10ai.assignments;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AssignmentRequest(
    @NotNull Integer lessonId,
    @NotBlank String lessonTitle,
    String type,
    String targetType,
    String targetValue,
    @NotBlank String deadline,
    String note
) {}
