package vn.math10ai.content;

public record LessonDto(int id, int topicId, String title, String description, String content,
                        String videoUrl, String resourceUrl, int order) {}
