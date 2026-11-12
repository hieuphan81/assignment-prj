package vn.math10ai.content;

import java.util.List;

public record LessonVideoDto(
        int lessonId,
        String videoId,
        String videoUrl,
        String title,
        String channel,
        List<ExtraVideo> extraVideos,
        String updatedAt
) {
    public record ExtraVideo(String videoId, String videoUrl, String title, String channel) {}
}
