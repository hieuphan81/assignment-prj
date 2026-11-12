<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Luyện tập Toán 10 — Trắc nghiệm & Tự luận — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="practice" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Luyện tập Toán 10" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow">LUYỆN TẬP TOÁN 10 &bull; CHẤM ĐIỂM TỨC THÌ & AI VISION</div>
        <h1 id="practice-main-heading">Luyện tập Toán 10</h1>
        <p id="practice-main-desc">Lựa chọn hình thức ôn luyện phù hợp: Trắc nghiệm khách quan chấm điểm tức thì hoặc Tự luận có AI chấm ảnh và lời giải chi tiết.</p>
      </div>
      <div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/lessons">&larr; Danh mục bài học</a>
      </div>
    </div>

    <!-- Mode Tabs: Trắc nghiệm vs Tự luận -->
    <div class="cardx card-pad mb-4 p-2">
      <ul class="nav nav-pills nav-fill" id="practice-tab-nav" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active fw-bold py-2 d-flex align-items-center justify-content-center gap-2" id="tab-mcq-btn" type="button" onclick="switchPracticeTab('mcq')">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M9 12.5 11 14.5 15.5 9.5"/></svg> Luyện tập Trắc nghiệm (MCQ)
          </button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link fw-bold py-2 d-flex align-items-center justify-content-center gap-2" id="tab-essay-btn" type="button" onclick="switchPracticeTab('essay')">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg> Luyện tập Tự luận (AI Chấm bài)
          </button>
        </li>
      </ul>
    </div>

    <!-- TAB 1: LUYỆN TẬP TRẮC NGHIỆM -->
    <div id="section-mcq-practice">
      <div class="row g-4">
        <div class="col-lg-8">
          <!-- Chế độ luyện tập: Luyện tập theo bài hoặc ngẫu nhiên -->
          <div class="cardx card-pad mb-4" id="practice-mode-container">
            <div class="section-head mb-3">
              <div>
                <div class="eyebrow text-primary">CHỌN CHẾ ĐỘ ÔN LUYỆN TRẮC NGHIỆM</div>
                <h2 class="card-title fs-4">Luyện tập trắc nghiệm Toán 10</h2>
                <p class="small text-muted mb-0">Hệ thống hỗ trợ chấm điểm tức thì ngay khi chọn đáp án và giải thích chi tiết từng bước.</p>
              </div>
            </div>

            <div class="row g-3 mt-1">
              <!-- Lựa chọn 1: Luyện tập theo bài -->
              <div class="col-md-6">
                <div class="border rounded-3 p-3 h-100 d-flex flex-column justify-content-between" style="background:#f8fafc; border-color:#e2e8f0 !important;">
                  <div>
                    <div class="d-flex align-items-center gap-2 mb-2">
                      <span class="badge bg-primary px-2 py-1">Lựa chọn 1</span>
                      <h3 class="fs-5 mb-0 fw-bold">Luyện tập theo bài</h3>
                    </div>
                    <p class="small text-muted mb-3">
                      Chọn bài học cụ thể trong SGK Toán 10 để rèn luyện trọng tâm từng chuyên đề.
                    </p>
                    <div class="mb-3">
                      <label class="form-label small fw-bold text-secondary" for="practice-lesson-select">Chọn bài học:</label>
                      <select class="form-select" id="practice-lesson-select">
                        <!-- Tự động nạp 27 bài học từ JavaScript -->
                      </select>
                    </div>
                  </div>
                  <button class="btn btn-primary w-100 mt-2" id="practice-start-lesson-btn">
                    Bắt đầu theo bài &rarr;
                  </button>
                </div>
              </div>

              <!-- Lựa chọn 2: Luyện tập ngẫu nhiên -->
              <div class="col-md-6">
                <div class="border rounded-3 p-3 h-100 d-flex flex-column justify-content-between" style="background:#f8fafc; border-color:#e2e8f0 !important;">
                  <div>
                    <div class="d-flex align-items-center gap-2 mb-2">
                      <span class="badge bg-success px-2 py-1">Lựa chọn 2</span>
                      <h3 class="fs-5 mb-0 fw-bold">Luyện tập ngẫu nhiên</h3>
                    </div>
                    <p class="small text-muted mb-3">
                      Hệ thống tự động xáo trộn ngẫu nhiên ngân hàng câu hỏi từ tất cả các chương để bạn ôn tập tổng hợp.
                    </p>
                    <div class="alert alert-light border small text-muted py-2 px-3 mb-3">
                      Đầy đủ 27 câu hỏi trắc nghiệm phủ khắp 9 chuyên đề Toán 10.
                    </div>
                  </div>
                  <button class="btn btn-success text-white w-100 mt-2" id="practice-start-random-btn">
                    Bắt đầu ngẫu nhiên &rarr;
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Màn hình làm bài trắc nghiệm (Ẩn ban đầu, hiện khi bắt đầu) -->
          <div class="cardx card-pad d-none" id="practice-quiz-view">
            <!-- Quiz Mode Bar & Change Mode button -->
            <div class="d-flex justify-content-between align-items-center pb-2 mb-3 border-bottom">
              <button class="btn btn-sm btn-light" id="practice-change-mode-btn">
                &larr; Đổi chế độ luyện tập
              </button>
              <span class="badge bg-primary-subtle text-primary border" id="practice-mode-badge">
                Luyện tập theo bài
              </span>
            </div>

            <!-- Quiz Header -->
            <div class="d-flex justify-content-between align-items-center pb-3 border-bottom mb-3">
              <div class="quiz-progress">
                <span class="question-number" id="practice-progress-text">Câu 1 / 27</span>
                <div class="progress" style="width: 140px;">
                  <div class="progress-bar" id="practice-progress-bar" style="width: 20%;"></div>
                </div>
              </div>
              <span class="tag tag-blue" id="practice-difficulty-tag">CƠ BẢN</span>
            </div>

            <!-- Question Content -->
            <div class="question-box" id="practice-question-container">
              <div class="eyebrow text-muted" id="practice-topic-name">Chương VI: Hàm số bậc hai &bull; Bài 16</div>
              <h2 class="mt-2 mb-4" id="practice-question-text">
                Toạ độ đỉnh \( I \) của parabol \( y = 2x^2 - 4x + 1 \) là:
              </h2>

              <!-- Options A, B, C, D -->
              <div class="options-group" id="practice-options-group">
              </div>
            </div>

            <!-- Result & AI Socratic Guidance Box -->
            <div class="d-none mt-3" id="practice-result-box">
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
              <button class="btn btn-light" id="practice-prev-btn" disabled>&larr; Câu trước</button>
              <div class="d-flex gap-2">
                <button class="btn btn-success d-none" id="practice-finish-btn">Hoàn tất luyện tập</button>
                <button class="btn btn-outline-primary d-none" id="practice-next-btn">Câu kế tiếp &rarr;</button>
                <button class="btn btn-primary d-none" id="practice-next-lesson-btn">Bài tiếp theo &rarr;</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar MCQ Instructions -->
        <div class="col-lg-4">
          <div class="cardx card-pad mb-4">
            <div class="section-head">
              <h2 class="card-title">Cơ chế gia sư AI</h2>
            </div>
            <div class="d-flex gap-3 align-items-start mb-3">
              <div class="ai-spark"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3 1.7 5.3L19 10l-5.3 1.7L12 17l-1.7-5.3L5 10l5.3-1.7z"/></svg></div>
              <div class="small">
                <strong>Học từ sai lầm:</strong> Khi chọn sai, AI sẽ phân tích bước tính toán bạn có thể đã nhầm lẫn và đưa ra một gợi ý gợi mở.
              </div>
            </div>
            <div class="d-flex gap-3 align-items-start mb-3">
              <div class="ai-spark" style="background:#def5e9; color:#15835c;"></div>
              <div class="small">
                <strong>Tương tác từng bước:</strong> Bạn sẽ nhập bước biến đổi hoặc con số tiếp theo để AI kiểm tra trước khi đi tới đáp án cuối cùng.
              </div>
            </div>
            <div class="d-flex gap-3 align-items-start">
              <div class="ai-spark" style="background:#fff3df; color:#c17c1c;"></div>
              <div class="small">
                <strong>Lưu tiến độ tự động:</strong> Mỗi lượt nộp bài đều được ghi nhận vào lịch sử học tập để theo dõi điểm số trung bình.
              </div>
            </div>
          </div>

          <div class="cardx card-pad">
            <div class="section-head">
              <h2 class="card-title">Công thức liên quan</h2>
            </div>
            <p class="small text-muted mb-2">Đỉnh Parabol \( y = ax^2 + bx + c \):</p>
            <div class="formula-display">
              \[ x_I = -\frac{b}{2a}, \quad y_I = f(x_I) \]
            </div>
            <a class="btn btn-light btn-sm w-100 mt-3" href="${pageContext.request.contextPath}/formulas">Mở sổ tay công thức</a>
          </div>
        </div>
      </div>
    </div>

    <!-- TAB 2: LUYỆN TẬP TỰ LUẬN (CHẤM ẢNH & LỜI GIẢI AI) -->
    <div class="d-none" id="section-essay-practice">
      <!-- Lesson Selector Bar for Essay -->
      <div class="cardx card-pad mb-4">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
          <div class="d-flex align-items-center gap-2">
            <span class="badge bg-purple px-3 py-2 fw-semibold text-white" style="background: var(--brand-primary, #4361ee);">CHỌN BÀI HỌC</span>
            <label class="form-label fw-bold mb-0 text-dark" for="practice-essay-lesson-select">Bài học cần làm tự luận:</label>
          </div>
          <div class="flex-grow-1" style="max-width: 500px;">
            <select id="practice-essay-lesson-select" class="form-select fw-semibold border-primary shadow-xs">
              <!-- Populated by JS for all 27 lessons -->
            </select>
          </div>
        </div>
      </div>

      <div class="row g-4">
        <div class="col-lg-7">
          <div class="cardx card-pad mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="tag tag-purple">BÀI TOÁN TỰ LUẬN VẬN DỤNG</span>
              <span class="tag tag-blue">ĐIỂM: 10.0</span>
            </div>
            <div class="eyebrow text-muted mt-2" id="practice-essay-topic-title">Đang nạp chủ đề...</div>
            <h2 class="card-title my-3" id="practice-essay-question-text" style="font-size: 18px; line-height: 1.6;">
              Đang tải câu hỏi tự luận của bài học...
            </h2>
            <div class="alert alert-light border small text-muted py-2 px-3 mb-0" id="practice-essay-guide-box">
              <strong>Gợi ý hướng làm:</strong> <span id="practice-essay-guide-text">Đang tải gợi ý...</span>
            </div>

            <div class="alert alert-primary py-2 px-3 small d-flex align-items-center justify-content-between mb-3 shadow-2xs border-primary-subtle">
              <div>
                <strong>💡 Gia sư AI Socratic từng bước:</strong> Trải nghiệm hướng dẫn giải tự luận từng bước, điền đáp số theo công thức và nộp lại ảnh bài làm hoàn chỉnh.
              </div>
              <a class="btn btn-sm btn-primary fw-semibold text-nowrap ms-2" id="btn-open-socratic-essay" href="${pageContext.request.contextPath}/essay">Mở Gia sư từng bước &rarr;</a>
            </div>

            <hr class="my-3">

            <form id="practice-essay-form">
              <!-- Text solution area -->
              <div class="mb-3">
                <label class="form-label fw-semibold" for="practice-essay-answer-text">1. Nhập lời giải bằng văn bản (tuỳ chọn)</label>
                <textarea class="form-control" id="practice-essay-answer-text" rows="5" placeholder="Gõ các bước giải của bạn ở đây... Ví dụ:&#10;Bước 1: Điều kiện xác định...&#10;Bước 2: Biến đổi phương trình..."></textarea>
              </div>

              <!-- Image upload zone -->
              <div class="mb-3">
                <label class="form-label fw-semibold">2. Tải ảnh chụp bài làm viết tay (tuỳ chọn)</label>
                <div class="upload-zone" id="practice-essay-drop-zone" style="cursor: pointer;">
                  <input type="file" id="practice-essay-image-input" accept="image/jpeg,image/png,image/webp" class="d-none">
                  <div class="text-center py-2">
                    <div class="upload-icon mb-2">
                      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-primary"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                    </div>
                    <div class="fw-bold mb-1">Kéo thả ảnh bài làm vào đây, hoặc nhấn để chọn ảnh</div>
                    <div class="small text-muted">Hỗ trợ JPG, PNG, WEBP (tối đa 10 MB). AI Vision sẽ đọc chữ viết tay và công thức.</div>
                  </div>
                </div>
                <div class="mt-2 d-none" id="practice-essay-preview-box">
                  <div class="d-flex align-items-center gap-2 p-2 border rounded bg-light">
                    <img id="practice-essay-preview-img" src="" alt="Xem trước bài làm" style="max-height: 60px; max-width: 100px; object-fit: contain;">
                    <div class="flex-grow-1 small text-truncate fw-semibold" id="practice-essay-file-name">ten_file.jpg</div>
                    <button type="button" class="btn btn-sm btn-outline-danger" id="practice-essay-remove-img">&times; Xoá ảnh</button>
                  </div>
                </div>
              </div>

              <div id="practice-essay-alert" class="alert d-none py-2 px-3 small" role="alert"></div>

              <div class="d-flex gap-2 mt-2">
                <button class="btn btn-primary flex-grow-1 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" type="submit" id="practice-essay-submit-btn">
                  <span class="spinner-border spinner-border-sm d-none" id="practice-essay-spinner" role="status"></span>
                  <span>Nộp bài & Nhận chấm điểm AI</span>
                </button>
                <button class="btn btn-outline-primary py-2 px-3 fw-semibold" type="button" id="practice-essay-next-lesson-btn" title="Chuyển sang bài học tiếp theo">
                  Bài tiếp theo &rarr;
                </button>
              </div>
            </form>
          </div>

          <!-- AI Grading Result Box -->
          <div class="cardx card-pad d-none" id="practice-essay-feedback-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div class="d-flex align-items-center gap-2">
                <div class="ai-spark"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3 1.7 5.3L19 10l-5.3 1.7L12 17l-1.7-5.3L5 10l5.3-1.7z"/></svg></div>
                <h2 class="card-title mb-0">Kết quả chấm bài từ AI</h2>
              </div>
              <div class="badge bg-success fs-6" id="practice-essay-score-badge">Đã chấm điểm</div>
            </div>
            <div class="tutor-bubble p-3 rounded bg-light border" id="practice-essay-feedback-content" style="line-height: 1.7;">
            </div>
          </div>
        </div>

        <!-- Guidelines for Essay Tab -->
        <div class="col-lg-5">
          <div class="cardx card-pad mb-4">
            <div class="section-head mb-3">
              <h2 class="card-title">Quy trình chấm bài tự luận AI</h2>
            </div>
            <div class="step-line mb-2">
              <div class="step-dot">1</div>
              <div class="step-copy">
                <strong>Tiếp nhận bài làm</strong>
                <div class="small text-muted">Hệ thống lưu trữ ảnh và văn bản an toàn vào máy chủ.</div>
              </div>
            </div>
            <div class="step-line mb-2">
              <div class="step-dot">2</div>
              <div class="step-copy">
                <strong>Trích xuất & Nhận diện thị giác</strong>
                <div class="small text-muted">AI Vision đọc các ký hiệu toán học, toạ độ, dấu biến thiên và hình vẽ.</div>
              </div>
            </div>
            <div class="step-line mb-2">
              <div class="step-dot">3</div>
              <div class="step-copy">
                <strong>Đánh giá logic từng bước</strong>
                <div class="small text-muted">So sánh với đáp án chuẩn, chỉ ra bước đúng, sai hoặc còn thiếu.</div>
              </div>
            </div>
            <div class="step-line">
              <div class="step-dot done"></div>
              <div class="step-copy">
                <strong>Phản hồi chi tiết</strong>
                <div class="small text-muted">Đưa ra gợi ý gợi mở (Socratic) để bạn tự sửa chữa và nâng cao kỹ năng.</div>
              </div>
            </div>
          </div>

          <div class="cardx card-pad">
            <div class="section-head mb-2">
              <h2 class="card-title">Mẹo chụp ảnh bài làm</h2>
            </div>
            <ul class="small text-muted ps-3 mb-0">
              <li class="mb-2">Đặt bài làm trên mặt phẳng sáng rõ, tránh bóng che.</li>
              <li class="mb-2">Chụp thẳng góc để chữ viết và công thức không bị nghiêng.</li>
              <li class="mb-2">Chữ viết rõ ràng, ghi rõ từng bước biến đổi đại số hoặc hình vẽ.</li>
              <li>Định dạng hỗ trợ: JPG, PNG, WEBP dưới 10MB.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>

  <script src="${pageContext.request.contextPath}/js/practice.js"></script>

  <!-- Practice Page Tabs & Essay Integration Logic -->
  <script>
    // Tab switching handler
    function switchPracticeTab(tab) {
      const tabMcqBtn = document.getElementById('tab-mcq-btn');
      const tabEssayBtn = document.getElementById('tab-essay-btn');
      const sectionMcq = document.getElementById('section-mcq-practice');
      const sectionEssay = document.getElementById('section-essay-practice');

      if (tab === 'essay') {
        tabMcqBtn.classList.remove('active');
        tabEssayBtn.classList.add('active');
        sectionMcq.classList.add('d-none');
        sectionEssay.classList.remove('d-none');

        // Check if an essay question needs to be loaded (URL param, MCQ selection, or storage)
        const urlParams = new URLSearchParams(window.location.search);
        let lId = parseInt(urlParams.get('lessonId') || urlParams.get('lesson') || urlParams.get('id'), 10);
        if (isNaN(lId) || lId < 1 || lId > 27) {
          const mcqSelect = document.getElementById('practice-lesson-select');
          if (mcqSelect && mcqSelect.value) {
            const v = parseInt(mcqSelect.value, 10);
            if (!isNaN(v) && v >= 1 && v <= 27) lId = v;
          }
        }
        if (isNaN(lId) || lId < 1 || lId > 27) {
          const stored = parseInt(sessionStorage.getItem('math10_selected_lesson_id') || localStorage.getItem('math10_selected_lesson_id'), 10);
          if (!isNaN(stored) && stored >= 1 && stored <= 27) lId = stored;
        }
        if (isNaN(lId) || lId < 1 || lId > 27) lId = 1;

        initPracticeEssay(lId);
        triggerMathJax();
      } else {
        tabEssayBtn.classList.remove('active');
        tabMcqBtn.classList.add('active');
        sectionEssay.classList.add('d-none');
        sectionMcq.classList.remove('d-none');
        triggerMathJax();
      }
    }

    function triggerMathJax(elements) {
      function doTypeset() {
        if (!window.MathJax || !window.MathJax.typesetPromise) return;
        try {
          const targets = elements ? (Array.isArray(elements) ? elements : [elements]) : undefined;
          if (window.MathJax.typesetClear) {
            window.MathJax.typesetClear(targets);
          }
          window.MathJax.typesetPromise(targets).catch(err => console.debug('MathJax typeset:', err));
        } catch (e) {
          console.debug('MathJax trigger error:', e);
        }
      }

      if (window.MathJax && window.MathJax.typesetPromise) {
        doTypeset();
      } else {
        let retries = 0;
        const interval = setInterval(() => {
          retries++;
          if (window.MathJax && window.MathJax.typesetPromise) {
            clearInterval(interval);
            doTypeset();
          } else if (retries > 30) {
            clearInterval(interval);
          }
        }, 100);
      }
    }

    // Catalog for Essay in Practice page
    const practiceEssayCatalog = [
      { lessonId: 1, questionId: 33, chapter: "Chương I. Mệnh đề và tập hợp", lessonTitle: "Bài 1. Mệnh đề", text: "Giải thích vì sao câu “x > 3” chưa là mệnh đề khi chưa biết x. Viết phủ định của mệnh đề “7 là số nguyên tố”.", guide: "Mệnh đề phải khẳng định đúng hoặc sai xác định. Phủ định: '7 không phải là số nguyên tố'." },
      { lessonId: 2, questionId: 34, chapter: "Chương I. Mệnh đề và tập hợp", lessonTitle: "Bài 2. Tập hợp và các phép toán trên tập hợp", text: "Cho hai tập hợp \\( A = \\{1; 2; 3\\} \\) và \\( B = \\{3; 4; 5\\} \\). Tìm \\( A \\cup B \\) và \\( A \\cap B \\).", guide: "A ∪ B = {1, 2, 3, 4, 5}; A ∩ B = {3}." },
      { lessonId: 3, questionId: 35, chapter: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn", lessonTitle: "Bài 3. Bất phương trình bậc nhất hai ẩn", text: "Kiểm tra điểm \\( M(1; 2) \\) có thuộc miền nghiệm của bất phương trình \\( x + y \\le 4 \\) không. Nêu cách kiểm tra bằng phép thử.", guide: "Thay x=1, y=2 ta có 1 + 2 = 3 ≤ 4 (đúng) => M(1; 2) thuộc miền nghiệm." },
      { lessonId: 4, questionId: 36, chapter: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn", lessonTitle: "Bài 4. Hệ bất phương trình bậc nhất hai ẩn", text: "Mô tả miền nghiệm của hệ: \\( x \\ge 0, \\ y \\ge 0, \\ x + y \\le 4 \\) bằng các đỉnh của đa giác miền nghiệm.", guide: "Miền nghiệm là tam giác vuông OAB với O(0,0), A(4,0), B(0,4)." },
      { lessonId: 5, questionId: 37, chapter: "Chương III. Hệ thức lượng trong tam giác", lessonTitle: "Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°", text: "Tính \\( \\sin 150^\\circ \\) và \\( \\cos 150^\\circ \\). Trình bày công thức góc bù đã dùng.", guide: "sin 150° = sin 30° = 1/2; cos 150° = -cos 30° = -√3/2." },
      { lessonId: 6, questionId: 38, chapter: "Chương III. Hệ thức lượng trong tam giác", lessonTitle: "Bài 6. Hệ thức lượng trong tam giác", text: "Cho tam giác \\( ABC \\) có \\( b = 3 \\), \\( c = 4 \\) và góc \\( A = 60^\\circ \\). Dùng định lí côsin tính cạnh \\( a \\).", guide: "a² = b² + c² - 2bc·cos A = 9 + 16 - 2·3·4·(1/2) = 13 => a = √13." },
      { lessonId: 7, questionId: 39, chapter: "Chương IV. Vectơ", lessonTitle: "Bài 7. Các khái niệm mở đầu", text: "Cho \\( A(1; 1) \\), \\( B(4; 5) \\). Tính độ dài vectơ \\( \\vec{AB} \\) và nêu điều kiện để hai vectơ bằng nhau.", guide: "AB = (3; 4) => |AB| = √(3² + 4²) = 5." },
      { lessonId: 8, questionId: 40, chapter: "Chương IV. Vectơ", lessonTitle: "Bài 8. Tổng và hiệu của hai vectơ", text: "Phát biểu quy tắc ba điểm và áp dụng để rút gọn tổng vectơ: \\( \\vec{AB} + \\vec{BC} + \\vec{CA} \\).", guide: "AB + BC = AC; AC + CA = vectơ 0." },
      { lessonId: 9, questionId: 41, chapter: "Chương IV. Vectơ", lessonTitle: "Bài 9. Tích của một vectơ với một số", text: "Cho \\( |\\vec{a}| = 3 \\). Tính độ dài và xác định hướng của vectơ \\( -2\\vec{a} \\) so với vectơ \\( \\vec{a} \\).", guide: "Độ dài |-2a| = 6; vì -2 < 0 nên vectơ -2a ngược hướng với a." },
      { lessonId: 10, questionId: 42, chapter: "Chương IV. Vectơ", lessonTitle: "Bài 10. Vectơ trong mặt phẳng tọa độ", text: "Cho \\( A(1; -2) \\), \\( B(4; 2) \\). Tính tọa độ vectơ \\( \\vec{AB} \\) và khoảng cách giữa \\( A, B \\).", guide: "AB = (3; 4), độ dài AB = 5." },
      { lessonId: 11, questionId: 43, chapter: "Chương IV. Vectơ", lessonTitle: "Bài 11. Tích vô hướng của hai vectơ", text: "Cho \\( \\vec{a} = (2; 1) \\), \\( \\vec{b} = (1; -2) \\). Tính tích vô hướng \\( \\vec{a} \\cdot \\vec{b} \\) và kết luận góc giữa chúng.", guide: "a·b = 2·1 + 1·(-2) = 0 => hai vectơ vuông góc nhau (góc 90°)." },
      { lessonId: 12, questionId: 44, chapter: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm", lessonTitle: "Bài 12. Số gần đúng và sai số", text: "Làm tròn \\( 12{,}347 \\) đến hàng phần trăm. Tính sai số tuyệt đối do làm tròn.", guide: "Làm tròn: 12,35. Sai số tuyệt đối Δ = |12,347 - 12,35| = 0,003." },
      { lessonId: 13, questionId: 45, chapter: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm", lessonTitle: "Bài 13. Các số đặc trưng đo xu thế trung tâm", text: "Với mẫu số liệu \\( 2, \\ 3, \\ 3, \\ 8 \\), hãy tính số trung bình, trung vị và mốt.", guide: "Trung bình = 4; Trung vị = 3; Mốt = 3." },
      { lessonId: 14, questionId: 46, chapter: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm", lessonTitle: "Bài 14. Các số đặc trưng đo độ phân tán", text: "Với mẫu số liệu \\( 1, \\ 2, \\ 3 \\), tính khoảng biến thiên \\( R \\) và phương sai \\( s^2 \\).", guide: "R = 3 - 1 = 2; x̄ = 2; s² = 2/3." },
      { lessonId: 15, questionId: 47, chapter: "Chương VI. Hàm số, đồ thị và ứng dụng", lessonTitle: "Bài 15. Hàm số", text: "Tìm tập xác định của hàm số \\( f(x) = \\sqrt{x - 1} \\) và tính \\( f(5) \\).", guide: "ĐK: x ≥ 1 => TXĐ [1; +∞). f(5) = √(5-1) = 2." },
      { lessonId: 16, questionId: 5, chapter: "Chương VI. Hàm số, đồ thị và ứng dụng", lessonTitle: "Bài 16. Hàm số bậc hai", text: "Cho hàm số bậc hai \\( y = -x^2 + 4x - 3 \\).<br>a) Lập bảng biến thiên và xác định đỉnh parabol.<br>b) Tìm các giá trị \\( x \\) để \\( y \\ge 0 \\).", guide: "a) Đỉnh I(2; 1), trục đối xứng x = 2.<br>b) y ≥ 0 <=> 1 ≤ x ≤ 3." },
      { lessonId: 17, questionId: 48, chapter: "Chương VI. Hàm số, đồ thị và ứng dụng", lessonTitle: "Bài 17. Dấu của tam thức bậc hai", text: "Giải bất phương trình \\( x^2 - 5x + 6 \\le 0 \\) bằng cách xét dấu tam thức bậc hai.", guide: "Nghiệm của tam thức là x=2 và x=3. Trong khoảng hai nghiệm: 2 ≤ x ≤ 3." },
      { lessonId: 18, questionId: 49, chapter: "Chương VI. Hàm số, đồ thị và ứng dụng", lessonTitle: "Bài 18. Phương trình quy về phương trình bậc hai", text: "Giải phương trình vô tỉ: \\( \\sqrt{x + 1} = x \\) và đối chiếu điều kiện.", guide: "ĐK: x ≥ 0. x + 1 = x² <=> x² - x - 1 = 0 => x = (1 + √5)/2." },
      { lessonId: 19, questionId: 50, chapter: "Chương VII. Phương pháp tọa độ trong mặt phẳng", lessonTitle: "Bài 19. Phương trình đường thẳng", text: "Viết phương trình đường thẳng qua \\( M(1; 2) \\), có VTPT \\( \\vec{n} = (2; -1) \\).", guide: "Phương trình: 2(x - 1) - 1(y - 2) = 0 <=> 2x - y = 0." },
      { lessonId: 20, questionId: 51, chapter: "Chương VII. Phương pháp tọa độ trong mặt phẳng", lessonTitle: "Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách", text: "Tính khoảng cách từ gốc tọa độ \\( O(0; 0) \\) đến đường thẳng \\( 3x + 4y - 10 = 0 \\).", guide: "d = |3·0 + 4·0 - 10| / √(3² + 4²) = 10 / 5 = 2." },
      { lessonId: 21, questionId: 52, chapter: "Chương VII. Phương pháp tọa độ trong mặt phẳng", lessonTitle: "Bài 21. Đường tròn trong mặt phẳng tọa độ", text: "Viết phương trình đường tròn tâm \\( I(2; -1) \\), bán kính \\( R = 3 \\).", guide: "(x - 2)² + (y + 1)² = 9." },
      { lessonId: 22, questionId: 53, chapter: "Chương VII. Phương pháp tọa độ trong mặt phẳng", lessonTitle: "Bài 22. Ba đường conic", text: "Cho elip \\( \\frac{x^2}{25} + \\frac{y^2}{9} = 1 \\). Xác định các bán trục \\( a, b \\) và tọa độ hai tiêu điểm.", guide: "a = 5, b = 3 => c = 4. Tiêu điểm F1(-4; 0), F2(4; 0)." },
      { lessonId: 23, questionId: 54, chapter: "Chương VIII. Đại số tổ hợp", lessonTitle: "Bài 23. Quy tắc đếm", text: "Có 3 áo khác màu và 4 quần khác kiểu. Hỏi có bao nhiêu cách chọn một bộ quần áo gồm một áo và một quần?", guide: "Quy tắc nhân: 3 × 4 = 12 cách." },
      { lessonId: 24, questionId: 55, chapter: "Chương VIII. Đại số tổ hợp", lessonTitle: "Bài 24. Hoán vị, chỉnh hợp và tổ hợp", text: "Có 5 học sinh. Hỏi có bao nhiêu cách chọn 2 bạn lập một nhóm? Giải thích vì sao dùng tổ hợp.", guide: "Không phân biệt thứ tự: C(5, 2) = 10 cách." },
      { lessonId: 25, questionId: 56, chapter: "Chương VIII. Đại số tổ hợp", lessonTitle: "Bài 25. Nhị thức Newton", text: "Khai triển \\( (x + 2)^3 \\) bằng công thức nhị thức Newton.", guide: "(x + 2)³ = x³ + 6x² + 12x + 8." },
      { lessonId: 26, questionId: 57, chapter: "Chương IX. Tính xác suất theo định nghĩa cổ điển", lessonTitle: "Bài 26. Biến cố và định nghĩa cổ điển của xác suất", text: "Gieo một con xúc xắc cân đối. Tính xác suất xuất hiện mặt có số chấm là số chẵn.", guide: "n(Ω) = 6, n(A) = 3 => P = 3/6 = 0,5." },
      { lessonId: 27, questionId: 58, chapter: "Chương IX. Tính xác suất theo định nghĩa cổ điển", lessonTitle: "Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển", text: "Gieo đồng thời hai đồng xu cân đối. Tính xác suất có đúng một mặt sấp.", guide: "n(Ω) = 4, thuận lợi có 2 => P = 2/4 = 0,5." }
    ];

    let practiceEssayCurrentQuestion = null;
    let practiceEssayAttachedFile = null;

    function initPracticeEssay(lessonId) {
      const sel = document.getElementById('practice-essay-lesson-select');
      if (!sel) return;

      sel.innerHTML = practiceEssayCatalog.map(q => {
        const isSel = (q.lessonId === lessonId) ? 'selected' : '';
        return `<option value="\${q.lessonId}" \${isSel}>\${q.lessonTitle} (\${q.chapter})</option>`;
      }).join('');

      sel.onchange = (e) => {
        const selectedLessonId = parseInt(e.target.value, 10);
        renderPracticeEssayQuestion(selectedLessonId);
        try {
          sessionStorage.setItem('math10_selected_lesson_id', String(selectedLessonId));
          localStorage.setItem('math10_selected_lesson_id', String(selectedLessonId));
          const newUrl = window.location.pathname + '?tab=essay&lessonId=' + selectedLessonId;
          window.history.replaceState(null, '', newUrl);
        } catch (e) {}
      };

      renderPracticeEssayQuestion(lessonId);
    }

    function renderPracticeEssayQuestion(lessonId) {
      const item = practiceEssayCatalog.find(q => q.lessonId === lessonId) || practiceEssayCatalog[0];
      practiceEssayCurrentQuestion = item;

      const topicEl = document.getElementById('practice-essay-topic-title');
      const textEl = document.getElementById('practice-essay-question-text');
      const guideEl = document.getElementById('practice-essay-guide-text');
      const socraticBtn = document.getElementById('btn-open-socratic-essay');

      if (topicEl) topicEl.textContent = `\${item.chapter} • \${item.lessonTitle}`;
      if (textEl) textEl.innerHTML = item.text;
      if (guideEl) guideEl.innerHTML = item.guide;

      // Ensure the "Mở Gia sư từng bước" button carries the selected lessonId
      if (socraticBtn) {
        socraticBtn.href = '${pageContext.request.contextPath}/essay?lessonId=' + item.lessonId;
      }

      // Persist to storage
      try {
        sessionStorage.setItem('math10_selected_lesson_id', String(item.lessonId));
        localStorage.setItem('math10_selected_lesson_id', String(item.lessonId));
      } catch (e) {}

      document.getElementById('practice-essay-feedback-card').classList.add('d-none');
      document.getElementById('practice-essay-alert').classList.add('d-none');
      resetPracticeEssayImage();

      triggerMathJax();
    }

    function resetPracticeEssayImage() {
      practiceEssayAttachedFile = null;
      const fileInput = document.getElementById('practice-essay-image-input');
      const previewBox = document.getElementById('practice-essay-preview-box');
      const previewImg = document.getElementById('practice-essay-preview-img');
      if (fileInput) fileInput.value = '';
      if (previewImg) previewImg.src = '';
      if (previewBox) previewBox.classList.add('d-none');
    }

    // Setup Essay Drag & Drop on Practice page
    function setupPracticeEssayUpload() {
      const dropZone = document.getElementById('practice-essay-drop-zone');
      const fileInput = document.getElementById('practice-essay-image-input');
      const removeBtn = document.getElementById('practice-essay-remove-img');

      if (!dropZone || !fileInput) return;

      dropZone.onclick = () => fileInput.click();

      fileInput.onchange = (e) => {
        if (e.target.files && e.target.files.length > 0) {
          const file = e.target.files[0];
          if (!file.type.match(/^image\/(jpeg|png|webp)$/)) {
            alert('Vui lòng chỉ tải lên ảnh JPG, PNG hoặc WEBP.');
            return;
          }
          if (file.size > 10 * 1024 * 1024) {
            alert('Ảnh không được vượt quá 10 MB.');
            return;
          }
          practiceEssayAttachedFile = file;

          const previewBox = document.getElementById('practice-essay-preview-box');
          const previewImg = document.getElementById('practice-essay-preview-img');
          const fileNameEl = document.getElementById('practice-essay-file-name');

          const reader = new FileReader();
          reader.onload = (ev) => {
            previewImg.src = ev.target.result;
            fileNameEl.textContent = file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
            previewBox.classList.remove('d-none');
          };
          reader.readAsDataURL(file);
        }
      };

      if (removeBtn) {
        removeBtn.onclick = (e) => {
          e.stopPropagation();
          resetPracticeEssayImage();
        };
      }
    }

    // Submit Essay on Practice Page
    function setupPracticeEssaySubmit() {
      const form = document.getElementById('practice-essay-form');
      if (!form) return;

      form.onsubmit = async (e) => {
        e.preventDefault();
        const answerText = (document.getElementById('practice-essay-answer-text').value || '').trim();
        const alertEl = document.getElementById('practice-essay-alert');
        const submitBtn = document.getElementById('practice-essay-submit-btn');
        const spinner = document.getElementById('practice-essay-spinner');
        const feedbackCard = document.getElementById('practice-essay-feedback-card');
        const feedbackContent = document.getElementById('practice-essay-feedback-content');
        const scoreBadge = document.getElementById('practice-essay-score-badge');

        alertEl.classList.add('d-none');

        if (!answerText && !practiceEssayAttachedFile) {
          alertEl.className = 'alert alert-warning py-2 px-3 small';
          alertEl.textContent = 'Vui lòng nhập lời giải hoặc tải lên ảnh chụp bài làm trước khi nộp.';
          alertEl.classList.remove('d-none');
          return;
        }

        submitBtn.disabled = true;
        spinner.classList.remove('d-none');
        alertEl.className = 'alert alert-info py-2 px-3 small';
        alertEl.textContent = 'AI Vision đang phân tích bài giải và chấm điểm... Vui lòng chờ.';
        alertEl.classList.remove('d-none');

        try {
          let sessionUser = { username: 'demo.student' };
          try {
            const raw = localStorage.getItem('math10_session_user');
            if (raw) sessionUser = JSON.parse(raw);
          } catch(_) {}

          const formData = new FormData();
          const qId = practiceEssayCurrentQuestion ? practiceEssayCurrentQuestion.questionId : 33;
          formData.append('questionId', qId);
          if (answerText) formData.append('answerText', answerText);
          if (practiceEssayAttachedFile) formData.append('image', practiceEssayAttachedFile);

          const apiBase = window.MATH10_API_BASE_URL || 'http://localhost:8081/api/v1';
          const res = await fetch(apiBase + '/attempts/essay', {
            method: 'POST',
            headers: {
              'X-Auth-User': sessionUser.username || 'demo.student'
            },
            credentials: 'include',
            body: formData
          });

          if (!res.ok) {
            let msg = 'Mã lỗi: ' + res.status;
            try {
              const body = await res.json();
              if (body.message) msg = body.message;
            } catch(_) {}
            throw new Error(msg);
          }

          const attempt = await res.json();
          alertEl.classList.add('d-none');

          // If this practice is for an assigned homework, mark it submitted
          const assignParam = new URLSearchParams(window.location.search).get('assignId');
          if (assignParam) {
            try {
              await fetch(apiBase + '/assignments/' + assignParam + '/submit?score=' + (attempt.score || 10), {
                method: 'POST',
                headers: { 'X-Auth-User': sessionUser.username || 'student' },
                credentials: 'include'
              });
            } catch(_) {}
          }

          feedbackCard.classList.remove('d-none');
          if (attempt.score !== null && attempt.score !== undefined) {
            scoreBadge.textContent = 'Điểm: ' + Number(attempt.score).toFixed(1) + ' / 10';
          } else {
            scoreBadge.textContent = 'AI đã chấm bài';
          }

          let raw = attempt.feedback || 'Bài làm đã được chấm điểm.';
          raw = raw
            .replace(/^### (.*$)/gim, '<h5 class="fw-bold text-primary mt-3 mb-2">$1</h5>')
            .replace(/^## (.*$)/gim, '<h4 class="fw-bold text-dark mt-3 mb-2">$1</h4>')
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/\n\n/g, '<p class="mb-2"></p>')
            .replace(/\n/g, '<br>');

          feedbackContent.innerHTML = raw;

          if (window.MathJax && window.MathJax.typesetPromise) {
            window.MathJax.typesetPromise();
          }

          feedbackCard.scrollIntoView({ behavior: 'smooth', block: 'start' });

        } catch (err) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = err.message || 'Lỗi khi gửi bài làm lên máy chủ.';
        } finally {
          submitBtn.disabled = false;
          spinner.classList.add('d-none');
        }
      };
    }

    // Auto-detect URL tab on load
    document.addEventListener('DOMContentLoaded', () => {
      setupPracticeEssayUpload();
      setupPracticeEssaySubmit();

      const essayNextBtn = document.getElementById('practice-essay-next-lesson-btn');
      if (essayNextBtn) {
        essayNextBtn.onclick = () => {
          const sel = document.getElementById('practice-essay-lesson-select');
          if (!sel) return;
          const cur = parseInt(sel.value, 10) || 1;
          const next = (cur % 27) + 1;
          sel.value = String(next);
          renderPracticeEssayQuestion(next);
          window.scrollTo({ top: 0, behavior: 'smooth' });
        };
      }

      const urlParams = new URLSearchParams(window.location.search);
      const tabParam = (urlParams.get('tab') || urlParams.get('type') || '').toLowerCase();
      let lessonParam = parseInt(urlParams.get('lessonId') || urlParams.get('lesson') || urlParams.get('id'), 10);
      if (isNaN(lessonParam) || lessonParam < 1 || lessonParam > 27) {
        const stored = parseInt(sessionStorage.getItem('math10_selected_lesson_id') || localStorage.getItem('math10_selected_lesson_id'), 10);
        if (!isNaN(stored) && stored >= 1 && stored <= 27) lessonParam = stored;
      }
      if (isNaN(lessonParam) || lessonParam < 1 || lessonParam > 27) lessonParam = 1;

      if (tabParam === 'essay') {
        switchPracticeTab('essay');
      } else {
        // Default MCQ, but pre-populate essay with lessonId
        initPracticeEssay(lessonParam);
      }
    });
  </script>
<jsp:include page="/common/footer.jsp" />
