package vn.math10ai.questions;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.SessionUser;
import vn.math10ai.ai.AiProviderClient;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.json.JsonReadFeature;

@Service
public class QuestionService {
    private final QuestionRepository repo;
    private final AiProviderClient ai;
    private final ObjectMapper json;
    private final ObjectMapper lenientJson;

    public QuestionService(QuestionRepository repo, AiProviderClient ai, ObjectMapper json) {
        this.repo = repo;
        this.ai = ai;
        this.json = json;
        this.lenientJson = json.copy()
                .configure(JsonReadFeature.ALLOW_BACKSLASH_ESCAPING_ANY_CHARACTER.mappedFeature(), true)
                .configure(JsonReadFeature.ALLOW_UNESCAPED_CONTROL_CHARS.mappedFeature(), true);
    }

    public List<QuestionDto> manage(SessionUser u) {
        return repo.manage(u.id(), "ADMIN".equals(u.role()));
    }

    public List<PracticeQuestionDto> practice(int lessonId) {
        return repo.publishedForLesson(lessonId).stream()
                .map(q -> new PracticeQuestionDto(q.id(), q.lessonId(), q.type(), q.text(), q.optionA(), q.optionB(), q.optionC(), q.optionD(), q.difficulty()))
                .toList();
    }

    public QuestionDto create(SessionUser u, QuestionRequest q) {
        validate(u, q);
        int id = repo.insert(u.id(), q, "MANUAL");
        return repo.find(id);
    }

    public QuestionDto update(SessionUser u, int id, QuestionRequest q) {
        validate(u, q);
        if (repo.update(id, u.id(), "ADMIN".equals(u.role()), q) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy câu hỏi hoặc không có quyền sửa.");
        }
        return repo.find(id);
    }

    public QuestionDto publish(SessionUser u, int id) {
        if (repo.publish(id, u.id(), "ADMIN".equals(u.role())) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy câu hỏi hoặc không có quyền duyệt.");
        }
        return repo.find(id);
    }

    public void delete(SessionUser u, int id) {
        if (repo.delete(id) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy câu hỏi hoặc không thể xóa.");
        }
    }

