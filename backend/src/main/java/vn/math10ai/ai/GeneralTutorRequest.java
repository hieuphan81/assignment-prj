package vn.math10ai.ai;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
public record GeneralTutorRequest(@NotBlank @Size(max=10000) String question,
        @Size(max=10000) String studentInput,@Size(max=30000) String previousTurns,
        @Min(1) @Max(20) int stepNumber,
        @Pattern(regexp="image/(jpeg|png|webp)") String imageMimeType,
        @Size(max=7000000) String imageBase64) {}
