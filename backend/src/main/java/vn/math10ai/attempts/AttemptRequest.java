package vn.math10ai.attempts;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
public record AttemptRequest(@NotNull @Positive Integer questionId,@Size(max=20000) String answerText) {}
