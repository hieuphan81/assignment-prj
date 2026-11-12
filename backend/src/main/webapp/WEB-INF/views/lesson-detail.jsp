<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Chi tiết bài học — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="lessons" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Chi tiết bài học" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <!-- Top breadcrumb & Navigation Bar -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3">
      <a class="btn btn-light btn-sm" href="${pageContext.request.contextPath}/lessons">&larr; Quay lại danh sách bài giảng</a>
      <div class="d-flex align-items-center gap-2">
        <a class="btn btn-outline-secondary btn-sm" id="btn-prev-lesson" href="#">&larr; Bài trước</a>
        <span class="badge bg-light text-dark border px-2 py-1" id="lesson-page-badge">Bài ... / 27</span>
        <a class="btn btn-outline-secondary btn-sm" id="btn-next-lesson" href="#">Bài tiếp theo &rarr;</a>
      </div>
    </div>

    <!-- Main Page Heading with Dynamic Actions (Role-based) -->
    <div class="page-heading align-items-start pb-3 border-bottom mb-4">
      <div>
        <div class="eyebrow text-primary fw-semibold" id="lesson-detail-topic">CHƯƠNG ... &bull; BÀI HỌC</div>
        <h1 id="lesson-detail-title" class="mb-2">Đang tải nội dung bài học...</h1>
        <p id="lesson-detail-desc" class="text-muted mb-0">Mô tả tóm tắt nội dung bài học.</p>
      </div>

      <!-- Action buttons in Header -->
      <div class="d-flex flex-column align-items-end gap-2 mt-2 mt-md-0">
        <!-- Student Actions in Header -->
        <div class="d-flex flex-column align-items-end gap-2" id="header-student-actions">
          <button class="btn btn-outline-success fw-bold px-3 py-2 shadow-xs d-flex align-items-center gap-2" id="btn-toggle-lesson-complete" type="button">
            <span id="complete-icon" class="fs-5 me-1"></span>
            <span id="complete-text">Đánh dấu hoàn thành bài học</span>
          </button>
          <div class="d-flex gap-2">
            <a class="btn btn-primary btn-sm" id="btn-header-practice" href="${pageContext.request.contextPath}/practice">Luyện trắc nghiệm &rarr;</a>
            <a class="btn btn-soft btn-sm" id="btn-header-essay" href="${pageContext.request.contextPath}/essay">Luyện tự luận &rarr;</a>
          </div>
        </div>

        <!-- Teacher / Admin Actions in Header -->
        <div class="d-none d-flex flex-wrap align-items-center gap-2" id="header-teacher-actions">
          <button class="btn btn-primary fw-bold shadow-xs" id="btn-header-assign" type="button">
            Giao bài tập bài này
          </button>
          <a class="btn btn-soft text-primary fw-semibold" id="btn-header-questions" href="${pageContext.request.contextPath}/teacher/questions">
            Ngân hàng câu hỏi
          </a>
          <a class="btn btn-light fw-semibold" id="btn-header-ai" href="${pageContext.request.contextPath}/teacher/questions#aiGen">
            Tạo câu hỏi AI
          </a>
        </div>
      </div>
    </div>

    <div class="row g-4">
      <!-- Main Content Article -->
      <div class="col-xl-8">
        <article class="cardx card-pad">
          <div class="d-flex align-items-center justify-content-between mb-3">
            <span class="tag tag-blue">BÀI GIẢNG CHÍNH THỨC</span>
            <span class="text-muted small" id="reading-time-est">Thời gian đọc ước tính: ~5 phút</span>
          </div>

          <!-- Video bài giảng YouTube -->
          <div class="card p-3 mb-4 border border-danger-subtle bg-white rounded-3 shadow-xs" id="lesson-video-card">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-2 pb-2 border-bottom">
              <div class="d-flex align-items-center gap-2">
                <span class="badge bg-danger text-white px-2 py-1 d-inline-flex align-items-center gap-1 shadow-xs">
                  <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.01 2.01 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.01 2.01 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31 31 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.01 2.01 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A100 100 0 0 1 7.858 2zM6.4 5.209v5.582l4.8-2.79z"/></svg>
                  YouTube
                </span>
                <h4 class="h6 fw-bold mb-0 text-dark" id="lesson-video-title">Video bài giảng: Đang tải...</h4>
              </div>
              <div class="d-flex flex-wrap align-items-center gap-2">
                <span class="badge bg-light text-secondary border small" id="lesson-video-channel">Kênh: VietJack</span>
                <button type="button" id="btn-admin-edit-video" class="btn btn-warning text-dark btn-sm py-1 px-2 fw-semibold d-none">
                  Đổi / Thêm link video
                </button>
                <a id="btn-open-youtube-ext" href="#" target="_blank" rel="noopener noreferrer" class="btn btn-outline-danger btn-sm py-1 px-2 fw-semibold">
                  Xem trên YouTube ↗
                </a>
              </div>
            </div>

            <div id="lesson-video-switcher" class="d-none flex-wrap gap-2 mb-2"></div>
            
            <div class="ratio ratio-16x9 rounded-3 overflow-hidden shadow-xs border bg-dark">
              <iframe id="lesson-youtube-player" src="" title="Video bài giảng Toán 10" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen style="border:0;"></iframe>
            </div>
            
            <div class="d-flex flex-wrap justify-content-between align-items-center mt-2 text-muted small">
              <span class="d-flex align-items-center gap-1">
                <span class="text-danger fw-bold">▶ Hướng dẫn:</span> Xem video bài giảng kết hợp đọc kiến thức bên dưới để tiếp thu bài học hiệu quả nhất.
              </span>
              <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Toán 10 SGK Kết nối tri thức</span>
            </div>
          </div>

          <div class="lesson-content" id="lesson-detail-sections">
            <div class="py-5 text-center text-muted">
              <div class="spinner-border spinner-border-sm text-primary mb-2" role="status"></div>
              <div>Đang tải nội dung bài giảng...</div>
            </div>
          </div>

          <!-- Bottom Completion Card (Chỉ dành cho Học sinh) -->
          <div class="card p-3 my-4 border border-success-subtle bg-light rounded-3 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 shadow-sm" id="bottom-complete-box">
            <div>
              <h5 class="mb-1 text-success fw-bold d-flex align-items-center gap-2">
                Bạn đã học xong bài này chưa?
              </h5>
              <p class="text-muted small mb-0">Bấm nút bên cạnh để ghi nhận tiến độ học tập trên Bảng điều khiển trang chủ.</p>
            </div>
            <div>
              <button class="btn btn-outline-success fw-bold px-4 py-2" id="btn-toggle-lesson-complete-bottom" type="button">
                Đánh dấu hoàn thành
              </button>
            </div>
          </div>

          <!-- Footer Action Box (Phân quyền Học sinh vs Giáo viên) -->
          <div class="mt-4 pt-3 border-top" id="lesson-student-footer-links">
            <div class="d-flex flex-wrap gap-2 align-items-center">
              <span class="tag tag-orange">LUYỆN TẬP</span>
              <a class="btn btn-primary" id="btn-action-practice" href="${pageContext.request.contextPath}/practice">Luyện tập trắc nghiệm &rarr;</a>
              <a class="btn btn-soft" id="btn-action-essay" href="${pageContext.request.contextPath}/essay">Luyện tập tự luận &rarr;</a>
              <a class="btn btn-light" href="${pageContext.request.contextPath}/ai-tutor">Hỏi gia sư AI về bài này</a>
            </div>
          </div>

          <div class="mt-4 pt-3 border-top d-none" id="lesson-teacher-footer-links">
            <div class="d-flex flex-wrap gap-2 align-items-center">
              <span class="tag tag-blue">CÔNG CỤ GIẢNG DẠY</span>
              <button class="btn btn-primary fw-semibold" id="btn-footer-assign" type="button">
                Giao bài tập bài này cho học sinh &rarr;
              </button>
              <a class="btn btn-soft" id="btn-footer-questions" href="${pageContext.request.contextPath}/teacher/questions">
                Xem câu hỏi bài này trong ngân hàng
              </a>
              <a class="btn btn-light" id="btn-footer-ai" href="${pageContext.request.contextPath}/teacher/questions#aiGen">
                Sinh câu hỏi AI bằng Gemini
              </a>
            </div>
          </div>
        </article>
      </div>

      <!-- Sidebar Table of Contents & Quick Jump -->
      <div class="col-xl-4">
        <!-- Table of Contents Card -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3">
            <h2 class="card-title h5 mb-0">Mục lục bài học</h2>
          </div>
          <div id="lesson-toc-list">
            <!-- Dynamically populated -->
          </div>
        </div>

        <!-- Quick Switch Lesson Card -->
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3">
            <h2 class="card-title h5 mb-0">Chuyển nhanh bài học</h2>
          </div>
          <select class="form-select form-select-sm mb-3" id="lesson-quick-select" aria-label="Chọn bài học">
            <!-- Dynamically filled with 27 lessons -->
          </select>
          <div class="d-flex justify-content-between align-items-center small text-muted">
            <span id="sidebar-completed-count">Đã hoàn thành: 0 / 27</span>
            <a href="${pageContext.request.contextPath}/lessons" class="text-decoration-none">Xem tất cả bài &rarr;</a>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Modal Giao bài tập cho học sinh (Nằm ngoài main để tránh stacking/đen màn hình) -->
  <div class="modal fade" id="assignHomeworkModal" tabindex="-1" aria-labelledby="assignModalLabel" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content border-0 shadow">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title fw-bold" id="assignModalLabel">Giao bài tập Toán 10 cho học sinh</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="assign-homework-form">
          <div class="modal-body p-4">
            <div class="alert alert-info py-2 px-3 small mb-3">
              <strong>Chế độ Giáo viên:</strong> Giao bài tập trực tiếp cho học sinh theo bài học đang giảng dạy. Học sinh sẽ làm bài và nhận phản hồi AI chi tiết.
            </div>
            <div class="row g-3">
              <div class="col-md-7">
                <label class="form-label fw-semibold">Bài học cần giao <span class="text-danger">*</span></label>
                <select class="form-select" id="assign-lesson-select" required>
                  <option value="1">Bài 1. Mệnh đề (Chương I)</option>
                  <option value="2">Bài 2. Tập hợp và các phép toán trên tập hợp (Chương I)</option>
                  <option value="3">Bài 3. Bất phương trình bậc nhất hai ẩn (Chương II)</option>
                  <option value="4">Bài 4. Hệ bất phương trình bậc nhất hai ẩn (Chương II)</option>
                  <option value="5">Bài 5. Giá trị lượng giác của một góc từ 0° đến 180° (Chương III)</option>
                  <option value="6">Bài 6. Hệ thức lượng trong tam giác (Chương III)</option>
                  <option value="7">Bài 7. Các khái niệm mở đầu về vectơ (Chương IV)</option>
                  <option value="8">Bài 8. Tổng và hiệu của hai vectơ (Chương IV)</option>
                  <option value="9">Bài 9. Tích của một vectơ với một số (Chương IV)</option>
                  <option value="10">Bài 10. Vectơ trong mặt phẳng tọa độ (Chương IV)</option>
                  <option value="11">Bài 11. Tích vô hướng của hai vectơ (Chương IV)</option>
                  <option value="12">Bài 12. Số gần đúng và sai số (Chương V)</option>
                  <option value="13">Bài 13. Các số đặc trưng đo xu thế trung tâm (Chương V)</option>
                  <option value="14">Bài 14. Các số đặc trưng đo độ phân tán (Chương V)</option>
                  <option value="15">Bài 15. Hàm số và đồ thị (Chương VI)</option>
                  <option value="16">Bài 16. Hàm số bậc hai (Chương VI)</option>
                  <option value="17">Bài 17. Dấu của tam thức bậc hai (Chương VI)</option>
                  <option value="18">Bài 18. Phương trình quy về phương trình bậc hai (Chương VI)</option>
                  <option value="19">Bài 19. Phương trình đường thẳng (Chương VII)</option>
                  <option value="20">Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách (Chương VII)</option>
                  <option value="21">Bài 21. Đường tròn trong mặt phẳng tọa độ (Chương VII)</option>
                  <option value="22">Bài 22. Ba đường conic trong mặt phẳng tọa độ (Chương VII)</option>
                  <option value="23">Bài 23. Quy tắc đếm (Chương VIII)</option>
                  <option value="24">Bài 24. Hoán vị, chỉnh hợp và tổ hợp (Chương VIII)</option>
                  <option value="25">Bài 25. Nhị thức Newton (Chương VIII)</option>
                  <option value="26">Bài 26. Biến cố và định nghĩa cổ điển của xác suất (Chương IX)</option>
                  <option value="27">Bài 27. Thực hành tính xác suất trong một số bài toán thực tế (Chương IX)</option>
                </select>
              </div>
              <div class="col-md-5">
                <label class="form-label fw-semibold">Hình thức bài tập <span class="text-danger">*</span></label>
                <select class="form-select" id="assign-type-select">
                  <option value="ALL">Cả Trắc nghiệm & Tự luận</option>
                  <option value="MCQ">Trắc nghiệm (Chấm tự động)</option>
                  <option value="ESSAY">Tự luận (AI chấm bước giải)</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Đối tượng nhận bài <span class="text-danger">*</span></label>
                <select class="form-select" id="assign-target-select">
                  <option value="all">Tất cả học sinh phụ trách</option>
                  <option value="10A1">Lớp 10A1</option>
                  <option value="10A2">Lớp 10A2</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold">Hạn nộp bài <span class="text-danger">*</span></label>
                <input type="date" class="form-control" id="assign-deadline" required />
              </div>
              <div class="col-12">
                <label class="form-label fw-semibold">Lời dặn / Yêu cầu của giáo viên</label>
                <textarea class="form-control" id="assign-note" rows="2" placeholder="Ví dụ: Hoàn thành bài tập trước cuối tuần. Vướng câu nào hãy dùng Gia sư AI để được gợi ý."></textarea>
              </div>
            </div>
            <div id="assign-alert" class="alert d-none mt-3 py-2 small" role="alert"></div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary fw-semibold d-flex align-items-center gap-2" id="btn-submit-assignment">
              <span class="spinner-border spinner-border-sm d-none" id="assign-spinner" role="status"></span>
              <span>Xác nhận Giao bài tập &rarr;</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Đổi / Thêm Link Video YouTube (Dành riêng cho Quản trị viên) -->
  <div class="modal fade" id="adminVideoModal" tabindex="-1" aria-labelledby="adminVideoModalLabel" aria-hidden="true" style="z-index: 1070;">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
      <div class="modal-content border-0 shadow">
        <div class="modal-header bg-dark text-white">
          <div class="d-flex align-items-center gap-2">
            <span class="badge bg-danger px-2 py-1">YouTube</span>
            <h5 class="modal-title fw-bold mb-0" id="adminVideoModalLabel">Đổi / Thêm Link Video bài giảng (Admin)</h5>
          </div>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="admin-video-form">
          <div class="modal-body p-4">
            <div id="adminVideoAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <div class="d-flex justify-content-between align-items-center mb-3">
              <span class="small text-muted">Bài học hiện tại: <strong id="adminVideoLessonName" class="text-dark"></strong></span>
              <button type="button" class="btn btn-outline-secondary btn-sm" id="btnResetDetailVideoDefault">
                ↺ Khôi phục video mặc định
              </button>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold small mb-1" for="detailVideoUrlInput">Link Video YouTube chính (hoặc Video ID 11 ký tự)</label>
              <div class="input-group input-group-sm">
                <input type="text" class="form-control" id="detailVideoUrlInput" placeholder="https://www.youtube.com/watch?v=..." />
                <button type="button" class="btn btn-outline-danger fw-semibold" id="btnPreviewDetailVideo">Xem thử</button>
              </div>
              <div class="form-text small">Hỗ trợ link <code>youtube.com/watch?v=...</code>, <code>youtu.be/...</code>, <code>youtube.com/shorts/...</code> hoặc mã ID.</div>
            </div>

            <div class="row g-2 mb-3">
              <div class="col-md-7">
                <label class="form-label fw-semibold small mb-1" for="detailVideoTitleInput">Tiêu đề video hiển thị</label>
                <input type="text" class="form-control form-control-sm" id="detailVideoTitleInput" placeholder="Tên bài giảng video..." />
              </div>
              <div class="col-md-5">
                <label class="form-label fw-semibold small mb-1" for="detailVideoChannelInput">Tên kênh / Giáo viên</label>
                <input type="text" class="form-control form-control-sm" id="detailVideoChannelInput" placeholder="Ví dụ: VietJack THPT Official" />
              </div>
            </div>

            <div id="detailVideoPreviewWrap" class="d-none mb-3">
              <div class="small fw-semibold text-muted mb-1">Xem trước:</div>
              <div class="ratio ratio-16x9 rounded overflow-hidden border bg-dark" style="max-width: 420px;">
                <iframe id="detailVideoPreviewIframe" src="" title="Preview" allowfullscreen style="border:0;"></iframe>
              </div>
            </div>

            <div class="pt-3 border-top">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-dark">Danh sách Link video bổ sung</span>
                <button type="button" class="btn btn-sm btn-outline-primary fw-semibold py-0 px-2" id="btnAddDetailExtraVideo">
                  + Thêm link video
                </button>
              </div>
              <div id="detailExtraVideosList" class="d-flex flex-column gap-2"></div>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary fw-semibold" id="btnSaveDetailVideo">Lưu Link Video</button>
          </div>
        </form>
      </div>
    </div>
  </div>

