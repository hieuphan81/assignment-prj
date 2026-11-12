<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Lịch sử bài làm — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="history" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Lịch sử bài làm" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow" id="history-eyebrow">THEO DÕI HỌC TẬP &bull; BÀI LÀM CỦA BẠN</div>
        <h1 id="history-title">Lịch sử bài làm</h1>
        <p id="history-desc">Danh sách các lần nộp bài trắc nghiệm và tự luận kèm điểm số, nhận xét của AI và thời gian hoàn thành.</p>
      </div>
      <div id="history-top-actions">
        <a class="btn btn-primary" id="btn-top-action" href="${pageContext.request.contextPath}/practice">Luyện tập thêm &rarr;</a>
      </div>
    </div>

    <!-- Teacher Selector Bar (Hiển thị khi là Giáo viên) -->
    <div class="cardx card-pad p-3 mb-3 d-none bg-light border" id="teacher-selector-box">
      <div class="row g-2 align-items-center">
        <div class="col-md-6 col-lg-5">
          <div class="input-group input-group-sm">
            <span class="input-group-text bg-white fw-semibold text-secondary">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              Học sinh:
            </span>
            <select class="form-select form-select-sm fw-semibold" id="teacher-student-select">
              <option value="">Đang tải danh sách học sinh...</option>
            </select>
          </div>
        </div>
        <div class="col-md-6 col-lg-7 text-md-end">
          <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/teacher/students">&larr; Quản lý học sinh phụ trách</a>
        </div>
      </div>
    </div>

    <div class="cardx card-pad">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="card-title h5 mb-0" id="history-card-title">Tất cả lượt làm bài</h2>
        <span class="small text-muted" id="history-total-count">Đang tải dữ liệu...</span>
      </div>

      <div class="table-responsive">
        <table class="table align-middle" id="history-table">
          <thead class="table-light">
            <tr>
              <th scope="col" style="width: 60px;">ID</th>
              <th scope="col" style="width: 170px;">Bài học</th>
              <th scope="col">Câu hỏi & Phương án đã làm</th>
              <th scope="col" style="width: 100px;">Loại bài</th>
              <th scope="col" style="width: 100px;" class="text-center">Kết quả</th>
              <th scope="col" style="width: 90px;" class="text-center">Điểm số</th>
              <th scope="col" style="width: 150px;">Thời gian nộp</th>
            </tr>
          </thead>
          <tbody id="history-table-body">
            <tr>
              <td colspan="7" class="text-center py-4 text-muted">
                <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải dữ liệu bài làm...
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <script>
    function escapeHtml(text) {
      if (!text) return '';
      return String(text)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }

    async function loadHistoryData() {
      const tbody = document.getElementById('history-table-body');
      const counter = document.getElementById('history-total-count');
      const eyebrow = document.getElementById('history-eyebrow');
      const title = document.getElementById('history-title');
      const desc = document.getElementById('history-desc');
      const topActions = document.getElementById('history-top-actions');
      const teacherBox = document.getElementById('teacher-selector-box');
      const teacherStudentSelect = document.getElementById('teacher-student-select');

      let sessionUser = null;
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) sessionUser = JSON.parse(raw);
      } catch (e) {}

      if (!sessionUser) {
        if (counter) counter.textContent = 'Chưa đăng nhập';
        tbody.innerHTML = `
          <tr>
            <td colspan="7" class="text-center py-5 text-muted">
              <div class="mb-2">Bạn chưa đăng nhập. Vui lòng đăng nhập để xem lịch sử bài làm.</div>
              <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/login">Đăng nhập tài khoản</a>
            </td>
          </tr>
        `;
        return;
      }

      const role = (sessionUser.role || 'STUDENT').toUpperCase();
      const isTeacherOrAdmin = (role === 'TEACHER' || role === 'ADMIN');
      const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');

      const urlParams = new URLSearchParams(window.location.search);
      let targetStudentId = urlParams.get('studentId');
      let targetStudentName = urlParams.get('name');

      if (isTeacherOrAdmin) {
        // Teacher Mode
        if (teacherBox) teacherBox.classList.remove('d-none');
        if (topActions) {
          topActions.innerHTML = `<a class="btn btn-primary" href="${pageContext.request.contextPath}/lessons">Giao bài tập &rarr;</a>`;
        }
        if (eyebrow) eyebrow.textContent = 'GIÁO VIÊN • THEO DÕI HỌC SINH';

        // Load teacher's student list to populate dropdown
        let studentList = [];
        try {
          const sRes = await fetch(apiBase + '/users/students', {
            headers: {
              'Content-Type': 'application/json',
              'X-Auth-User': sessionUser.username
            },
            credentials: 'include'
          });
          if (sRes.ok) {
            const rawList = await sRes.json();
            studentList = Array.isArray(rawList) ? rawList.filter(u => u.role === 'STUDENT') : [];
          }
        } catch(e) {}

        if (teacherStudentSelect) {
          if (studentList.length === 0) {
            teacherStudentSelect.innerHTML = '<option value="">Chưa có học sinh nào trong lớp</option>';
          } else {
            teacherStudentSelect.innerHTML = studentList.map(st => `
              <option value="\${st.id}" \${String(st.id) === String(targetStudentId) ? 'selected' : ''}>
                \${st.fullName} (@\${st.username}) - ID: #\${st.id}
              </option>
            `).join('');

            // If no student specified in URL, pick the first student
            if (!targetStudentId && studentList.length > 0) {
              targetStudentId = String(studentList[0].id);
              targetStudentName = studentList[0].fullName;
              teacherStudentSelect.value = targetStudentId;
            }

            teacherStudentSelect.addEventListener('change', (e) => {
              const selectedId = e.target.value;
              const selectedSt = studentList.find(s => String(s.id) === String(selectedId));
              const sName = selectedSt ? selectedSt.fullName : '';
              window.location.href = '${pageContext.request.contextPath}/history?studentId=' + selectedId + '&name=' + encodeURIComponent(sName);
            });
          }
        }

        if (!targetStudentId) {
          if (counter) counter.textContent = 'Chưa chọn học sinh';
          tbody.innerHTML = `
            <tr>
              <td colspan="7" class="text-center py-5 text-muted">
                <p class="mb-2">Chưa có học sinh nào được phân công vào lớp của bạn.</p>
                <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/teacher/students">Thêm học sinh vào lớp &rarr;</a>
              </td>
            </tr>
          `;
          return;
        }

        if (title) title.textContent = 'Lịch sử bài làm: ' + (targetStudentName || ('Học sinh #' + targetStudentId));
        if (desc) desc.textContent = 'Theo dõi chi tiết các lần nộp bài trắc nghiệm, tự luận, điểm số và nhận xét của AI của học sinh này.';

        // Fetch attempts for specific student
        try {
          const res = await fetch(apiBase + '/attempts/students/' + targetStudentId, {
            headers: {
              'Content-Type': 'application/json',
              'X-Auth-User': sessionUser.username
            },
            credentials: 'include'
          });

          if (!res.ok) throw new Error('Mã lỗi ' + res.status);
          const list = await res.json();
          renderAttemptsTable(list, true);

        } catch(err) {
          if (counter) counter.textContent = 'Lỗi tải';
          tbody.innerHTML = `<tr><td colspan="7" class="text-center py-5 text-danger">Không thể tải bài làm của học sinh (\${escapeHtml(err.message)}).</td></tr>`;
        }

      } else {
        // Student Mode: Load personal attempts
        if (teacherBox) teacherBox.classList.add('d-none');
        try {
          const res = await fetch(apiBase + '/attempts/mine', {
            headers: {
              'Content-Type': 'application/json',
              'X-Auth-User': sessionUser.username
            },
            credentials: 'include'
          });

          if (!res.ok) throw new Error('Mã lỗi ' + res.status);
          const list = await res.json();
          renderAttemptsTable(list, false);

        } catch(err) {
          if (counter) counter.textContent = 'Lỗi tải';
          tbody.innerHTML = `<tr><td colspan="7" class="text-center py-5 text-danger">Không thể tải lịch sử bài làm (\${escapeHtml(err.message)}).</td></tr>`;
        }
      }

      function renderAttemptsTable(list, isViewingStudent) {
        if (!Array.isArray(list) || list.length === 0) {
          if (counter) counter.textContent = '0 lượt làm bài';
          tbody.innerHTML = `
            <tr>
              <td colspan="7" class="text-center py-5 text-muted">
                <p class="mb-2">\${isViewingStudent ? 'Học sinh này chưa nộp lượt làm bài nào.' : 'Bạn chưa có lượt làm bài nào được lưu.'}</p>
                <a class="btn btn-primary btn-sm" href="\${isViewingStudent ? '${pageContext.request.contextPath}/lessons' : '${pageContext.request.contextPath}/practice'}">
                  \${isViewingStudent ? 'Giao bài tập cho học sinh &rarr;' : 'Bắt đầu luyện tập ngay &rarr;'}
                </a>
              </td>
            </tr>
          `;
          return;
        }

        if (counter) counter.textContent = list.length + ' lượt làm bài';

        tbody.innerHTML = list.map(a => {
          const isMcq = (a.questionType === 'MCQ');
          const typeBadge = isMcq 
            ? '<span class="badge bg-primary">Trắc nghiệm</span>' 
            : '<span class="badge bg-info text-dark">Tự luận</span>';

          let resultBadge = '';
          if (a.correct === true) {
            resultBadge = '<span class="badge bg-success">Chính xác</span>';
          } else if (a.correct === false) {
            resultBadge = '<span class="badge bg-danger">Chưa đúng</span>';
          } else {
            resultBadge = '<span class="badge bg-secondary">AI đã chấm</span>';
          }

          const scoreVal = (a.score !== null && a.score !== undefined) ? Number(a.score).toFixed(1) : '-';

          let dateStr = '-';
          if (a.submittedAt) {
            try {
              const d = new Date(a.submittedAt);
              dateStr = d.toLocaleDateString('vi-VN') + ' ' + d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
            } catch(e) {}
          }

          const qText = a.questionText ? escapeHtml(a.questionText) : ('Câu hỏi #' + a.questionId);
          const ansText = isMcq ? ('Phương án: <strong>' + escapeHtml(a.answerText || '-') + '</strong>') : escapeHtml(a.answerText || 'Bài tự luận đã nộp');
          const feedback = a.feedback ? escapeHtml(a.feedback) : '';

          return `
            <tr>
              <td class="text-muted fw-bold">#\${a.id}</td>
              <td class="small fw-semibold text-primary">\${escapeHtml(a.lessonTitle || 'Bài học')}</td>
              <td>
                <div class="fw-semibold text-dark mb-1 small">\${qText}</div>
                <div class="p-2 bg-light rounded small border-start border-3 border-primary mb-1">
                  <strong>\${isViewingStudent ? 'Học sinh làm' : 'Bạn đã chọn'}:</strong> \${ansText}
                </div>
                \${feedback ? `
                  <div class="p-2 bg-light rounded small border-start border-3 border-success text-secondary">
                    <strong>Nhận xét AI:</strong> \${feedback}
                  </div>
                ` : ''}
              </td>
              <td>\${typeBadge}</td>
              <td class="text-center">\${resultBadge}</td>
              <td class="text-center fw-bold text-dark fs-6">\${scoreVal}</td>
              <td class="small text-muted">\${dateStr}</td>
            </tr>
          `;
        }).join('');

        if (window.MathJax && window.MathJax.typesetPromise) window.MathJax.typesetPromise();
      }
    }

    document.addEventListener('DOMContentLoaded', loadHistoryData);
  </script>

<jsp:include page="/common/footer.jsp" />
