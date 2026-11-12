package vn.math10ai.questions;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
public record QuestionRequest(int lessonId,@NotBlank @Pattern(regexp="MCQ|ESSAY") String type,
        @NotBlank String text,@Size(max=1000) String optionA,@Size(max=1000) String optionB,
        @Size(max=1000) String optionC,@Size(max=1000) String optionD,
        String correctAnswer,String explanation,String solutionSteps,
        @NotBlank @Pattern(regexp="EASY|MEDIUM|HARD") String difficulty,
        @Pattern(regexp="DRAFT|PENDING_REVIEW|PUBLISHED|ARCHIVED") String status) {}
