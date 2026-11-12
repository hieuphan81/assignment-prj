package vn.math10ai.content;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
public record TopicRequest(@NotBlank @Size(max=160) String name, @Size(max=1000) String description,
                           @Min(1) int order, String status) {}
