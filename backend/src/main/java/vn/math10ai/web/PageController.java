package vn.math10ai.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Spring MVC Page Controller for rendering JSP views (PRJ301 Standard).
 */
@Controller
public class PageController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @GetMapping("/lessons")
    public String lessons() {
        return "lessons";
    }

    @GetMapping("/lesson-detail")
    public String lessonDetail() {
        return "lesson-detail";
    }

    @GetMapping("/formulas")
    public String formulas() {
        return "formulas";
    }

    @GetMapping("/practice")
    public String practice() {
        return "practice";
    }

    @GetMapping("/essay")
    public String essay() {
        return "essay";
    }

    @GetMapping("/ai-tutor")
    public String aiTutor() {
        return "ai-tutor";
    }

    @GetMapping("/history")
    public String history() {
        return "history";
    }

    @GetMapping("/progress")
    public String progress() {
        return "progress";
    }

    @GetMapping("/teacher/students")
    public String teacherStudents() {
        return "teacher-students";
    }

    @GetMapping("/teacher/questions")
    public String teacherQuestions() {
        return "teacher-questions";
    }

    @GetMapping("/admin/users")
    public String adminUsers() {
        return "admin-users";
    }

    @GetMapping("/admin/settings")
    public String adminSettings() {
        return "admin-settings";
    }
}
