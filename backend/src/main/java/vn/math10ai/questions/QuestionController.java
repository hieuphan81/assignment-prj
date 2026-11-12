package vn.math10ai.questions;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;

@RestController
@RequestMapping("/api/v1")
public class QuestionController {
    private final QuestionService service;

    public QuestionController(QuestionService service) {
        this.service = service;
    }

    @GetMapping("/lessons/{lessonId}/questions")
    public List<PracticeQuestionDto> practice(@PathVariable int lessonId) {
        return service.practice(lessonId);
    }

    @GetMapping("/manage/questions")
    @RequireRoles({"ADMIN", "TEACHER"})
    public List<QuestionDto> manage(@SessionAttribute(value = "math10.user", required = false) SessionUser user) {
        return service.manage(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null));
    }

    @PostMapping("/questions")
    @RequireRoles({"ADMIN", "TEACHER"})
    @ResponseStatus(HttpStatus.CREATED)
    public QuestionDto create(@SessionAttribute(value = "math10.user", required = false) SessionUser user, @Valid @RequestBody QuestionRequest body) {
        return service.create(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null), body);
    }

    @PutMapping("/questions/{id}")
    @RequireRoles({"ADMIN", "TEACHER"})
    public QuestionDto update(@SessionAttribute(value = "math10.user", required = false) SessionUser user, @PathVariable int id, @Valid @RequestBody QuestionRequest body) {
        return service.update(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null), id, body);
    }

    @PostMapping("/questions/{id}/publish")
    @RequireRoles({"ADMIN", "TEACHER"})
    public QuestionDto publish(@SessionAttribute(value = "math10.user", required = false) SessionUser user, @PathVariable int id) {
        return service.publish(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null), id);
    }

    @DeleteMapping("/questions/{id}")
    @RequireRoles({"ADMIN", "TEACHER"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@SessionAttribute(value = "math10.user", required = false) SessionUser user, @PathVariable int id) {
        service.delete(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null), id);
    }

    @PostMapping("/questions/generate")
    @RequireRoles({"TEACHER", "ADMIN"})
    public List<QuestionDto> generate(@SessionAttribute(value = "math10.user", required = false) SessionUser user, @Valid @RequestBody GenerateRequest body) {
        return service.generate(user != null ? user : new SessionUser(2, "demo.teacher", "Giáo viên", "TEACHER", null), body);
    }
}
