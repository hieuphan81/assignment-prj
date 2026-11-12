<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Quản lý học sinh — Giáo viên — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="teacher-students" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Quản lý học sinh" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow">GIÁO VIÊN &bull; QUẢN LÝ LỚP HỌC</div>
        <h1>Danh sách học sinh phụ trách</h1>
        <p>Theo dõi các học sinh được phân công vào lớp của bạn, tạo tài khoản học sinh nhanh và xem kết quả học tập chi tiết.</p>
      </div>
      <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary" onclick="loadClassStudents()">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1"><path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"/></svg> Làm mới
        </button>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createStudentModal">
          + Thêm học sinh vào lớp
        </button>
      </div>
    </div>

    <!-- Student List Card -->
    <div class="cardx card-pad">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="card-title mb-0">Học sinh trong lớp (<span id="student-count-badge">0</span>)</h2>
        <span class="small text-muted">Phân quyền: Hiển thị học sinh thuộc trách nhiệm phụ trách của bạn</span>
      </div>

      <div class="table-responsive">
        <table class="table align-middle">
          <thead>
            <tr>
              <th scope="col" style="width:70px;">ID</th>
              <th scope="col">Họ và tên</th>
              <th scope="col">Tên đăng nhập</th>
              <th scope="col">Email</th>
              <th scope="col">Trạng thái</th>
              <th scope="col" class="text-end" style="width:180px;">Thao tác</th>
            </tr>
          </thead>
          <tbody id="studentsTableBody">
            <tr>
              <td colspan="6" class="text-center py-5 text-muted">
                <div class="spinner-border text-primary spinner-border-sm me-2" role="status"></div>
                Đang tải danh sách học sinh...
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <!-- Modal Create Student -->
  <div class="modal fade" id="createStudentModal" tabindex="-1" aria-labelledby="createStudentModalLabel" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" id="createStudentModalLabel">Thêm tài khoản học sinh mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="teacher-create-student-form" onsubmit="handleTeacherCreateStudent(event)">
          <div class="modal-body">
            <div id="createStudentAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="modal-student-name">Họ và tên học sinh <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="modal-student-name" required placeholder="Nguyễn Văn B" maxlength="120">
            </div>
            <div class="mb-3">
              <label class="form-label fw-semibold" for="modal-student-user">Tên đăng nhập <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="modal-student-user" required placeholder="nguyenvanb10" maxlength="50">
            </div>
            <div class="mb-3">
              <label class="form-label fw-semibold" for="modal-student-email">Email <span class="text-danger">*</span></label>
              <input type="email" class="form-control" id="modal-student-email" required placeholder="b@math10.local" maxlength="254">
            </div>
            <div class="mb-3">
              <label class="form-label fw-semibold" for="modal-student-pass">Mật khẩu ban đầu <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="modal-student-pass" required placeholder="Tối thiểu 6 ký tự" minlength="6">
            </div>
            <div class="small text-muted bg-light p-2 rounded">Học sinh tạo tại đây sẽ được tự động gán vào danh sách lớp do bạn phụ trách.</div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
            <button type="submit" class="btn btn-primary" id="btn-submit-create-student">Tạo tài khoản</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Chi tiết bài làm của học sinh -->
  <div class="modal fade" id="studentAttemptsModal" tabindex="-1" aria-labelledby="attemptsModalLabel" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content shadow-lg border-0">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title fw-bold" id="attemptsModalLabel">
            Lịch sử bài làm học sinh: <span id="modal-attempt-student-name">...</span>
          </h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body p-4">
          <!-- Quick stats for this student -->
          <div class="row g-2 mb-3" id="modal-student-stats-row">
            <div class="col-sm-3">
              <div class="p-2 border rounded bg-light text-center">
                <div class="small text-muted">Tổng số lượt làm</div>
                <div class="h5 fw-bold mb-0 mt-1" id="m-stat-total">0</div>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="p-2 border rounded bg-light text-center">
                <div class="small text-muted">Số câu đạt yêu cầu</div>
                <div class="h5 fw-bold mb-0 mt-1 text-success" id="m-stat-correct">0</div>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="p-2 border rounded bg-light text-center">
                <div class="small text-muted">Tỷ lệ chính xác</div>
                <div class="h5 fw-bold mb-0 mt-1 text-primary" id="m-stat-acc">0%</div>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="p-2 border rounded bg-light text-center">
                <div class="small text-muted">Điểm trung bình</div>
                <div class="h5 fw-bold mb-0 mt-1 text-warning" id="m-stat-score">0.0</div>
              </div>
            </div>
          </div>

          <!-- Attempts Table -->
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="modal-attempts-table">
              <thead class="table-light">
                <tr>
                  <th style="width: 50px;">ID</th>
                  <th style="width: 150px;">Bài học</th>
                  <th>Câu hỏi & Phương án học sinh chọn</th>
                  <th style="width: 100px;">Loại bài</th>
                  <th style="width: 100px;" class="text-center">Kết quả</th>
                  <th style="width: 90px;" class="text-center">Điểm số</th>
                  <th style="width: 140px;">Thời gian nộp</th>
                </tr>
              </thead>
              <tbody id="modal-attempts-tbody">
                <tr>
                  <td colspan="7" class="text-center py-4 text-muted">
                    <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải dữ liệu bài làm...
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="modal-footer bg-light justify-content-between">
          <span class="small text-muted" id="modal-attempt-footer-note">Dữ liệu được chấm điểm tự động và nhận xét bởi AI.</span>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        </div>
      </div>
    </div>
  </div>

