package vn.math10ai.progress;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;
@RestController @RequestMapping("/api/v1/progress")
public class ProgressController {
 private final ProgressRepository repository;
 public ProgressController(ProgressRepository repository){
     this.repository = repository;
 }
 
 @GetMapping("/mine")
 @RequireRoles({"STUDENT", "TEACHER", "ADMIN"})
 public Map<String, Object> mine(@SessionAttribute("math10.user") SessionUser user) {
     if ("TEACHER".equalsIgnoreCase(user.role())) {
         List<ProgressSummary> students = repository.students(user.id());
         int totalAttempts = students.stream().mapToInt(ProgressSummary::attempts).sum();
         long totalCorrect = students.stream().mapToLong(ProgressSummary::correct).sum();
         double avgScore = students.isEmpty() ? 0.0 : students.stream().mapToDouble(ProgressSummary::averageScore).average().orElse(0.0);
         double accuracyRate = totalAttempts == 0 ? 0.0 : (100.0 * totalCorrect / totalAttempts);
         ProgressSummary teacherSummary = new ProgressSummary(user.id(), user.fullName(), totalAttempts, totalCorrect, accuracyRate, avgScore);
         return Map.of(
             "role", "TEACHER",
             "summary", teacherSummary,
             "studentCount", students.size(),
             "students", students
         );
     }
     if ("ADMIN".equalsIgnoreCase(user.role())) {
         ProgressSummary global = repository.global();
         return Map.of(
             "role", "ADMIN",
             "summary", global != null ? global : new ProgressSummary(0, "Toàn hệ thống", 0, 0L, 0.0, 0.0)
         );
     }
     ProgressSummary studentSummary = repository.student(user.id());
     return Map.of(
         "role", "STUDENT",
         "summary", studentSummary != null ? studentSummary : new ProgressSummary(user.id(), user.fullName(), 0, 0L, 0.0, 0.0),
         "topics", repository.topics(user.id())
     );
 }

 @GetMapping("/students")
 @RequireRoles({"TEACHER", "ADMIN"})
 public List<ProgressSummary> students(@SessionAttribute("math10.user") SessionUser user) {
     return repository.students(user.id());
 }

 @GetMapping
 @RequireRoles({"ADMIN"})
 public ProgressSummary global() {
     return repository.global();
 }
}
