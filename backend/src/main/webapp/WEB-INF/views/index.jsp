<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Math10 AI — Tổng quan" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Tổng quan" />
  </jsp:include>

  <main class="page-content" id="main-content">
    
    <!-- ==================== 1. KHÔNG GIAN GIÁO VIÊN ==================== -->
    <div id="dashboard-teacher" class="dashboard-role-view d-none">
      <div class="page-heading">
        <div>
          <div class="eyebrow">KHÔNG GIAN GIẢNG DẠY &bull; BỘ SÁCH KẾT NỐI TRI THỨC</div>
          <h1 id="teacher-heading-name">Xin chào, Giáo viên</h1>
          <p>Theo dõi học sinh được phân công, quản lý bài giảng, giao bài tập và sinh câu hỏi AI.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
          <button class="btn btn-primary fw-semibold d-flex align-items-center gap-2 shadow-xs" type="button" data-bs-toggle="modal" data-bs-target="#assignHomeworkModal">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/></svg> Giao bài tập cho học sinh
          </button>
          <a class="btn btn-outline-primary fw-semibold d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/teacher/questions?openAi=true">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/></svg> Tạo câu hỏi AI
          </a>
          <a class="btn btn-light" href="${pageContext.request.contextPath}/teacher/students">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg> Quản lý học sinh
          </a>
        </div>
      </div>

      <!-- 4 Metric Cards for Teacher -->
      <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Học sinh phụ trách</div>
            <div class="metric-value" id="teacher-metric-students">3</div>
            <div class="metric-note" id="teacher-metric-students-note">Học sinh được phân công</div>
            <div class="metric-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Bài giảng phụ trách</div>
            <div class="metric-value">27</div>
            <div class="metric-note">Đầy đủ 9 chuyên đề SGK</div>
            <div class="metric-icon green"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Ngân hàng câu hỏi</div>
            <div class="metric-value" id="teacher-metric-questions">58</div>
            <div class="metric-note">Trắc nghiệm & tự luận</div>
            <div class="metric-icon orange"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m9 12 2 2 4-4"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Bài tập đã giao</div>
            <div class="metric-value" id="teacher-metric-assignments">1</div>
            <div class="metric-note">Đang mở nộp bài</div>
            <div class="metric-icon purple"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></div>
          </div>
        </div>
      </div>

      <!-- Teacher Main Content -->
      <div class="row g-4 mb-4">
        <div class="col-lg-8">
          <!-- Bảng học sinh phụ trách -->
          <div class="cardx card-pad mb-4">
            <div class="section-head d-flex justify-content-between align-items-center mb-3">
              <div>
                <h2 class="card-title">Học sinh trong danh sách phụ trách</h2>
                <div class="card-subtitle">Chỉ hiển thị các học sinh được phân công cho tài khoản của bạn</div>
              </div>
              <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/teacher/students">Quản lý chi tiết &rarr;</a>
            </div>
            <div class="table-responsive">
              <table class="table align-middle table-hover mb-0">
                <thead class="table-light">
                  <tr>
                    <th>Họ và tên</th>
                    <th>Tên đăng nhập</th>
                    <th>Email</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Thao tác</th>
                  </tr>
                </thead>
                <tbody id="teacher-students-tbody">
                  <tr>
                    <td colspan="5" class="text-center py-3 text-muted">Đang tải danh sách học sinh...</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Bảng bài tập đã giao -->
          <div class="cardx card-pad">
            <div class="section-head d-flex justify-content-between align-items-center mb-3">
              <div>
                <h2 class="card-title">Bài tập đã giao cho học sinh</h2>
                <div class="card-subtitle">Theo dõi trạng thái làm bài, hạn nộp và thu hồi bài tập</div>
              </div>
              <button class="btn btn-sm btn-primary fw-semibold" type="button" data-bs-toggle="modal" data-bs-target="#assignHomeworkModal">
                + Giao thêm bài mới
              </button>
            </div>
            <div class="table-responsive">
              <table class="table align-middle table-hover mb-0">
                <thead class="table-light">
                  <tr>
                    <th>Bài học</th>
                    <th>Hình thức</th>
                    <th>Giao cho</th>
                    <th>Hạn nộp</th>
                    <th>Lượt nộp</th>
                    <th class="text-end">Thao tác</th>
                  </tr>
                </thead>
                <tbody id="teacher-assignments-tbody">
                  <tr>
                    <td colspan="6" class="text-center py-3 text-muted">Chưa có bài tập nào được giao. Hãy bấm "Giao bài tập cho học sinh".</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="col-lg-4">
          <div class="cardx card-pad mb-4">
            <div class="eyebrow text-primary">CÔNG CỤ GIẢNG DẠY</div>
            <h3 class="card-title mt-2">Giao bài tập nhanh</h3>
            <p class="small text-muted">Giao bài tập trắc nghiệm và tự luận Toán 10 kèm hạn nộp và nhận xét tự động từ AI.</p>
            <button class="btn btn-primary w-100 fw-semibold" type="button" data-bs-toggle="modal" data-bs-target="#assignHomeworkModal">Mở biểu mẫu giao bài</button>
          </div>

          <div class="cardx card-pad mb-4">
            <div class="eyebrow text-warning">SINH ĐỀ NHÁP VỚI AI</div>
            <h3 class="card-title mt-2">Ngân hàng câu hỏi & AI</h3>
            <p class="small text-muted">Tự động sinh câu hỏi Toán 10 bám sát chương trình bằng Google Gemini AI.</p>
            <a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/teacher/questions">Vào Ngân hàng câu hỏi</a>
          </div>

          <div class="cardx card-pad">
            <div class="eyebrow text-secondary">QUẢN LÝ BÀI DẠY</div>
            <h3 class="card-title mt-2">Mục lục bài giảng SGK</h3>
            <p class="small text-muted">Đầy đủ 27 bài học bám sát SGK Toán 10 Kết nối tri thức.</p>
            <a class="btn btn-light w-100" href="${pageContext.request.contextPath}/lessons">Khám phá 27 bài giảng &rarr;</a>
          </div>
        </div>
      </div>
    </div>

    <!-- ==================== 2. KHÔNG GIAN QUẢN TRỊ VIÊN ==================== -->
    <div id="dashboard-admin" class="dashboard-role-view d-none">
      <div class="page-heading">
        <div>
          <div class="eyebrow">QUẢN TRỊ TOÀN DIỆN HỆ THỐNG</div>
          <h1 id="admin-heading-name">Bảng điều khiển Quản trị viên</h1>
          <p>Giám sát toàn bộ người dùng, dữ liệu bài học, phân công giáo viên - học sinh và kết nối AI.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
          <a class="btn btn-primary fw-semibold" href="${pageContext.request.contextPath}/admin/users">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg> Quản lý người dùng
          </a>
          <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/teacher/questions">Ngân hàng câu hỏi</a>
          <a class="btn btn-light" href="${pageContext.request.contextPath}/admin/settings">Cấu hình AI</a>
        </div>
      </div>

      <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Người dùng hệ thống</div>
            <div class="metric-value" id="admin-metric-users">17</div>
            <div class="metric-note">Admin, Giáo viên, Học sinh</div>
            <div class="metric-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Chuyên đề Toán 10</div>
            <div class="metric-value">9</div>
            <div class="metric-note">Toàn bộ chương trình</div>
            <div class="metric-icon green"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="6" height="6" rx="1"/><rect x="14" y="4" width="6" height="6" rx="1"/><rect x="4" y="14" width="6" height="6" rx="1"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Bài học xuất bản</div>
            <div class="metric-value">27</div>
            <div class="metric-note">SGK Kết nối tri thức</div>
            <div class="metric-icon orange"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Tổng câu hỏi trong CSDL</div>
            <div class="metric-value" id="admin-metric-questions">58</div>
            <div class="metric-note">Trắc nghiệm & tự luận</div>
            <div class="metric-icon purple"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m9 12 2 2 4-4"/></svg></div>
          </div>
        </div>
      </div>

      <div class="row g-4 mb-4">
        <div class="col-md-6">
          <div class="cardx card-pad h-100">
            <div class="eyebrow text-primary">DỊCH VỤ TRÍ TUỆ NHÂN TẠO</div>
            <h3 class="card-title mt-2">Trạng thái AI Provider</h3>
            <div class="mt-3">
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Mô hình AI chính:</span>
                <strong>Google Gemini 1.5 Flash</strong>
              </div>
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Trạng thái kết nối:</span>
                <span class="badge bg-success-subtle text-success border border-success-subtle">Sẵn sàng 24/7</span>
              </div>
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Gia sư AI học sinh:</span>
                <span class="text-success fw-bold">Đang bật</span>
              </div>
              <div class="d-flex justify-content-between py-2">
                <span class="text-muted">AI Chấm tự luận:</span>
                <span class="text-primary fw-bold">Tích hợp đầy đủ (Multimodal)</span>
              </div>
            </div>
            <a class="btn btn-light w-100 mt-3" href="${pageContext.request.contextPath}/admin/settings">Kiểm tra cấu hình AI &rarr;</a>
          </div>
        </div>

        <div class="col-md-6">
          <div class="cardx card-pad h-100">
            <div class="eyebrow text-secondary">CƠ SỞ DỮ LIỆU & BẢO MẬT</div>
            <h3 class="card-title mt-2">Hệ thống cơ sở dữ liệu</h3>
            <div class="mt-3">
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Hệ quản trị CSDL:</span>
                <strong>Microsoft SQL Server</strong>
              </div>
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Tên cơ sở dữ liệu:</span>
                <span class="badge bg-primary">Math10AI</span>
              </div>
              <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted">Mã hóa mật khẩu:</span>
                <span>BCrypt Hasher</span>
              </div>
              <div class="d-flex justify-content-between py-2">
                <span class="text-muted">Xác thực người dùng:</span>
                <span>Spring Session + X-Auth Token</span>
              </div>
            </div>
            <a class="btn btn-light w-100 mt-3" href="${pageContext.request.contextPath}/admin/users">Phân quyền & Phân công giáo viên &rarr;</a>
          </div>
        </div>
      </div>
    </div>

    <!-- ==================== 3. KHÔNG GIAN HỌC SINH ==================== -->
    <div id="dashboard-student" class="dashboard-role-view">
      <div class="page-heading">
        <div>
          <div class="eyebrow">MATH10 AI — BỘ SÁCH KẾT NỐI TRI THỨC</div>
          <h1>Không gian học Toán 10</h1>
          <p>Học từng bước với gia sư AI, giải bài tập trắc nghiệm và tự luận với phản hồi chi tiết.</p>
        </div>
        <div class="d-flex gap-2">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/practice">Luyện tập ngay &rarr;</a>
          <a class="btn btn-light" href="${pageContext.request.contextPath}/lessons">Xem bài học</a>
        </div>
      </div>

      <!-- Card Bài tập do Giáo viên giao -->
      <div class="cardx card-pad mb-4 border border-primary-subtle shadow-xs d-none" id="student-assignments-wrapper">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
          <div class="d-flex align-items-center gap-2">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-primary"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/></svg>
            <div>
              <h2 class="card-title mb-0 fs-5 text-primary">Bài tập giáo viên giao cho bạn</h2>
              <div class="small text-muted">Hoàn thành bài tập đúng hạn để nhận điểm và phản hồi từ giáo viên & AI</div>
            </div>
            <span class="badge bg-danger rounded-pill ms-2" id="student-assignments-badge">0 bài cần làm</span>
          </div>
          <span class="text-muted small">Tự động đồng bộ với giáo viên phụ trách</span>
        </div>
        <div class="row g-3" id="student-assignments-list">
          <!-- Dynamically populated -->
        </div>
      </div>

      <!-- 4 Metric Cards for Student -->
      <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Bài học hoàn thành</div>
            <div class="metric-value" id="metric-lessons">0 / 27</div>
            <div class="metric-note" id="metric-lessons-note">Toàn bộ 9 chủ đề SGK</div>
            <div class="metric-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Độ chính xác</div>
            <div class="metric-value" id="metric-accuracy">-- %</div>
            <div class="metric-note" id="metric-accuracy-note">Trắc nghiệm & tự luận</div>
            <div class="metric-icon green"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m9 12 2 2 4-4"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Thời gian luyện tập</div>
            <div class="metric-value" id="metric-hours">-- giờ</div>
            <div class="metric-note" id="metric-hours-note">Mục tiêu tuần: 10 giờ</div>
            <div class="metric-icon orange"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          </div>
        </div>
        <div class="col-sm-6 col-xl-3">
          <div class="cardx metric-card">
            <div class="metric-label">Gia sư AI đồng hành</div>
            <div class="metric-value" id="metric-ai">24/7</div>
            <div class="metric-note">Gợi ý từng bước khi làm sai</div>
            <div class="metric-icon purple"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3 1.7 5.3L19 10l-5.3 1.7L12 17l-1.7-5.3L5 10l5.3-1.7z"/></svg></div>
          </div>
        </div>
      </div>

      <!-- Quick Shortcuts & Next Lessons for Student -->
      <div class="row g-4 mb-4">
        <div class="col-lg-8">
          <div class="cardx card-pad">
            <div class="section-head d-flex justify-content-between align-items-center mb-3">
              <div>
                <h2 class="card-title">Tiếp tục học tập</h2>
                <div class="card-subtitle">Các bài học theo thứ tự chương trình SGK Kết nối tri thức</div>
              </div>
              <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/lessons">Xem tất cả 27 bài &rarr;</a>
            </div>

            <div class="row g-3">
              <div class="col-md-6">
                <div class="cardx lesson-card h-100">
                  <div class="lesson-cover cover-blue p-3 text-white rounded-top">
                    <span class="cover-tag">CHƯƠNG VI &bull; HÀM SỐ</span>
                    <h3 class="h5 mt-2 mb-0">Hàm số bậc hai</h3>
                    <div class="math-art small opacity-75 mt-1">y = ax&sup2; + bx + c</div>
                  </div>
                  <div class="lesson-body p-3">
                    <p class="small text-muted mb-3">Dạng đồ thị parabol, trục đối xứng và toạ độ đỉnh.</p>
                    <a class="btn btn-primary btn-sm w-100" href="${pageContext.request.contextPath}/lesson-detail?id=16">Vào học bài này &rarr;</a>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="cardx lesson-card h-100">
                  <div class="lesson-cover cover-mint p-3 text-white rounded-top" style="background: linear-gradient(135deg, #198460, #0f5a41);">
                    <span class="cover-tag">CHƯƠNG I &bull; MỆNH ĐỀ</span>
                    <h3 class="h5 mt-2 mb-0">Mệnh đề và tập hợp</h3>
                    <div class="math-art small opacity-75 mt-1">A &cap; B, A &cup; B</div>
                  </div>
                  <div class="lesson-body p-3">
                    <p class="small text-muted mb-3">Mệnh đề logic, phủ định, kéo theo và các phép toán tập hợp.</p>
                    <a class="btn btn-light btn-sm w-100" href="${pageContext.request.contextPath}/lesson-detail?id=1">Xem nội dung &rarr;</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-4">
          <div class="cardx card-pad mb-4">
            <div class="eyebrow">GIA SƯ TOÁN AI</div>
            <h3 class="card-title mt-2">Hỏi bài gia sư AI</h3>
            <p class="small text-muted">Gặp bài toán khó? Gõ câu hỏi hoặc dán đề bài để AI hướng dẫn từng bước.</p>
            <a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/ai-tutor"> Trò chuyện với AI Tutor</a>
          </div>

          <div class="cardx card-pad">
            <div class="eyebrow">CÔNG THỨC NHANH</div>
            <h3 class="card-title mt-2">Tra cứu công thức</h3>
            <p class="small text-muted">10 thẻ công thức trọng tâm: Parabol, Lượng giác, Vectơ, Toạ độ.</p>
            <a class="btn btn-light w-100" href="${pageContext.request.contextPath}/formulas"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="6" height="6" rx="1"/><rect x="14" y="4" width="6" height="6" rx="1"/><rect x="4" y="14" width="6" height="6" rx="1"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg> Tra cứu công thức</a>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Modal Giao bài tập cho học sinh (Dành cho Giáo viên) -->
  <div class="modal fade" id="assignHomeworkModal" tabindex="-1" aria-labelledby="assignModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title fw-bold" id="assignModalLabel">Giao bài tập Toán 10 cho học sinh</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
          </div>
          <form id="assign-homework-form">
            <div class="modal-body p-4">
              <div class="alert alert-info py-2 px-3 small mb-3">
                <strong>Hướng dẫn:</strong> Giáo viên chọn bài học và hình thức bài tập. Sau khi giao, hệ thống sẽ lưu bài tập và gửi thông báo trực tiếp tới không gian học tập của học sinh.
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
                    <option value="MCQ">Trắc nghiệm (Tự động chấm)</option>
                    <option value="ESSAY">Tự luận (AI chấm từng bước)</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label fw-semibold">Đối tượng nhận bài <span class="text-danger">*</span></label>
                  <select class="form-select" id="assign-target-select">
                    <option value="all">Tất cả học sinh được phân công</option>
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
                  <textarea class="form-control" id="assign-note" rows="2" placeholder="Ví dụ: Các em hoàn thành bài trước hạn, đọc kỹ lời giải từng bước khi làm sai."></textarea>
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

  <script>
    function getSessionUser() {
      try {
        const raw = localStorage.getItem('math10_session_user');
        return raw ? JSON.parse(raw) : null;
      } catch(e) {
        return null;
      }
    }

    function getActiveRole() {
      const user = getSessionUser();
      if (user && user.role) return user.role.toUpperCase();
      const roleSelect = document.getElementById('role-select');
      if (roleSelect && roleSelect.value) return roleSelect.value.toUpperCase();
      return 'STUDENT';
    }

    function switchDashboardView(role) {
      const normRole = (role || 'STUDENT').toUpperCase();
      const dTeacher = document.getElementById('dashboard-teacher');
      const dAdmin = document.getElementById('dashboard-admin');
      const dStudent = document.getElementById('dashboard-student');

      if (dTeacher) dTeacher.classList.toggle('d-none', normRole !== 'TEACHER');
      if (dAdmin) dAdmin.classList.toggle('d-none', normRole !== 'ADMIN');
      if (dStudent) dStudent.classList.toggle('d-none', normRole !== 'STUDENT');

      if (normRole === 'TEACHER') {
        renderTeacherDashboard();
      } else if (normRole === 'ADMIN') {
        renderAdminDashboard();
      } else {
        renderStudentDashboard();
      }
    }

    // 1. TEACHER DASHBOARD LOGIC
    async function renderTeacherDashboard() {
      const user = getSessionUser();
      const headingName = document.getElementById('teacher-heading-name');
      if (headingName) {
        headingName.textContent = user && (user.fullName || user.username) 
          ? 'Xin chào, ' + (user.fullName || user.username)
          : 'Xin chào, Thầy/Cô';
      }

      // Default deadline = 3 days later
      const dlInput = document.getElementById('assign-deadline');
      if (dlInput && !dlInput.value) {
        const d = new Date();
        d.setDate(d.getDate() + 3);
        dlInput.value = d.toISOString().split('T')[0];
      }

      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
      const headers = { 'Content-Type': 'application/json' };
      if (user && user.username) headers['X-Auth-User'] = user.username;

      // 1.1 Fetch teacher assigned students
      const tbody = document.getElementById('teacher-students-tbody');
      const metricStudents = document.getElementById('teacher-metric-students');

      try {
        const res = await fetch(apiBase + '/users', { headers, credentials: 'include' });
        if (res.ok) {
          const students = await res.json();
          if (Array.isArray(students) && students.length > 0) {
            if (metricStudents) metricStudents.textContent = students.length;

            const targetSelect = document.getElementById('assign-target-select');
            if (targetSelect) {
              let optHtml = '<option value="all">Tất cả học sinh phụ trách (' + students.length + ' em)</option>';
              students.forEach(st => {
                optHtml += '<option value="' + (st.username || st.id) + '">' + (st.fullName || st.username) + ' (' + st.username + ')</option>';
              });
              targetSelect.innerHTML = optHtml;
            }

            if (tbody) {
              tbody.innerHTML = students.map(st => `
                <tr>
                  <td><strong>\${st.fullName || st.username}</strong></td>
                  <td><code class="text-primary">\${st.username}</code></td>
                  <td><span class="text-muted small">\${st.email || 'student@math10.local'}</span></td>
                  <td><span class="badge bg-success-subtle text-success border border-success-subtle">Hoạt động</span></td>
                  <td class="text-end">
                    <button class="btn btn-sm btn-outline-primary py-1 px-2 fw-semibold" onclick="openAssignForStudent('\${st.username || st.id}', '\${st.fullName || st.username}')">
                      Giao bài
                    </button>
                  </td>
                </tr>
              `).join('');
            }
          }
        }
      } catch(e) {}

      // 1.2 Fetch teacher assignments list
      await loadTeacherAssignments();
    }

    async function loadTeacherAssignments() {
      const user = getSessionUser();
      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
      const headers = { 'Content-Type': 'application/json' };
      if (user && user.username) headers['X-Auth-User'] = user.username;

      const assignTbody = document.getElementById('teacher-assignments-tbody');
      const countEl = document.getElementById('teacher-metric-assignments');

      let list = [];
      try {
        const res = await fetch(apiBase + '/assignments/teacher', { headers, credentials: 'include' });
        if (res.ok) {
          list = await res.json();
        }
      } catch(e) {}

      // Fallback local storage if empty
      if (!Array.isArray(list) || list.length === 0) {
        try {
          list = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
        } catch(e) { list = []; }
      }

      if (countEl) countEl.textContent = list.length;

      if (assignTbody) {
        if (!list || list.length === 0) {
          assignTbody.innerHTML = `
            <tr>
              <td colspan="6" class="text-center py-4 text-muted">
                Chưa có bài tập nào được giao. Hãy bấm nút <strong>"Giao bài tập cho học sinh"</strong> ở trên để bắt đầu!
              </td>
            </tr>
          `;
          return;
        }

        assignTbody.innerHTML = list.map(a => {
          const typeBadge = a.type === 'ESSAY' 
            ? '<span class="badge bg-info text-dark">Tự luận</span>' 
            : (a.type === 'MCQ' ? '<span class="badge bg-primary">Trắc nghiệm</span>' : '<span class="badge bg-success">Trắc nghiệm & Tự luận</span>');
          
          const targetText = a.targetValue === 'all' ? 'Tất cả học sinh' : ('Học sinh: ' + a.targetValue);

          return `
            <tr>
              <td><strong>\${a.lessonTitle}</strong></td>
              <td>\${typeBadge}</td>
              <td><code>\${targetText}</code></td>
              <td><span class="text-danger small fw-semibold">\${a.deadline}</span></td>
              <td><span class="badge bg-light text-secondary border">\${a.submissionCount || 0} lượt nộp</span></td>
              <td class="text-end">
                <button class="btn btn-sm btn-outline-danger py-0 px-2 small" onclick="deleteTeacherAssignment(\${a.id})">
                  Thu hồi
                </button>
              </td>
            </tr>
          `;
        }).join('');
      }
    }

    async function deleteTeacherAssignment(id) {
      if (!confirm('Bạn có chắc chắn muốn thu hồi bài tập này không?')) return;
      const user = getSessionUser();
      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
      const headers = { 'Content-Type': 'application/json' };
      if (user && user.username) headers['X-Auth-User'] = user.username;

      try {
        await fetch(apiBase + '/assignments/' + id, { method: 'DELETE', headers, credentials: 'include' });
      } catch(e) {}

      // Update localStorage
      try {
        let list = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
        list = list.filter(item => item.id !== id);
        localStorage.setItem('math10_assignments', JSON.stringify(list));
      } catch(e) {}

      await loadTeacherAssignments();
    }

    // 2. ADMIN DASHBOARD LOGIC
    async function renderAdminDashboard() {
      const user = getSessionUser();
      const headingName = document.getElementById('admin-heading-name');
      if (headingName) {
        headingName.textContent = user && (user.fullName || user.username) 
          ? 'Xin chào, ' + (user.fullName || user.username)
          : 'Bảng điều khiển Quản trị viên';
      }

      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
      try {
        const headers = { 'Content-Type': 'application/json' };
        if (user && user.username) headers['X-Auth-User'] = user.username;
        const res = await fetch(apiBase + '/users', { headers, credentials: 'include' });
        if (res.ok) {
          const list = await res.json();
          if (Array.isArray(list)) {
            const el = document.getElementById('admin-metric-users');
            if (el) el.textContent = list.length;
          }
        }
      } catch(e) {}
    }

    // 3. STUDENT DASHBOARD LOGIC
    async function renderStudentDashboard() {
      const user = getSessionUser();
      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
      const headers = { 'Content-Type': 'application/json' };
      if (user && user.username) headers['X-Auth-User'] = user.username;

      // 3.1 Load assigned homework for this student
      const assignWrapper = document.getElementById('student-assignments-wrapper');
      const assignList = document.getElementById('student-assignments-list');
      const assignBadge = document.getElementById('student-assignments-badge');

      try {
        const res = await fetch(apiBase + '/assignments/student', { headers, credentials: 'include' });
        let hwList = [];
        if (res.ok) {
          hwList = await res.json();
        }

        // Fallback local storage
        if (!Array.isArray(hwList) || hwList.length === 0) {
          try {
            const allHw = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
            hwList = allHw.filter(h => h.targetValue === 'all' || (user && (h.targetValue === user.username || h.target === user.username)));
          } catch(e) {}
        }

        if (Array.isArray(hwList) && hwList.length > 0) {
          assignWrapper.classList.remove('d-none');
          const unsubmittedCount = hwList.filter(h => !h.isSubmitted).length;
          if (assignBadge) {
            assignBadge.textContent = unsubmittedCount + ' bài cần làm';
            assignBadge.className = unsubmittedCount > 0 ? 'badge bg-danger rounded-pill ms-2' : 'badge bg-success rounded-pill ms-2';
          }

          if (assignList) {
            assignList.innerHTML = hwList.map(h => {
              const typeLabel = h.type === 'ESSAY' ? 'Tự luận' : (h.type === 'MCQ' ? 'Trắc nghiệm' : 'Trắc nghiệm & Tự luận');
              const actionBtn = h.isSubmitted 
                ? '<button class="btn btn-sm btn-outline-success w-100 disabled" disabled>Đã hoàn thành bài</button>'
                : '<a class="btn btn-sm btn-primary w-100 fw-semibold" href="${pageContext.request.contextPath}/practice?tab=' + (h.type === 'ESSAY' ? 'essay' : 'mcq') + '&lessonId=' + h.lessonId + '&assignId=' + h.id + '">Làm bài ngay &rarr;</a>';

              return `
                <div class="col-md-6 col-lg-4">
                  <div class="cardx border p-3 h-100 d-flex flex-column justify-content-between bg-white shadow-xs">
                    <div>
                      <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle">\${typeLabel}</span>
                        <span class="small \${h.isSubmitted ? 'text-success fw-bold' : 'text-danger fw-semibold'}">
                          \${h.isSubmitted ? 'Đã nộp bài' : 'Hạn: ' + h.deadline}
                        </span>
                      </div>
                      <h4 class="h6 fw-bold text-dark mb-1">\${h.lessonTitle}</h4>
                      <div class="small text-muted mb-2">Giáo viên: <strong>\${h.teacherName || 'Giáo viên phụ trách'}</strong></div>
                      \${h.note ? '<div class="alert alert-light py-1 px-2 small mb-3 border text-secondary fst-italic">"' + h.note + '"</div>' : ''}
                    </div>
                    <div class="pt-2 border-top">
                      \${actionBtn}
                    </div>
                  </div>
                </div>
              `;
            }).join('');
          }
        } else {
          assignWrapper.classList.add('d-none');
        }
      } catch(e) {}

      // 3.2 Metric cards
      const elLessons = document.getElementById('metric-lessons');
      const elLessonsNote = document.getElementById('metric-lessons-note');
      const elAccuracy = document.getElementById('metric-accuracy');
      const elAccuracyNote = document.getElementById('metric-accuracy-note');
      const elHours = document.getElementById('metric-hours');
      const elHoursNote = document.getElementById('metric-hours-note');

      if (!elLessons && !elAccuracy) return;

      const totalLessons = 27;
      const completedLessonIds = new Set();
      let totalAttempts = 0;
      let correctAttempts = 0;

      try {
        const userKey = (user && user.username) ? ('math10_completed_lessons_' + user.username) : 'math10_completed_lessons';
        const storedLessons = JSON.parse(localStorage.getItem(userKey) || localStorage.getItem('math10_completed_lessons') || '[]');
        if (Array.isArray(storedLessons)) {
          storedLessons.forEach(id => completedLessonIds.add(Number(id)));
        }
        const storedStats = JSON.parse(localStorage.getItem('math10_practice_stats') || '{}');
        if (storedStats && typeof storedStats.total === 'number') {
          totalAttempts = storedStats.total;
          correctAttempts = storedStats.correct || 0;
        }
      } catch(e) {}

      function updateUI() {
        const completedCount = completedLessonIds.size;
        if (elLessons) {
          elLessons.textContent = completedCount + ' / ' + totalLessons;
          if (elLessonsNote) {
            const pct = Math.round((completedCount / totalLessons) * 100);
            elLessonsNote.textContent = completedCount > 0 ? ('Đạt ' + pct + '% chương trình SGK') : 'Toàn bộ 9 chủ đề SGK';
          }
        }

        if (elAccuracy) {
          if (totalAttempts > 0) {
            const acc = Math.round((correctAttempts / totalAttempts) * 100);
            elAccuracy.textContent = acc + '%';
            if (elAccuracyNote) {
              elAccuracyNote.textContent = correctAttempts + ' / ' + totalAttempts + ' câu đúng (' + acc + '%)';
            }
          } else {
            elAccuracy.textContent = '0%';
            if (elAccuracyNote) {
              elAccuracyNote.textContent = 'Chưa có lượt làm bài';
            }
          }
        }

        if (elHours) {
          if (totalAttempts > 0 || completedCount > 0) {
            const minutes = totalAttempts * 2.5 + completedCount * 12;
            const hours = (minutes / 60).toFixed(1);
            elHours.textContent = hours + ' giờ';
            if (elHoursNote) {
              elHoursNote.textContent = 'Mục tiêu tuần: 10 giờ';
            }
          } else {
            elHours.textContent = '0.0 giờ';
          }
        }
      }

      updateUI();
    }

    // Helper: open assign modal for a specific student
    function openAssignForStudent(studentId, studentName) {
      const targetSelect = document.getElementById('assign-target-select');
      if (targetSelect) {
        let found = false;
        for (let i = 0; i < targetSelect.options.length; i++) {
          if (targetSelect.options[i].value === studentId) {
            targetSelect.selectedIndex = i;
            found = true;
            break;
          }
        }
        if (!found) {
          const opt = new Option(studentName + ' (' + studentId + ')', studentId, true, true);
          targetSelect.add(opt);
        }
      }
      const modalEl = document.getElementById('assignHomeworkModal');
      if (modalEl && window.bootstrap && window.bootstrap.Modal) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
      }
    }

    // Handle Assign Form Submit
    document.addEventListener('DOMContentLoaded', () => {
      // 1. Initial view switch based on role
      const initialRole = getActiveRole();
      switchDashboardView(initialRole);

      // 2. Listen to custom role changed event from footer
      window.addEventListener('math10RoleChanged', (e) => {
        if (e.detail && e.detail.role) {
          switchDashboardView(e.detail.role);
        }
      });

      // 3. Listen to role select dropdown changes
      const roleSelect = document.getElementById('role-select');
      if (roleSelect) {
        roleSelect.addEventListener('change', (e) => {
          switchDashboardView(e.target.value);
        });
      }

      // 4. Setup Assign Homework Form Submit
      const assignForm = document.getElementById('assign-homework-form');
      if (assignForm) {
        assignForm.addEventListener('submit', async (e) => {
          e.preventDefault();
          const btnSubmit = document.getElementById('btn-submit-assignment');
          const spinner = document.getElementById('assign-spinner');
          const alertEl = document.getElementById('assign-alert');

          const user = getSessionUser();
          const lessonId = document.getElementById('assign-lesson-select').value;
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
          if (user && user.username) headers['X-Auth-User'] = user.username;

          const payload = {
            lessonId: Number(lessonId),
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
          } catch(e) {}

          // Also save locally for instant offline sync
          const localItem = {
            id: savedId,
            ...payload,
            createdAt: new Date().toISOString()
          };
          try {
            const list = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
            list.unshift(localItem);
            localStorage.setItem('math10_assignments', JSON.stringify(list));
          } catch(e) {}

          btnSubmit.disabled = false;
          spinner.classList.add('d-none');

          alertEl.className = 'alert alert-success mt-3 py-2 small';
          alertEl.innerHTML = '<strong>Thành công!</strong> Đã giao bài tập <em>' + lessonText + '</em> cho học sinh. Hạn nộp: ' + deadline;
          alertEl.classList.remove('d-none');

          // Refresh teacher assignment list immediately
          await loadTeacherAssignments();

          setTimeout(() => {
            const modalEl = document.getElementById('assignHomeworkModal');
            if (modalEl && window.bootstrap && window.bootstrap.Modal) {
              const modal = bootstrap.Modal.getInstance(modalEl);
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