</div> <!-- /.main-area -->

<!-- Load 27 Detailed Lessons Dictionary Data -->
<script src="${pageContext.request.contextPath}/js/lesson-detail.js?v=20261111"></script>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    // 0. Ensure modals are directly under document.body to prevent backdrop and dark overlay issues
    const assignModalEl = document.getElementById('assignHomeworkModal');
    if (assignModalEl && assignModalEl.parentNode !== document.body) {
      document.body.appendChild(assignModalEl);
    }
    const adminVideoModalEl = document.getElementById('adminVideoModal');
    if (adminVideoModalEl && adminVideoModalEl.parentNode !== document.body) {
      document.body.appendChild(adminVideoModalEl);
    }

    const urlParams = new URLSearchParams(window.location.search);
    let lessonId = parseInt(urlParams.get('id') || '1', 10);
    if (isNaN(lessonId) || lessonId < 1) lessonId = 1;
    if (lessonId > 27) lessonId = 27;

    const lessonsData = window.MATH10_LESSONS_DATA || {};
    const lesson = lessonsData[lessonId] || {
      id: lessonId,
      title: 'Bài ' + lessonId,
      topic: 'Toán học 10',
      desc: 'Nội dung chi tiết bài học đang được hoàn thiện.',
      sections: [
        { heading: '1. Kiến thức trọng tâm', body: 'Nội dung lý thuyết trọng tâm của bài học đang được cập nhật.' }
      ]
    };

    // Apply any custom edits by Admin
    try {
      const customLessons = JSON.parse(localStorage.getItem('math10_custom_lessons') || '{}');
      if (customLessons[lessonId]) {
        if (customLessons[lessonId].title) lesson.title = customLessons[lessonId].title;
        if (customLessons[lessonId].summary) lesson.desc = customLessons[lessonId].summary;
        if (customLessons[lessonId].topic) lesson.topic = customLessons[lessonId].topic;
      }
    } catch(e) {}

    // 1. Populate Header info
    document.getElementById('lesson-detail-topic').textContent = (lesson.topic || 'Toán học 10').toUpperCase();
    document.getElementById('lesson-detail-title').textContent = lesson.title || ('Bài ' + lessonId);
    document.getElementById('lesson-detail-desc').textContent = lesson.desc || '';
    document.title = (lesson.title || ('Bài ' + lessonId)) + ' — Math10 AI';

    // 2. Navigation buttons & links
    const prevBtn = document.getElementById('btn-prev-lesson');
    const nextBtn = document.getElementById('btn-next-lesson');
    const pageBadge = document.getElementById('lesson-page-badge');

    if (pageBadge) pageBadge.textContent = 'Bài ' + lessonId + ' / 27';

    if (prevBtn) {
      if (lessonId > 1) {
        prevBtn.href = '${pageContext.request.contextPath}/lesson-detail?id=' + (lessonId - 1);
        prevBtn.classList.remove('disabled');
      } else {
        prevBtn.href = '#';
        prevBtn.classList.add('disabled');
      }
    }

    if (nextBtn) {
      if (lessonId < 27) {
        nextBtn.href = '${pageContext.request.contextPath}/lesson-detail?id=' + (lessonId + 1);
        nextBtn.classList.remove('disabled');
      } else {
        nextBtn.href = '#';
        nextBtn.classList.add('disabled');
      }
    }

    // Set deadline input default (+3 days)
    const dlInput = document.getElementById('assign-deadline');
    if (dlInput && !dlInput.value) {
      const d = new Date();
      d.setDate(d.getDate() + 3);
      dlInput.value = d.toISOString().split('T')[0];
    }

    // 3. User session & Role handling
    let sessionUser = null;
    try {
      const raw = localStorage.getItem('math10_session_user');
      if (raw) sessionUser = JSON.parse(raw);
    } catch(e) {}

    function getEffectiveRole() {
      if (sessionUser && sessionUser.role) return sessionUser.role.toUpperCase();
      const sessionRole = "${sessionScope['math10.user'].role}";
      if (sessionRole) return sessionRole.toUpperCase();
      const roleSelect = document.getElementById('role-select');
      if (roleSelect && roleSelect.value) return roleSelect.value.toUpperCase();
      return 'STUDENT';
    }

    const role = getEffectiveRole();
    const isTeacherOrAdmin = (role === 'TEACHER' || role === 'ADMIN');

    const headerStudentActions = document.getElementById('header-student-actions');
    const headerTeacherActions = document.getElementById('header-teacher-actions');
    const bottomCompleteBox = document.getElementById('bottom-complete-box');
    const footerStudentLinks = document.getElementById('lesson-student-footer-links');
    const footerTeacherLinks = document.getElementById('lesson-teacher-footer-links');
    const sidebarCompletedCount = document.getElementById('sidebar-completed-count');

    function openAssignModal() {
      const sel = document.getElementById('assign-lesson-select');
      if (sel) sel.value = String(lessonId);
      if (assignModalEl && window.bootstrap && window.bootstrap.Modal) {
        const modal = bootstrap.Modal.getOrCreateInstance(assignModalEl);
        modal.show();
      }
    }

    if (isTeacherOrAdmin) {
      // Show Teacher UI, hide Student UI
      if (headerStudentActions) headerStudentActions.classList.add('d-none');
      if (headerTeacherActions) headerTeacherActions.classList.remove('d-none');
      if (bottomCompleteBox) bottomCompleteBox.classList.add('d-none');
      if (footerStudentLinks) footerStudentLinks.classList.add('d-none');
      if (footerTeacherLinks) footerTeacherLinks.classList.remove('d-none');
      if (sidebarCompletedCount) sidebarCompletedCount.classList.add('d-none');

      // Bind Assign Homework modal triggers
      const btnHeaderAssign = document.getElementById('btn-header-assign');
      const btnFooterAssign = document.getElementById('btn-footer-assign');
      if (btnHeaderAssign) btnHeaderAssign.addEventListener('click', openAssignModal);
      if (btnFooterAssign) btnFooterAssign.addEventListener('click', openAssignModal);

      // Question bank link with lesson query param
      const btnHeaderQuestions = document.getElementById('btn-header-questions');
      const btnFooterQuestions = document.getElementById('btn-footer-questions');
      const qBankUrl = '${pageContext.request.contextPath}/teacher/questions?lessonId=' + lessonId;
      if (btnHeaderQuestions) btnHeaderQuestions.href = qBankUrl;
      if (btnFooterQuestions) btnFooterQuestions.href = qBankUrl;
    } else {
      // Student UI: Link to practice & essay for this specific lesson
      const practiceHref = '${pageContext.request.contextPath}/practice?lessonId=' + lessonId;
      const essayHref = '${pageContext.request.contextPath}/essay?lessonId=' + lessonId;
      const headerPractice = document.getElementById('btn-header-practice');
      const headerEssay = document.getElementById('btn-header-essay');
      const actionPractice = document.getElementById('btn-action-practice');
      const actionEssay = document.getElementById('btn-action-essay');

      if (headerPractice) headerPractice.href = practiceHref;
      if (headerEssay) headerEssay.href = essayHref;
      if (actionPractice) actionPractice.href = practiceHref;
      if (actionEssay) actionEssay.href = essayHref;

      // Completion Logic for Students
      const btnTop = document.getElementById('btn-toggle-lesson-complete');
      const btnBottom = document.getElementById('btn-toggle-lesson-complete-bottom');
      const completeIcon = document.getElementById('complete-icon');
      const completeText = document.getElementById('complete-text');

      const storageKey = (sessionUser && sessionUser.username) ? ('math10_completed_lessons_' + sessionUser.username) : 'math10_completed_lessons';
      let completed = [];
      try {
        const stored = localStorage.getItem(storageKey);
        if (stored) {
          completed = JSON.parse(stored);
        } else {
          const legacy = localStorage.getItem('math10_completed_lessons');
          if (legacy) {
            completed = JSON.parse(legacy);
            localStorage.setItem(storageKey, legacy);
          }
        }
        if (!Array.isArray(completed)) completed = [];
      } catch(e) {
        completed = [];
      }

      function updateCompleteButtons() {
        const isDone = completed.includes(lessonId);
        if (sidebarCompletedCount) {
          sidebarCompletedCount.textContent = 'Đã hoàn thành: ' + completed.length + ' / 27';
        }

        if (btnTop) {
          if (isDone) {
            btnTop.className = 'btn btn-success text-white fw-bold px-3 py-2 shadow-sm d-flex align-items-center gap-2';
            if (completeIcon) completeIcon.textContent = '';
            if (completeText) completeText.textContent = 'Đã hoàn thành bài học (Bấm để hủy)';
          } else {
            btnTop.className = 'btn btn-outline-success fw-bold px-3 py-2 shadow-xs d-flex align-items-center gap-2';
            if (completeIcon) completeIcon.textContent = '';
            if (completeText) completeText.textContent = 'Đánh dấu hoàn thành bài học';
          }
        }

        if (btnBottom) {
          if (isDone) {
            btnBottom.className = 'btn btn-success text-white fw-bold px-4 py-2 shadow-sm';
            btnBottom.textContent = 'Đã hoàn thành bài học';
          } else {
            btnBottom.className = 'btn btn-outline-success fw-bold px-4 py-2';
            btnBottom.textContent = 'Đánh dấu hoàn thành bài học';
          }
        }
      }

      function toggleComplete() {
        const idx = completed.indexOf(lessonId);
        if (idx >= 0) {
          completed.splice(idx, 1);
        } else {
          completed.push(lessonId);
        }
        try {
          localStorage.setItem(storageKey, JSON.stringify(completed));
        } catch(e) {}
        updateCompleteButtons();
      }

      if (btnTop) btnTop.addEventListener('click', toggleComplete);
      if (btnBottom) btnBottom.addEventListener('click', toggleComplete);

      updateCompleteButtons();
    }

    // 4. Setup YouTube Video (with Admin Edit/Add & Extra Videos support) & Render Lesson Sections & TOC
    function renderLessonVideoPlayer() {
      const videoData = window.getLessonVideoConfig
        ? window.getLessonVideoConfig(lessonId)
        : ((window.MATH10_LESSON_VIDEOS && window.MATH10_LESSON_VIDEOS[lessonId]) || {
            videoId: 'vZF3rsOSDAU',
            title: lesson.title,
            channel: 'VietJack THPT Official',
            extraVideos: []
          });

      const playerIframe = document.getElementById('lesson-youtube-player');
      const videoTitleEl = document.getElementById('lesson-video-title');
      const videoChannelEl = document.getElementById('lesson-video-channel');
      const btnOpenYt = document.getElementById('btn-open-youtube-ext');
      const switcher = document.getElementById('lesson-video-switcher');

      const allVideos = [
        { videoId: videoData.videoId, title: videoData.title || lesson.title, channel: videoData.channel, label: 'Video chính' }
      ];
      if (Array.isArray(videoData.extraVideos)) {
        videoData.extraVideos.forEach((ev, idx) => {
          if (ev && ev.videoId) {
            allVideos.push({
              videoId: ev.videoId,
              title: ev.title || ('Video bổ sung #' + (idx + 2)),
              channel: ev.channel || videoData.channel,
              label: 'Video ' + (idx + 2)
            });
          }
        });
      }

      function selectVideo(v) {
        if (playerIframe && v.videoId) {
          playerIframe.src = 'https://www.youtube.com/embed/' + v.videoId + '?rel=0';
        }
        if (videoTitleEl) {
          videoTitleEl.textContent = 'Video bài giảng: ' + (v.title || lesson.title);
        }
        if (videoChannelEl) {
          videoChannelEl.textContent = 'Kênh: ' + (v.channel || 'Toán 10 KNTT');
        }
        if (btnOpenYt && v.videoId) {
          btnOpenYt.href = 'https://www.youtube.com/watch?v=' + v.videoId;
        }
      }

      selectVideo(allVideos[0]);

      if (switcher) {
        if (allVideos.length > 1) {
          switcher.classList.remove('d-none');
          switcher.classList.add('d-flex');
          switcher.innerHTML = '';
          allVideos.forEach((v, idx) => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-sm ' + (idx === 0 ? 'btn-danger' : 'btn-outline-secondary');
            btn.textContent = v.label + (v.title ? ': ' + v.title : '');
            btn.onclick = () => {
              switcher.querySelectorAll('button').forEach(b => {
                b.className = 'btn btn-sm btn-outline-secondary';
              });
              btn.className = 'btn btn-sm btn-danger';
              selectVideo(v);
            };
            switcher.appendChild(btn);
          });
        } else {
          switcher.classList.add('d-none');
          switcher.classList.remove('d-flex');
          switcher.innerHTML = '';
        }
      }
    }

    renderLessonVideoPlayer();

    // Sync server custom videos
    if (window.syncServerLessonVideos) {
      const apiBase = window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1';
      window.syncServerLessonVideos(apiBase).then(() => renderLessonVideoPlayer());
    }

    // Admin Video Management Modal logic
    const btnAdminEditVideo = document.getElementById('btn-admin-edit-video');
    function updateAdminVideoButtonVisibility(effectiveRole) {
      if (!btnAdminEditVideo) return;
      if ((effectiveRole || '').toUpperCase() === 'ADMIN') {
        btnAdminEditVideo.classList.remove('d-none');
      } else {
        btnAdminEditVideo.classList.add('d-none');
      }
    }
    updateAdminVideoButtonVisibility(role);
    window.addEventListener('math10RoleChanged', (e) => {
      if (e.detail && e.detail.role) updateAdminVideoButtonVisibility(e.detail.role);
    });

    function appendDetailExtraRow(evData) {
      const list = document.getElementById('detailExtraVideosList');
      if (!list) return;
      const row = document.createElement('div');
      row.className = 'p-2 bg-light border rounded detail-extra-video-row';
      const u = (evData && (evData.videoUrl || evData.videoId)) || '';
      const t = (evData && evData.title) || '';
      const c = (evData && evData.channel) || '';
      row.innerHTML =
        '<div class="row g-2 align-items-center">' +
          '<div class="col-md-5"><input type="text" class="form-control form-control-sm detail-extra-url" placeholder="Link YouTube bổ sung hoặc ID..." value="' + u.replace(/"/g, '&quot;') + '"></div>' +
          '<div class="col-md-4"><input type="text" class="form-control form-control-sm detail-extra-title" placeholder="Tiêu đề video" value="' + t.replace(/"/g, '&quot;') + '"></div>' +
          '<div class="col-md-2"><input type="text" class="form-control form-control-sm detail-extra-channel" placeholder="Kênh/GV" value="' + c.replace(/"/g, '&quot;') + '"></div>' +
          '<div class="col-md-1 text-end"><button type="button" class="btn btn-sm btn-outline-danger py-0 px-2" title="Xóa link" onclick="this.closest(\'.detail-extra-video-row\').remove()">&times;</button></div>' +
        '</div>';
      list.appendChild(row);
    }

    function previewDetailVideoModal(showErr) {
      const urlVal = (document.getElementById('detailVideoUrlInput')?.value || '').trim();
      const wrap = document.getElementById('detailVideoPreviewWrap');
      const iframe = document.getElementById('detailVideoPreviewIframe');
      const alertEl = document.getElementById('adminVideoAlert');
      if (!wrap || !iframe) return;
      if (!urlVal) {
        wrap.classList.add('d-none');
        iframe.src = '';
        return;
      }
      const parsed = window.extractYouTubeId ? window.extractYouTubeId(urlVal) : null;
      if (parsed && parsed.videoId) {
        iframe.src = 'https://www.youtube.com/embed/' + parsed.videoId + '?rel=0';
        wrap.classList.remove('d-none');
        if (alertEl && alertEl.classList.contains('alert-danger')) alertEl.classList.add('d-none');
      } else {
        wrap.classList.add('d-none');
        iframe.src = '';
        if (showErr && alertEl) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = 'Link YouTube không hợp lệ. Vui lòng nhập link youtube.com, youtu.be hoặc mã ID 11 ký tự.';
          alertEl.classList.remove('d-none');
        }
      }
    }

    if (btnAdminEditVideo) {
      btnAdminEditVideo.addEventListener('click', () => {
        const cfg = window.getLessonVideoConfig ? window.getLessonVideoConfig(lessonId) : {};
        document.getElementById('adminVideoLessonName').textContent = lesson.title || ('Bài ' + lessonId);
        document.getElementById('detailVideoUrlInput').value = cfg.videoUrl || '';
        document.getElementById('detailVideoTitleInput').value = cfg.title || '';
        document.getElementById('detailVideoChannelInput').value = cfg.channel || '';
        const extraList = document.getElementById('detailExtraVideosList');
        if (extraList) {
          extraList.innerHTML = '';
          if (Array.isArray(cfg.extraVideos)) cfg.extraVideos.forEach(ev => appendDetailExtraRow(ev));
        }
        const alertEl = document.getElementById('adminVideoAlert');
        if (alertEl) alertEl.classList.add('d-none');
        previewDetailVideoModal(false);
        if (adminVideoModalEl && window.bootstrap && window.bootstrap.Modal) {
          bootstrap.Modal.getOrCreateInstance(adminVideoModalEl).show();
        }
      });
    }

    document.getElementById('btnPreviewDetailVideo')?.addEventListener('click', () => previewDetailVideoModal(true));
    document.getElementById('detailVideoUrlInput')?.addEventListener('input', () => previewDetailVideoModal(false));
    document.getElementById('btnAddDetailExtraVideo')?.addEventListener('click', () => appendDetailExtraRow());
    document.getElementById('btnResetDetailVideoDefault')?.addEventListener('click', () => {
      const def = (window.MATH10_LESSON_VIDEOS && window.MATH10_LESSON_VIDEOS[lessonId]) || {};
      document.getElementById('detailVideoUrlInput').value = def.videoId ? ('https://www.youtube.com/watch?v=' + def.videoId) : '';
      document.getElementById('detailVideoTitleInput').value = def.title || '';
      document.getElementById('detailVideoChannelInput').value = def.channel || '';
      document.getElementById('detailExtraVideosList').innerHTML = '';
      previewDetailVideoModal(false);
    });

    if (adminVideoModalEl) {
      adminVideoModalEl.addEventListener('hidden.bs.modal', () => {
        const ifr = document.getElementById('detailVideoPreviewIframe');
        if (ifr) ifr.src = '';
      });
    }

    document.getElementById('admin-video-form')?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const rawUrl = (document.getElementById('detailVideoUrlInput')?.value || '').trim();
      const vTitle = (document.getElementById('detailVideoTitleInput')?.value || '').trim();
      const vChannel = (document.getElementById('detailVideoChannelInput')?.value || '').trim();
      const alertEl = document.getElementById('adminVideoAlert');
      const saveBtn = document.getElementById('btnSaveDetailVideo');

      let parsedPrimary = null;
      if (rawUrl) {
        parsedPrimary = window.extractYouTubeId ? window.extractYouTubeId(rawUrl) : null;
        if (!parsedPrimary) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = 'Link YouTube chính không hợp lệ.';
          alertEl.classList.remove('d-none');
          return;
        }
      }

      const extraVideos = [];
      const rows = document.querySelectorAll('#detailExtraVideosList .detail-extra-video-row');
      for (let i = 0; i < rows.length; i++) {
        const uVal = (rows[i].querySelector('.detail-extra-url')?.value || '').trim();
        const tVal = (rows[i].querySelector('.detail-extra-title')?.value || '').trim();
        const cVal = (rows[i].querySelector('.detail-extra-channel')?.value || '').trim();
        if (!uVal) continue;
        const pEx = window.extractYouTubeId ? window.extractYouTubeId(uVal) : null;
        if (!pEx) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = 'Link YouTube bổ sung "' + uVal + '" không hợp lệ.';
          alertEl.classList.remove('d-none');
          return;
        }
        extraVideos.push({
          videoId: pEx.videoId,
          videoUrl: pEx.videoUrl,
          title: tVal || ('Video bổ sung #' + (extraVideos.length + 2)),
          channel: cVal || vChannel || 'YouTube'
        });
      }

      saveBtn.disabled = true;
      const nowIso = new Date().toISOString();
      if (window.saveLocalLessonVideoConfig) {
        if (!parsedPrimary && extraVideos.length === 0) {
          window.saveLocalLessonVideoConfig(lessonId, { resetToDefault: true });
        } else {
          window.saveLocalLessonVideoConfig(lessonId, {
            videoId: parsedPrimary ? parsedPrimary.videoId : null,
            videoUrl: parsedPrimary ? parsedPrimary.videoUrl : null,
            videoTitle: vTitle,
            videoChannel: vChannel,
            extraVideos: extraVideos,
            updatedAt: nowIso
          });
        }
      }

      try {
        const apiBase = window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1';
        await fetch(apiBase + '/lessons/' + lessonId + '/video', {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json', 'X-Auth-User': (sessionUser && sessionUser.username) || 'admin' },
          credentials: 'include',
          body: JSON.stringify({
            videoUrl: parsedPrimary ? parsedPrimary.videoUrl : null,
            videoId: parsedPrimary ? parsedPrimary.videoId : null,
            title: vTitle,
            channel: vChannel,
            extraVideos: extraVideos,
            resetToDefault: (!parsedPrimary && extraVideos.length === 0)
          })
        });
      } catch (err) {}

      saveBtn.disabled = false;
      renderLessonVideoPlayer();

      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.innerHTML = '<strong>Thành công!</strong> Đã cập nhật link video cho bài học.';
      alertEl.classList.remove('d-none');

      setTimeout(() => {
        if (adminVideoModalEl && window.bootstrap && window.bootstrap.Modal) {
          bootstrap.Modal.getInstance(adminVideoModalEl)?.hide();
        }
        alertEl.classList.add('d-none');
      }, 700);
    });

    const sectionsContainer = document.getElementById('lesson-detail-sections');
    const tocContainer = document.getElementById('lesson-toc-list');
    if (sectionsContainer && lesson.sections && lesson.sections.length > 0) {
      let secHtml = '';
      let tocHtml = `
        <div class="step-line py-2 border-bottom border-light">
          <div class="step-dot" style="background:#dc3545;"></div>
          <div class="step-copy">
            <a href="#lesson-video-card" class="text-decoration-none text-danger fw-bold small d-block">▶ Video bài giảng YouTube</a>
          </div>
        </div>
      `;

      lesson.sections.forEach((sec, idx) => {
        const secId = 'section-' + (idx + 1);
        secHtml += '<section class="lesson-note mb-4" id="' + secId + '">';
        secHtml += '<h3 class="h5 fw-bold text-dark mb-2">' + sec.heading + '</h3>';
        secHtml += '<div class="lesson-body text-secondary lh-lg">' + sec.body + '</div>';
        secHtml += '</section>';

        tocHtml += '<div class="step-line py-2 border-bottom border-light">';
        tocHtml += '<div class="step-dot done"></div>';
        tocHtml += '<div class="step-copy">';
        tocHtml += '<a href="#' + secId + '" class="text-decoration-none text-dark fw-semibold small d-block">' + sec.heading + '</a>';
        tocHtml += '</div></div>';
      });

      sectionsContainer.innerHTML = secHtml;
      if (tocContainer) tocContainer.innerHTML = tocHtml;

      if (window.MathJax && window.MathJax.typesetPromise) {
        window.MathJax.typesetPromise();
      }
    }

    // 5. Quick Select Dropdown for all 27 lessons
    const quickSelect = document.getElementById('lesson-quick-select');
    if (quickSelect) {
      let opts = '';
      for (let i = 1; i <= 27; i++) {
        const lData = lessonsData[i];
        const lTitle = lData ? lData.title : ('Bài ' + i);
        const isSelected = (i === lessonId) ? 'selected' : '';
        opts += '<option value="' + i + '" ' + isSelected + '>' + lTitle + '</option>';
      }
      quickSelect.innerHTML = opts;
      quickSelect.addEventListener('change', (e) => {
        const selectedId = e.target.value;
        window.location.href = '${pageContext.request.contextPath}/lesson-detail?id=' + selectedId;
      });
    }

    // 6. Handle Assign Form Submission
    const assignForm = document.getElementById('assign-homework-form');
    if (assignForm) {
      assignForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const btnSubmit = document.getElementById('btn-submit-assignment');
        const spinner = document.getElementById('assign-spinner');
        const alertEl = document.getElementById('assign-alert');

        const chosenLessonId = document.getElementById('assign-lesson-select').value;
        const lessonText = document.getElementById('assign-lesson-select').options[document.getElementById('assign-lesson-select').selectedIndex].text;
        const assignType = document.getElementById('assign-type-select').value;
        const target = document.getElementById('assign-target-select').value;
        const deadline = document.getElementById('assign-deadline').value;
        const note = (document.getElementById('assign-note').value || '').trim();

        btnSubmit.disabled = true;
        spinner.classList.remove('d-none');
        alertEl.classList.add('d-none');

        const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
        const headers = { 'Content-Type': 'application/json' };
        if (sessionUser && sessionUser.username) headers['X-Auth-User'] = sessionUser.username;

        const payload = {
          lessonId: Number(chosenLessonId),
          lessonTitle: lessonText,
          type: assignType,
          targetType: target === 'all' ? 'ALL' : (target.startsWith('10A') ? 'CLASS' : 'STUDENT'),
          targetValue: target,
          deadline: deadline,
          note: note
        };

        let savedId = Date.now();
        try {
          const res = await fetch(apiBase + '/assignments', {
            method: 'POST',
            headers,
            credentials: 'include',
            body: JSON.stringify(payload)
          });
          if (res.ok) {
            const resData = await res.json();
            if (resData && resData.id) savedId = resData.id;
          }
        } catch(err) {}

        const newAssignment = {
          id: savedId,
          ...payload,
          createdAt: new Date().toISOString()
        };

        try {
          const list = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
          list.unshift(newAssignment);
          localStorage.setItem('math10_assignments', JSON.stringify(list));
        } catch(err) {}

        btnSubmit.disabled = false;
        spinner.classList.add('d-none');

        alertEl.className = 'alert alert-success mt-3 py-2 small';
        alertEl.innerHTML = '<strong>Thành công!</strong> Đã giao bài tập <em>' + lessonText + '</em> cho học sinh. Hạn nộp: ' + deadline;
        alertEl.classList.remove('d-none');

        setTimeout(() => {
          if (assignModalEl && window.bootstrap && window.bootstrap.Modal) {
            const modal = bootstrap.Modal.getInstance(assignModalEl);
            if (modal) modal.hide();
          }
          alertEl.classList.add('d-none');
          assignForm.reset();
        }, 1200);
      });
    }

  });
</script>

<jsp:include page="/common/footer.jsp" />
