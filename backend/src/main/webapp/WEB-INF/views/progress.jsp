<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Tiến độ học tập — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="progress" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Tiến độ học tập" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow" id="progress-eyebrow">PHÂN TÍCH HỌC TẬP &bull; BÁO CÁO TIẾN ĐỘ</div>
        <h1 id="progress-title">Tiến độ học tập cá nhân</h1>
        <p id="progress-desc">Thống kê chi tiết tỷ lệ hoàn thành theo từng chuyên đề Toán 10, độ chính xác làm bài và thời lượng luyện tập trong tuần.</p>
      </div>
      <div id="progress-actions">
        <a class="btn btn-primary" id="btn-progress-action" href="${pageContext.request.contextPath}/lessons">Tiếp tục học bài &rarr;</a>
      </div>
    </div>

    <!-- 4 Stats Cards -->
    <div class="row g-3 mb-4">
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label" id="card-label-1">Tổng lượt làm bài</div>
          <div class="metric-value" id="metric-attempts">...</div>
          <div class="metric-note" id="card-note-1">Trắc nghiệm + Tự luận</div>
          <div class="metric-icon" id="card-icon-1">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label" id="card-label-2">Số câu đạt yêu cầu</div>
          <div class="metric-value" id="metric-correct" style="color: #19815d;">...</div>
          <div class="metric-note" id="card-note-2">Trả lời đúng hoặc AI chấm &ge; 5</div>
          <div class="metric-icon green"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m9 12 2 2 4-4"/></svg></div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label" id="card-label-3">Tỷ lệ chính xác</div>
          <div class="metric-value" id="metric-accuracy">...</div>
          <div class="metric-note" id="card-note-3">Tính trên các bài trắc nghiệm</div>
          <div class="metric-icon purple"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label" id="card-label-4">Điểm trung bình</div>
          <div class="metric-value" id="metric-avg-score">...</div>
          <div class="metric-note" id="card-note-4">Thang điểm 10</div>
          <div class="metric-icon orange"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg></div>
        </div>
      </div>
    </div>

    <!-- Student View: Weekly Chart & Topic Breakdown -->
    <div class="row g-4" id="student-progress-section">
      <div class="col-lg-7">
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-3">
            <div>
              <h2 class="card-title h5 mb-1 fw-bold text-dark" id="student-chart-title">Hoạt động luyện tập 7 ngày gần nhất</h2>
              <div class="small text-muted" id="student-chart-subtitle">Thống kê số câu làm bài và số câu đạt yêu cầu theo từng ngày thực tế.</div>
            </div>
            <div class="chart-legend">
              <span><span class="legend-dot" style="background:#16a34a;"></span>Đạt yêu cầu</span>
              <span><span class="legend-dot alt" style="background:#93c5fd;"></span>Tổng câu làm</span>
            </div>
          </div>
          <!-- Pure CSS Bar Chart (rendered dynamically via JS) -->
          <div class="chart-area mb-4" id="weekly-chart-area">
            <div class="w-100 text-center py-4 text-muted">
              <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải dữ liệu hoạt động...
            </div>
          </div>
          <!-- Weekly Summary Highlights -->
          <div class="row g-2 pt-2 border-top text-center" id="weekly-chart-stats">
            <div class="col-4">
              <div class="small text-muted">Làm trong 7 ngày</div>
              <div class="fw-bold fs-6 text-dark" id="week-stat-total">0 câu</div>
            </div>
            <div class="col-4">
              <div class="small text-muted">Số câu đạt</div>
              <div class="fw-bold fs-6 text-success" id="week-stat-correct">0 câu</div>
            </div>
            <div class="col-4">
              <div class="small text-muted">Tỷ lệ đúng tuần</div>
              <div class="fw-bold fs-6 text-primary" id="week-stat-accuracy">0%</div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-5">
        <div class="cardx card-pad">
          <div class="section-head">
            <h2 class="card-title">Tiến độ theo chuyên đề</h2>
          </div>
          <div class="space-y-3" id="topic-progress-list">
            <div class="text-center py-4 text-muted">
              <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải tiến độ chuyên đề...
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Teacher View: Classroom & Student Progress Table -->
    <div class="d-none" id="teacher-progress-section">
      <div class="cardx card-pad mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2 mb-3">
          <div>
            <h2 class="card-title h5 mb-1 fw-bold text-dark">Báo cáo tiến độ học sinh phụ trách</h2>
            <p class="text-muted small mb-0">Thống kê chi tiết lượt làm bài, tỷ lệ chính xác và điểm trung bình của từng học sinh.</p>
          </div>
          <div class="d-flex align-items-center gap-2">
            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 fw-semibold" id="teacher-student-badge">0 học sinh</span>
            <button class="btn btn-sm btn-outline-secondary" onclick="loadProgressData()" title="Làm mới dữ liệu">Làm mới</button>
          </div>
        </div>

        <div class="table-responsive">
          <table class="table align-middle table-hover mb-0">
            <thead class="table-light text-muted small">
              <tr>
                <th style="width: 50px;">STT</th>
                <th>Học sinh</th>
                <th class="text-center" style="width: 140px;">Lượt làm bài</th>
                <th class="text-center" style="width: 130px;">Số câu đạt</th>
                <th style="width: 240px;">Tỷ lệ chính xác</th>
                <th class="text-center" style="width: 120px;">Điểm TB</th>
                <th class="text-center" style="width: 150px;">Tình trạng</th>
                <th class="text-end" style="width: 130px;">Hành động</th>
              </tr>
            </thead>
            <tbody id="student-progress-tbody">
              <tr>
                <td colspan="8" class="text-center py-4 text-muted">
                  <span class="spinner-border spinner-border-sm me-2" role="status"></span>Đang tải danh sách học sinh...
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </main>

  <script>
    async function loadProgressData() {
      let sessionUser = null;
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) sessionUser = JSON.parse(raw);
      } catch (e) {}

      const elEyebrow = document.getElementById('progress-eyebrow');
      const elTitle = document.getElementById('progress-title');
      const elDesc = document.getElementById('progress-desc');
      const elActions = document.getElementById('progress-actions');

      const elAttempts = document.getElementById('metric-attempts');
      const elCorrect = document.getElementById('metric-correct');
      const elAccuracy = document.getElementById('metric-accuracy');
      const elAvgScore = document.getElementById('metric-avg-score');

      const elCardLabel1 = document.getElementById('card-label-1');
      const elCardNote1 = document.getElementById('card-note-1');
      const elCardLabel2 = document.getElementById('card-label-2');
      const elCardNote2 = document.getElementById('card-note-2');
      const elCardLabel3 = document.getElementById('card-label-3');
      const elCardNote3 = document.getElementById('card-note-3');
      const elCardLabel4 = document.getElementById('card-label-4');
      const elCardNote4 = document.getElementById('card-note-4');

      const studentSec = document.getElementById('student-progress-section');
      const teacherSec = document.getElementById('teacher-progress-section');
      const elTopics = document.getElementById('topic-progress-list');
      const elStudentTbody = document.getElementById('student-progress-tbody');
      const elStudentBadge = document.getElementById('teacher-student-badge');

      if (!sessionUser) {
        if (elAttempts) elAttempts.textContent = '-';
        if (elCorrect) elCorrect.textContent = '-';
        if (elAccuracy) elAccuracy.textContent = '-';
        if (elAvgScore) elAvgScore.textContent = '-';
        if (elTopics) elTopics.innerHTML = `
          <div class="text-center py-4 text-muted">
            <p class="mb-2">Vui lòng đăng nhập để xem tiến độ học tập.</p>
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
          </div>
        `;
        return;
      }

      const role = (sessionUser.role || 'STUDENT').toUpperCase();
      const isTeacher = (role === 'TEACHER');
      const isAdmin = (role === 'ADMIN');

      if (isTeacher || isAdmin) {
        // Teacher / Admin UI Mode
        if (elEyebrow) elEyebrow.textContent = isTeacher ? 'QUẢN LÝ GIẢNG DẠY • BÁO CÁO TIẾN ĐỘ' : 'QUẢN TRỊ HỆ THỐNG • TIẾN ĐỘ TOÀN DIỆN';
        if (elTitle) elTitle.textContent = isTeacher ? 'Báo cáo tiến độ học sinh & Lớp học' : 'Báo cáo tiến độ toàn hệ thống';
        if (elDesc) elDesc.textContent = isTeacher 
          ? 'Theo dõi mức độ hoàn thành bài tập, tỷ lệ chính xác và kết quả học tập của các học sinh thuộc lớp phụ trách.'
          : 'Thống kê tổng quan tình hình học tập và làm bài của toàn bộ học sinh trên hệ thống Toán 10 AI.';
        
        if (elActions) {
          elActions.innerHTML = `
            <div class="d-flex gap-2">
              <a class="btn btn-primary" href="${pageContext.request.contextPath}/lessons">Giao bài tập mới &rarr;</a>
              <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/teacher/questions">Ngân hàng câu hỏi</a>
            </div>
          `;
        }

        if (studentSec) studentSec.classList.add('d-none');
        if (teacherSec) teacherSec.classList.remove('d-none');

        if (elCardLabel1) elCardLabel1.textContent = isTeacher ? 'Tổng lượt làm bài của HS' : 'Tổng lượt làm toàn hệ thống';
        if (elCardNote1) elCardNote1.textContent = 'Trắc nghiệm + Tự luận';

        if (elCardLabel2) elCardLabel2.textContent = 'Số câu đạt yêu cầu';
        if (elCardNote2) elCardNote2.textContent = 'HS trả lời đúng / AI chấm ≥ 5';

        if (elCardLabel3) elCardLabel3.textContent = 'Tỷ lệ chính xác lớp';
        if (elCardNote3) elCardNote3.textContent = 'Trung bình toàn bộ học sinh';

        if (elCardLabel4) elCardLabel4.textContent = 'Điểm trung bình lớp';
        if (elCardNote4) elCardNote4.textContent = 'Thang điểm 10';
      } else {
        // Student UI Mode
        if (studentSec) studentSec.classList.remove('d-none');
        if (teacherSec) teacherSec.classList.add('d-none');
      }

      try {
        const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
        const res = await fetch(apiBase + '/progress/mine', {
          headers: {
            'Content-Type': 'application/json',
            'X-Auth-User': sessionUser.username
          },
          credentials: 'include'
        });

        if (!res.ok) throw new Error('HTTP ' + res.status);
        const data = await res.json();
        const summary = data.summary || {};

        if (elAttempts) elAttempts.textContent = summary.attempts || 0;
        if (elCorrect) elCorrect.textContent = summary.correct || 0;
        if (elAccuracy) elAccuracy.textContent = ((summary.accuracy || 0).toFixed(1)) + '%';
        if (elAvgScore) elAvgScore.textContent = (summary.averageScore || 0).toFixed(1);

        if (isTeacher || isAdmin) {
          const students = data.students || [];
          if (elStudentBadge) elStudentBadge.textContent = students.length + ' học sinh phụ trách';

          if (elStudentTbody) {
            if (students.length === 0) {
              elStudentTbody.innerHTML = `
                <tr>
                  <td colspan="8" class="text-center py-4 text-muted">
                    <p class="mb-2">Chưa có học sinh nào được phân công hoặc chưa có dữ liệu làm bài.</p>
                    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/lessons">Giao bài tập cho học sinh</a>
                  </td>
                </tr>
              `;
            } else {
              elStudentTbody.innerHTML = students.map((st, idx) => {
                const acc = Math.min(100, Math.max(0, st.accuracy || 0));
                const avg = st.averageScore || 0;
                let statusBadge = '<span class="badge bg-secondary-subtle text-secondary">Chưa làm bài</span>';
                if (st.attempts > 0) {
                  if (avg >= 8.0) {
                    statusBadge = '<span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold">Xuất sắc</span>';
                  } else if (avg >= 6.5) {
                    statusBadge = '<span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-semibold">Khá tốt</span>';
                  } else if (avg >= 5.0) {
                    statusBadge = '<span class="badge bg-warning-subtle text-warning border border-warning-subtle fw-semibold">Đạt chuẩn</span>';
                  } else {
                    statusBadge = '<span class="badge bg-danger-subtle text-danger border border-danger-subtle fw-semibold">Cần cố gắng</span>';
                  }
                }

                return `
                  <tr>
                    <td class="text-muted fw-bold">\${idx + 1}</td>
                    <td>
                      <div class="d-flex align-items-center gap-2">
                        <div class="avatar-sm rounded-circle bg-primary-subtle text-primary fw-bold d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 13px;">
                          \${(st.fullName || 'HS').charAt(0).toUpperCase()}
                        </div>
                        <div>
                          <div class="fw-semibold text-dark">\${st.fullName || 'Học sinh'}</div>
                          <div class="small text-muted">ID: #\${st.userId || ''}</div>
                        </div>
                      </div>
                    </td>
                    <td class="text-center fw-semibold">\${st.attempts}</td>
                    <td class="text-center text-success fw-semibold">\${st.correct}</td>
                    <td>
                      <div class="d-flex justify-content-between small fw-semibold mb-1">
                        <span>\${acc.toFixed(1)}%</span>
                        <span class="text-muted">\${st.correct}/\${st.attempts}</span>
                      </div>
                      <div class="progress" style="height: 6px;">
                        <div class="progress-bar \${acc >= 50 ? 'bg-success' : 'bg-warning'}" style="width: \${acc}%;"></div>
                      </div>
                    </td>
                    <td class="text-center">
                      <span class="fw-bold \${avg >= 6.5 ? 'text-primary' : (avg >= 5 ? 'text-dark' : 'text-danger')}">\${avg.toFixed(1)}</span>
                    </td>
                    <td class="text-center">\${statusBadge}</td>
                    <td class="text-end">
                      <a class="btn btn-sm btn-outline-primary py-0 px-2" href="${pageContext.request.contextPath}/lessons" title="Giao bài tập riêng">Giao bài</a>
                    </td>
                  </tr>
                `;
              }).join('');
            }
          }
        } else {
          // Student Topics View
          const topics = data.topics || [];
          if (elTopics) {
            if (topics.length === 0) {
              elTopics.innerHTML = '<div class="text-muted small">Chưa có dữ liệu tiến độ theo chuyên đề.</div>';
            } else {
              const colors = ['#2563eb', '#16a34a', '#d97706', '#9333ea', '#dc2626', '#0891b2', '#4f46e5', '#ca8a04', '#059669'];
              elTopics.innerHTML = topics.map((t, i) => {
                const acc = Math.min(100, Math.max(0, t.accuracy || 0));
                const color = colors[i % colors.length];
                return `
                  <div class="mb-3">
                    <div class="d-flex justify-content-between small fw-bold mb-1">
                      <span class="text-truncate me-2" title="\${t.topicName}">\${t.topicName}</span>
                      <span class="text-nowrap text-secondary">\${t.correct}/\${t.attempts} đúng (\${acc.toFixed(0)}%)</span>
                    </div>
                    <div class="progress" style="height: 6px;">
                      <div class="progress-bar" style="width: \${acc}%; background: \${color};"></div>
                    </div>
                  </div>
                `;
              }).join('');
            }
          }

          // Fetch recent attempts to render real weekly activity chart
          try {
            const attRes = await fetch(apiBase + '/attempts/mine', {
              headers: {
                'Content-Type': 'application/json',
                'X-Auth-User': sessionUser.username
              },
              credentials: 'include'
            });
            if (attRes.ok) {
              const attemptsList = await attRes.json();
              renderWeeklyActivityChart(attemptsList);
            } else {
              renderWeeklyActivityChart([]);
            }
          } catch(e) {
            renderWeeklyActivityChart([]);
          }
        }

      } catch (err) {
        if (elTopics) elTopics.innerHTML = '<div class="text-danger small py-3">Không thể tải dữ liệu tiến độ (' + err.message + ').</div>';
        if (elStudentTbody) elStudentTbody.innerHTML = '<tr><td colspan="8" class="text-danger text-center py-3">Không thể tải dữ liệu tiến độ (' + err.message + ').</td></tr>';
      }
    }

    function renderWeeklyActivityChart(attemptsList) {
      const chartArea = document.getElementById('weekly-chart-area');
      const statTotal = document.getElementById('week-stat-total');
      const statCorrect = document.getElementById('week-stat-correct');
      const statAcc = document.getElementById('week-stat-accuracy');
      if (!chartArea) return;

      // Build 7 days array ending today
      const days = [];
      const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
      const today = new Date();

      for (let i = 6; i >= 0; i--) {
        const d = new Date(today);
        d.setDate(today.getDate() - i);
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        const dd = String(d.getDate()).padStart(2, '0');
        const dateStr = yyyy + '-' + mm + '-' + dd;
        const dayLabel = dayNames[d.getDay()];
        const shortDate = dd + '/' + mm;
        days.push({
          dateStr: dateStr,
          label: dayLabel,
          shortDate: shortDate,
          total: 0,
          correct: 0
        });
      }

      // Count attempts for each of the 7 days
      let weekTotal = 0;
      let weekCorrect = 0;

      if (Array.isArray(attemptsList) && attemptsList.length > 0) {
        attemptsList.forEach(att => {
          if (!att.submittedAt) return;
          const attDate = (typeof att.submittedAt === 'string') ? att.submittedAt.split('T')[0] : '';
          const dayObj = days.find(d => d.dateStr === attDate);
          if (dayObj) {
            dayObj.total++;
            weekTotal++;
            const isOk = (att.correct === true || (att.score && Number(att.score) >= 5));
            if (isOk) {
              dayObj.correct++;
              weekCorrect++;
            }
          }
        });
      }

      // Fallback if no server attempts found but localStorage stats exist
      if (weekTotal === 0) {
        try {
          const localStats = JSON.parse(localStorage.getItem('math10_practice_stats') || '{}');
          if (localStats && localStats.total > 0) {
            days[days.length - 1].total = localStats.total;
            days[days.length - 1].correct = localStats.correct || 0;
            weekTotal = localStats.total;
            weekCorrect = localStats.correct || 0;
          }
        } catch(e) {}
      }

      if (statTotal) statTotal.textContent = weekTotal + ' câu';
      if (statCorrect) statCorrect.textContent = weekCorrect + ' câu';
      const weekAcc = weekTotal > 0 ? Math.round((weekCorrect / weekTotal) * 100) : 0;
      if (statAcc) statAcc.textContent = weekAcc + '%';

      if (weekTotal === 0) {
        chartArea.innerHTML = `
          <div class="w-100 text-center py-4 text-muted my-auto">
            <p class="mb-2">Bạn chưa làm bài tập nào trong 7 ngày gần nhất.</p>
            <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/practice">Bắt đầu luyện tập ngay &rarr;</a>
          </div>
        `;
        return;
      }

      const maxDaily = Math.max(...days.map(d => d.total), 1);

      chartArea.innerHTML = days.map(d => {
        const totalPercent = Math.min(100, Math.max(d.total > 0 ? 15 : 4, Math.round((d.total / maxDaily) * 85)));
        const correctPercent = Math.min(100, Math.max(d.correct > 0 ? 12 : 0, Math.round((d.correct / maxDaily) * 85)));
        const titleText = d.label + ' (' + d.shortDate + '): ' + d.total + ' câu làm (' + d.correct + ' câu đạt)';

        return `
          <div class="bar-group" title="\${titleText}" style="cursor: pointer;">
            <div class="bar" style="height: \${totalPercent}%; background: #93c5fd;" title="Tổng câu: \${d.total}"></div>
            <div class="bar alt" style="height: \${correctPercent}%; background: #16a34a;" title="Đạt yêu cầu: \${d.correct}"></div>
            <span class="bar-label">\${d.label}</span>
          </div>
        `;
      }).join('');
    }

    document.addEventListener('DOMContentLoaded', loadProgressData);
  </script>

<jsp:include page="/common/footer.jsp" />
