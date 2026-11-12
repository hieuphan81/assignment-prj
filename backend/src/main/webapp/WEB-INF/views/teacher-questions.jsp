<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Ngân hàng câu hỏi & Tạo đề ngẫu nhiên AI — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="teacher-questions" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Ngân hàng câu hỏi & AI" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading align-items-start pb-3 border-bottom mb-4">
      <div>
        <div class="eyebrow text-primary fw-semibold">GIÁO VIÊN &bull; NGÂN HÀNG CÂU HỎI & AI GENERATOR</div>
        <h1 class="mb-2">Quản lý câu hỏi & Tạo đề ngẫu nhiên bằng AI</h1>
        <p class="text-muted mb-0">Sử dụng Google Gemini AI để sinh đề thi ngẫu nhiên theo chủ đề hoặc toàn bộ chương trình Toán 10. Giáo viên có thể duyệt, xem trước và xuất đề thi cho học sinh.</p>
      </div>
      <div class="d-flex flex-wrap gap-2 mt-2 mt-md-0">
        <button class="btn btn-primary fw-semibold shadow-xs d-flex align-items-center gap-2" id="btn-open-gen-modal" type="button" data-bs-toggle="modal" data-bs-target="#generateAiModal">
          Tạo đề ngẫu nhiên bằng AI
        </button>
        <button class="btn btn-outline-secondary" type="button" data-bs-toggle="modal" data-bs-target="#createManualQuestionModal">
          + Soạn câu hỏi thủ công
        </button>
      </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
      <div class="col-sm-6 col-xl-3">
        <div class="cardx card-pad p-3">
          <div class="text-muted small">Tổng câu hỏi trong ngân hàng</div>
          <div class="h3 fw-bold mb-0 mt-1" id="stat-total-count">0</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx card-pad p-3">
          <div class="text-muted small">Câu hỏi Trắc nghiệm (MCQ)</div>
          <div class="h3 fw-bold mb-0 mt-1 text-primary" id="stat-mcq-count">0</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx card-pad p-3">
          <div class="text-muted small">Câu hỏi Tự luận (ESSAY)</div>
          <div class="h3 fw-bold mb-0 mt-1 text-info" id="stat-essay-count">0</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx card-pad p-3">
          <div class="text-muted small">Do AI sinh (Chờ duyệt)</div>
          <div class="h3 fw-bold mb-0 mt-1 text-warning" id="stat-pending-count">0</div>
        </div>
      </div>
    </div>

    <!-- Questions Bank Card -->
    <div class="cardx card-pad">
      <!-- Comprehensive Filters Toolbar -->
      <div class="row g-2 align-items-center mb-3">
        <!-- Lesson Dropdown Filter -->
        <div class="col-md-5 col-lg-4">
          <div class="input-group input-group-sm">
            <span class="input-group-text bg-light text-secondary fw-semibold">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
              Bài học:
            </span>
            <select class="form-select form-select-sm fw-semibold" id="filter-lesson-select">
              <option value="ALL">Tất cả bài học (Toàn bộ 27 bài)</option>
            </select>
          </div>
        </div>

        <!-- Search Keyword -->
        <div class="col-md-4 col-lg-4">
          <div class="input-group input-group-sm">
            <span class="input-group-text bg-light text-secondary small fw-semibold">Tìm kiếm</span>
            <input type="text" class="form-control form-control-sm" id="filter-search-input" placeholder="Nhập từ khóa đề bài..." />
          </div>
        </div>

        <!-- Question Type Filters -->
        <div class="col-md-3 col-lg-4 text-md-end">
          <div class="btn-group btn-group-sm" role="group" id="filter-group">
            <button type="button" class="btn btn-outline-secondary active" data-filter="ALL">Tất cả</button>
            <button type="button" class="btn btn-outline-secondary" data-filter="MCQ">Trắc nghiệm</button>
            <button type="button" class="btn btn-outline-secondary" data-filter="ESSAY">Tự luận</button>
            <button type="button" class="btn btn-outline-secondary" data-filter="PENDING_REVIEW">Chờ duyệt (AI)</button>
          </div>
        </div>
      </div>

      <!-- Active Lesson Filter Banner -->
      <div class="alert alert-primary py-2 px-3 small d-none align-items-center justify-content-between mb-3 shadow-xs" id="active-lesson-filter-alert">
        <div class="d-flex align-items-center gap-2">
          <span>Đang lọc câu hỏi theo: <strong id="filter-active-lesson-title">Bài 1. Mệnh đề</strong> (<span id="filter-active-lesson-count">0</span> câu hỏi)</span>
        </div>
        <button class="btn btn-sm btn-link text-primary text-decoration-none fw-semibold p-0" id="btn-clear-lesson-filter" type="button">Xem tất cả 27 bài</button>
      </div>

      <div class="table-responsive">
        <table class="table table-hover align-middle" id="questions-table">
          <thead class="table-light">
            <tr>
              <th scope="col" style="width: 60px;">ID</th>
              <th scope="col" style="width: 140px;">Bài học</th>
              <th scope="col">Đề bài</th>
              <th scope="col" style="width: 90px;">Loại</th>
              <th scope="col" style="width: 90px;">Nguồn</th>
              <th scope="col" style="width: 100px;">Độ khó</th>
              <th scope="col" style="width: 130px;">Trạng thái</th>
              <th scope="col" style="width: 160px;">Thao tác</th>
            </tr>
          </thead>
          <tbody id="questions-tbody">
            <tr>
              <td colspan="8" class="text-center py-4 text-muted">
                <div class="spinner-border spinner-border-sm text-primary mb-2" role="status"></div>
                <div>Đang tải ngân hàng câu hỏi...</div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div><!-- End .main-area -->

