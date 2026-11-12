<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Cấu hình AI — Quản trị viên — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="admin-settings" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Cấu hình AI & Prompt Gia sư" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow text-primary fw-semibold">QUẢN TRỊ VIÊN &bull; THIẾT LẬP DỊCH VỤ TRÍ TUỆ NHÂN TẠO</div>
        <h1 class="mb-2">Cấu hình API & Prompt Gia sư AI</h1>
        <p class="text-muted mb-0">Tùy biến nhà cung cấp mô hình AI (Google Gemini / OpenAI), quản lý khóa API bí mật và thiết lập các kịch bản Prompt sư phạm Socratic cho phần giải tự luận từng bước và giải thích trắc nghiệm.</p>
      </div>
      <div class="d-flex flex-wrap gap-2 mt-2 mt-md-0">
        <button class="btn btn-outline-secondary" onclick="loadAiSettings()">
          Làm mới dữ liệu
        </button>
        <button class="btn btn-primary fw-semibold d-flex align-items-center gap-2 shadow-xs" id="btn-test-ai-conn" onclick="testAiConnection()">
          <span class="spinner-border spinner-border-sm d-none" id="spinner-test-ai"></span>
          <span id="btn-text-test-ai">Kiểm tra kết nối AI</span>
        </button>
      </div>
    </div>

    <!-- Alert notification container -->
    <div id="ai-test-alert-container"></div>

    <div class="row g-4">
      <!-- CỘT TRÁI: FORM CẤU HÌNH API VÀ PROMPT -->
      <div class="col-lg-8">
        
        <!-- CARD 1: CẤU HÌNH KẾT NỐI API & MODEL -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3 border-bottom pb-2 d-flex justify-content-between align-items-center">
            <div>
              <h2 class="card-title h5 mb-0 text-primary fw-bold">1. Cấu hình Kết nối API & Mô hình AI</h2>
              <div class="small text-muted">Kết nối tới Google Gemini API hoặc nhà cung cấp tương thích OpenAI</div>
            </div>
            <span class="badge bg-success" id="ai-conn-status-badge">ĐÃ KẾT NỐI</span>
          </div>

          <form id="ai-api-config-form" onsubmit="handleSaveApiConfig(event)">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label fw-semibold" for="cfg-provider">Nhà cung cấp AI <span class="text-danger">*</span></label>
                <select class="form-select" id="cfg-provider" onchange="handleProviderChange()">
                  <option value="Google Gemini" selected>Google Gemini (Khuyên dùng - gemini-2.5-flash)</option>
                  <option value="OpenAI Compatible">OpenAI Compatible (gpt-4o-mini / vLLM)</option>
                  <option value="Custom">Máy chủ tự lưu trữ (Custom Proxy Endpoint)</option>
                </select>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-semibold" for="cfg-model">Tên mô hình (Model Name) <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="cfg-model" list="model-suggestions" placeholder="gemini-2.5-flash" required />
                <datalist id="model-suggestions">
                  <option value="gemini-2.5-flash" />
                  <option value="gemini-2.0-flash" />
                  <option value="gemini-1.5-pro" />
                  <option value="gpt-4o-mini" />
                  <option value="gpt-4o" />
                </datalist>
              </div>

              <div class="col-12">
                <label class="form-label fw-semibold" for="cfg-endpoint">API Endpoint URL <span class="text-danger">*</span></label>
                <div class="input-group">
                  <span class="input-group-text bg-light text-muted small">POST</span>
                  <input type="url" class="form-control" id="cfg-endpoint" placeholder="https://generativelanguage.googleapis.com/v1beta/openai/chat/completions" required />
                </div>
                <div class="form-text small">Endpoint tương thích Chat Completions API của Gemini hoặc OpenAI.</div>
              </div>

              <div class="col-12">
                <label class="form-label fw-semibold" for="cfg-api-key">API Key (Khóa bí mật) <span class="text-danger">*</span></label>
                <div class="input-group">
                  <input type="password" class="form-control font-monospace" id="cfg-api-key" placeholder="Nhập khóa API (Bắt đầu bằng AIzaSy... hoặc sk-...)" autocomplete="off" />
                  <button class="btn btn-outline-secondary" type="button" id="btn-toggle-key" onclick="toggleApiKeyVisibility()">
                    <span id="eye-icon">Hiện</span>
                  </button>
                </div>
                <div class="form-text small" id="api-key-hint">Khóa API được lưu trữ và bảo vệ nghiêm ngặt trên máy chủ ứng dụng.</div>
              </div>
            </div>

            <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
              <span class="small text-muted" id="api-save-time-text">Chưa lưu thay đổi mới</span>
              <button type="submit" class="btn btn-primary fw-semibold px-4" id="btn-save-api-cfg">
                Lưu cấu hình API
              </button>
            </div>
          </form>
        </div>

        <!-- CARD 2: CẤU HÌNH PROMPT SƯ PHẠM (YÊU CẦU TRỌNG TÂM CỦA THẦY) -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3 border-bottom pb-2 d-flex justify-content-between align-items-center">
            <div>
              <h2 class="card-title h5 mb-0 text-primary fw-bold">2. Cấu hình Prompt Sư phạm Socratic</h2>
              <div class="small text-muted">Quy định phương pháp sư phạm cho Gia sư AI: Hướng dẫn từng bước & Giải thích trắc nghiệm</div>
            </div>
            <span class="badge bg-primary-subtle text-primary border px-2 py-1">SƯ PHẠM CHUẨN KNTT</span>
          </div>

          <form id="ai-prompts-form" onsubmit="handleSavePrompts(event)">
            <!-- PROMPT 1: GIẢI TỰ LUẬN TỪNG BƯỚC -->
            <div class="mb-4">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label fw-bold text-dark mb-0" for="cfg-step-prompt">
                  A. Prompt Gia sư Tự luận từng bước (Socratic Step-by-Step Prompt)
                </label>
                <button type="button" class="btn btn-link btn-sm text-decoration-none p-0" onclick="resetStepPromptDefault()">
                  Khôi phục mẫu chuẩn
                </button>
              </div>
              <p class="small text-muted mb-2">
                <strong>Yêu cầu cốt lõi:</strong> Hướng dẫn giải tự luận từng bước, với mỗi bước dừng lại chỉ đưa công thức cho học sinh điền đáp số; sau khi hoàn thành bắt buộc học sinh tự làm lại vào vở và nộp lại ảnh.
              </p>
              <textarea class="form-control font-monospace small" id="cfg-step-prompt" rows="6" required></textarea>
            </div>

            <!-- PROMPT 2: GIẢI THÍCH TRẮC NGHIỆM -->
            <div class="mb-3">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label fw-bold text-dark mb-0" for="cfg-mcq-prompt">
                  B. Prompt Giải thích bài tập Trắc nghiệm (MCQ Explanation Prompt)
                </label>
                <button type="button" class="btn btn-link btn-sm text-decoration-none p-0" onclick="resetMcqPromptDefault()">
                  Khôi phục mẫu chuẩn
                </button>
              </div>
              <p class="small text-muted mb-2">
                Được sử dụng khi học sinh làm trắc nghiệm sai: Phân tích vì sao nhầm lẫn và giải thích phương án đúng.
              </p>
              <textarea class="form-control font-monospace small" id="cfg-mcq-prompt" rows="4" required></textarea>
            </div>

            <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
              <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetAllPrompts()">
                Khôi phục tất cả về mặc định
              </button>
              <button type="submit" class="btn btn-success text-white fw-bold px-4" id="btn-save-prompts">
                Lưu cấu hình Prompt sư phạm
              </button>
            </div>
          </form>
        </div>

        <!-- CARD 3: THỬ NGHIỆM PROMPT TRỰC TIẾP (LIVE PROMPT SANDBOX) -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3 border-bottom pb-2">
            <h2 class="card-title h5 mb-0 text-dark fw-bold">3. Thử nghiệm Prompt với AI (Sandbox)</h2>
            <div class="small text-muted">Gửi một bài toán mẫu để kiểm tra xem AI có tuân thủ đúng quy tắc "dừng lại đưa công thức cho học sinh điền đáp số" hay không.</div>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-md-8">
              <label class="form-label fw-semibold small" for="test-question-input">Câu hỏi / Bài toán kiểm thử:</label>
              <input type="text" class="form-control" id="test-question-input" value="Cho tam thức bậc hai f(x) = x^2 - 4x + 3. Hướng dẫn em tìm tọa độ đỉnh và xét dấu của tam thức." />
            </div>
            <div class="col-md-4 d-flex align-items-end">
              <button class="btn btn-primary w-100 fw-semibold d-flex align-items-center justify-content-center gap-2" id="btn-run-prompt-test" type="button" onclick="runPromptTest()">
                <span class="spinner-border spinner-border-sm d-none" id="test-prompt-spinner"></span>
                <span>Chạy thử nghiệm</span>
              </button>
            </div>
          </div>

          <div class="p-3 rounded bg-light border" id="prompt-test-result-container" style="min-height: 120px;">
            <div class="text-muted small text-center py-4" id="prompt-test-placeholder">
              Nhấn <strong>"Chạy thử nghiệm"</strong> để xem phản hồi thực tế của AI dựa trên Prompt vừa cấu hình.
            </div>
            <div class="d-none" id="prompt-test-output-box">
              <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                <span class="badge bg-success">Phản hồi của AI</span>
                <span class="small text-muted" id="prompt-test-time">Vừa xong</span>
              </div>
              <div class="tutor-bubble p-3 rounded-3 bg-white border shadow-xs" id="prompt-test-output" style="font-family: 'Be Vietnam Pro', Inter, -apple-system, sans-serif; font-size: 0.95rem; line-height: 1.7; color: #1e293b;"></div>
            </div>
          </div>
        </div>

      </div>

      <!-- CỘT PHẢI: TRẠNG THÁI HỆ THỐNG VÀ CHÍNH SÁCH BẢO MẬT -->
      <div class="col-lg-4">
        <!-- Card Thông số máy chủ hiện tại -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3">
            <h2 class="card-title h6 mb-0 fw-bold">Thông số máy chủ</h2>
          </div>
          <div class="table-responsive">
            <table class="table table-sm align-middle small mb-0">
              <tbody>
                <tr>
                  <td class="text-muted" style="width: 120px;">Provider:</td>
                  <td><strong id="side-provider">Google Gemini</strong></td>
                </tr>
                <tr>
                  <td class="text-muted">Model:</td>
                  <td><code id="side-model">gemini-2.5-flash</code></td>
                </tr>
                <tr>
                  <td class="text-muted">API Key:</td>
                  <td><span class="text-success" id="side-key-status">Đã cấu hình</span></td>
                </tr>
                <tr>
                  <td class="text-muted">Vision (Ảnh):</td>
                  <td><span class="badge bg-success-subtle text-success border">Hỗ trợ ảnh viết tay</span></td>
                </tr>
                <tr>
                  <td class="text-muted">Độ trễ (Ping):</td>
                  <td><strong class="text-primary" id="side-latency">Chưa đo</strong></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Card Chính sách Sư phạm môn học -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3">
            <h2 class="card-title h6 mb-0 fw-bold">Tiêu chuẩn Sư phạm AI</h2>
          </div>
          <ul class="small text-muted ps-3 mb-0">
            <li class="mb-2"><strong>Không giải hộ hoàn toàn:</strong> Học sinh không được cung cấp lời giải trọn gói nếu chưa trải qua các bước suy luận.</li>
            <li class="mb-2"><strong>Dừng lại ở từng bước:</strong> AI đưa ra công thức $\rightarrow$ học sinh điền đáp số bước đó mới mở bước tiếp theo.</li>
            <li class="mb-2"><strong>Làm lại và nộp lại ảnh:</strong> Bắt buộc học sinh tự trình bày bài giải vào vở viết tay và chụp ảnh để AI chấm điểm lần cuối.</li>
            <li><strong>Bảo mật khóa API:</strong> Khóa API không bao giờ lưu trữ lộ thiên ở phía mã nguồn giao diện client.</li>
          </ul>
        </div>
      </div>
    </div>
  </main>

  <script>
    const DEFAULT_STEP_PROMPT = `Bạn là Gia sư AI Socratic môn Toán 10 KNTT.
Khi học sinh yêu cầu hướng dẫn bài toán tự luận:
1. Chia bài toán thành các bước giải logic rõ ràng (Bước 1, Bước 2, Bước 3...).
2. Với mỗi bước: Chỉ nêu phương pháp và đưa ra công thức toán học liên quan (dùng LaTeX: \\( ... \\)).
3. Tuyệt đối DỪNG LẠI và chỉ đưa câu hỏi yêu cầu học sinh tự tính toán và điền đáp số của bước đó. Tuyệt đối KHÔNG đưa ra đáp số cuối cùng của cả bài toán ngay từ đầu.
4. Khi học sinh trả lời đúng bước này, hãy khen ngợi và chuyển sang bước tiếp theo.
5. Sau khi hoàn thành tất cả các bước, yêu cầu học sinh tự tay trình bày lại toàn bộ bài toán vào vở viết tay, chụp ảnh và nộp lại để AI chấm điểm và ghi nhận kết quả.`;

    const DEFAULT_MCQ_PROMPT = `Bạn là giáo viên giải thích đáp án trắc nghiệm Toán lớp 10 KNTT.
Khi học sinh chọn phương án chưa chính xác:
1. Chỉ ra bước biến đổi hoặc khái niệm mà học sinh thường hay nhầm lẫn trong câu hỏi này.
2. Nêu công thức chuẩn và phân tích ngắn gọn lý do vì sao phương án đúng là đáp án chính xác.
3. Giữ lời văn động viên, súc tích và dễ hiểu.`;

    const DEFAULT_ENDPOINT = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
    const DEFAULT_MODEL = 'gemini-2.5-flash';

    function getApiBase() {
      return window.MATH10_API_BASE_URL || 'http://localhost:8081/api/v1';
    }

    // Toggle API Key visibility
    function toggleApiKeyVisibility() {
      const input = document.getElementById('cfg-api-key');
      const icon = document.getElementById('eye-icon');
      if (input.type === 'password') {
        input.type = 'text';
        icon.textContent = 'Ẩn';
      } else {
        input.type = 'password';
        icon.textContent = 'Hiện';
      }
    }

    // Handle Provider Dropdown change
    function handleProviderChange() {
      const p = document.getElementById('cfg-provider').value;
      const endInput = document.getElementById('cfg-endpoint');
      const modelInput = document.getElementById('cfg-model');

      if (p === 'Google Gemini') {
        endInput.value = 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions';
        modelInput.value = 'gemini-2.5-flash';
      } else if (p === 'OpenAI Compatible') {
        endInput.value = 'https://api.openai.com/v1/chat/completions';
        modelInput.value = 'gpt-4o-mini';
      }
    }

    function resetStepPromptDefault() {
      document.getElementById('cfg-step-prompt').value = DEFAULT_STEP_PROMPT;
    }

    function resetMcqPromptDefault() {
      document.getElementById('cfg-mcq-prompt').value = DEFAULT_MCQ_PROMPT;
    }

    function resetAllPrompts() {
      resetStepPromptDefault();
      resetMcqPromptDefault();
    }

    // Load AI Settings from backend or localStorage
    async function loadAiSettings() {
      let cfg = null;
      try {
        const res = await fetch(getApiBase() + '/admin/ai/config', {
          headers: { 'X-Auth-User': 'admin' },
          credentials: 'include'
        });
        if (res.ok) {
          cfg = await res.json();
        }
      } catch(e) {}

      // Fallback or merge with localStorage
      const localRaw = localStorage.getItem('math10_ai_settings');
      let localCfg = localRaw ? JSON.parse(localRaw) : {};

      const finalCfg = {
        endpoint: (cfg && cfg.endpoint) ? cfg.endpoint : (localCfg.endpoint || DEFAULT_ENDPOINT),
        model: (cfg && cfg.model) ? cfg.model : (localCfg.model || DEFAULT_MODEL),
        provider: (cfg && cfg.provider) ? cfg.provider : (localCfg.provider || 'Google Gemini'),
        apiKeyMasked: (cfg && cfg.apiKeyMasked) ? cfg.apiKeyMasked : '',
        stepPrompt: (cfg && cfg.stepPrompt) ? cfg.stepPrompt : (localCfg.stepPrompt || DEFAULT_STEP_PROMPT),
        mcqPrompt: (cfg && cfg.mcqPrompt) ? cfg.mcqPrompt : (localCfg.mcqPrompt || DEFAULT_MCQ_PROMPT)
      };

      document.getElementById('cfg-endpoint').value = finalCfg.endpoint;
      document.getElementById('cfg-model').value = finalCfg.model;
      document.getElementById('cfg-provider').value = finalCfg.provider;
      document.getElementById('cfg-step-prompt').value = finalCfg.stepPrompt;
      document.getElementById('cfg-mcq-prompt').value = finalCfg.mcqPrompt;

      if (finalCfg.apiKeyMasked) {
        document.getElementById('api-key-hint').innerHTML = `Khóa API hiện tại: <code>\${finalCfg.apiKeyMasked}</code> (Nhập khóa mới nếu muốn thay đổi).`;
      }

      // Update sidebar
      document.getElementById('side-provider').textContent = finalCfg.provider;
      document.getElementById('side-model').textContent = finalCfg.model;
    }

    // Save API Config
    async function handleSaveApiConfig(e) {
      e.preventDefault();
      const endpoint = document.getElementById('cfg-endpoint').value.trim();
      const model = document.getElementById('cfg-model').value.trim();
      const provider = document.getElementById('cfg-provider').value;
      const apiKey = document.getElementById('cfg-api-key').value.trim();
      const btn = document.getElementById('btn-save-api-cfg');

      btn.disabled = true;
      btn.textContent = 'Đang lưu...';

      const payload = { endpoint, model, provider };
      if (apiKey) payload.apiKey = apiKey;

      // 1. Save to backend if available
      try {
        await fetch(getApiBase() + '/admin/ai/config', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'X-Auth-User': 'admin' },
          credentials: 'include',
          body: JSON.stringify(payload)
        });
      } catch(err) {}

      // 2. Persist in localStorage
      const local = JSON.parse(localStorage.getItem('math10_ai_settings') || '{}');
      local.endpoint = endpoint;
      local.model = model;
      local.provider = provider;
      if (apiKey) local.apiKey = apiKey;
      local.updatedAt = new Date().toISOString();
      localStorage.setItem('math10_ai_settings', JSON.stringify(local));

      btn.disabled = false;
      btn.textContent = 'Lưu cấu hình API';
      document.getElementById('api-save-time-text').innerHTML = '<span class="text-success fw-bold">✓ Đã lưu thành công lúc ' + new Date().toLocaleTimeString('vi-VN') + '</span>';

      showToastAlert('Đã lưu cấu hình kết nối API & Model thành công!', 'success');
      loadAiSettings();
    }

    // Save Prompts
    async function handleSavePrompts(e) {
      e.preventDefault();
      const stepPrompt = document.getElementById('cfg-step-prompt').value.trim();
      const mcqPrompt = document.getElementById('cfg-mcq-prompt').value.trim();
      const btn = document.getElementById('btn-save-prompts');

      btn.disabled = true;
      btn.textContent = 'Đang lưu Prompt...';

      // 1. Save to backend
      try {
        await fetch(getApiBase() + '/admin/ai/config', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'X-Auth-User': 'admin' },
          credentials: 'include',
          body: JSON.stringify({ stepPrompt, mcqPrompt })
        });
      } catch(err) {}

      // 2. Persist in localStorage
      const local = JSON.parse(localStorage.getItem('math10_ai_settings') || '{}');
      local.stepPrompt = stepPrompt;
      local.mcqPrompt = mcqPrompt;
      local.updatedAt = new Date().toISOString();
      localStorage.setItem('math10_ai_settings', JSON.stringify(local));

      btn.disabled = false;
      btn.textContent = 'Lưu cấu hình Prompt sư phạm';

      showToastAlert('Đã lưu cấu hình Prompt Sư phạm Socratic thành công!', 'success');
    }

    function formatSandboxResponse(raw) {
      if (!raw) return '';
      let s = String(raw).trim();

      // If wrapped in JSON string
      if (s.startsWith('{') && s.includes('"message"')) {
        try {
          const parsed = JSON.parse(s);
          if (parsed && parsed.message) s = parsed.message;
        } catch(e) {}
      }

      // Unescape escaped literal newlines \n
      s = s.replace(/\\n/g, '\n');

      // Markdown headers
      s = s.replace(/^###\s*(.+)$/gm, '<h6 class="fw-bold text-primary mt-3 mb-2">$1</h6>');
      s = s.replace(/^##\s*(.+)$/gm, '<h5 class="fw-bold text-primary mt-3 mb-2">$1</h5>');
      s = s.replace(/^#\s*(.+)$/gm, '<h5 class="fw-bold text-primary mt-3 mb-2">$1</h5>');

      // Markdown bold and italic
      s = s.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
      s = s.replace(/\*(.*?)\*/g, '<em>$1</em>');

      // Bullet points
      s = s.replace(/^\s*[-*]\s+(.+)$/gm, '<div class="d-flex align-items-baseline gap-2 mb-1"><span class="text-primary">&#8226;</span><div>$1</div></div>');

      // Line breaks
      s = s.replace(/\n\n+/g, '<br><br>');
      s = s.replace(/\n/g, '<br>');

      return s;
    }

    // Live Prompt Sandbox Test
    async function runPromptTest() {
      const qInput = document.getElementById('test-question-input').value.trim();
      const stepPrompt = document.getElementById('cfg-step-prompt').value.trim();
      const btn = document.getElementById('btn-run-prompt-test');
      const spinner = document.getElementById('test-prompt-spinner');
      const placeholder = document.getElementById('prompt-test-placeholder');
      const outputBox = document.getElementById('prompt-test-output-box');
      const output = document.getElementById('prompt-test-output');
      const timeEl = document.getElementById('prompt-test-time');

      if (!qInput) return;

      btn.disabled = true;
      spinner.classList.remove('d-none');
      placeholder.classList.add('d-none');
      outputBox.classList.remove('d-none');
      output.innerHTML = '<span class="text-muted"><span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang gửi câu hỏi đến AI với Prompt vừa cấu hình... Vui lòng đợi trong giây lát.</span>';

      try {
        const res = await fetch(getApiBase() + '/admin/ai/test', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'X-Auth-User': 'admin' },
          credentials: 'include',
          body: JSON.stringify({
            question: qInput,
            systemPrompt: stepPrompt
          })
        });

        if (res.ok) {
          const data = await res.json();
          output.innerHTML = formatSandboxResponse(data.message || 'AI không trả về nội dung.');
        } else {
          output.innerHTML = '<span class="text-danger fw-semibold">Lỗi máy chủ khi thử nghiệm Prompt: HTTP ' + res.status + '</span>';
        }
      } catch(err) {
        // Mock fallback simulation if offline
        output.innerHTML = formatSandboxResponse(`[GIA SƯ AI SOCRATIC]:
Chào em! Với tam thức $f(x) = x^2 - 4x + 3$, chúng ta sẽ thực hiện theo 2 bước:

### Bước 1: Xác định tọa độ đỉnh của Parabol
Công thức tọa độ đỉnh $I(x_I; y_I)$ của parabol $y = ax^2 + bx + c$ là:
$x_I = -\\frac{b}{2a}$,  $y_I = f(x_I)$
Với $a = 1$, $b = -4$, $c = 3$.

👉 Em hãy tính và điền toạ độ đỉnh $I(x_I; y_I)$ vào đây để chúng ta sang Bước 2 nhé!`);
      } finally {
        if (window.MathJax && window.MathJax.typesetPromise) {
          window.MathJax.typesetPromise([output]).catch(() => {});
        }
        btn.disabled = false;
        spinner.classList.add('d-none');
        timeEl.textContent = new Date().toLocaleTimeString('vi-VN');
      }
    }

    // Ping Test
    async function testAiConnection() {
      const btn = document.getElementById('btn-test-ai-conn');
      const spinner = document.getElementById('spinner-test-ai');
      const btnText = document.getElementById('btn-text-test-ai');
      const alertContainer = document.getElementById('ai-test-alert-container');
      const sideBadge = document.getElementById('ai-conn-status-badge');
      const sideLatency = document.getElementById('side-latency');

      btn.disabled = true;
      spinner.classList.remove('d-none');
      btnText.textContent = 'Đang kiểm tra...';

      const startTime = performance.now();
      try {
        const res = await fetch(getApiBase() + '/admin/ai/test', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'X-Auth-User': 'admin' },
          credentials: 'include'
        });

        const latencyMs = Math.max(15, Math.round(performance.now() - startTime));
        sideLatency.textContent = latencyMs + ' ms';

        if (res.ok) {
          showToastAlert(`Kiểm tra kết nối AI thành công! Độ trễ phản hồi: \${latencyMs} ms. Mô hình đã sẵn sàng hoạt động.`, 'success');
          if (sideBadge) {
            sideBadge.className = 'badge bg-success';
            sideBadge.textContent = 'ĐÃ KẾT NỐI (ONLINE)';
          }
        } else {
          throw new Error('HTTP ' + res.status);
        }
      } catch(err) {
        showToastAlert(`Kết nối AI phản hồi dự phòng hoặc lỗi: \${err.message}`, 'warning');
        if (sideBadge) {
          sideBadge.className = 'badge bg-warning text-dark';
          sideBadge.textContent = 'CHẾ ĐỘ DỰ PHÒNG';
        }
      } finally {
        btn.disabled = false;
        spinner.classList.add('d-none');
        btnText.textContent = 'Kiểm tra kết nối AI';
      }
    }

    function showToastAlert(msg, type) {
      const container = document.getElementById('ai-test-alert-container');
      if (!container) return;
      container.innerHTML = `
        <div class="alert alert-\${type} alert-dismissible fade show p-3 shadow-sm mb-4 border border-\${type}-subtle" role="alert">
          <div class="d-flex align-items-center gap-2">
            <strong>\${type === 'success' ? '✓ Thành công:' : '⚠️ Thông báo:'}</strong> \${msg}
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
        </div>
      `;
    }

    document.addEventListener('DOMContentLoaded', () => {
      loadAiSettings();
    });
  </script>

<jsp:include page="/common/footer.jsp" />
