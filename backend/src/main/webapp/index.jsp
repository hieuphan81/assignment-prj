<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
  <jsp:param name="title" value="Math10 AI — Tổng quan học tập" />
</jsp:include>

<jsp:include page="common/sidebar.jsp">
  <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="main-area">
  <jsp:include page="common/navbar.jsp">
    <jsp:param name="pageTitle" value="Tổng quan học tập" />
  </jsp:include>

  <main class="page-content" id="main-content">
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

    <!-- 4 Metric Cards -->
    <div class="row g-3 mb-4">
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Bài học hoàn thành</div>
          <div class="metric-value" id="metric-lessons">0 / 27</div>
          <div class="metric-note">Toàn bộ 9 chủ đề SGK</div>
          <div class="metric-icon">&#128214;</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Độ chính xác</div>
          <div class="metric-value" id="metric-accuracy">-- %</div>
          <div class="metric-note">Trắc nghiệm & tự luận</div>
          <div class="metric-icon green">&#9989;</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Thời gian luyện tập</div>
          <div class="metric-value" id="metric-hours">-- giờ</div>
          <div class="metric-note">Mục tiêu tuần: 10 giờ</div>
          <div class="metric-icon orange">&#9200;</div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Gia sư AI đồng hành</div>
          <div class="metric-value" id="metric-ai">24/7</div>
          <div class="metric-note">Gợi ý từng bước khi làm sai</div>
          <div class="metric-icon purple">&#129302;</div>
        </div>
      </div>
    </div>

    <!-- Quick Shortcuts & Next Lessons -->
    <div class="row g-4 mb-4">
      <div class="col-lg-8">
        <div class="cardx card-pad">
          <div class="section-head">
            <h2 class="card-title">Tiếp tục học tập</h2>
            <a href="${pageContext.request.contextPath}/lessons">Tất cả bài học &rarr;</a>
          </div>
          <div class="row g-3" id="dashboard-recent-lessons">
            <!-- Lesson cards will be populated by app.js or server-side -->
            <div class="col-md-6">
              <div class="cardx lesson-card">
                <div class="lesson-cover cover-blue">
                  <span class="cover-tag">CHƯƠNG I</span>
                  <div class="math-art">A &cap; B</div>
                </div>
                <div class="lesson-body">
                  <span class="tag tag-blue">Mệnh đề & Tập hợp</span>
                  <h3>Bài 1: Mệnh đề toán học</h3>
                  <p class="small text-muted mb-3">Mệnh đề phủ định, mệnh đề kéo theo và điều kiện cần, đủ.</p>
                  <a class="btn btn-sm btn-primary w-100" href="${pageContext.request.contextPath}/lesson-detail?id=1">Vào bài học</a>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="cardx lesson-card">
                <div class="lesson-cover cover-mint">
                  <span class="cover-tag">CHƯƠNG VI</span>
                  <div class="math-art">y = ax&sup2;</div>
                </div>
                <div class="lesson-body">
                  <span class="tag tag-green">Hàm số bậc hai</span>
                  <h3>Bài 16: Hàm số bậc hai</h3>
                  <p class="small text-muted mb-3">Đồ thị parabol, đỉnh, trục đối xứng và bảng biến thiên.</p>
                  <a class="btn btn-sm btn-primary w-100" href="${pageContext.request.contextPath}/lesson-detail?id=16">Vào bài học</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="cardx card-pad mb-4">
          <div class="section-head">
            <h2 class="card-title">Luyện tập nhanh</h2>
          </div>
          <div class="d-grid gap-2">
            <a class="btn btn-primary text-start p-3" href="${pageContext.request.contextPath}/practice">
              <div class="fw-bold">&#9999;&#65039; Trắc nghiệm 5 phút</div>
              <div class="small text-white-50">Luyện tập câu hỏi theo bài học và nhận giải thích AI</div>
            </a>
            <a class="btn btn-light text-start p-3" href="${pageContext.request.contextPath}/essay">
              <div class="fw-bold">&#128248; Nộp bài tự luận ảnh</div>
              <div class="small text-muted">Upload ảnh chữ giải tay để AI Vision chấm điểm</div>
            </a>
            <a class="btn btn-soft text-start p-3" href="${pageContext.request.contextPath}/ai-tutor">
              <div class="fw-bold">&#129302; Hỏi gia sư AI tự do</div>
              <div class="small text-muted">Gõ đề bài hoặc gửi ảnh để hỏi gia sư giải từng bước</div>
            </a>
          </div>
        </div>

        <div class="cardx card-pad">
          <div class="section-head">
            <h2 class="card-title">Sổ tay công thức</h2>
            <a href="${pageContext.request.contextPath}/formulas">Tra cứu &rarr;</a>
          </div>
          <p class="small text-muted">Tra cứu nhanh các công thức quan trọng Toán 10 và sao chép mã LaTeX một chạm.</p>
          <div class="formula-display my-2">
            \[ \cos A = \frac{b^2 + c^2 - a^2}{2bc} \]
          </div>
          <a class="btn btn-light btn-sm w-100 mt-2" href="${pageContext.request.contextPath}/formulas">Mở sổ tay công thức</a>
        </div>
      </div>
    </div>
  </main>

<jsp:include page="common/footer.jsp" />