<!-- ======================================================== -->
<!-- MODALS PLACED OUTSIDE MAIN-AREA TO PREVENT Z-INDEX BUGS  -->
<!-- ======================================================== -->

<!-- Modal Generate Questions / Exam via AI -->
<div class="modal fade" id="generateAiModal" tabindex="-1" aria-labelledby="generateAiModalLabel" aria-hidden="true" style="z-index: 1060;">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content shadow-lg border-0">
      <div class="modal-header bg-light">
        <h5 class="modal-title d-flex align-items-center gap-2" id="generateAiModalLabel">
          Tạo đề ngẫu nhiên bằng AI (Google Gemini)
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <form id="ai-generate-question-form">
        <div class="modal-body p-4">
          <div class="alert alert-primary py-2 px-3 small mb-3">
            Hệ thống AI sẽ áp dụng cấu trúc đề chuẩn chương trình Toán 10 mới (SGK Kết nối tri thức), tự động soạn đề bài, các phương án lựa chọn và lời giải chi tiết.
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold" for="gen-lesson-id">Phạm vi kiến thức đề thi</label>
            <select class="form-select" id="gen-lesson-id" required>
              <option value="0" selected>Ngẫu nhiên toàn bộ chương trình Toán 10 (Tổng hợp)</option>
              <!-- Dynamically populated 27 lessons -->
            </select>
          </div>

          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <label class="form-label fw-bold" for="gen-type">Loại câu hỏi</label>
              <select class="form-select" id="gen-type">
                <option value="MCQ" selected>Trắc nghiệm khách quan (4 phương án A, B, C, D)</option>
                <option value="ESSAY">Tự luận kèm các bước giải chi tiết</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-bold" for="gen-difficulty">Độ khó câu hỏi</label>
              <select class="form-select" id="gen-difficulty">
                <option value="MEDIUM" selected>Thông hiểu (Trung bình)</option>
                <option value="EASY">Nhận biết (Cơ bản)</option>
                <option value="HARD">Vận dụng & Vận dụng cao</option>
              </select>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold" for="gen-count">Số lượng câu cần sinh trong đề</label>
            <select class="form-select" id="gen-count">
              <option value="3">3 câu (Bộ câu hỏi nhanh)</option>
              <option value="5" selected>5 câu (Đề kiểm tra 15 phút)</option>
              <option value="10">10 câu (Đề kiểm tra 1 tiết)</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold" for="gen-prompt">Yêu cầu biên soạn bổ sung (tuỳ chọn)</label>
            <textarea class="form-control" id="gen-prompt" rows="2" placeholder="Ví dụ: Tập trung vào bài toán thực tế, tìm toạ độ đỉnh parabol, tính diện tích tam giác..."></textarea>
          </div>

          <div id="ai-generate-status-box" class="d-none">
            <div class="card p-3 border border-primary-subtle bg-light-subtle text-center">
              <div class="spinner-border text-primary mx-auto mb-2" role="status"></div>
              <strong class="text-primary">Google Gemini AI đang biên soạn đề thi...</strong>
              <div class="small text-muted mt-1">Quá trình có thể mất từ 3-8 giây tuỳ vào độ phức tạp của công thức toán.</div>
            </div>
          </div>
        </div>
        <div class="modal-footer bg-light">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
          <button type="button" class="btn btn-primary fw-bold" id="btn-start-generate">
            Bắt đầu tạo đề thi bằng AI
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal View Question Detail -->
<div class="modal fade" id="viewQuestionModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content shadow-lg border-0">
      <div class="modal-header bg-light">
        <h5 class="modal-title" id="viewQuestionModalTitle">Chi tiết câu hỏi</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body p-4" id="viewQuestionModalBody">
        <!-- Dynamic content -->
      </div>
      <div class="modal-footer bg-light d-flex justify-content-between">
        <button type="button" class="btn btn-outline-danger" id="modal-btn-delete">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1 align-middle"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
          Xóa câu hỏi này
        </button>
        <div class="d-flex gap-2">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
          <button type="button" class="btn btn-success text-white" id="modal-btn-publish">Duyệt xuất bản câu hỏi này</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal Generated Exam Preview & Export -->
