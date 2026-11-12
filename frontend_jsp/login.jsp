<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Đăng nhập — Math10 AI" />
</jsp:include>

<div class="d-flex align-items-center justify-content-center min-vh-100 p-3" style="background: var(--canvas);">
  <div class="cardx card-pad auth-card shadow-lg" style="width: min(100%, 440px);">
    <div class="text-center mb-3">
      <div class="brand-mark mx-auto mb-2" style="width: 44px; height: 44px;">
        <svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg>
      </div>
      <div class="eyebrow">MATH10 AI — HỌC TOÁN 10 TỪNG BƯỚC</div>
      <h1 class="card-title" id="login-title" style="font-size: 22px;">Đăng nhập tài khoản</h1>
      <p class="small text-muted mt-1" id="login-subtitle">Chọn vai trò của bạn để đăng nhập vào không gian phù hợp.</p>
    </div>

    <!-- Role Tabs Switcher -->
    <ul class="nav nav-pills nav-fill mb-3 p-1 rounded-3" style="background: #eef2f8;">
      <li class="nav-item">
        <button class="nav-link active py-2 fw-bold" id="tab-student" type="button" onclick="switchLoginRole('student')">
          Học sinh
        </button>
      </li>
      <li class="nav-item">
        <button class="nav-link py-2 fw-bold text-secondary" id="tab-teacher" type="button" onclick="switchLoginRole('teacher')">
          Giáo viên
        </button>
      </li>
      <li class="nav-item">
        <button class="nav-link py-2 fw-bold text-secondary" id="tab-admin" type="button" onclick="switchLoginRole('admin')">
          Quản trị viên
        </button>
      </li>
    </ul>

    <form id="standalone-login-form">
      <div class="mb-3">
        <label class="form-label" for="login-username" id="label-username">Tên đăng nhập Học sinh</label>
        <input class="form-control" type="text" id="login-username" name="username" required autocomplete="username" placeholder="Ví dụ: student hoặc tên đăng nhập của bạn">
      </div>

      <div class="mb-3">
        <label class="form-label" for="login-password">Mật khẩu</label>
        <input class="form-control" type="password" id="login-password" name="password" required autocomplete="current-password" placeholder="Nhập mật khẩu">
      </div>

      <div class="small text-danger mb-3 d-none" id="standalone-login-error"></div>

      <button class="btn btn-primary w-100 py-2 mb-3" type="submit" id="login-submit-btn">Đăng nhập Học sinh &rarr;</button>
    </form>

    <div class="text-center small text-muted" id="register-switch-container">
      Chưa có tài khoản? <a class="text-primary fw-bold" id="link-register" href="${pageContext.request.contextPath}/register">Đăng ký tài khoản học sinh</a>
    </div>

    <hr class="my-3">
    <div class="text-center d-flex justify-content-between">
      <a class="btn btn-light btn-sm" href="${pageContext.request.contextPath}/">&larr; Trang chủ xem thử</a>
      <button class="btn btn-link btn-sm text-muted p-0" type="button" onclick="quickFillAdmin()">Đăng nhập nhanh Admin</button>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/local-config.js"></script>