</div><!-- /.main-area -->

<jsp:include page="/common/footer.jsp" />

<script>
  function getApiBase() {
    return window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1';
  }

  function getAuthUser() {
    try {
      const raw = localStorage.getItem('math10_session_user');
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return { username: 'gv1', role: 'TEACHER' };
  }

  function getAuthHeaders(extra = {}) {
    const u = getAuthUser();
    return {
      'Content-Type': 'application/json',
      'X-Auth-User': u.username,
      ...extra
    };
  }

  function escapeHtml(s) {
    if (!s) return '';
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  }

  async function loadClassStudents() {
    const tbody = document.getElementById('studentsTableBody');
    tbody.innerHTML = `
      <tr>
        <td colspan="6" class="text-center py-5 text-muted">
          <div class="spinner-border text-primary spinner-border-sm me-2" role="status"></div>
          Đang tải danh sách học sinh...
        </td>
      </tr>
    `;

    const apiBase = getApiBase();
    let students = [];

    // Strategy 1: Fetch /users
    try {
      const res = await fetch(apiBase + '/users', {
        headers: getAuthHeaders(),
        credentials: 'include'
      });
      if (res.ok) {
        const list = await res.json();
        if (Array.isArray(list)) {
          students = list.filter(u => u.role === 'STUDENT');
        }
      }
    } catch(e) {}

    // Strategy 2: Fallback to /users/students
    if (students.length === 0) {
      try {
        const res2 = await fetch(apiBase + '/users/students', {
          headers: getAuthHeaders(),
          credentials: 'include'
        });
        if (res2.ok) {
          const list2 = await res2.json();
          if (Array.isArray(list2)) {
            students = list2.filter(u => u.role === 'STUDENT');
          }
        }
      } catch(e) {}
    }

    // Strategy 3: Fallback to /progress/mine
    if (students.length === 0) {
      try {
        const res3 = await fetch(apiBase + '/progress/mine', {
          headers: getAuthHeaders(),
          credentials: 'include'
        });
        if (res3.ok) {
          const prog = await res3.json();
          if (prog && Array.isArray(prog.students)) {
            students = prog.students.map(s => ({
              id: s.userId,
              fullName: s.fullName,
              username: 'hs_' + s.userId,
              email: '-',
              status: 'ACTIVE',
              role: 'STUDENT'
            }));
          }
        }
      } catch(e) {}
    }

    const badge = document.getElementById('student-count-badge');
    if (badge) badge.textContent = students.length;

    if (students.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="6" class="text-center py-5 text-muted">
            Chưa có học sinh nào trong danh sách phụ trách của bạn. Bấm <strong>+ Thêm học sinh vào lớp</strong> để tạo mới.
          </td>
        </tr>
      `;
      return;
    }

    tbody.innerHTML = students.map(s => `
      <tr>
        <td><span class="text-muted fw-bold">#\${s.id}</span></td>
        <td><strong class="text-dark">\${escapeHtml(s.fullName)}</strong></td>
        <td><code>\${escapeHtml(s.username)}</code></td>
        <td class="text-muted small">\${escapeHtml(s.email || '-')}</td>
        <td><span class="badge bg-success-subtle text-success border border-success-subtle">\${s.status || 'ACTIVE'}</span></td>
        <td class="text-end">
          <div class="d-flex justify-content-end gap-1">
            <button class="btn btn-sm btn-outline-primary btn-view-attempts fw-semibold" 
                    data-id="\${s.id}" 
                    data-name="\${escapeHtml(s.fullName)}"
                    data-user="\${escapeHtml(s.username)}">
              Xem bài làm
            </button>
            <a class="btn btn-sm btn-light border text-primary" 
               href="${pageContext.request.contextPath}/history?studentId=\${s.id}&name=\${encodeURIComponent(s.fullName)}" 
               title="Mở toàn màn hình">&nearr;</a>
          </div>
        </td>
      </tr>
    `).join('');

    // Bind click events to view attempts buttons
    document.querySelectorAll('.btn-view-attempts').forEach(btn => {
      btn.addEventListener('click', () => {
        const sid = btn.dataset.id;
        const sname = btn.dataset.name;
        const suser = btn.dataset.user;
        openStudentAttemptsModal(sid, sname, suser);
      });
    });
  }

  async function openStudentAttemptsModal(studentId, studentName, studentUser) {
    const modalEl = document.getElementById('studentAttemptsModal');
    if (!modalEl) return;

    if (modalEl.parentNode !== document.body) {
      document.body.appendChild(modalEl);
    }

    const titleEl = document.getElementById('modal-attempt-student-name');
    const tbody = document.getElementById('modal-attempts-tbody');
    const totalEl = document.getElementById('m-stat-total');
    const correctEl = document.getElementById('m-stat-correct');
    const accEl = document.getElementById('m-stat-acc');
    const scoreEl = document.getElementById('m-stat-score');

    if (titleEl) titleEl.textContent = studentName + ' (@' + studentUser + ')';
    if (tbody) tbody.innerHTML = `
      <tr>
        <td colspan="7" class="text-center py-4 text-muted">
          <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải dữ liệu bài làm...
        </td>
      </tr>
    `;

    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
    modal.show();

    try {
      const res = await fetch(getApiBase() + '/attempts/students/' + studentId, {
        headers: getAuthHeaders(),
        credentials: 'include'
      });

      if (!res.ok) throw new Error('Mã lỗi HTTP: ' + res.status);
      const list = await res.json();

      if (!Array.isArray(list) || list.length === 0) {
        if (totalEl) totalEl.textContent = '0';
        if (correctEl) correctEl.textContent = '0';
        if (accEl) accEl.textContent = '0%';
        if (scoreEl) scoreEl.textContent = '0.0';

        tbody.innerHTML = `
          <tr>
            <td colspan="7" class="text-center py-5 text-muted">
              <p class="mb-2">Học sinh <strong>\${escapeHtml(studentName)}</strong> chưa nộp bất kỳ bài làm nào trên hệ thống.</p>
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lessons">Giao bài tập cho học sinh</a>
            </td>
          </tr>
        `;
        return;
      }

      // Calculate stats
      const total = list.length;
      const correctCount = list.filter(a => a.correct === true || (a.score !== null && a.score !== undefined && a.score !== '' && Number(a.score) >= 5)).length;
      const acc = total > 0 ? (100.0 * correctCount / total).toFixed(1) : '0';

      let scoreSum = 0;
      let scoredCount = 0;
      list.forEach(a => {
        let sc = null;
        if (a.score !== null && a.score !== undefined && a.score !== '' && !isNaN(Number(a.score))) {
          sc = Number(a.score);
        } else if (a.correct === true) {
          sc = 10.0;
        } else if (a.correct === false) {
          sc = 0.0;
        }

        if (sc !== null) {
          scoreSum += sc;
          scoredCount++;
        }
      });
      const avgScore = scoredCount > 0 ? (scoreSum / scoredCount).toFixed(1) : (total > 0 ? '0.0' : '-');

      if (totalEl) totalEl.textContent = total;
      if (correctEl) correctEl.textContent = correctCount;
      if (accEl) accEl.textContent = acc + '%';
      if (scoreEl) scoreEl.textContent = avgScore;

      tbody.innerHTML = list.map((a, idx) => {
        const isMcq = (a.questionType === 'MCQ');
        const typeBadge = isMcq 
          ? '<span class="badge bg-primary">Trắc nghiệm</span>' 
          : '<span class="badge bg-info text-dark">Tự luận</span>';

        let resultBadge = '';
        if (a.correct === true) {
          resultBadge = '<span class="badge bg-success">Đúng</span>';
        } else if (a.correct === false) {
          resultBadge = '<span class="badge bg-danger">Sai</span>';
        } else {
          resultBadge = '<span class="badge bg-secondary">AI chấm</span>';
        }

        const scoreStr = (a.score !== null && a.score !== undefined) ? Number(a.score).toFixed(1) : '-';

        let dateStr = '-';
        if (a.submittedAt) {
          try {
            const d = new Date(a.submittedAt);
            dateStr = d.toLocaleDateString('vi-VN') + ' ' + d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
          } catch(e) {}
        }

        const qText = a.questionText ? escapeHtml(a.questionText) : 'Câu hỏi #' + a.questionId;
        const ansText = isMcq ? ('Chọn phương án: <strong>' + escapeHtml(a.answerText || '-') + '</strong>') : escapeHtml(a.answerText || 'Bài tự luận đã nộp');
        const feedbackText = a.feedback ? escapeHtml(a.feedback) : '';

        return `
          <tr>
            <td class="text-muted fw-bold">#\${a.id}</td>
            <td class="small fw-semibold text-primary">\${escapeHtml(a.lessonTitle || 'Bài học')}</td>
            <td>
              <div class="fw-semibold text-dark mb-1 small">\${qText}</div>
              <div class="p-2 bg-light rounded small mb-1 border-start border-3 border-primary">
                <strong>Học sinh làm:</strong> \${ansText}
              </div>
              \${feedbackText ? `
                <div class="small text-muted p-2 bg-light rounded mt-1 border-start border-3 border-success">
                  <strong>Nhận xét AI:</strong> \${feedbackText}
                </div>
              ` : ''}
            </td>
            <td>\${typeBadge}</td>
            <td class="text-center">\${resultBadge}</td>
            <td class="text-center fw-bold text-dark fs-6">\${scoreStr}</td>
            <td class="small text-muted">\${dateStr}</td>
          </tr>
        `;
      }).join('');

      if (window.MathJax && window.MathJax.typesetPromise) window.MathJax.typesetPromise();

    } catch(err) {
      tbody.innerHTML = `
        <tr>
          <td colspan="7" class="text-center py-4 text-danger">
            Không thể tải dữ liệu bài làm: \${escapeHtml(err.message)}
          </td>
        </tr>
      `;
    }
  }

  async function handleTeacherCreateStudent(e) {
    e.preventDefault();
    const alertEl = document.getElementById('createStudentAlert');
    const btn = document.getElementById('btn-submit-create-student');
    alertEl.className = 'alert d-none';
    btn.disabled = true;

    const fullName = document.getElementById('modal-student-name').value.trim();
    const username = document.getElementById('modal-student-user').value.trim();
    const email = document.getElementById('modal-student-email').value.trim();
    const password = document.getElementById('modal-student-pass').value;

    try {
      const res = await fetch(getApiBase() + '/users/students', {
        method: 'POST',
        headers: getAuthHeaders(),
        credentials: 'include',
        body: JSON.stringify({ fullName, username, email, password })
      });

      if (!res.ok) {
        let msg = 'Lỗi tạo học sinh (' + res.status + ')';
        try {
          const body = await res.json();
          if (body.message) msg = body.message;
        } catch (_) {}
        throw new Error(msg);
      }

      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.textContent = 'Đã thêm học sinh thành công!';
      setTimeout(() => {
        const modalEl = document.getElementById('createStudentModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        document.getElementById('teacher-create-student-form').reset();
        alertEl.classList.add('d-none');
        loadClassStudents();
      }, 700);
    } catch (err) {
      alertEl.className = 'alert alert-danger py-2 px-3 small';
      alertEl.textContent = err.message;
    } finally {
      btn.disabled = false;
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    // Reparent modals to body
    const createMod = document.getElementById('createStudentModal');
    if (createMod && createMod.parentNode !== document.body) document.body.appendChild(createMod);
    const attMod = document.getElementById('studentAttemptsModal');
    if (attMod && attMod.parentNode !== document.body) document.body.appendChild(attMod);

    loadClassStudents();
  });
</script>
