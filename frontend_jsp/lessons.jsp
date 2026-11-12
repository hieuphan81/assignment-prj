<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isTeacherOrAdmin" value="${sessionScope['math10.user'].role == 'TEACHER' || sessionScope['math10.user'].role == 'ADMIN'}" />

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Khám phá bài học Toán 10 — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="lessons" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="${isTeacherOrAdmin ? 'Danh sách bài giảng' : 'Khám phá bài học'}" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow">CHƯƠNG TRÌNH TOÁN 10 — KẾT NỐI TRI THỨC</div>
        <h1 id="lessons-main-heading">${isTeacherOrAdmin ? 'Danh sách bài giảng' : 'Khám phá bài học'}</h1>
        <p id="lessons-main-desc">${isTeacherOrAdmin ? 'Hệ thống 27 bài giảng chuẩn theo SGK Toán 10 Kết nối tri thức. Xem nội dung bài giảng chi tiết hoặc giao bài tập cho học sinh.' : 'Chọn chủ đề và học theo nhịp độ của bạn. Đầy đủ 9 chuyên đề và 27 bài học bám sát SGK.'}</p>
      </div>
      <div id="lessons-header-actions">
        <!-- For Teacher & Admin: Giao bài tập -->
        <button class="btn btn-primary fw-semibold d-none shadow-xs" id="btn-header-assign" type="button" data-bs-toggle="modal" data-bs-target="#assignHomeworkModal">
          Giao bài tập
        </button>
        <!-- For Student only: Luyện tập ngay (Mặc định ẩn, chỉ bật lên khi là học sinh) -->
        <a class="btn btn-primary d-none" id="btn-header-practice" href="${pageContext.request.contextPath}/practice">Luyện tập ngay &rarr;</a>
        <script>
          (function() {
            try {
              const u = JSON.parse(localStorage.getItem('math10_session_user') || '{}');
              const roleSel = document.getElementById('role-select');
              const r = (u.role || (roleSel ? roleSel.value : '') || '').toUpperCase();
              if (r !== 'TEACHER' && r !== 'ADMIN') {
                const pBtn = document.getElementById('btn-header-practice');
                if (pBtn) pBtn.classList.remove('d-none');
                const pCard = document.getElementById('student-progress-card');
                if (pCard) {
                  pCard.classList.remove('d-none');
                  pCard.style.display = 'block';
                }
              } else {
                const aBtn = document.getElementById('btn-header-assign');
                if (aBtn) aBtn.classList.remove('d-none');
                const tBan = document.getElementById('teacher-admin-banner');
                if (tBan) tBan.classList.remove('d-none');
                const hEl = document.getElementById('lessons-main-heading');
                if (hEl) hEl.textContent = 'Danh sách bài giảng';
                const dEl = document.getElementById('lessons-main-desc');
                if (dEl) dEl.textContent = 'Hệ thống 27 bài giảng chuẩn theo SGK Toán 10 Kết nối tri thức. Xem nội dung bài giảng chi tiết hoặc giao bài tập cho học sinh.';
              }
            } catch(e) {}
          })();
        </script>
      </div>
    </div>

    <!-- Student Progress & Status Filter Card (Visible for STUDENT by default) -->
    <div class="cardx card-pad mb-4" id="student-progress-card">
      <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
        <div>
          <div class="fw-bold text-dark d-flex align-items-center gap-2 fs-6">
            <span>Tiến độ học tập của bạn:</span>
            <span class="text-primary fw-bold" id="student-progress-text">0 / 27 bài học (0%)</span>
          </div>
          <div class="small text-muted">Bấm trực tiếp nút "Đã học" trên từng bài để đánh dấu hoàn thành hoặc bỏ đánh dấu.</div>
        </div>
        <div class="d-flex align-items-center gap-2">
          <span class="small fw-semibold text-secondary">Trạng thái:</span>
          <div class="btn-group btn-group-sm" role="group" id="status-filter-group">
            <button type="button" class="btn btn-primary active status-filter-btn" data-status="all" onclick="filterByStatus('all', this)">Tất cả bài học (27)</button>
            <button type="button" class="btn btn-outline-success status-filter-btn" data-status="completed" onclick="filterByStatus('completed', this)">Đã hoàn thành (<span id="count-completed">0</span>)</button>
            <button type="button" class="btn btn-outline-secondary status-filter-btn" data-status="incomplete" onclick="filterByStatus('incomplete', this)">Chưa hoàn thành (<span id="count-incomplete">27</span>)</button>
          </div>
        </div>
      </div>
      <div class="progress" style="height: 8px; border-radius: 4px; background-color: #e9ecef;">
        <div class="progress-bar bg-success progress-bar-striped" id="student-progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
      </div>
    </div>

    <!-- Teacher & Admin Info Banner (Only visible for TEACHER / ADMIN) -->
    <div class="cardx card-pad mb-4 d-none" id="teacher-admin-banner">
      <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
        <div class="d-flex align-items-center gap-2">
          <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">CHẾ ĐỘ GIẢNG DẠY & QUẢN TRỊ</span>
          <span class="text-secondary small">Toàn bộ 27 bài học theo chương trình SGK Toán 10 Kết nối tri thức. Giáo viên có thể xem nội dung bài giảng hoặc giao bài tập trực tiếp cho học sinh.</span>
        </div>
        <div class="d-flex gap-2">
          <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/teacher/questions">Ngân hàng câu hỏi</a>
          <button class="btn btn-sm btn-primary fw-semibold" type="button" data-bs-toggle="modal" data-bs-target="#assignHomeworkModal">
            Giao bài tập
          </button>
        </div>
      </div>
    </div>

    <!-- Filter Pills by Topic -->
    <div class="cardx card-pad mb-4">
      <div class="filter-row" id="topic-filter-bar">
        <button class="btn btn-soft topic-filter active" data-chapter="all" data-topic="all" onclick="filterByChapter('all', this)">Tất cả chủ đề (9)</button>
        <button class="btn btn-light topic-filter" data-chapter="1" data-topic="1" onclick="filterByChapter('1', this)">Chương I: Mệnh đề & Tập hợp</button>
        <button class="btn btn-light topic-filter" data-chapter="2" data-topic="2" onclick="filterByChapter('2', this)">Chương II: Bất PT bậc nhất hai ẩn</button>
        <button class="btn btn-light topic-filter" data-chapter="3" data-topic="3" onclick="filterByChapter('3', this)">Chương III: Hệ thức lượng trong tam giác</button>
        <button class="btn btn-light topic-filter" data-chapter="4" data-topic="4" onclick="filterByChapter('4', this)">Chương IV: Vectơ</button>
        <button class="btn btn-light topic-filter" data-chapter="5" data-topic="5" onclick="filterByChapter('5', this)">Chương V: Thống kê</button>
        <button class="btn btn-light topic-filter" data-chapter="6" data-topic="6" onclick="filterByChapter('6', this)">Chương VI: Hàm số & Đồ thị</button>
        <button class="btn btn-light topic-filter" data-chapter="7" data-topic="7" onclick="filterByChapter('7', this)">Chương VII: Tọa độ phẳng</button>
        <button class="btn btn-light topic-filter" data-chapter="8" data-topic="8" onclick="filterByChapter('8', this)">Chương VIII: Đại số tổ hợp</button>
        <button class="btn btn-light topic-filter" data-chapter="9" data-topic="9" onclick="filterByChapter('9', this)">Chương IX: Xác suất cổ điển</button>
      </div>
    </div>

    <!-- Lessons Grid (27 bài học bám sát SGK Toán 10) -->
    <div class="row g-3" id="lessons-grid">
      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương I. Mệnh đề và tập hợp">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG I</span>
            <div class="math-art">A ∩ B</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Mệnh đề và tập hợp</span>
            <h3>Bài 1. Mệnh đề</h3>
            <p class="small text-muted">Nhận biết mệnh đề, phủ định và mệnh đề chứa biến.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=1" data-lesson-id="1">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương I. Mệnh đề và tập hợp">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG I</span>
            <div class="math-art">∅ ⊆ A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Mệnh đề và tập hợp</span>
            <h3>Bài 2. Tập hợp và các phép toán trên tập hợp</h3>
            <p class="small text-muted">Biểu diễn tập hợp và thực hiện hợp, giao, hiệu, phần bù.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=2" data-lesson-id="2">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG II</span>
            <div class="math-art">∆ ABC</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Bất phương trình và hệ bất phương trình bậc nhất hai ẩn</span>
            <h3>Bài 3. Bất phương trình bậc nhất hai ẩn</h3>
            <p class="small text-muted">Biểu diễn miền nghiệm của bất phương trình tuyến tính hai ẩn.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=3" data-lesson-id="3">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG II</span>
            <div class="math-art">\cos A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Bất phương trình và hệ bất phương trình bậc nhất hai ẩn</span>
            <h3>Bài 4. Hệ bất phương trình bậc nhất hai ẩn</h3>
            <p class="small text-muted">Tìm miền nghiệm chung và vận dụng vào bài toán tối ưu đơn giản.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=4" data-lesson-id="4">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương III. Hệ thức lượng trong tam giác">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG III</span>
            <div class="math-art">y = ax²</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hệ thức lượng trong tam giác</span>
            <h3>Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°</h3>
            <p class="small text-muted">Hiểu dấu và các giá trị lượng giác của góc tù, góc nhọn.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=5" data-lesson-id="5">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương III. Hệ thức lượng trong tam giác">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG III</span>
            <div class="math-art">P(A)</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hệ thức lượng trong tam giác</span>
            <h3>Bài 6. Hệ thức lượng trong tam giác</h3>
            <p class="small text-muted">Áp dụng định lí sin, cosin và công thức diện tích.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=6" data-lesson-id="6">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IV. Vectơ">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG IV</span>
            <div class="math-art">∑</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Vectơ</span>
            <h3>Bài 7. Các khái niệm mở đầu</h3>
            <p class="small text-muted">Nhận biết vectơ, độ dài, phương, hướng và vectơ bằng nhau.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=7" data-lesson-id="7">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IV. Vectơ">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG IV</span>
            <div class="math-art">→AB</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Vectơ</span>
            <h3>Bài 8. Tổng và hiệu của hai vectơ</h3>
            <p class="small text-muted">Dùng quy tắc ba điểm, hình bình hành và vectơ đối.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=8" data-lesson-id="8">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IV. Vectơ">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG IV</span>
            <div class="math-art">∈ ℝ</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Vectơ</span>
            <h3>Bài 9. Tích của một vectơ với một số</h3>
            <p class="small text-muted">Hiểu hướng và độ dài của vectơ k·a.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=9" data-lesson-id="9">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IV. Vectơ">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG IV</span>
            <div class="math-art">A ∩ B</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Vectơ</span>
            <h3>Bài 10. Vectơ trong mặt phẳng tọa độ</h3>
            <p class="small text-muted">Tính tọa độ vectơ, độ dài và tọa độ trung điểm.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=10" data-lesson-id="10">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IV. Vectơ">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG IV</span>
            <div class="math-art">∅ ⊆ A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Vectơ</span>
            <h3>Bài 11. Tích vô hướng của hai vectơ</h3>
            <p class="small text-muted">Tính tích vô hướng và dùng để nhận biết vuông góc.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=11" data-lesson-id="11">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG V</span>
            <div class="math-art">∆ ABC</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Các số đặc trưng của mẫu số liệu không ghép nhóm</span>
            <h3>Bài 12. Số gần đúng và sai số</h3>
            <p class="small text-muted">Làm tròn số và ước lượng sai số tuyệt đối, tương đối.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=12" data-lesson-id="12">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG V</span>
            <div class="math-art">\cos A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Các số đặc trưng của mẫu số liệu không ghép nhóm</span>
            <h3>Bài 13. Các số đặc trưng đo xu thế trung tâm</h3>
            <p class="small text-muted">Tính số trung bình, trung vị và mốt để mô tả dữ liệu.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=13" data-lesson-id="13">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG V</span>
            <div class="math-art">y = ax²</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Các số đặc trưng của mẫu số liệu không ghép nhóm</span>
            <h3>Bài 14. Các số đặc trưng đo độ phân tán</h3>
            <p class="small text-muted">Dùng khoảng biến thiên, khoảng tứ phân vị và độ lệch chuẩn.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=14" data-lesson-id="14">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VI. Hàm số, đồ thị và ứng dụng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG VI</span>
            <div class="math-art">P(A)</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hàm số, đồ thị và ứng dụng</span>
            <h3>Bài 15. Hàm số</h3>
            <p class="small text-muted">Xác định tập xác định, giá trị và đọc đồ thị hàm số.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=15" data-lesson-id="15">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VI. Hàm số, đồ thị và ứng dụng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG VI</span>
            <div class="math-art">∑</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hàm số, đồ thị và ứng dụng</span>
            <h3>Bài 16. Hàm số bậc hai</h3>
            <p class="small text-muted">Khảo sát dạng, đỉnh, trục đối xứng và chiều mở của parabol.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=16" data-lesson-id="16">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VI. Hàm số, đồ thị và ứng dụng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG VI</span>
            <div class="math-art">→AB</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hàm số, đồ thị và ứng dụng</span>
            <h3>Bài 17. Dấu của tam thức bậc hai</h3>
            <p class="small text-muted">Xét dấu ax²+bx+c theo nghiệm và hệ số a.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=17" data-lesson-id="17">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VI. Hàm số, đồ thị và ứng dụng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG VI</span>
            <div class="math-art">∈ ℝ</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Hàm số, đồ thị và ứng dụng</span>
            <h3>Bài 18. Phương trình quy về phương trình bậc hai</h3>
            <p class="small text-muted">Giải phương trình chứa căn, phân thức bằng điều kiện và phép đặt ẩn.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=18" data-lesson-id="18">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VII. Phương pháp tọa độ trong mặt phẳng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG VII</span>
            <div class="math-art">A ∩ B</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Phương pháp tọa độ trong mặt phẳng</span>
            <h3>Bài 19. Phương trình đường thẳng</h3>
            <p class="small text-muted">Viết phương trình đường thẳng từ điểm và vectơ pháp tuyến.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=19" data-lesson-id="19">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VII. Phương pháp tọa độ trong mặt phẳng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG VII</span>
            <div class="math-art">∅ ⊆ A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Phương pháp tọa độ trong mặt phẳng</span>
            <h3>Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách</h3>
            <p class="small text-muted">Xét giao điểm, song song, góc và khoảng cách điểm–đường.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=20" data-lesson-id="20">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VII. Phương pháp tọa độ trong mặt phẳng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG VII</span>
            <div class="math-art">∆ ABC</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Phương pháp tọa độ trong mặt phẳng</span>
            <h3>Bài 21. Đường tròn trong mặt phẳng tọa độ</h3>
            <p class="small text-muted">Nhận dạng tâm, bán kính và lập phương trình đường tròn.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=21" data-lesson-id="21">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VII. Phương pháp tọa độ trong mặt phẳng">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG VII</span>
            <div class="math-art">\cos A</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Phương pháp tọa độ trong mặt phẳng</span>
            <h3>Bài 22. Ba đường conic</h3>
            <p class="small text-muted">Nhận biết elip, hypebol, parabol qua tiêu điểm và phương trình.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=22" data-lesson-id="22">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VIII. Đại số tổ hợp">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG VIII</span>
            <div class="math-art">y = ax²</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Đại số tổ hợp</span>
            <h3>Bài 23. Quy tắc đếm</h3>
            <p class="small text-muted">Phân biệt quy tắc cộng và quy tắc nhân trong bài đếm.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=23" data-lesson-id="23">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VIII. Đại số tổ hợp">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-amber">
            <span class="cover-tag">CHƯƠNG VIII</span>
            <div class="math-art">P(A)</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Đại số tổ hợp</span>
            <h3>Bài 24. Hoán vị, chỉnh hợp và tổ hợp</h3>
            <p class="small text-muted">Chọn công thức đếm có xét hay không xét thứ tự.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=24" data-lesson-id="24">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương VIII. Đại số tổ hợp">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-blue">
            <span class="cover-tag">CHƯƠNG VIII</span>
            <div class="math-art">∑</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Đại số tổ hợp</span>
            <h3>Bài 25. Nhị thức Newton</h3>
            <p class="small text-muted">Khai triển (a+b)ⁿ bằng hệ số nhị thức.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=25" data-lesson-id="25">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IX. Tính xác suất theo định nghĩa cổ điển">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-mint">
            <span class="cover-tag">CHƯƠNG IX</span>
            <div class="math-art">→AB</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Tính xác suất theo định nghĩa cổ điển</span>
            <h3>Bài 26. Biến cố và định nghĩa cổ điển của xác suất</h3>
            <p class="small text-muted">Mô tả không gian mẫu, biến cố và tính xác suất đồng khả năng.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=26" data-lesson-id="26">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6 col-lg-4 lesson-item" data-topic-name="Chương IX. Tính xác suất theo định nghĩa cổ điển">
        <div class="cardx lesson-card">
          <div class="lesson-cover cover-lilac">
            <span class="cover-tag">CHƯƠNG IX</span>
            <div class="math-art">∈ ℝ</div>
          </div>
          <div class="lesson-body">
            <span class="tag tag-blue">Tính xác suất theo định nghĩa cổ điển</span>
            <h3>Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển</h3>
            <p class="small text-muted">Tổ chức phép thử đơn giản và đếm kết quả thuận lợi.</p>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
              <span class="small text-muted">Lớp 10 &bull; SGK</span>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lesson-detail?id=27" data-lesson-id="27">${isTeacherOrAdmin ? 'Xem bài giảng &rarr;' : 'Học bài &rarr;'}</a>
            </div>
          </div>
        </div>
    </div>
  </main>

  <!-- Modal Giao bài tập cho học sinh (Dành cho Giáo viên & Quản trị) -->
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
                <strong>Chế độ Giáo viên:</strong> Chọn bài học và hình thức bài tập để giao cho học sinh. Học sinh sẽ nhận bài và làm trực tiếp trên hệ thống với sự hỗ trợ của AI.
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
                  <textarea class="form-control" id="assign-note" rows="2" placeholder="Ví dụ: Các em hoàn thành bài tập trước 22:00 Chủ nhật. Gặp bài khó hãy hỏi Gia sư AI."></textarea>
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

  <!-- Modal Chỉnh sửa bài học & Link Video YouTube (Dành riêng cho Quản trị viên) -->
  <div class="modal fade" id="adminEditLessonModal" tabindex="-1" aria-labelledby="adminEditLessonModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
      <div class="modal-content border-0 shadow">
        <div class="modal-header bg-dark text-white">
          <h5 class="modal-title fw-bold" id="adminEditLessonModalLabel">Chỉnh sửa nội dung &amp; Video bài học</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" onclick="closeEditLessonModal()" aria-label="Đóng"></button>
        </div>
        <form id="admin-edit-lesson-form" onsubmit="handleSaveEditLesson(event)">
          <input type="hidden" id="editLessonId" />
          <div class="modal-body p-4">
            <div id="editLessonAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <div class="row g-3 mb-3">
              <div class="col-md-7">
                <label class="form-label fw-semibold" for="editLessonTitle">Tên bài học <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="editLessonTitle" required />
              </div>
              <div class="col-md-5">
                <label class="form-label fw-semibold" for="editLessonTopic">Chủ đề / Chuyên đề <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="editLessonTopic" required />
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label fw-semibold" for="editLessonSummary">Mô tả tóm tắt nội dung <span class="text-danger">*</span></label>
              <textarea class="form-control" id="editLessonSummary" rows="2" required></textarea>
            </div>

            <!-- Quản lý Video YouTube (Đổi / Thêm link) -->
            <div class="p-3 rounded-3 border border-danger-subtle bg-light">
              <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3 pb-2 border-bottom">
                <div class="d-flex align-items-center gap-2">
                  <span class="badge bg-danger text-white px-2 py-1">YouTube</span>
                  <span class="fw-bold text-dark">Quản lý Link Video bài giảng (Admin)</span>
                </div>
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetEditLessonVideoToDefault()" title="Khôi phục link video gốc của hệ thống">
                  ↺ Khôi phục video mặc định
                </button>
              </div>

              <div class="mb-2">
                <label class="form-label fw-semibold small mb-1" for="editLessonVideoUrl">Link Video YouTube chính (hoặc Video ID 11 ký tự)</label>
                <div class="input-group input-group-sm">
                  <input type="text" class="form-control" id="editLessonVideoUrl" placeholder="Ví dụ: https://www.youtube.com/watch?v=... hoặc https://youtu.be/..." oninput="previewEditLessonVideo(false)" />
                  <button type="button" class="btn btn-outline-danger fw-semibold" onclick="previewEditLessonVideo(true)">Xem thử</button>
                </div>
                <div class="form-text small">Hỗ trợ link <code>youtube.com/watch?v=...</code>, <code>youtu.be/...</code>, <code>youtube.com/shorts/...</code> hoặc mã ID.</div>
              </div>

              <div class="row g-2 mb-3">
                <div class="col-md-7">
                  <label class="form-label fw-semibold small mb-1" for="editLessonVideoTitle">Tiêu đề video hiển thị</label>
                  <input type="text" class="form-control form-control-sm" id="editLessonVideoTitle" placeholder="Ví dụ: Bài 1. Mệnh đề - Thầy Đạt" />
                </div>
                <div class="col-md-5">
                  <label class="form-label fw-semibold small mb-1" for="editLessonVideoChannel">Tên kênh / Giáo viên</label>
                  <input type="text" class="form-control form-control-sm" id="editLessonVideoChannel" placeholder="Ví dụ: VietJack THPT Official" />
                </div>
              </div>

              <!-- Preview Player -->
              <div id="editVideoPreviewWrap" class="d-none mb-3">
                <div class="small fw-semibold text-muted mb-1">Xem trước video chính:</div>
                <div class="ratio ratio-16x9 rounded overflow-hidden border bg-dark" style="max-width: 420px;">
                  <iframe id="editVideoPreviewIframe" src="" title="Preview" allowfullscreen style="border:0;"></iframe>
                </div>
              </div>

              <!-- Danh sách video bổ sung -->
              <div class="pt-2 border-top">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <span class="small fw-bold text-dark">Link video bổ sung (Học sinh có thể chuyển xem thêm)</span>
                  <button type="button" class="btn btn-sm btn-outline-primary fw-semibold py-0 px-2" onclick="addExtraVideoRow()">
                    + Thêm link video
                  </button>
                </div>
                <div id="editExtraVideosList" class="d-flex flex-column gap-2">
                  <!-- Dynamic rows -->
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeEditLessonModal()">Hủy</button>
            <button type="submit" class="btn btn-primary fw-semibold" id="btn-submit-edit-lesson">Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Xem Video Bài Giảng YouTube -->
  <div class="modal fade" id="lessonVideoModal" tabindex="-1" aria-labelledby="lessonVideoModalLabel" aria-hidden="true" style="z-index: 1070;">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content border-0 shadow-lg rounded-3 overflow-hidden">
        <div class="modal-header bg-dark text-white py-3">
          <div class="d-flex align-items-center gap-2">
            <span class="badge bg-danger px-2 py-1 d-inline-flex align-items-center gap-1 shadow-xs">
              <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.01 2.01 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.01 2.01 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31 31 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.01 2.01 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A100 100 0 0 1 7.858 2zM6.4 5.209v5.582l4.8-2.79z"/></svg>
              YouTube
            </span>
            <h5 class="modal-title fw-bold mb-0 text-white" id="lessonVideoModalLabel">Video bài giảng</h5>
          </div>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng" onclick="closeLessonVideoModal()"></button>
        </div>
        <div id="modalVideoSwitcher" class="bg-dark border-top border-secondary px-3 py-2 d-none flex-wrap gap-2"></div>
        <div class="modal-body p-0 bg-black">
          <div class="ratio ratio-16x9">
            <iframe id="modalYoutubePlayer" src="" title="Video bài giảng" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen style="border:0;"></iframe>
          </div>
        </div>
        <div class="modal-footer bg-light d-flex flex-wrap justify-content-between align-items-center">
          <div class="small text-muted mb-2 mb-md-0">
            <span class="badge bg-light text-secondary border me-1" id="modalVideoChannel">Kênh: VietJack</span>
            <span id="modalVideoTitle" class="fw-semibold text-dark"></span>
          </div>
          <div class="d-flex flex-wrap align-items-center gap-2">
            <button type="button" id="modalBtnAdminEditVideo" class="btn btn-warning text-dark btn-sm fw-semibold d-none" onclick="editVideoFromPreviewModal()">
              Đổi / Thêm link video
            </button>
            <a id="modalBtnYoutubeExt" href="#" target="_blank" rel="noopener noreferrer" class="btn btn-outline-danger btn-sm fw-semibold">
              Mở trên YouTube ↗
            </a>
            <a id="modalBtnGoDetail" href="#" class="btn btn-primary btn-sm fw-semibold">
              Vào học chi tiết bài này &rarr;
            </a>
            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal" onclick="closeLessonVideoModal()">Đóng</button>
          </div>
        </div>
      </div>
    </div>
  </div>

