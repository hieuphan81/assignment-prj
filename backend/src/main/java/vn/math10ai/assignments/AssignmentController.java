package vn.math10ai.assignments;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;

@RestController
@RequestMapping("/api/v1/assignments")
public class AssignmentController {
    private final AssignmentRepository repository;

    public AssignmentController(AssignmentRepository repository) {
        this.repository = repository;
    }

    @PostMapping
    @RequireRoles({"TEACHER", "ADMIN"})
    @ResponseStatus(HttpStatus.CREATED)
    public AssignmentDto create(@SessionAttribute("math10.user") SessionUser user, @Valid @RequestBody AssignmentRequest request) {
        int id = repository.create(user.id(), request);
        return new AssignmentDto(id, user.id(), user.fullName(), request.lessonId(), request.lessonTitle(),
            request.type() != null ? request.type() : "ALL",
            request.targetType() != null ? request.targetType() : "ALL",
            request.targetValue() != null ? request.targetValue() : "all",
            request.deadline(), request.note(), "ACTIVE", "Vừa xong", 0, false);
    }

    @GetMapping("/teacher")
    @RequireRoles({"TEACHER", "ADMIN"})
    public List<AssignmentDto> listTeacher(@SessionAttribute("math10.user") SessionUser user) {
        return repository.listForTeacher(user.id());
    }

    @GetMapping("/student")
    @RequireRoles({"STUDENT", "TEACHER", "ADMIN"})
    public List<AssignmentDto> listStudent(@SessionAttribute("math10.user") SessionUser user) {
        return repository.listForStudent(user.id(), user.username(), user.teacherId());
    }

    @DeleteMapping("/{id}")
    @RequireRoles({"TEACHER", "ADMIN"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable int id, @SessionAttribute("math10.user") SessionUser user) {
        repository.delete(id, user.id());
    }

    @PostMapping("/{id}/submit")
    @RequireRoles({"STUDENT"})
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void submit(@PathVariable int id, @SessionAttribute("math10.user") SessionUser user, @RequestParam(required = false) Double score) {
        repository.submit(id, user.id(), user.username(), score);
    }
}
