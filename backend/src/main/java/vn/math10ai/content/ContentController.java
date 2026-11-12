package vn.math10ai.content;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;

@RestController
@RequestMapping("/api/v1")
public class ContentController {
    private final ContentService service;

    public ContentController(ContentService service) { this.service = service; }

    @GetMapping("/topics")
    public List<TopicDto> topics() { return service.topics(); }

    @GetMapping("/lessons")
    public List<LessonDto> lessons(@RequestParam(required = false) Integer topicId) {
        return service.publishedLessons(topicId);
    }

    @GetMapping("/manage/topics") @RequireRoles({"ADMIN","TEACHER"})
    public List<TopicDto> managedTopics(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user){return service.managedTopics(user);}
    @PostMapping("/topics") @RequireRoles({"ADMIN","TEACHER"}) @org.springframework.web.bind.annotation.ResponseStatus(HttpStatus.CREATED)
    public TopicDto createTopic(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user,@Valid @RequestBody TopicRequest body){return service.createTopic(user,body);}
    @PutMapping("/topics/{id}") @RequireRoles({"ADMIN","TEACHER"})
    public TopicDto updateTopic(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user,@PathVariable int id,@Valid @RequestBody TopicRequest body){return service.updateTopic(user,id,body);}
    @GetMapping("/manage/lessons") @RequireRoles({"ADMIN","TEACHER"})
    public List<LessonDto> managedLessons(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user){return service.managedLessons(user);}
    @PostMapping("/lessons") @RequireRoles({"ADMIN","TEACHER"}) @org.springframework.web.bind.annotation.ResponseStatus(HttpStatus.CREATED)
    public LessonDto createLesson(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user,@Valid @RequestBody LessonRequest body){return service.createLesson(user,body);}
    @PutMapping("/lessons/{id}") @RequireRoles({"ADMIN","TEACHER"})
    public LessonDto updateLesson(@org.springframework.web.bind.annotation.SessionAttribute("math10.user") SessionUser user,@PathVariable int id,@Valid @RequestBody LessonRequest body){return service.updateLesson(user,id,body);}

    @GetMapping("/lessons/videos")
    public java.util.Map<Integer, LessonVideoDto> lessonVideos() {
        return service.getCustomLessonVideos();
    }

    @PutMapping("/lessons/{id}/video")
    @RequireRoles({"ADMIN"})
    public LessonVideoDto updateLessonVideo(@PathVariable int id, @Valid @RequestBody LessonVideoRequest body) {
        return service.updateLessonVideo(id, body);
    }
}