<div class="modal fade" id="examPreviewModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
  <div class="modal-dialog modal-xl modal-dialog-centered">
    <div class="modal-content shadow-lg border-0">
      <div class="modal-header bg-light">
        <h5 class="modal-title fw-bold" id="examPreviewModalTitle">ĐỀ THI TOÁN 10 DO AI VỪA SINH</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body p-4" id="examPreviewModalBody">
        <!-- Dynamic content -->
      </div>
      <div class="modal-footer bg-light">
        <button type="button" class="btn btn-outline-secondary" onclick="window.print()">In đề thi</button>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Hoàn tất & Quay lại ngân hàng</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Manual Create Question -->
<div class="modal fade" id="createManualQuestionModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content shadow-lg border-0">
      <div class="modal-header bg-light">
        <h5 class="modal-title">+ Soạn câu hỏi thủ công</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <form id="manual-question-form">
        <div class="modal-body p-4">
          <div class="mb-3">
            <label class="form-label fw-bold">Bài học</label>
            <select class="form-select" id="manual-lesson-id" required>
              <!-- 27 lessons -->
            </select>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <label class="form-label fw-bold">Loại câu hỏi</label>
              <select class="form-select" id="manual-type">
                <option value="MCQ" selected>Trắc nghiệm (MCQ)</option>
                <option value="ESSAY">Tự luận (ESSAY)</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-bold">Độ khó</label>
              <select class="form-select" id="manual-difficulty">
                <option value="EASY">Cơ bản (EASY)</option>
                <option value="MEDIUM" selected>Trung bình (MEDIUM)</option>
                <option value="HARD">Nâng cao (HARD)</option>
              </select>
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label fw-bold">Nội dung đề bài</label>
            <textarea class="form-control" id="manual-text" rows="3" required placeholder="Nhập đề bài toán..."></textarea>
          </div>

          <div id="manual-mcq-fields">
            <div class="row g-2 mb-2">
              <div class="col-6">
                <input type="text" class="form-control" id="manual-opt-a" placeholder="Phương án A">
              </div>
              <div class="col-6">
                <input type="text" class="form-control" id="manual-opt-b" placeholder="Phương án B">
              </div>
              <div class="col-6">
                <input type="text" class="form-control" id="manual-opt-c" placeholder="Phương án C">
              </div>
              <div class="col-6">
                <input type="text" class="form-control" id="manual-opt-d" placeholder="Phương án D">
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label fw-bold">Đáp án đúng</label>
              <select class="form-select" id="manual-correct">
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
              </select>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Giải thích & Lời giải chi tiết</label>
            <textarea class="form-control" id="manual-explanation" rows="2" placeholder="Lời giải từng bước..."></textarea>
          </div>
        </div>
        <div class="modal-footer bg-light">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary" id="btn-save-manual">Lưu câu hỏi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Load 27 lessons data -->
