package vn.math10ai.content;

import jakarta.validation.constraints.Size;
import java.util.List;

public record LessonVideoRequest(
        @Size(max = 2048) String videoUrl,
        @Size(max = 50) String videoId,
        @Size(max = 300) String title,
        @Size(max = 150) String channel,
        List<LessonVideoDto.ExtraVideo> extraVideos,
        Boolean resetToDefault
) {}