    public List<QuestionDto> generate(SessionUser u, GenerateRequest request) {
        if (!repo.ownsLesson(request.lessonId(), u.id(), "ADMIN".equals(u.role()))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Bài học không thuộc phạm vi quản lý của bạn.");
        }

        int targetLessonId = request.lessonId() <= 0 ? 1 : request.lessonId();
        String lessonTitle = repo.findLessonTitle(request.lessonId());

        String system = "Bạn là chuyên gia khảo thí biên soạn đề thi môn Toán lớp 10 theo chương trình GDPT 2018 (SGK Kết nối tri thức). "
                + "Hãy tạo ra các câu hỏi toán học chuẩn xác, phân loại rõ ràng. Với công thức toán, hãy dùng $...$ hoặc \\\\( ... \\\\). "
                + "LƯU Ý ĐẶC BIỆT: Mọi công thức toán ở cả đề bài ('text'), lời giải ('explanation') và CẢ 4 phương án ('optionA', 'optionB', 'optionC', 'optionD') BẮT BUỘC phải bọc trong cặp dấu $...$ (Ví dụ: \"optionA\":\"$\\dfrac{16}{5}$\", không để trần \\dfrac{16}{5}). "
                + "Chỉ trả về DUY NHẤT một mảng JSON thuần túy (không bọc trong ```json hay markdown khác). Cấu trúc:\n"
                + "Nếu loại MCQ: [{\"text\":\"...\", \"optionA\":\"...\", \"optionB\":\"...\", \"optionC\":\"...\", \"optionD\":\"...\", \"correctAnswer\":\"A/B/C/D\", \"explanation\":\"...\", \"solutionSteps\":\"...\"}]\n"
                + "Nếu loại ESSAY: [{\"text\":\"...\", \"explanation\":\"...\", \"solutionSteps\":\"...\"}]\n"
                + "Không trả về văn bản nào ngoài mảng JSON.";

        String prompt = "Hãy tạo " + request.count() + " câu hỏi " + request.type() + " mức độ " + request.difficulty()
                + " bám sát bài: " + lessonTitle + " (Chương trình Toán 10). "
                + (request.instructions() != null && !request.instructions().isBlank() ? "Yêu cầu từ giáo viên: " + request.instructions() : "");

        try {
            String raw = ai.complete(system, prompt).replaceAll("(?s)^```(?:json)?\\s*|\\s*```$", "").trim();
            // Sanitize unescaped latex brackets if any
            String sanitized = raw.replace("\\(", "\\\\(").replace("\\)", "\\\\)").replace("\\[", "\\\\[").replace("\\]", "\\\\]");
            
            com.fasterxml.jackson.databind.JsonNode array;
            try {
                array = lenientJson.readTree(sanitized);
            } catch (Exception ex) {
                array = lenientJson.readTree(raw);
            }

            if (!array.isArray()) {
                throw new IllegalArgumentException("AI response is not an array");
            }

            java.util.ArrayList<QuestionRequest> drafts = new java.util.ArrayList<>();
            java.util.Random rng = new java.util.Random();
            for (var node : array) {
                int qLessonId = request.lessonId() <= 0 ? (rng.nextInt(27) + 1) : request.lessonId();
                String ca = nullable(node, "correctAnswer");

                if (ca != null) {
                    ca = ca.trim().toUpperCase();
                    if (ca.startsWith("A") || ca.contains("A")) ca = "A";
                    else if (ca.startsWith("B") || ca.contains("B")) ca = "B";
                    else if (ca.startsWith("C") || ca.contains("C")) ca = "C";
                    else if (ca.startsWith("D") || ca.contains("D")) ca = "D";
                    else ca = "A";
                }
                String expl = nullable(node, "explanation");
                if (expl == null || expl.isBlank()) expl = "Đáp án đúng theo chuẩn SGK Toán 10.";
                String steps = nullable(node, "solutionSteps");
                if (steps == null || steps.isBlank()) steps = expl;

                QuestionRequest q = new QuestionRequest(
                        qLessonId,
                        request.type(),
                        formatMathText(node.path("text").asText("")),
                        formatMathText(nullable(node, "optionA")),
                        formatMathText(nullable(node, "optionB")),
                        formatMathText(nullable(node, "optionC")),
                        formatMathText(nullable(node, "optionD")),
                        ca,
                        formatMathText(expl),
                        formatMathText(steps),
                        request.difficulty(),
                        "PENDING_REVIEW"
                );
                validate(u, q);
                drafts.add(q);
            }

            if (drafts.isEmpty()) {
                throw new IllegalArgumentException("Empty questions list generated");
            }

            return repo.insertAiBatch(u.id(), drafts).stream().map(repo::find).toList();
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY, "AI không trả về đúng định dạng câu hỏi hoặc gặp sự cố: " + ex.getMessage());
        }
    }

    private String nullable(com.fasterxml.jackson.databind.JsonNode node, String key) {
        var value = node.get(key);
        return value == null || value.isNull() ? null : value.asText();
    }

    private void validate(SessionUser u, QuestionRequest q) {
        boolean admin = "ADMIN".equals(u.role());
        if (q.text() == null || q.text().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung câu hỏi không được để trống.");
        }
        if (!repo.ownsLesson(q.lessonId(), u.id(), admin)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bài học không tồn tại hoặc bạn không có quyền.");
        }
        if ("MCQ".equals(q.type())) {
            if (blank(q.optionA()) || blank(q.optionB()) || blank(q.optionC()) || blank(q.optionD()) || !List.of("A", "B", "C", "D").contains(q.correctAnswer())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Trắc nghiệm cần đủ bốn lựa chọn và đáp án A/B/C/D.");
            }
        } else if (!"ESSAY".equals(q.type()) || q.optionA() != null || q.optionB() != null || q.optionC() != null || q.optionD() != null || q.correctAnswer() != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Dữ liệu câu tự luận không hợp lệ.");
        }
        if (q.status() != null && !List.of("DRAFT", "PENDING_REVIEW", "PUBLISHED").contains(q.status())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Trạng thái câu hỏi không hợp lệ.");
        }
    }

    private boolean blank(String s) {
        return s == null || s.isBlank();
    }

    private String formatMathText(String text) {
        if (text == null) return null;
        String s = text.trim();
        if (s.isEmpty()) return s;
        if (!s.contains("$") && !s.contains("\\(") && (s.contains("\\") || s.contains("^") || s.contains("_"))) {
            return "$" + s + "$";
        }
        return s;
    }
}
