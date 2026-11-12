package vn.math10ai.content;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.SessionUser;

@Service
public class ContentService {
    private static final Pattern YT_ID_PATTERN = Pattern.compile(
            "(?:youtube\\.com/(?:watch\\?(?:.*&)?v=|embed/|v/|shorts/|live/)|youtu\\.be/)([A-Za-z0-9_-]{11})|^([A-Za-z0-9_-]{11})$");

    private final ContentRepository repository;
    private final ObjectMapper json;
    private final Path videoStorePath;

    public ContentService(ContentRepository repository, ObjectMapper json,
                          @Value("${math10.upload-dir:./private-uploads}") String uploadDir) {
        this.repository = repository;
        this.json = json;
        this.videoStorePath = Path.of(uploadDir, "lesson-videos.json");
    }

    public List<TopicDto> topics() { return repository.findActiveTopics(); }
    public List<LessonDto> publishedLessons(Integer topicId) { return repository.findPublishedLessons(topicId); }
    public List<TopicDto> managedTopics(SessionUser user){return repository.findManagedTopics(user.id(),"ADMIN".equals(user.role()));}
    public List<LessonDto> managedLessons(SessionUser user){return repository.findManagedLessons(user.id(),"ADMIN".equals(user.role()));}
    public TopicDto createTopic(SessionUser user,TopicRequest request){checkTopicRequest(request);int id=repository.insertTopic(user.id(),request);return managedTopics(user).stream().filter(t->t.id()==id).findFirst().orElseThrow();}
    public TopicDto updateTopic(SessionUser user,int id,TopicRequest request){checkTopicRequest(request);if(repository.updateTopic(id,user.id(),"ADMIN".equals(user.role()),request)==0)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy chủ đề hoặc không có quyền sửa.");return managedTopics(user).stream().filter(t->t.id()==id).findFirst().orElseThrow();}
    public LessonDto createLesson(SessionUser user,LessonRequest request){validateLesson(user,request);int id=repository.insertLesson(user.id(),request);return managedLessons(user).stream().filter(l->l.id()==id).findFirst().orElseThrow();}
    public LessonDto updateLesson(SessionUser user,int id,LessonRequest request){validateLesson(user,request);if(repository.updateLesson(id,user.id(),"ADMIN".equals(user.role()),request)==0)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy bài học hoặc không có quyền sửa.");return managedLessons(user).stream().filter(l->l.id()==id).findFirst().orElseThrow();}

    public synchronized Map<Integer, LessonVideoDto> getCustomLessonVideos() {
        Map<Integer, LessonVideoDto> result = new LinkedHashMap<>(readVideoStore());
        // Merge DB video_url if present and not overridden in store
        try {
            for (LessonDto lesson : repository.findPublishedLessons(null)) {
                if (lesson.videoUrl() != null && !lesson.videoUrl().isBlank() && !result.containsKey(lesson.id())) {
                    String ytId = extractYouTubeId(lesson.videoUrl());
                    if (ytId != null) {
                        result.put(lesson.id(), new LessonVideoDto(
                                lesson.id(), ytId, "https://www.youtube.com/watch?v=" + ytId,
                                lesson.title(), null, List.of(), null
                        ));
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return result;
    }

    public synchronized LessonVideoDto updateLessonVideo(int lessonId, LessonVideoRequest req) {
        Map<Integer, LessonVideoDto> store = readVideoStore();
        if (Boolean.TRUE.equals(req.resetToDefault())) {
            store.remove(lessonId);
            writeVideoStore(store);
            repository.updateLessonVideoUrl(lessonId, null);
            return new LessonVideoDto(lessonId, null, null, null, null, List.of(), Instant.now().toString());
        }

        String rawInput = (req.videoUrl() != null && !req.videoUrl().isBlank()) ? req.videoUrl().trim() : req.videoId();
        String primaryVideoId = null;
        String primaryVideoUrl = null;
        if (rawInput != null && !rawInput.isBlank()) {
            primaryVideoId = extractYouTubeId(rawInput);
            if (primaryVideoId == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Link YouTube không hợp lệ. Vui lòng nhập link youtube.com, youtu.be hoặc mã ID 11 ký tự.");
            }
            primaryVideoUrl = "https://www.youtube.com/watch?v=" + primaryVideoId;
        }

        List<LessonVideoDto.ExtraVideo> cleanExtras = new ArrayList<>();
        if (req.extraVideos() != null) {
            for (LessonVideoDto.ExtraVideo ev : req.extraVideos()) {
                if (ev == null) continue;
                String evRaw = (ev.videoUrl() != null && !ev.videoUrl().isBlank()) ? ev.videoUrl().trim() : ev.videoId();
                if (evRaw == null || evRaw.isBlank()) continue;
                String evId = extractYouTubeId(evRaw);
                if (evId == null) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Link YouTube bổ sung không hợp lệ: " + evRaw);
                }
                cleanExtras.add(new LessonVideoDto.ExtraVideo(
                        evId,
                        "https://www.youtube.com/watch?v=" + evId,
                        ev.title() != null ? ev.title().trim() : "",
                        ev.channel() != null ? ev.channel().trim() : ""
                ));
            }
        }

        String title = req.title() != null ? req.title().trim() : "";
        String channel = req.channel() != null ? req.channel().trim() : "";

        // If completely cleared and no extras, revert to default
        if (primaryVideoId == null && cleanExtras.isEmpty()) {
            store.remove(lessonId);
            writeVideoStore(store);
            repository.updateLessonVideoUrl(lessonId, null);
            return new LessonVideoDto(lessonId, null, null, null, null, List.of(), Instant.now().toString());
        }

        LessonVideoDto saved = new LessonVideoDto(
                lessonId,
                primaryVideoId,
                primaryVideoUrl,
                title,
                channel,
                cleanExtras,
                Instant.now().toString()
        );
        store.put(lessonId, saved);
        writeVideoStore(store);
        repository.updateLessonVideoUrl(lessonId, primaryVideoUrl);
        return saved;
    }

    private String extractYouTubeId(String input) {
        if (input == null) return null;
        Matcher m = YT_ID_PATTERN.matcher(input.trim());
        if (m.find()) {
            return m.group(1) != null ? m.group(1) : m.group(2);
        }
        return null;
    }

    private Map<Integer, LessonVideoDto> readVideoStore() {
        try {
            if (!Files.exists(videoStorePath)) return new LinkedHashMap<>();
            Map<Integer, LessonVideoDto> loaded = json.readValue(videoStorePath.toFile(), new TypeReference<>() {});
            return loaded != null ? loaded : new LinkedHashMap<>();
        } catch (IOException e) {
            return new LinkedHashMap<>();
        }
    }

    private void writeVideoStore(Map<Integer, LessonVideoDto> store) {
        try {
            if (videoStorePath.getParent() != null) {
                Files.createDirectories(videoStorePath.getParent());
            }
            json.writerWithDefaultPrettyPrinter().writeValue(videoStorePath.toFile(), store);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Không thể lưu cấu hình video bài học.");
        }
    }

    private void checkTopicRequest(TopicRequest r){if(r.status()!=null&&!Set.of("ACTIVE","INACTIVE").contains(r.status()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Trạng thái chủ đề không hợp lệ.");}
    private void validateLesson(SessionUser user,LessonRequest r){boolean admin="ADMIN".equals(user.role());if(!repository.ownsTopic(r.topicId(),user.id(),admin))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Chủ đề không tồn tại hoặc bạn không có quyền sử dụng.");if(r.status()!=null&&!Set.of("DRAFT","PUBLISHED","ARCHIVED").contains(r.status()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Trạng thái bài học không hợp lệ.");validateUrl(r.videoUrl());validateUrl(r.resourceUrl());}
    private void validateUrl(String value){if(value==null||value.isBlank())return;try{String scheme=URI.create(value).getScheme();if(!"http".equalsIgnoreCase(scheme)&&!"https".equalsIgnoreCase(scheme))throw new IllegalArgumentException();}catch(Exception ex){throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Đường dẫn tài liệu/video phải dùng HTTP hoặc HTTPS.");}}
}