<script src="${pageContext.request.contextPath}/js/lesson-detail.js?v=20261006"></script>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const apiBase = window.MATH10_API_BASE_URL || '/api/v1';
    let allQuestions = [];
    let currentFilter = 'ALL';

    const genLessonSelect = document.getElementById('gen-lesson-id');
    const manualLessonSelect = document.getElementById('manual-lesson-id');
    const filterLessonSelect = document.getElementById('filter-lesson-select');
    const filterSearchInput = document.getElementById('filter-search-input');
    const activeLessonAlert = document.getElementById('active-lesson-filter-alert');
    const activeLessonTitle = document.getElementById('filter-active-lesson-title');
    const activeLessonCount = document.getElementById('filter-active-lesson-count');
    const btnClearLessonFilter = document.getElementById('btn-clear-lesson-filter');
    const lessonsData = window.MATH10_LESSONS_DATA || {};

    let currentLessonFilter = 'ALL';
    let currentSearchKeyword = '';

    function openGenerateAiModal() {
      const modalEl = document.getElementById('generateAiModal');
      if (modalEl && window.bootstrap && window.bootstrap.Modal) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
      }
    }
    window.openGenerateAiModal = openGenerateAiModal;

    // Check URL param for lessonId and openAi flag
    const urlParams = new URLSearchParams(window.location.search);
    const initialLessonId = urlParams.get('lessonId');
    if (initialLessonId && Number(initialLessonId) >= 1 && Number(initialLessonId) <= 27) {
      currentLessonFilter = String(initialLessonId);
    }

    const shouldOpenAi = (urlParams.get('openAi') === 'true' || window.location.hash === '#aiGen' || window.location.hash === '#generateAiModal');
    if (shouldOpenAi) {
      setTimeout(() => {
        openGenerateAiModal();
      }, 300);
    }

    // 1. Populate 27 lessons in dropdowns (grouped by Chapters)
    const chapters = [
      { name: 'Chương I. Mệnh đề và tập hợp', lessons: [1, 2] },
      { name: 'Chương II. Bất phương trình bậc nhất hai ẩn', lessons: [3, 4] },
      { name: 'Chương III. Hệ thức lượng trong tam giác', lessons: [5, 6] },
      { name: 'Chương IV. Vectơ', lessons: [7, 8, 9, 10, 11] },
      { name: 'Chương V. Các số đặc trưng mẫu số liệu', lessons: [12, 13, 14] },
      { name: 'Chương VI. Hàm số và đồ thị', lessons: [15, 16, 17, 18] },
      { name: 'Chương VII. Phương pháp tọa độ trong mặt phẳng', lessons: [19, 20, 21, 22] },
      { name: 'Chương VIII. Đại số tổ hợp', lessons: [23, 24, 25] },
      { name: 'Chương IX. Tính xác suất', lessons: [26, 27] }
    ];

    chapters.forEach(chap => {
      const optGroupFilter = document.createElement('optgroup');
      optGroupFilter.label = chap.name;

      chap.lessons.forEach(lid => {
        const item = lessonsData[lid];
        const title = item ? item.title : ('Bài ' + lid);

        // Filter dropdown
        const optFilter = document.createElement('option');
        optFilter.value = String(lid);
        optFilter.textContent = title;
        if (String(lid) === currentLessonFilter) optFilter.selected = true;
        optGroupFilter.appendChild(optFilter);

        // Gen AI dropdown
        const optGen = document.createElement('option');
        optGen.value = lid;
        optGen.textContent = title;
        if (genLessonSelect) genLessonSelect.appendChild(optGen);

        // Manual question dropdown
        const optManual = document.createElement('option');
        optManual.value = lid;
        optManual.textContent = title;
        if (manualLessonSelect) manualLessonSelect.appendChild(optManual);
      });

      if (filterLessonSelect) filterLessonSelect.appendChild(optGroupFilter);
    });

    if (filterLessonSelect && currentLessonFilter !== 'ALL') {
      filterLessonSelect.value = currentLessonFilter;
    }

    function getAuthHeaders(extraHeaders = {}) {
      const headers = { ...extraHeaders };
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) {
          const u = JSON.parse(raw);
          if (u && u.username) {
            headers['X-Auth-User'] = u.username;
          }
        }
      } catch (e) {}
      return headers;
    }

    // 2. Fetch and render Questions list
    async function loadQuestions() {
      try {
        const res = await fetch(apiBase + '/manage/questions', {
          headers: getAuthHeaders(),
          credentials: 'include'
        });
        if (!res.ok) {
          document.getElementById('questions-tbody').innerHTML = 
            '<tr><td colspan="8" class="text-center py-4 text-danger">Không thể tải danh sách câu hỏi (' + res.status + ').</td></tr>';
          return;
        }
        allQuestions = await res.json();
        updateStats();
        renderTable();
      } catch (err) {
        document.getElementById('questions-tbody').innerHTML = 
          '<tr><td colspan="8" class="text-center py-4 text-danger">Lỗi kết nối máy chủ: ' + err.message + '</td></tr>';
      }
    }

    function updateStats() {
      const total = allQuestions.length;
      const mcq = allQuestions.filter(q => q.type === 'MCQ').length;
      const essay = allQuestions.filter(q => q.type === 'ESSAY').length;
      const pending = allQuestions.filter(q => q.status === 'PENDING_REVIEW').length;

      document.getElementById('stat-total-count').textContent = total;
      document.getElementById('stat-mcq-count').textContent = mcq;
      document.getElementById('stat-essay-count').textContent = essay;
      document.getElementById('stat-pending-count').textContent = pending;
    }

    function renderTable() {
      const tbody = document.getElementById('questions-tbody');
      let filtered = allQuestions;

      // Type filter
      if (currentFilter === 'MCQ') filtered = filtered.filter(q => q.type === 'MCQ');
      else if (currentFilter === 'ESSAY') filtered = filtered.filter(q => q.type === 'ESSAY');
      else if (currentFilter === 'PENDING_REVIEW') filtered = filtered.filter(q => q.status === 'PENDING_REVIEW');

      // Lesson filter
      if (currentLessonFilter !== 'ALL') {
        filtered = filtered.filter(q => String(q.lessonId) === String(currentLessonFilter));
        
        // Show active filter banner
        if (activeLessonAlert && activeLessonTitle && activeLessonCount) {
          const curData = lessonsData[currentLessonFilter];
          activeLessonTitle.textContent = curData ? curData.title : ('Bài ' + currentLessonFilter);
          activeLessonCount.textContent = filtered.length;
          activeLessonAlert.classList.remove('d-none');
          activeLessonAlert.classList.add('d-flex');
        }
      } else {
        if (activeLessonAlert) {
          activeLessonAlert.classList.add('d-none');
          activeLessonAlert.classList.remove('d-flex');
        }
      }

      // Keyword search
      if (currentSearchKeyword) {
        filtered = filtered.filter(q => (q.text || '').toLowerCase().includes(currentSearchKeyword));
      }

      if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4 text-muted">Không tìm thấy câu hỏi nào phù hợp với bộ lọc hiện tại.</td></tr>';
        return;
      }

      let html = '';
      filtered.forEach(q => {
        const lData = lessonsData[q.lessonId];
        const lessonName = lData ? lData.title : ('Bài ' + q.lessonId);
        const shortText = q.text.length > 70 ? q.text.substring(0, 70) + '...' : q.text;

        const typeBadge = q.type === 'MCQ' 
          ? '<span class="badge bg-primary">MCQ</span>' 
          : '<span class="badge bg-info text-dark">ESSAY</span>';

        const sourceBadge = q.source === 'AI' 
          ? '<span class="badge bg-warning text-dark">AI</span>' 
          : '<span class="badge bg-secondary">MANUAL</span>';

        let statusBadge = '<span class="badge bg-success">PUBLISHED</span>';
        if (q.status === 'PENDING_REVIEW') {
          statusBadge = '<span class="badge bg-warning text-dark">PENDING_REVIEW</span>';
        } else if (q.status === 'DRAFT') {
          statusBadge = '<span class="badge bg-secondary">DRAFT</span>';
        }

        let actions = '<div class="d-flex gap-1">';
        actions += '<button class="btn btn-sm btn-light border btn-view-q" data-id="' + q.id + '" title="Xem chi tiết">Xem</button>';
        if (q.status !== 'PUBLISHED') {
          actions += '<button class="btn btn-sm btn-primary btn-publish-q" data-id="' + q.id + '" title="Duyệt câu hỏi">Duyệt</button>';
        }
        actions += '<button class="btn btn-sm btn-outline-danger btn-delete-q" data-id="' + q.id + '" title="Xóa câu hỏi">'
          + '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1 align-middle"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>Xóa'
          + '</button>';
        actions += '</div>';

        html += '<tr>'
          + '<td>#' + q.id + '</td>'
          + '<td class="small fw-semibold text-primary">' + lessonName + '</td>'
          + '<td class="small">' + shortText + '</td>'
          + '<td>' + typeBadge + '</td>'
          + '<td>' + sourceBadge + '</td>'
          + '<td><span class="small text-muted">' + (q.difficulty || 'MEDIUM') + '</span></td>'
          + '<td>' + statusBadge + '</td>'
          + '<td>' + actions + '</td>'
          + '</tr>';
      });

      tbody.innerHTML = html;
      attachTableEvents();
      if (window.MathJax && window.MathJax.typesetPromise) window.MathJax.typesetPromise();
    }

    function attachTableEvents() {
      document.querySelectorAll('.btn-view-q').forEach(btn => {
        btn.addEventListener('click', () => {
          const id = parseInt(btn.getAttribute('data-id'), 10);
          const q = allQuestions.find(x => x.id === id);
          if (q) openDetailModal(q);
        });
      });

      document.querySelectorAll('.btn-publish-q').forEach(btn => {
        btn.addEventListener('click', async () => {
          const id = btn.getAttribute('data-id');
          await publishQuestion(id);
        });
      });

      document.querySelectorAll('.btn-delete-q').forEach(btn => {
        btn.addEventListener('click', async () => {
          const id = btn.getAttribute('data-id');
          await deleteQuestion(id);
        });
      });
    }

    async function deleteQuestion(id) {
      if (!confirm('Bạn có chắc chắn muốn xóa câu hỏi #' + id + ' không?\nLưu ý: Thao tác này sẽ xóa vĩnh viễn câu hỏi khỏi ngân hàng.')) {
        return;
      }
      try {
        const res = await fetch(apiBase + '/questions/' + id, {
          method: 'DELETE',
          headers: getAuthHeaders(),
          credentials: 'include'
        });
        if (!res.ok) {
          throw new Error('Không thể xóa câu hỏi (Mã lỗi ' + res.status + ').');
        }
        if (viewModal && currentViewingId == id) {
          viewModal.hide();
        }
        await loadQuestions();
      } catch (err) {
        alert('Lỗi khi xóa câu hỏi: ' + err.message);
      }
    }

    async function publishQuestion(id) {
      try {
        const res = await fetch(apiBase + '/questions/' + id + '/publish', {
          method: 'POST',
          headers: getAuthHeaders(),
          credentials: 'include'
        });
        if (!res.ok) {
          alert('Không thể duyệt câu hỏi (Mã lỗi ' + res.status + ').');
          return;
        }
        await loadQuestions();
      } catch(e) {
        alert('Lỗi: ' + e.message);
      }
    }

    // Filter by Lesson select change
    if (filterLessonSelect) {
      filterLessonSelect.addEventListener('change', (e) => {
        currentLessonFilter = e.target.value;
        if (currentLessonFilter !== 'ALL') {
          window.history.replaceState(null, '', window.location.pathname + '?lessonId=' + currentLessonFilter);
          if (genLessonSelect) genLessonSelect.value = currentLessonFilter;
        } else {
          window.history.replaceState(null, '', window.location.pathname);
        }
        renderTable();
      });
    }

    // Clear lesson filter button
    if (btnClearLessonFilter) {
      btnClearLessonFilter.addEventListener('click', () => {
        currentLessonFilter = 'ALL';
        if (filterLessonSelect) filterLessonSelect.value = 'ALL';
        window.history.replaceState(null, '', window.location.pathname);
        renderTable();
      });
    }

    // Search input change
    if (filterSearchInput) {
      filterSearchInput.addEventListener('input', (e) => {
        currentSearchKeyword = (e.target.value || '').trim().toLowerCase();
        renderTable();
      });
    }

    // Filter type buttons (ALL, MCQ, ESSAY, PENDING_REVIEW)
    document.querySelectorAll('#filter-group button').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('#filter-group button').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        currentFilter = btn.getAttribute('data-filter');
        renderTable();
      });
    });

    // Question Detail Modal
    let viewModal;
    function formatMathInContent(text) {
      if (!text) return '';
      let s = String(text).trim();

      // If the string starts with LaTeX command or contains math symbols without any $ or \(
      if (!s.includes('$') && !s.includes('\\(')) {
        if (s.includes('\\') || s.includes('^') || s.includes('_')) {
          return '$' + s + '$';
        }
      }

      // If text has inline LaTeX commands like \dfrac{...}{...} that are NOT wrapped in $...$
      s = s.replace(/(^|[^\$\\])(\\(?:d?frac|sqrt|mathbf|text|left|right|vec|alpha|beta|gamma|Delta|delta|theta|pi|sigma|pm|mp|cdot|times|div|le|ge|ne|approx|sim|in|subset|cap|cup|emptyset|forall|exists|infty|angle|sin|cos|tan|cot|log|ln)\b[^{\$]*?(?:\{[^{}]*\})*)/g, function(match, prefix, expr) {
        return prefix + '$' + expr + '$';
      });

      return s;
    }

    const modalPublishBtn = document.getElementById('modal-btn-publish');
    let currentViewingId = null;

    function openDetailModal(q) {
      currentViewingId = q.id;
      document.getElementById('viewQuestionModalTitle').textContent = 'Câu hỏi #' + q.id + ' (' + q.type + ' - ' + q.difficulty + ')';
      const body = document.getElementById('viewQuestionModalBody');

      let html = '<div class="mb-3"><strong>Đề bài:</strong><div class="mt-1 p-2 bg-light rounded text-dark lh-base">' + formatMathInContent(q.text) + '</div></div>';

      if (q.type === 'MCQ') {
        html += '<div class="row g-2 mb-3">'
          + '<div class="col-6 p-2 border rounded ' + (q.correctAnswer === 'A' ? 'bg-success-subtle fw-bold' : '') + '">A. ' + formatMathInContent(q.optionA || '') + '</div>'
          + '<div class="col-6 p-2 border rounded ' + (q.correctAnswer === 'B' ? 'bg-success-subtle fw-bold' : '') + '">B. ' + formatMathInContent(q.optionB || '') + '</div>'
          + '<div class="col-6 p-2 border rounded ' + (q.correctAnswer === 'C' ? 'bg-success-subtle fw-bold' : '') + '">C. ' + formatMathInContent(q.optionC || '') + '</div>'
          + '<div class="col-6 p-2 border rounded ' + (q.correctAnswer === 'D' ? 'bg-success-subtle fw-bold' : '') + '">D. ' + formatMathInContent(q.optionD || '') + '</div>'
          + '</div>';
        html += '<div class="mb-3"><span class="badge bg-success fs-6">Đáp án đúng: ' + q.correctAnswer + '</span></div>';
      }

      if (q.solutionSteps || q.explanation) {
        html += '<div class="mb-2"><strong>Lời giải / Giải thích:</strong><div class="mt-1 p-2 bg-light rounded text-secondary lh-base">' + formatMathInContent(q.solutionSteps || q.explanation) + '</div></div>';
      }

      body.innerHTML = html;
      if (q.status === 'PUBLISHED') {
        modalPublishBtn.classList.add('d-none');
      } else {
        modalPublishBtn.classList.remove('d-none');
      }

      if (!viewModal) viewModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('viewQuestionModal'));
      viewModal.show();
      if (window.MathJax && window.MathJax.typesetPromise) {
        setTimeout(() => {
          window.MathJax.typesetPromise([body]).catch(() => {});
        }, 50);
      }
    }

    if (modalPublishBtn) {
      modalPublishBtn.addEventListener('click', async () => {
        if (!currentViewingId) return;
        await publishQuestion(currentViewingId);
        if (viewModal) viewModal.hide();
      });
    }

    const modalDeleteBtn = document.getElementById('modal-btn-delete');
    if (modalDeleteBtn) {
      modalDeleteBtn.addEventListener('click', async () => {
        if (!currentViewingId) return;
        await deleteQuestion(currentViewingId);
      });
    }

    // 3. AI Question & Random Exam Generator Submit
    const btnStartGen = document.getElementById('btn-start-generate');
    const statusBox = document.getElementById('ai-generate-status-box');

    async function executeAiGeneration() {
      const lessonId = parseInt(document.getElementById('gen-lesson-id').value, 10);
      const type = document.getElementById('gen-type').value;
      const difficulty = document.getElementById('gen-difficulty').value;
      const count = parseInt(document.getElementById('gen-count').value, 10);
      const prompt = document.getElementById('gen-prompt').value;

      btnStartGen.disabled = true;
      btnStartGen.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tạo đề bằng AI...';
      statusBox.classList.remove('d-none');

      try {
        const payload = {
          lessonId: lessonId,
          type: type,
          difficulty: difficulty,
          count: count,
          instructions: prompt || null
        };

        const res = await fetch(apiBase + '/questions/generate', {
          method: 'POST',
          headers: getAuthHeaders({ 'Content-Type': 'application/json' }),
          credentials: 'include',
          body: JSON.stringify(payload)
        });

        if (!res.ok) {
          const errData = await res.json().catch(() => ({}));
          throw new Error(errData.detail || errData.message || ('Lỗi máy chủ (' + res.status + ')'));
        }

        const generatedList = await res.json();

        // Safely hide generate modal
        const genModalEl = document.getElementById('generateAiModal');
        const genModalInstance = bootstrap.Modal.getOrCreateInstance(genModalEl);
        genModalInstance.hide();

        // Refresh questions table
        await loadQuestions();

        // Show exam preview modal
        renderExamPreview(generatedList, lessonId, type);
        const examPreviewEl = document.getElementById('examPreviewModal');
        const examModalInstance = bootstrap.Modal.getOrCreateInstance(examPreviewEl);
        examModalInstance.show();
        if (window.MathJax && window.MathJax.typesetPromise) {
          setTimeout(() => {
            window.MathJax.typesetPromise([document.getElementById('examPreviewModalBody')]).catch(() => {});
          }, 60);
        }

      } catch (err) {
        alert('Tạo đề AI thất bại: ' + err.message);
      } finally {
        btnStartGen.disabled = false;
        btnStartGen.innerHTML = 'Bắt đầu tạo đề thi bằng AI';
        statusBox.classList.add('d-none');
      }
    }

    if (btnStartGen) {
      btnStartGen.addEventListener('click', (e) => {
        e.preventDefault();
        executeAiGeneration();
      });
    }

    const aiGenForm = document.getElementById('ai-generate-question-form');
    if (aiGenForm) {
      aiGenForm.addEventListener('submit', (e) => {
        e.preventDefault();
        executeAiGeneration();
      });
    }

    function renderExamPreview(list, lessonId, type) {
      const body = document.getElementById('examPreviewModalBody');
      const lTitle = lessonId > 0 && lessonsData[lessonId] ? lessonsData[lessonId].title : 'Toàn bộ chương trình Toán 10 (Tổng hợp)';

      let html = '<div class="border-bottom pb-3 mb-4 text-center">'
        + '<h4 class="fw-bold mb-1">ĐỀ KIỂM TRA MÔN TOÁN LỚP 10</h4>'
        + '<div class="text-muted small">Chủ đề: ' + lTitle + ' &bull; Hình thức: ' + (type === 'MCQ' ? 'Trắc nghiệm khách quan' : 'Tự luận') + ' &bull; Số lượng: ' + list.length + ' câu</div>'
        + '<div class="badge bg-warning text-dark mt-2">Biên soạn tự động bằng AI (Google Gemini)</div>'
        + '</div>';

      list.forEach((q, idx) => {
        const qLessonName = (q.lessonId > 0 && lessonsData[q.lessonId]) ? lessonsData[q.lessonId].title : ('Bài ' + q.lessonId);
        html += '<div class="card p-3 mb-3 border shadow-xs" id="exam-preview-item-' + q.id + '">'
          + '<div class="d-flex justify-content-between align-items-center mb-2">'
          + '<strong class="text-primary">Câu ' + (idx + 1) + ' [' + qLessonName + '] (ID #' + q.id + ' - ' + q.difficulty + '):</strong>'
          + '<div class="d-flex align-items-center gap-2">'
          + '<span class="badge bg-secondary">' + q.status + '</span>'
          + '<button type="button" class="btn btn-sm btn-outline-danger btn-delete-preview-q py-0 px-2" data-id="' + q.id + '" title="Xóa câu hỏi này">'
          + '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1 align-middle"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>Xóa'
          + '</button>'
          + '</div>'
          + '</div>'
          + '<div class="mb-2 lh-base text-dark">' + formatMathInContent(q.text) + '</div>';

        if (q.type === 'MCQ') {
          html += '<div class="row g-2 mb-2">'
            + '<div class="col-sm-6 small p-2 border rounded ' + (q.correctAnswer === 'A' ? 'bg-success-subtle fw-bold border-success' : '') + '">A. ' + formatMathInContent(q.optionA || '') + '</div>'
            + '<div class="col-sm-6 small p-2 border rounded ' + (q.correctAnswer === 'B' ? 'bg-success-subtle fw-bold border-success' : '') + '">B. ' + formatMathInContent(q.optionB || '') + '</div>'
            + '<div class="col-sm-6 small p-2 border rounded ' + (q.correctAnswer === 'C' ? 'bg-success-subtle fw-bold border-success' : '') + '">C. ' + formatMathInContent(q.optionC || '') + '</div>'
            + '<div class="col-sm-6 small p-2 border rounded ' + (q.correctAnswer === 'D' ? 'bg-success-subtle fw-bold border-success' : '') + '">D. ' + formatMathInContent(q.optionD || '') + '</div>'
            + '</div>';
          html += '<div class="small text-success fw-bold">Đáp án đúng: ' + q.correctAnswer + '</div>';
        }

        if (q.solutionSteps || q.explanation) {
          html += '<div class="small text-muted mt-2 pt-2 border-top lh-base"><strong>Hướng dẫn giải:</strong> ' + formatMathInContent(q.solutionSteps || q.explanation) + '</div>';
        }

        html += '</div>';
      });

      body.innerHTML = html;

      // Attach event listeners for delete in preview
      body.querySelectorAll('.btn-delete-preview-q').forEach(btn => {
        btn.addEventListener('click', async () => {
          const id = btn.getAttribute('data-id');
          if (!confirm('Bạn có muốn xóa câu hỏi #' + id + ' khỏi ngân hàng và đề thi này không?')) return;
          try {
            const res = await fetch(apiBase + '/questions/' + id, {
              method: 'DELETE',
              headers: getAuthHeaders(),
              credentials: 'include'
            });
            if (!res.ok) throw new Error('Mã lỗi ' + res.status);
            const card = document.getElementById('exam-preview-item-' + id);
            if (card) card.remove();
            await loadQuestions();
          } catch(err) {
            alert('Lỗi khi xóa câu hỏi: ' + err.message);
          }
        });
      });

      if (window.MathJax && window.MathJax.typesetPromise) {
        window.MathJax.typesetPromise([body]).catch(() => {});
      }
    }

    // 4. Manual Question Form
    const manualType = document.getElementById('manual-type');
    const mcqFields = document.getElementById('manual-mcq-fields');
    if (manualType && mcqFields) {
      manualType.addEventListener('change', () => {
        mcqFields.classList.toggle('d-none', manualType.value !== 'MCQ');
      });
    }

    const manualForm = document.getElementById('manual-question-form');
    if (manualForm) {
      manualForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const lessonId = parseInt(document.getElementById('manual-lesson-id').value, 10);
        const type = manualType.value;
        const difficulty = document.getElementById('manual-difficulty').value;
        const text = document.getElementById('manual-text').value;
        const expl = document.getElementById('manual-explanation').value;

        const payload = {
          lessonId: lessonId,
          type: type,
          text: text,
          difficulty: difficulty,
          explanation: expl,
          solutionSteps: expl,
          status: 'PUBLISHED'
        };

        if (type === 'MCQ') {
          payload.optionA = document.getElementById('manual-opt-a').value;
          payload.optionB = document.getElementById('manual-opt-b').value;
          payload.optionC = document.getElementById('manual-opt-c').value;
          payload.optionD = document.getElementById('manual-opt-d').value;
          payload.correctAnswer = document.getElementById('manual-correct').value;
        }

        try {
          const res = await fetch(apiBase + '/questions', {
            method: 'POST',
            headers: getAuthHeaders({ 'Content-Type': 'application/json' }),
            credentials: 'include',
            body: JSON.stringify(payload)
          });
          if (!res.ok) {
            const err = await res.json().catch(() => ({}));
            throw new Error(err.message || 'Lỗi lưu câu hỏi');
          }
          const manModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('createManualQuestionModal'));
          manModal.hide();
          manualForm.reset();
          await loadQuestions();
        } catch(err) {
          alert('Lỗi: ' + err.message);
        }
      });
    }

    // Initial load
    loadQuestions();
  });
</script>

<jsp:include page="/common/footer.jsp" />