<script>
  let currentRole = 'student';

  function switchLoginRole(role) {
    currentRole = role;
    const tabStudent = document.getElementById('tab-student');
    const tabTeacher = document.getElementById('tab-teacher');
    const tabAdmin = document.getElementById('tab-admin');
    const labelUser = document.getElementById('label-username');
    const inputUser = document.getElementById('login-username');
    const submitBtn = document.getElementById('login-submit-btn');
    const regContainer = document.getElementById('register-switch-container');
    const title = document.getElementById('login-title');
    const sub = document.getElementById('login-subtitle');

    // Reset tab active states
    [tabStudent, tabTeacher, tabAdmin].forEach(tab => {
      if (tab) {
        tab.classList.remove('active', 'bg-primary', 'text-white');
        tab.classList.add('text-secondary');
      }
    });

    if (role === 'admin') {
      if (tabAdmin) {
        tabAdmin.classList.add('active', 'bg-primary', 'text-white');
        tabAdmin.classList.remove('text-secondary');
      }
      title.textContent = 'Đăng nhập Quản trị viên';
      sub.textContent = 'Truy cập Bảng điều khiển quản trị hệ thống, quản lý người dùng và cấu hình AI.';
      labelUser.textContent = 'Tài khoản Quản trị viên (Admin)';
      inputUser.placeholder = 'admin';
      submitBtn.textContent = 'Đăng nhập Quản trị viên →';
      if (regContainer) {
        regContainer.innerHTML = '<span class="text-muted">Tài khoản quản trị viên do hệ thống cấp quyền.</span>';
      }
    } else if (role === 'teacher') {
      if (tabTeacher) {
        tabTeacher.classList.add('active', 'bg-primary', 'text-white');
        tabTeacher.classList.remove('text-secondary');
      }
      title.textContent = 'Đăng nhập Giáo viên';
      sub.textContent = 'Truy cập Không gian giảng dạy, quản lý học sinh và ngân hàng câu hỏi.';
      labelUser.textContent = 'Tên đăng nhập Giáo viên';
      inputUser.placeholder = 'Ví dụ: teacher';
      submitBtn.textContent = 'Đăng nhập Giáo viên →';
      if (regContainer) {
        regContainer.innerHTML = 'Chưa có tài khoản? <a class="text-primary fw-bold" id="link-register" href="${pageContext.request.contextPath}/register?role=teacher">Đăng ký tài khoản Giáo viên</a>';
      }
    } else {
      if (tabStudent) {
        tabStudent.classList.add('active', 'bg-primary', 'text-white');
        tabStudent.classList.remove('text-secondary');
      }
      title.textContent = 'Đăng nhập Học sinh';
      sub.textContent = 'Truy cập Không gian học tập, giải bài tập và học cùng Gia sư AI.';
      labelUser.textContent = 'Tên đăng nhập Học sinh';
      inputUser.placeholder = 'Ví dụ: student';
      submitBtn.textContent = 'Đăng nhập Học sinh →';
      if (regContainer) {
        regContainer.innerHTML = 'Chưa có tài khoản? <a class="text-primary fw-bold" id="link-register" href="${pageContext.request.contextPath}/register?role=student">Đăng ký tài khoản học sinh</a>';
      }
    }
  }

  function quickFillAdmin() {
    switchLoginRole('admin');
    document.getElementById('login-username').value = 'admin';
    document.getElementById('login-password').value = 'Admin@12345678';
  }

  // Pre-select role if URL has ?role=...
  const params = new URLSearchParams(window.location.search);
  const requestedRole = (params.get('role') || '').toLowerCase();
  if (requestedRole === 'teacher') {
    switchLoginRole('teacher');
  } else if (requestedRole === 'admin') {
    switchLoginRole('admin');
  } else {
    switchLoginRole('student');
  }

  const form = document.getElementById('standalone-login-form');
  const errorBox = document.getElementById('standalone-login-error');
  const submitBtn = document.getElementById('login-submit-btn');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    errorBox.classList.add('d-none');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Đang kiểm tra...';

    const username = document.getElementById('login-username').value.trim();
    const password = document.getElementById('login-password').value;
    const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');

    try {
      const res = await fetch(apiBase + '/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ username, password })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data?.detail || 'Tên đăng nhập hoặc mật khẩu không chính xác.');

      // Save user to localStorage & redirect
      try { localStorage.setItem('math10_session_user', JSON.stringify(data)); } catch (e) {}
      window.location.href = '${pageContext.request.contextPath}/';
    } catch (err) {
      if (err.message && (err.message.includes('fetch') || err.message.includes('Failed to fetch') || err.message.includes('NetworkError'))) {
        errorBox.textContent = 'Không thể kết nối đến máy chủ Backend (Port 8081). Hãy đảm bảo Backend Spring Boot đã được khởi động!';
      } else {
        errorBox.textContent = err.message || 'Lỗi kết nối máy chủ.';
      }
      errorBox.classList.remove('d-none');
    } finally {
      submitBtn.disabled = false;
      if (currentRole === 'admin') {
        submitBtn.textContent = 'Đăng nhập Quản trị viên →';
      } else if (currentRole === 'teacher') {
        submitBtn.textContent = 'Đăng nhập Giáo viên →';
      } else {
        submitBtn.textContent = 'Đăng nhập Học sinh →';
      }
    }
  });
</script>
</body>
</html>
