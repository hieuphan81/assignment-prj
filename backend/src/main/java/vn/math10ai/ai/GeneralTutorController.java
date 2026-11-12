package vn.math10ai.ai;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.attempts.AttemptRepository;
import vn.math10ai.auth.AuthRepository;

@RestController
@RequestMapping("/api/v1/tutor")
public class GeneralTutorController {
    private final AiProviderClient ai;
    private final ObjectMapper json;
    private final AuthRepository authRepository;
    private final AttemptRepository attemptRepository;
    private final JdbcTemplate jdbc;

    public GeneralTutorController(AiProviderClient ai, ObjectMapper json,
                                  AuthRepository authRepository,
                                  AttemptRepository attemptRepository,
                                  JdbcTemplate jdbc) {
        this.ai = ai;
        this.json = json;
        this.authRepository = authRepository;
        this.attemptRepository = attemptRepository;
        this.jdbc = jdbc;
    }

    private int getOrCreateTutorQuestionId() {
        try {
            Integer found = jdbc.query("SELECT TOP 1 question_id FROM dbo.QUESTIONS WHERE question_text LIKE N'%Gia sư AI%' AND question_type='ESSAY'", r -> r.next() ? r.getInt(1) : null);
            if (found != null) return found;
            return jdbc.queryForObject("INSERT dbo.QUESTIONS(lesson_id,created_by,source,question_type,question_text,difficulty,status) OUTPUT INSERTED.question_id VALUES(1,4,'AI','ESSAY',N'Gia sư AI Toán 10 — Hướng dẫn giải toán theo yêu cầu','EASY','PUBLISHED')", Integer.class);
        } catch (Exception ex) {
            try {
                return jdbc.query("SELECT TOP 1 question_id FROM dbo.QUESTIONS WHERE status='PUBLISHED'", r -> r.next() ? r.getInt(1) : 4);
            } catch (Exception e2) {
                return 4;
            }
        }
    }

    @PostMapping("/ask")
    public GeneralTutorResponse ask(@Valid @RequestBody GeneralTutorRequest request,
                                    @RequestHeader(value = "X-Auth-User", required = false) String authUser) {
        boolean finalStep = true;
        String defaultSystem = "Bạn là gia sư dạy Toán lớp 10 tận tâm, thông thái bằng tiếng Việt. "
                + "Nhiệm vụ của bạn là giải thích và hướng dẫn học sinh giải bài toán từng bước rõ ràng. "
                + "Hãy dùng ký hiệu toán học LaTeX chuẩn xác: dùng \\( ... \\) cho công thức inline và \\[ ... \\] cho công thức khối dòng riêng. "
                + "Trình bày trực tiếp, trang nhã bằng Markdown theo cấu trúc:\n"
                + "### 1. Phương pháp giải và Công thức\n"
                + "### 2. Lời giải chi tiết từng bước\n"
                + "### 3. Kết luận\n"
                + "Khuyến khích học sinh và gợi mở để học sinh tự tin học tập. Tuyệt đối KHÔNG trả về định dạng JSON, chỉ trả về nội dung bài giảng Markdown.";
        String system = (ai.getStepPrompt() != null && !ai.getStepPrompt().isBlank())
                ? ai.getStepPrompt()
                : defaultSystem;

        StringBuilder userPrompt = new StringBuilder();
        if (request.previousTurns() != null && !request.previousTurns().isBlank()) {
            userPrompt.append("Lịch sử trao đổi trước đó:\n").append(request.previousTurns()).append("\n\n");
        }
        userPrompt.append("Đề bài / Câu hỏi của học sinh:\n").append(request.question());
        if (request.studentInput() != null && !request.studentInput().isBlank()) {
            userPrompt.append("\n\nÝ kiến / Bước làm tiếp theo của học sinh:\n").append(request.studentInput());
        }
        userPrompt.append("\n\nHãy hướng dẫn phương pháp và đưa ra lời giải thích chi tiết, dễ hiểu nhất cho học sinh.");

        try {
            boolean hasMime = request.imageMimeType() != null && !request.imageMimeType().isBlank();
            boolean hasImage = request.imageBase64() != null && !request.imageBase64().isBlank();
            if (hasMime != hasImage) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Thiếu dữ liệu ảnh đề bài.");
            }
            if (hasImage) {
                try {
                    if (java.util.Base64.getDecoder().decode(request.imageBase64()).length > 5 * 1024 * 1024) {
                        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ảnh đề bài tối đa 5 MB.");
                    }
                } catch (IllegalArgumentException ex) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Dữ liệu ảnh không hợp lệ.");
                }
            }

            String answer = hasImage
                    ? ai.completeWithImage(system, userPrompt.toString(), request.imageMimeType(), request.imageBase64())
                    : ai.complete(system, userPrompt.toString());

            String raw = answer.replaceAll("(?s)^```(?:json)?\\s*|\\s*```$", "").trim();
            String message = raw;
            String action = "FINAL_SOLUTION";
            Boolean correct = null;

            // Handle accidental JSON format from AI
            if (raw.startsWith("{") && raw.contains("\"message\"")) {
                try {
                    var node = json.readTree(raw);
                    if (node.isObject() && node.has("message") && !node.path("message").asText().isBlank()) {
                        message = node.path("message").asText();
                        if (node.has("action")) action = node.path("action").asText("FINAL_SOLUTION");
                        if (node.has("correct") && node.path("correct").isBoolean()) correct = node.path("correct").asBoolean();
                    }
                } catch (Exception ex) {
                    Matcher m = Pattern.compile("\"message\"\\s*:\\s*\"([\\s\\S]*?)\"(?:\\s*\\}|,\\s*\"[a-zA-Z0-9_-]+\")").matcher(raw);
                    if (m.find()) {
                        message = m.group(1).replace("\\n", "\n").replace("\\\"", "\"").replace("\\\\", "\\");
                    }
                }
            }

            final String cleanMsg = message;

            // Persist as a learning attempt if user is authenticated student
            if (authUser != null && !authUser.isBlank()) {
                try {
                    authRepository.findByUsername(authUser.trim()).ifPresent(u -> {
                        if ("STUDENT".equals(u.role())) {
                            int qId = getOrCreateTutorQuestionId();
                            String qSummary = request.question();
                            if (request.studentInput() != null && !request.studentInput().isBlank()) {
                                qSummary += " (Học sinh: " + request.studentInput() + ")";
                            }
                            attemptRepository.insert(qId, u.id(), qSummary, null, java.math.BigDecimal.TEN, cleanMsg, null);
                        }
                    });
                } catch (Exception ignored) {}
            }

            return new GeneralTutorResponse(request.stepNumber(), action, correct, finalStep, cleanMsg);
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY, "Gia sư AI hiện chưa phản hồi được. Vui lòng thử lại sau.");
        }
    }
}
