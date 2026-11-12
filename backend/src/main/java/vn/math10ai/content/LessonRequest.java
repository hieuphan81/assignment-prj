package vn.math10ai.content;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
public record LessonRequest(@Min(1) int topicId, @NotBlank @Size(max=200) String title,
                            @Size(max=1000) String description, String content,
                            @Size(max=2048) String videoUrl, @Size(max=2048) String resourceUrl,
                            @Min(1) int order, String status) {}
