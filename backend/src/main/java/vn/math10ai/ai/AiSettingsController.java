package vn.math10ai.ai;
import java.util.HashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
import vn.math10ai.auth.RequireRoles;

@RestController
@RequestMapping("/api/v1/admin/ai")
@RequireRoles({"ADMIN"})
public class AiSettingsController {
    private final AiProviderClient ai;

    public AiSettingsController(AiProviderClient ai) {
        this.ai = ai;
    }

    @GetMapping("/status")
    public Map<String, Object> status() {
        return Map.of("provider", ai.provider(), "model", ai.model(), "apiKeyConfigured", ai.configured());
    }

    @GetMapping("/config")
    public Map<String, Object> getConfig() {
        String key = ai.getApiKey();
        String maskedKey = (key != null && key.length() > 6)
                ? key.substring(0, 3) + "..." + key.substring(key.length() - 3)
                : (key != null && !key.isBlank() ? "******" : "");
        Map<String, Object> res = new HashMap<>();
        res.put("provider", ai.provider());
        res.put("endpoint", ai.getEndpoint() != null ? ai.getEndpoint() : "");
        res.put("apiKeyMasked", maskedKey);
        res.put("model", ai.model());
        res.put("stepPrompt", ai.getStepPrompt());
        res.put("mcqPrompt", ai.getMcqPrompt());
        return res;
    }

    @PostMapping("/config")
    public Map<String, Object> updateConfig(@RequestBody Map<String, String> body) {
        if (body != null) {
            if (body.containsKey("endpoint") && body.get("endpoint") != null) {
                ai.setEndpoint(body.get("endpoint").trim());
            }
            if (body.containsKey("apiKey") && body.get("apiKey") != null && !body.get("apiKey").isBlank()) {
                ai.setApiKey(body.get("apiKey").trim());
            }
            if (body.containsKey("model") && body.get("model") != null && !body.get("model").isBlank()) {
                ai.setModel(body.get("model").trim());
            }
            if (body.containsKey("stepPrompt") && body.get("stepPrompt") != null) {
                ai.setStepPrompt(body.get("stepPrompt").trim());
            }
            if (body.containsKey("mcqPrompt") && body.get("mcqPrompt") != null) {
                ai.setMcqPrompt(body.get("mcqPrompt").trim());
            }
        }
        return Map.of("status", "success", "message", "Đã cập nhật cấu hình API & Prompt thành công.");
    }

    @PostMapping("/test")
    public Map<String, String> test(@RequestBody(required = false) Map<String, String> body) {
        String question = (body != null && body.containsKey("question") && body.get("question") != null && !body.get("question").isBlank())
                ? body.get("question").trim()
                : null;
        String systemPrompt = (body != null && body.containsKey("systemPrompt") && body.get("systemPrompt") != null && !body.get("systemPrompt").isBlank())
                ? body.get("systemPrompt").trim()
                : "Trả lời ngắn gọn và chính xác.";

        if (!ai.configured()) {
            if (question != null) {
                return Map.of("status", "simulated", "message", """
[GIA SƯ AI SOCRATIC]:
Chào em! Với tam thức $f(x) = x^2 - 4x + 3$, chúng ta sẽ thực hiện theo 2 bước:

### Bước 1: Xác định tọa độ đỉnh của Parabol
Công thức tọa độ đỉnh $I(x_I; y_I)$ của parabol $y = ax^2 + bx + c$ là:
$x_I = -\\frac{b}{2a}$,  $y_I = f(x_I)$
Với $a = 1$, $b = -4$, $c = 3$.

👉 Em hãy tính và điền toạ độ đỉnh $I(x_I; y_I)$ vào đây để chúng ta sang Bước 2 nhé!""");
            }
            return Map.of("status", "simulated", "message", "Dịch vụ AI đang chạy chế độ mô phỏng sư phạm (Chưa cấu hình API Key).");
        }

        try {
            String q = question != null ? question : "Kiểm tra kết nối và độ trễ máy chủ AI. Trả lời đúng một từ: OK.";
            String response = ai.complete(systemPrompt, q);
            return Map.of("status", "connected", "message", response.trim());
        } catch (Exception ex) {
            if (question != null) {
                return Map.of("status", "simulated", "message", """
[GIA SƯ AI SOCRATIC]:
Chào em! Với tam thức $f(x) = x^2 - 4x + 3$, chúng ta sẽ thực hiện theo 2 bước:

### Bước 1: Xác định tọa độ đỉnh của Parabol
Công thức tọa độ đỉnh $I(x_I; y_I)$ của parabol $y = ax^2 + bx + c$ là:
$x_I = -\\frac{b}{2a}$,  $y_I = f(x_I)$
Với $a = 1$, $b = -4$, $c = 3$.

👉 Em hãy tính và điền toạ độ đỉnh $I(x_I; y_I)$ vào đây để chúng ta sang Bước 2 nhé!""");
            }
            throw ex;
        }
    }
}