<script src="${pageContext.request.contextPath}/js/lesson-detail.js?v=20261111"></script>
<script>
  // Global helper functions and state
  function getSessionUser() {
    try {
      const raw = localStorage.getItem('math10_session_user');
      return raw ? JSON.parse(raw) : null;
    } catch(e) {
      return null;
    }
  }

  function getStudentStorageKey(u) {
    if (u && u.username) return 'math10_completed_lessons_' + u.username;
    return 'math10_completed_lessons';
  }

  function openAssignForLesson(lid, lTitle) {
    const sel = document.getElementById('assign-lesson-select');
    if (sel) sel.value = String(lid);
    const modalEl = document.getElementById('assignHomeworkModal');
    if (modalEl) {
      if (modalEl.parentElement !== document.body) {
        document.body.appendChild(modalEl);
      }
      if (window.bootstrap && window.bootstrap.Modal) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
      }
    }
  }

  function getLessonChapter(card) {
    if (card.dataset.chapter) return String(card.dataset.chapter);
    const tag = card.querySelector('.cover-tag');
    if (tag) {
      const txt = tag.textContent.trim().toUpperCase();
      if (txt === 'CHƯƠNG I') return '1';
      if (txt === 'CHƯƠNG II') return '2';
      if (txt === 'CHƯƠNG III') return '3';
      if (txt === 'CHƯƠNG IV') return '4';
      if (txt === 'CHƯƠNG V') return '5';
      if (txt === 'CHƯƠNG VI') return '6';
      if (txt === 'CHƯƠNG VII') return '7';
      if (txt === 'CHƯƠNG VIII') return '8';
      if (txt === 'CHƯƠNG IX') return '9';
    }
    const link = card.querySelector('[data-lesson-id]');
    if (link) {
      const lid = Number(link.dataset.lessonId);
      if (lid <= 2) return '1';
      if (lid <= 4) return '2';
      if (lid <= 6) return '3';
      if (lid <= 11) return '4';
      if (lid <= 14) return '5';
      if (lid <= 18) return '6';
      if (lid <= 22) return '7';
      if (lid <= 25) return '8';
      return '9';
    }
    return '1';
  }

  function matchCardChapter(card, filter) {
    if (!filter || filter === 'all') return true;
    const ch = getLessonChapter(card);
    if (ch === String(filter)) return true;
    const tn = (card.dataset.topicName || '').toLowerCase();
    const fLow = String(filter).toLowerCase();
    return tn.includes(fLow) || fLow.includes(tn);
  }

  // State
  let currentUser = getSessionUser();
  let completedLessons = [];
  let currentTopicFilter = 'all';
  let currentStatusFilter = 'all';

  function getEffectiveRole() {
    currentUser = getSessionUser();
    if (currentUser && currentUser.role) return currentUser.role.toUpperCase();
    const sessionRole = "${sessionScope['math10.user'].role}";
    if (sessionRole) return sessionRole.toUpperCase();
    const roleSelect = document.getElementById('role-select');
    if (roleSelect && roleSelect.value) return roleSelect.value.toUpperCase();
    return 'STUDENT';
  }

  let currentRole = getEffectiveRole();

  function loadStudentCompleted() {
    currentUser = getSessionUser();
    const storageKey = getStudentStorageKey(currentUser);
    try {
      const stored = localStorage.getItem(storageKey);
      if (stored) {
        completedLessons = JSON.parse(stored);
      } else if (!currentUser || currentUser.role === 'STUDENT') {
        const legacy = localStorage.getItem('math10_completed_lessons');
        if (legacy) {
          completedLessons = JSON.parse(legacy);
          localStorage.setItem(storageKey, legacy);
        }
      }
      if (!Array.isArray(completedLessons)) completedLessons = [];
    } catch(e) {
      completedLessons = [];
    }
  }

  function saveCompleted() {
    currentUser = getSessionUser();
    const storageKey = getStudentStorageKey(currentUser);
    try {
      localStorage.setItem(storageKey, JSON.stringify(completedLessons));
      localStorage.setItem('math10_completed_lessons', JSON.stringify(completedLessons));
    } catch(e) {}
  }

  window.toggleLessonDone = function(lid, forceState) {
    lid = Number(lid);
    const idx = completedLessons.indexOf(lid);
    if (typeof forceState === 'boolean') {
      if (forceState && idx === -1) {
        completedLessons.push(lid);
      } else if (!forceState && idx !== -1) {
        completedLessons.splice(idx, 1);
      }
    } else {
      if (idx >= 0) {
        completedLessons.splice(idx, 1);
      } else {
        completedLessons.push(lid);
      }
    }
    saveCompleted();
    window.updateStudentUI();
  };

  window.filterByChapter = function(ch, btnEl) {
    currentTopicFilter = String(ch);
    const filterButtons = document.querySelectorAll('.topic-filter');
    filterButtons.forEach(b => {
      b.classList.remove('active', 'btn-soft');
      b.classList.add('btn-light');
    });
    if (btnEl) {
      btnEl.classList.add('active', 'btn-soft');
      btnEl.classList.remove('btn-light');
    } else {
      const matchedBtn = document.querySelector(`.topic-filter[data-chapter="${ch}"]`);
      if (matchedBtn) {
        matchedBtn.classList.add('active', 'btn-soft');
        matchedBtn.classList.remove('btn-light');
      }
    }
    window.applyCombinedFilter();
  };

  window.filterByStatus = function(st, btnEl) {
    currentStatusFilter = String(st);
    const statusBtns = document.querySelectorAll('.status-filter-btn');
    statusBtns.forEach(b => {
      b.classList.remove('active', 'btn-primary', 'btn-success', 'btn-secondary');
      if (b.dataset.status === 'completed') b.classList.add('btn-outline-success');
      else if (b.dataset.status === 'incomplete') b.classList.add('btn-outline-secondary');
      else b.classList.add('btn-outline-primary');
    });
    if (btnEl) {
      btnEl.classList.add('active');
      if (st === 'completed') {
        btnEl.classList.remove('btn-outline-success');
        btnEl.classList.add('btn-success');
      } else if (st === 'incomplete') {
        btnEl.classList.remove('btn-outline-secondary');
        btnEl.classList.add('btn-secondary');
      } else {
        btnEl.classList.remove('btn-outline-primary');
        btnEl.classList.add('btn-primary');
      }
    }
    window.applyCombinedFilter();
  };

  window.applyCombinedFilter = function() {
    const cards = document.querySelectorAll('#lessons-grid .lesson-item');
    const isTeacherOrAdmin = (currentRole === 'TEACHER' || currentRole === 'ADMIN');

    cards.forEach(card => {
      const link = card.querySelector('[data-lesson-id]');
      const lid = link ? Number(link.dataset.lessonId) : 0;
      const isDone = completedLessons.includes(lid);

      const matchTopic = matchCardChapter(card, currentTopicFilter);

      let matchStatus = true;
      if (!isTeacherOrAdmin) {
        if (currentStatusFilter === 'completed') {
          matchStatus = isDone;
        } else if (currentStatusFilter === 'incomplete') {
          matchStatus = !isDone;
        }
      }

      if (matchTopic && matchStatus) {
        card.classList.remove('d-none');
        card.style.display = '';
      } else {
        card.classList.add('d-none');
        card.style.display = 'none';
      }
    });
  };

  window.updateStudentUI = function() {
    const cards = document.querySelectorAll('#lessons-grid .lesson-item');
    const totalLessons = cards.length;
    const doneCount = completedLessons.length;
    const incompleteCount = Math.max(0, totalLessons - doneCount);
    const percent = totalLessons > 0 ? Math.round((doneCount / totalLessons) * 100) : 0;

    const progressText = document.getElementById('student-progress-text');
    const progressBar = document.getElementById('student-progress-bar');
    const countDoneEl = document.getElementById('count-completed');
    const countIncompleteEl = document.getElementById('count-incomplete');

    if (progressText) progressText.textContent = doneCount + ' / ' + totalLessons + ' bài học (' + percent + '%)';
    if (progressBar) {
      progressBar.style.width = percent + '%';
      progressBar.setAttribute('aria-valuenow', percent);
    }
    if (countDoneEl) countDoneEl.textContent = doneCount;
    if (countIncompleteEl) countIncompleteEl.textContent = incompleteCount;

    cards.forEach(card => {
      const link = card.querySelector('[data-lesson-id]');
      if (!link) return;
      const lid = Number(link.dataset.lessonId);
      const isDone = completedLessons.includes(lid);

      // Status badge in card body
      const body = card.querySelector('.lesson-body');
      if (body) {
        let badge = body.querySelector('.lesson-status-badge');
        if (!badge) {
          badge = document.createElement('span');
          badge.className = 'badge mb-2 lesson-status-badge';
          body.insertBefore(badge, body.firstChild);
        }
        if (isDone) {
          badge.className = 'badge bg-success-subtle text-success border border-success-subtle mb-2 lesson-status-badge';
          badge.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" class="me-1"><path d="M20 6 9 17l-5-5"/></svg>Đã hoàn thành';
        } else {
          badge.className = 'badge bg-light text-muted border mb-2 lesson-status-badge';
          badge.innerHTML = '○ Chưa hoàn thành';
        }
      }

      // Checkbox in footer for students
      const footer = card.querySelector('.lesson-body .border-top');
      if (footer) {
        let checkContainer = footer.querySelector('.lesson-check-wrap');
        if (!checkContainer) {
          checkContainer = document.createElement('label');
          checkContainer.className = 'form-check lesson-check-wrap d-flex align-items-center gap-1 m-0 user-select-none cursor-pointer';
          checkContainer.title = 'Tích chọn để đánh dấu hoàn thành bài học';
          checkContainer.innerHTML = '<input class="form-check-input lesson-checkbox" type="checkbox" style="cursor: pointer; width: 1.15em; height: 1.15em;"><span class="small fw-semibold lesson-check-label ms-1"></span>';
          
          const sgkSpan = footer.querySelector('span.small.text-muted');
          if (sgkSpan) {
            footer.replaceChild(checkContainer, sgkSpan);
          } else {
            footer.insertBefore(checkContainer, footer.firstChild);
          }
        }

        const chk = checkContainer.querySelector('input.lesson-checkbox');
        const lbl = checkContainer.querySelector('span.lesson-check-label');
        if (chk) {
          chk.checked = isDone;
          chk.onchange = (e) => {
            e.stopPropagation();
            window.toggleLessonDone(lid, e.target.checked);
          };
        }
        if (lbl) {
          if (isDone) {
            lbl.textContent = 'Đã học';
            lbl.className = 'small fw-semibold lesson-check-label ms-1 text-success';
          } else {
            lbl.textContent = 'Chưa học';
            lbl.className = 'small fw-semibold lesson-check-label ms-1 text-muted';
          }
        }

        // Add YouTube Video button for each lesson
        let videoBtn = footer.querySelector('.btn-watch-video');
        if (!videoBtn) {
          videoBtn = document.createElement('button');
          videoBtn.type = 'button';
          videoBtn.className = 'btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1 btn-watch-video me-1';
          videoBtn.title = 'Xem video bài giảng YouTube';
          videoBtn.innerHTML = '<svg width="13" height="13" fill="currentColor" viewBox="0 0 16 16"><path d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.01 2.01 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.01 2.01 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31 31 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.01 2.01 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A100 100 0 0 1 7.858 2zM6.4 5.209v5.582l4.8-2.79z"/></svg> Video';
          videoBtn.onclick = (e) => {
            e.preventDefault();
            e.stopPropagation();
            window.openLessonVideoModal(lid);
          };
          if (link) {
            link.parentNode.insertBefore(videoBtn, link);
          } else {
            footer.appendChild(videoBtn);
          }
        }
      }
    });

    window.applyCombinedFilter();
  };

  // Video Modal Handlers
  let activePreviewLessonId = null;

  function renderModalVideoItem(lid, videoItem) {
    const iframe = document.getElementById('modalYoutubePlayer');
    const modalLabel = document.getElementById('lessonVideoModalLabel');
    const modalTitle = document.getElementById('modalVideoTitle');
    const modalChannel = document.getElementById('modalVideoChannel');
    const btnExt = document.getElementById('modalBtnYoutubeExt');

    if (modalLabel) modalLabel.textContent = 'Bài ' + lid + ': ' + (videoItem.title || ('Bài ' + lid));
    if (modalTitle) modalTitle.textContent = videoItem.title || ('Bài ' + lid);
    if (modalChannel) modalChannel.textContent = 'Kênh: ' + (videoItem.channel || 'Toán 10 KNTT');
    if (btnExt) btnExt.href = 'https://www.youtube.com/watch?v=' + videoItem.videoId;
    if (iframe) iframe.src = 'https://www.youtube.com/embed/' + videoItem.videoId + '?autoplay=1&rel=0';
  }

  window.openLessonVideoModal = function(lid) {
    lid = Number(lid);
    activePreviewLessonId = lid;
    const videoData = window.getLessonVideoConfig
      ? window.getLessonVideoConfig(lid)
      : ((window.MATH10_LESSON_VIDEOS && window.MATH10_LESSON_VIDEOS[lid]) || {
          videoId: 'vZF3rsOSDAU',
          title: 'Bài ' + lid,
          channel: 'VietJack THPT Official',
          extraVideos: []
        });

    const modalEl = document.getElementById('lessonVideoModal');
    const btnDetail = document.getElementById('modalBtnGoDetail');
    const btnAdminEdit = document.getElementById('modalBtnAdminEditVideo');
    const switcher = document.getElementById('modalVideoSwitcher');

    const allVideos = [
      { videoId: videoData.videoId, title: videoData.title, channel: videoData.channel, label: 'Video chính' }
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

    renderModalVideoItem(lid, allVideos[0]);

    if (switcher) {
      if (allVideos.length > 1) {
        switcher.classList.remove('d-none');
        switcher.classList.add('d-flex');
        switcher.innerHTML = '';
        allVideos.forEach((v, idx) => {
          const btn = document.createElement('button');
          btn.type = 'button';
          btn.className = 'btn btn-sm ' + (idx === 0 ? 'btn-danger' : 'btn-outline-light');
          btn.textContent = v.label + (v.title ? ': ' + v.title : '');
          btn.onclick = () => {
            switcher.querySelectorAll('button').forEach(b => {
              b.className = 'btn btn-sm btn-outline-light';
            });
            btn.className = 'btn btn-sm btn-danger';
            renderModalVideoItem(lid, v);
          };
          switcher.appendChild(btn);
        });
      } else {
        switcher.classList.add('d-none');
        switcher.classList.remove('d-flex');
        switcher.innerHTML = '';
      }
    }

    if (btnDetail) btnDetail.href = '${pageContext.request.contextPath}/lesson-detail?id=' + lid;
    if (btnAdminEdit) {
      if (currentRole === 'ADMIN') {
        btnAdminEdit.classList.remove('d-none');
      } else {
        btnAdminEdit.classList.add('d-none');
      }
    }

    if (modalEl) {
      if (modalEl.parentElement !== document.body) {
        document.body.appendChild(modalEl);
      }
      if (window.bootstrap && window.bootstrap.Modal) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
      }
    }
  };

  window.editVideoFromPreviewModal = function() {
    const lid = activePreviewLessonId;
    const modalEl = document.getElementById('lessonVideoModal');
    if (modalEl && window.bootstrap && window.bootstrap.Modal) {
      const inst = bootstrap.Modal.getInstance(modalEl);
      if (inst) inst.hide();
    }
    window.closeLessonVideoModal();
    if (lid) {
      setTimeout(() => {
        window.openEditLessonModal(lid);
        const urlInput = document.getElementById('editLessonVideoUrl');
        if (urlInput) urlInput.focus();
      }, 200);
    }
  };

  window.closeLessonVideoModal = function() {
    const iframe = document.getElementById('modalYoutubePlayer');
    if (iframe) iframe.src = '';
  };

  // Extra Video Row helpers for Admin Edit Modal
  window.addExtraVideoRow = function(evData) {
    const list = document.getElementById('editExtraVideosList');
    if (!list) return;
    const row = document.createElement('div');
    row.className = 'p-2 bg-white border rounded extra-video-row';
    const urlVal = (evData && (evData.videoUrl || evData.videoId)) || '';
    const titleVal = (evData && evData.title) || '';
    const chanVal = (evData && evData.channel) || '';
    row.innerHTML =
      '<div class="row g-2 align-items-center">' +
        '<div class="col-md-5">' +
          '<input type="text" class="form-control form-control-sm extra-video-url" placeholder="Link YouTube bổ sung hoặc ID..." value="' + urlVal.replace(/"/g, '&quot;') + '">' +
        '</div>' +
        '<div class="col-md-4">' +
          '<input type="text" class="form-control form-control-sm extra-video-title" placeholder="Tiêu đề (VD: Chữa bài tập)" value="' + titleVal.replace(/"/g, '&quot;') + '">' +
        '</div>' +
        '<div class="col-md-2">' +
          '<input type="text" class="form-control form-control-sm extra-video-channel" placeholder="Kênh/GV" value="' + chanVal.replace(/"/g, '&quot;') + '">' +
        '</div>' +
        '<div class="col-md-1 text-end">' +
          '<button type="button" class="btn btn-sm btn-outline-danger py-0 px-2" title="Xóa link này" onclick="this.closest(\'.extra-video-row\').remove()">&times;</button>' +
        '</div>' +
      '</div>';
    list.appendChild(row);
  };

  window.previewEditLessonVideo = function(showAlertIfInvalid) {
    const urlInput = document.getElementById('editLessonVideoUrl');
    const wrap = document.getElementById('editVideoPreviewWrap');
    const iframe = document.getElementById('editVideoPreviewIframe');
    const alertEl = document.getElementById('editLessonAlert');
    if (!urlInput || !wrap || !iframe) return;

    const val = urlInput.value.trim();
    if (!val) {
      wrap.classList.add('d-none');
      iframe.src = '';
      return;
    }
    const parsed = window.extractYouTubeId ? window.extractYouTubeId(val) : null;
    if (parsed && parsed.videoId) {
      iframe.src = 'https://www.youtube.com/embed/' + parsed.videoId + '?rel=0';
      wrap.classList.remove('d-none');
      if (alertEl && alertEl.classList.contains('alert-danger')) {
        alertEl.classList.add('d-none');
      }
    } else {
      wrap.classList.add('d-none');
      iframe.src = '';
      if (showAlertIfInvalid && alertEl) {
        alertEl.className = 'alert alert-danger py-2 px-3 small';
        alertEl.textContent = 'Link YouTube không hợp lệ. Vui lòng dán link dạng youtube.com/watch?v=..., youtu.be/... hoặc mã ID 11 ký tự.';
        alertEl.classList.remove('d-none');
      }
    }
  };

  window.resetEditLessonVideoToDefault = function() {
    const lid = Number(document.getElementById('editLessonId').value);
    const def = (window.MATH10_LESSON_VIDEOS && window.MATH10_LESSON_VIDEOS[lid]) || null;
    const urlInput = document.getElementById('editLessonVideoUrl');
    const vTitleInput = document.getElementById('editLessonVideoTitle');
    const vChannelInput = document.getElementById('editLessonVideoChannel');
    const extraList = document.getElementById('editExtraVideosList');

    if (def) {
      if (urlInput) urlInput.value = 'https://www.youtube.com/watch?v=' + def.videoId;
      if (vTitleInput) vTitleInput.value = def.title || '';
      if (vChannelInput) vChannelInput.value = def.channel || '';
    } else {
      if (urlInput) urlInput.value = '';
      if (vTitleInput) vTitleInput.value = '';
      if (vChannelInput) vChannelInput.value = '';
    }
    if (extraList) extraList.innerHTML = '';
    window.previewEditLessonVideo(false);
  };

  // Admin Lesson Editing
  window.openEditLessonModal = function(lid) {
    lid = String(lid);
    let card = null;
    const allCards = document.querySelectorAll('#lessons-grid .lesson-item');
    allCards.forEach(c => {
      const l = c.querySelector('[data-lesson-id]');
      if (l && String(l.dataset.lessonId) === lid) {
        card = c;
      }
    });

    let currentTitle = 'Bài ' + lid;
    let currentTopic = '';
    let currentSummary = '';

    if (card) {
      const titleEl = card.querySelector('h3');
      const descEl = card.querySelector('.lesson-body p');
      const tagEl = card.querySelector('.lesson-body .tag');
      if (titleEl) currentTitle = titleEl.textContent.trim();
      if (tagEl) currentTopic = tagEl.textContent.trim();
      if (descEl) currentSummary = descEl.textContent.trim();
    }

    const idInput = document.getElementById('editLessonId');
    const titleInput = document.getElementById('editLessonTitle');
    const topicInput = document.getElementById('editLessonTopic');
    const summaryInput = document.getElementById('editLessonSummary');

    if (idInput) idInput.value = lid;
    if (titleInput) titleInput.value = currentTitle;
    if (topicInput) topicInput.value = currentTopic;
    if (summaryInput) summaryInput.value = currentSummary;

    // Populate YouTube video fields
    const videoCfg = window.getLessonVideoConfig ? window.getLessonVideoConfig(lid) : null;
    const urlInput = document.getElementById('editLessonVideoUrl');
    const vTitleInput = document.getElementById('editLessonVideoTitle');
    const vChannelInput = document.getElementById('editLessonVideoChannel');
    const extraList = document.getElementById('editExtraVideosList');

    if (videoCfg) {
      if (urlInput) urlInput.value = videoCfg.videoUrl || '';
      if (vTitleInput) vTitleInput.value = videoCfg.title || '';
      if (vChannelInput) vChannelInput.value = videoCfg.channel || '';
      if (extraList) {
        extraList.innerHTML = '';
        if (Array.isArray(videoCfg.extraVideos)) {
          videoCfg.extraVideos.forEach(ev => window.addExtraVideoRow(ev));
        }
      }
    }
    window.previewEditLessonVideo(false);

    const alertEl = document.getElementById('editLessonAlert');
    if (alertEl) {
      alertEl.className = 'alert d-none';
      alertEl.innerHTML = '';
    }

    const modalEl = document.getElementById('adminEditLessonModal');
    if (modalEl) {
      if (modalEl.parentElement !== document.body) {
        document.body.appendChild(modalEl);
      }
      modalEl.style.zIndex = '99999';
      modalEl.style.display = '';
      if (window.bootstrap && window.bootstrap.Modal) {
        try {
          const inst = bootstrap.Modal.getOrCreateInstance(modalEl);
          inst.show();
          return;
        } catch(e) {}
      }
      // Pure CSS fallback
      modalEl.classList.add('show');
      modalEl.style.display = 'block';
      modalEl.style.backgroundColor = 'rgba(0,0,0,0.5)';
      modalEl.removeAttribute('aria-hidden');
      modalEl.setAttribute('aria-modal', 'true');
    }
  };

  window.closeEditLessonModal = function() {
    const previewIframe = document.getElementById('editVideoPreviewIframe');
    if (previewIframe) previewIframe.src = '';
    const modalEl = document.getElementById('adminEditLessonModal');
    if (modalEl) {
      if (window.bootstrap && window.bootstrap.Modal) {
        try {
          const inst = bootstrap.Modal.getInstance(modalEl);
          if (inst) inst.hide();
        } catch(e) {}
      }
      modalEl.classList.remove('show');
      modalEl.style.display = 'none';
      modalEl.removeAttribute('aria-modal');
      modalEl.setAttribute('aria-hidden', 'true');
    }
    document.querySelectorAll('.modal-backdrop').forEach(b => b.remove());
  };

  window.handleSaveEditLesson = async function(e) {
    e.preventDefault();
    const lid = document.getElementById('editLessonId').value;
    const newTitle = document.getElementById('editLessonTitle').value.trim();
    const newTopic = document.getElementById('editLessonTopic').value.trim();
    const newSummary = document.getElementById('editLessonSummary').value.trim();
    const rawVideoUrl = (document.getElementById('editLessonVideoUrl')?.value || '').trim();
    const newVideoTitle = (document.getElementById('editLessonVideoTitle')?.value || '').trim();
    const newVideoChannel = (document.getElementById('editLessonVideoChannel')?.value || '').trim();
    const alertEl = document.getElementById('editLessonAlert');
    const btnSubmit = document.getElementById('btn-submit-edit-lesson');

    // Validate primary video link if provided
    let parsedPrimary = null;
    if (rawVideoUrl) {
      parsedPrimary = window.extractYouTubeId ? window.extractYouTubeId(rawVideoUrl) : null;
      if (!parsedPrimary) {
        if (alertEl) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = 'Link YouTube chính không hợp lệ. Vui lòng kiểm tra lại.';
          alertEl.classList.remove('d-none');
        }
        return;
      }
    }

    // Collect & validate extra video links
    const extraVideos = [];
    const extraRows = document.querySelectorAll('#editExtraVideosList .extra-video-row');
    for (let i = 0; i < extraRows.length; i++) {
      const row = extraRows[i];
      const uVal = (row.querySelector('.extra-video-url')?.value || '').trim();
      const tVal = (row.querySelector('.extra-video-title')?.value || '').trim();
      const cVal = (row.querySelector('.extra-video-channel')?.value || '').trim();
      if (!uVal) continue;
      const parsedEx = window.extractYouTubeId ? window.extractYouTubeId(uVal) : null;
      if (!parsedEx) {
        if (alertEl) {
          alertEl.className = 'alert alert-danger py-2 px-3 small';
          alertEl.textContent = 'Link YouTube bổ sung "' + uVal + '" không hợp lệ.';
          alertEl.classList.remove('d-none');
        }
        return;
      }
      extraVideos.push({
        videoId: parsedEx.videoId,
        videoUrl: parsedEx.videoUrl,
        title: tVal || ('Video bổ sung #' + (extraVideos.length + 2)),
        channel: cVal || newVideoChannel || 'YouTube'
      });
    }

    btnSubmit.disabled = true;

    // 1. Update card DOM immediately
    const allCards = document.querySelectorAll('#lessons-grid .lesson-item');
    allCards.forEach(card => {
      const l = card.querySelector('[data-lesson-id]');
      if (l && String(l.dataset.lessonId) === String(lid)) {
        const titleEl = card.querySelector('h3');
        const descEl = card.querySelector('.lesson-body p');
        const tagEl = card.querySelector('.lesson-body .tag');
        if (titleEl) titleEl.textContent = newTitle;
        if (descEl) descEl.textContent = newSummary;
        if (tagEl) tagEl.textContent = newTopic;
      }
    });

    // 2. Persist in localStorage (lesson meta + video links)
    const nowIso = new Date().toISOString();
    try {
      const customLessons = JSON.parse(localStorage.getItem('math10_custom_lessons') || '{}');
      const existing = customLessons[lid] || {};
      customLessons[lid] = {
        ...existing,
        title: newTitle,
        topic: newTopic,
        summary: newSummary,
        updatedAt: nowIso
      };
      localStorage.setItem('math10_custom_lessons', JSON.stringify(customLessons));
      if (window.saveLocalLessonVideoConfig) {
        if (!parsedPrimary && extraVideos.length === 0) {
          window.saveLocalLessonVideoConfig(lid, { resetToDefault: true });
        } else {
          window.saveLocalLessonVideoConfig(lid, {
            videoId: parsedPrimary ? parsedPrimary.videoId : null,
            videoUrl: parsedPrimary ? parsedPrimary.videoUrl : null,
            videoTitle: newVideoTitle,
            videoChannel: newVideoChannel,
            extraVideos: extraVideos,
            updatedAt: nowIso
          });
        }
      }
    } catch(err) {}

    // 3. Sync to backend API (DB + Server Video Store)
    try {
      const apiBase = window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1';
      await fetch(apiBase + '/lessons/' + lid + '/video', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', 'X-Auth-User': (currentUser && currentUser.username) || 'admin' },
        credentials: 'include',
        body: JSON.stringify({
          videoUrl: parsedPrimary ? parsedPrimary.videoUrl : null,
          videoId: parsedPrimary ? parsedPrimary.videoId : null,
          title: newVideoTitle,
          channel: newVideoChannel,
          extraVideos: extraVideos,
          resetToDefault: (!parsedPrimary && extraVideos.length === 0)
        })
      });
    } catch(err) {}

    btnSubmit.disabled = false;

    if (alertEl) {
      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.innerHTML = '<strong>Thành công!</strong> Đã lưu thay đổi bài học &amp; link video cho Bài ' + lid + '.';
      alertEl.classList.remove('d-none');
    }

    setTimeout(() => {
      window.closeEditLessonModal();
      if (alertEl) alertEl.classList.add('d-none');
    }, 700);
  };

  function applyCustomLessons() {
    try {
      const customLessons = JSON.parse(localStorage.getItem('math10_custom_lessons') || '{}');
      Object.keys(customLessons).forEach(lid => {
        const data = customLessons[lid];
        const card = document.querySelector('.lesson-item [data-lesson-id="' + lid + '"]')?.closest('.lesson-item');
        if (card && data) {
          if (data.title) {
            const h3 = card.querySelector('h3');
            if (h3) h3.textContent = data.title;
          }
          if (data.summary) {
            const p = card.querySelector('.lesson-body p');
            if (p) p.textContent = data.summary;
          }
          if (data.topic) {
            const tag = card.querySelector('.lesson-body .tag');
            if (tag) tag.textContent = data.topic;
          }
        }
      });
    } catch(e) {}
  }

  window.applyRoleMode = function(role) {
    currentRole = (role || 'STUDENT').toUpperCase();
    const isTeacherOrAdmin = (currentRole === 'TEACHER' || currentRole === 'ADMIN');
    const isAdmin = (currentRole === 'ADMIN');

    const progressCard = document.getElementById('student-progress-card');
    const teacherBanner = document.getElementById('teacher-admin-banner');
    const btnHeaderAssign = document.getElementById('btn-header-assign');
    const btnHeaderPractice = document.getElementById('btn-header-practice');
    const cards = document.querySelectorAll('#lessons-grid .lesson-item');

    if (isTeacherOrAdmin) {
      if (btnHeaderAssign) btnHeaderAssign.classList.remove('d-none');
      if (btnHeaderPractice) {
        btnHeaderPractice.classList.add('d-none');
        btnHeaderPractice.style.display = 'none';
      }
      if (teacherBanner) {
        teacherBanner.classList.remove('d-none');
        const badge = teacherBanner.querySelector('.badge');
        const desc = teacherBanner.querySelector('.text-secondary');
        if (isAdmin) {
          if (badge) {
            badge.className = 'badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1';
            badge.textContent = 'CHẾ ĐỘ QUẢN TRỊ VIÊN';
          }
          if (desc) {
            desc.textContent = 'Toàn quyền quản trị 27 bài giảng SGK Toán 10. Quản trị viên có thể xem chi tiết, chỉnh sửa nội dung bài học hoặc giao bài tập cho học sinh.';
          }
        } else {
          if (badge) {
            badge.className = 'badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1';
            badge.textContent = 'CHẾ ĐỘ GIẢNG DẠY';
          }
          if (desc) {
            desc.textContent = 'Toàn bộ 27 bài học theo chương trình SGK Toán 10 Kết nối tri thức. Giáo viên có thể xem nội dung bài giảng hoặc giao bài tập trực tiếp cho học sinh.';
          }
        }
      }
      if (progressCard) {
        progressCard.classList.add('d-none');
        progressCard.style.display = 'none';
      }

      const pageH1 = document.getElementById('lessons-main-heading');
      const pageP = document.getElementById('lessons-main-desc');
      if (pageH1) pageH1.textContent = isAdmin ? 'Quản lý bài giảng & nội dung SGK' : 'Danh sách bài giảng';
      if (pageP) pageP.textContent = isAdmin ? 'Hệ thống 27 bài giảng chuẩn theo SGK Toán 10. Quản trị viên có thể xem nội dung, chỉnh sửa tiêu đề & tóm tắt hoặc giao bài tập.' : 'Hệ thống 27 bài giảng chuẩn theo SGK Toán 10 Kết nối tri thức. Xem nội dung bài giảng chi tiết hoặc giao bài tập cho học sinh.';

      cards.forEach(card => {
        card.querySelectorAll('.lesson-done-badge, .lesson-status-badge, .lesson-toggle-btn, .lesson-check-wrap').forEach(el => el.remove());
        
        const footer = card.querySelector('.lesson-body .border-top');
        if (footer) {
          if (!footer.querySelector('span.small.text-muted')) {
            const sgk = document.createElement('span');
            sgk.className = 'small text-muted';
            sgk.innerHTML = 'Lớp 10 &bull; SGK';
            footer.insertBefore(sgk, footer.firstChild);
          }
        }

        const link = card.querySelector('[data-lesson-id]');
        if (link) {
          link.innerHTML = 'Xem bài giảng &rarr;';
          const lid = link.dataset.lessonId;
          const heading = card.querySelector('h3')?.textContent || ('Bài ' + lid);

          if (footer && !footer.querySelector('.btn-watch-video')) {
            const videoBtn = document.createElement('button');
            videoBtn.type = 'button';
            videoBtn.className = 'btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1 btn-watch-video me-1';
            videoBtn.title = 'Xem video bài giảng YouTube';
            videoBtn.innerHTML = '<svg width="13" height="13" fill="currentColor" viewBox="0 0 16 16"><path d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.01 2.01 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.01 2.01 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31 31 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.01 2.01 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A100 100 0 0 1 7.858 2zM6.4 5.209v5.582l4.8-2.79z"/></svg> Video';
            videoBtn.onclick = (e) => {
              e.preventDefault();
              e.stopPropagation();
              window.openLessonVideoModal(lid);
            };
            link.parentNode.insertBefore(videoBtn, link);
          }

          if (footer && !footer.querySelector('.lesson-card-assign-btn')) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-sm btn-outline-primary lesson-card-assign-btn ms-2 fw-semibold';
            btn.innerHTML = 'Giao bài tập';
            btn.title = 'Giao bài tập cho ' + heading;
            btn.onclick = (e) => {
              e.preventDefault();
              e.stopPropagation();
              openAssignForLesson(lid, heading);
            };
            footer.appendChild(btn);
          }

          // Admin Edit Button
          if (isAdmin && footer && !footer.querySelector('.lesson-card-edit-btn')) {
            const btnEdit = document.createElement('button');
            btnEdit.type = 'button';
            btnEdit.className = 'btn btn-sm btn-outline-warning text-dark lesson-card-edit-btn ms-1 fw-semibold';
            btnEdit.innerHTML = 'Sửa bài';
            btnEdit.title = 'Chỉnh sửa tiêu đề & nội dung ' + heading;
            btnEdit.onclick = (e) => {
              e.preventDefault();
              e.stopPropagation();
              window.openEditLessonModal(lid);
            };
            footer.appendChild(btnEdit);
          } else if (!isAdmin && footer) {
            footer.querySelectorAll('.lesson-card-edit-btn').forEach(b => b.remove());
          }
        }
      });

      window.applyCombinedFilter();
    } else {
      if (btnHeaderAssign) btnHeaderAssign.classList.add('d-none');
      if (btnHeaderPractice) {
        btnHeaderPractice.classList.remove('d-none');
        btnHeaderPractice.style.display = '';
      }
      if (teacherBanner) teacherBanner.classList.add('d-none');
      if (progressCard) {
        progressCard.classList.remove('d-none');
        progressCard.style.display = 'block';
      }

      const pageH1 = document.getElementById('lessons-main-heading');
      const pageP = document.getElementById('lessons-main-desc');
      if (pageH1) pageH1.textContent = 'Khám phá bài học';
      if (pageP) pageP.textContent = 'Chọn chủ đề và học theo nhịp độ của bạn. Đầy đủ 9 chuyên đề và 27 bài học bám sát SGK.';

      cards.forEach(card => {
        card.querySelectorAll('.lesson-card-assign-btn, .lesson-card-edit-btn').forEach(el => el.remove());
        const link = card.querySelector('[data-lesson-id]');
        if (link) link.innerHTML = 'Học bài &rarr;';
      });

      loadStudentCompleted();
      window.updateStudentUI();
    }
  };

  // Initialization when DOM is ready
  function initLessonsPage() {
    currentUser = getSessionUser();
    currentRole = getEffectiveRole();

    const roleSelect = document.getElementById('role-select');
    if (roleSelect && currentRole) {
      roleSelect.value = currentRole.toLowerCase();
    }

    const dlInput = document.getElementById('assign-deadline');
    if (dlInput && !dlInput.value) {
      const d = new Date();
      d.setDate(d.getDate() + 3);
      dlInput.value = d.toISOString().split('T')[0];
    }

    applyCustomLessons();
    loadStudentCompleted();
    if (window.syncServerLessonVideos) {
      const apiBase = window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1';
      window.syncServerLessonVideos(apiBase);
    }

    const editModalElInit = document.getElementById('adminEditLessonModal');
    if (editModalElInit) {
      if (editModalElInit.parentElement !== document.body) {
        document.body.appendChild(editModalElInit);
      }
      editModalElInit.addEventListener('click', (e) => {
        if (e.target === editModalElInit) {
          window.closeEditLessonModal();
        }
      });
      editModalElInit.addEventListener('hidden.bs.modal', () => {
        const previewIframe = document.getElementById('editVideoPreviewIframe');
        if (previewIframe) previewIframe.src = '';
      });
    }

    const assignModalElInit = document.getElementById('assignHomeworkModal');
    if (assignModalElInit && assignModalElInit.parentElement !== document.body) {
      document.body.appendChild(assignModalElInit);
    }

    const videoModalElInit = document.getElementById('lessonVideoModal');
    if (videoModalElInit) {
      if (videoModalElInit.parentElement !== document.body) {
        document.body.appendChild(videoModalElInit);
      }
      videoModalElInit.addEventListener('hidden.bs.modal', () => {
        window.closeLessonVideoModal();
      });
    }

    window.applyRoleMode(currentRole);

    // Topic filter buttons
    const filterButtons = document.querySelectorAll('.topic-filter');
    filterButtons.forEach(btn => {
      btn.onclick = () => {
        window.filterByChapter(btn.dataset.chapter || btn.dataset.topic || 'all', btn);
      };
    });

    // Status filter buttons
    const statusBtns = document.querySelectorAll('.status-filter-btn');
    statusBtns.forEach(btn => {
      btn.onclick = () => {
        window.filterByStatus(btn.dataset.status, btn);
      };
    });

    // Handle Assign Form Submit
    const assignForm = document.getElementById('assign-homework-form');
    if (assignForm) {
      assignForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const btnSubmit = document.getElementById('btn-submit-assignment');
        const spinner = document.getElementById('assign-spinner');
        const alertEl = document.getElementById('assign-alert');

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
        if (currentUser && currentUser.username) headers['X-Auth-User'] = currentUser.username;

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

        const newAssignment = {
          id: savedId,
          ...payload,
          createdAt: new Date().toISOString()
        };

        try {
          const list = JSON.parse(localStorage.getItem('math10_assignments') || '[]');
          list.unshift(newAssignment);
          localStorage.setItem('math10_assignments', JSON.stringify(list));
        } catch(e) {}

        btnSubmit.disabled = false;
        spinner.classList.add('d-none');

        alertEl.className = 'alert alert-success mt-3 py-2 small';
        alertEl.innerHTML = '<strong>Thành công!</strong> Đã giao bài tập <em>' + lessonText + '</em> cho học sinh. Hạn nộp: ' + deadline;
        alertEl.classList.remove('d-none');

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

    // Role change listeners
    window.addEventListener('math10RoleChanged', (e) => {
      if (e.detail && e.detail.role) {
        window.applyRoleMode(e.detail.role);
      }
    });

    if (roleSelect) {
      roleSelect.addEventListener('change', (e) => {
        window.applyRoleMode(e.target.value);
      });
    }
  }

  // Bind events
  document.addEventListener('DOMContentLoaded', initLessonsPage);
  window.addEventListener('pageshow', () => {
    loadStudentCompleted();
    if (currentRole === 'STUDENT') {
      window.updateStudentUI();
    }
  });
  window.addEventListener('storage', (e) => {
    if (e.key && e.key.includes('completed_lessons')) {
      loadStudentCompleted();
      if (currentRole === 'STUDENT') {
        window.updateStudentUI();
      }
    }
  });
</script>
<jsp:include page="/common/footer.jsp" />
