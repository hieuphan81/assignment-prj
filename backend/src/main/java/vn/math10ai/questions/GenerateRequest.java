package vn.math10ai.questions;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
public record GenerateRequest(int lessonId,@Pattern(regexp="MCQ|ESSAY") String type,
 @Pattern(regexp="EASY|MEDIUM|HARD") String difficulty,@Min(1) @Max(10) int count,
 @Size(max=1000) String instructions) {}
