<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Đăng ký tài khoản — Math10 AI" />
</jsp:include>

<div class="d-flex align-items-center justify-content-center min-vh-100 p-3" style="background: var(--canvas);">
  <div class="cardx card-pad auth-card shadow-lg" style="width: min(100%, 460px);">
    <div class="text-center mb-3">
      <div class="brand-mark mx-auto mb-2" style="width: 44px; height: 44px;">
        <svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg>
      </div>
      <div class="eyebrow" id="reg-eyebrow">MATH10 AI — ĐĂNG KÝ TÀI KHOẢN</div>
      <h1 class="card-title" id="reg-title" style="font-size: 22px;">Tạo tài khoản học sinh</h1>
      <p class="small text-muted mt-1" id="reg-subtitle">Đăng ký để học Toán 10 và nhận phản hồi chi tiết từ AI.</p>
    </div>

    <!-- Role Switcher Tabs for Register -->
    <ul class="nav nav-pills nav-fill mb-3 p-1 rounded-3" style="background: #eef2f8;">
      <li class="nav-item">
        <button class="nav-link active py-2 fw-bold" id="reg-tab-student" type="button" onclick="switchRegisterRole('student')">
          Học sinh
        </button>
      </li>
      <li class="nav-item">
        <button class="nav-link py-2 fw-bold text-secondary" id="reg-tab-teacher" type="button" onclick="switchRegisterRole('teacher')">
          Giáo viên
        </button>
      </li>
    </ul>

    <form id="standalone-register-form">
      <div class="mb-3">
        <label class="form-label" for="reg-fullname" id="label-fullname">Họ và tên học sinh</label>
        <input class="form-control" type="text" id="reg-fullname" name="fullName" required placeholder="Ví dụ: Nguyễn Văn A">
      </div>

      <div class="mb-3">
        <label class="form-label" for="reg-username">Tên đăng nhập</label>
        <input class="form-control" type="text" id="reg-username" name="username" required autocomplete="username" placeholder="Ví dụ: nguyenhocsinh10">
      </div>

      <div class="mb-3">
        <label class="form-label" for="reg-email">Email</label>
        <input class="form-control" type="email" id="reg-email" name="email" required placeholder="email@example.com">
      </div>

      <div class="mb-3">
        <label class="form-label" for="reg-password">Mật khẩu</label>
        <input class="form-control" type="password" id="reg-password" name="password" required autocomplete="new-password" placeholder="Tối thiểu 12 ký tự">
        <div class="form-text">Mật khẩu cần có ít nhất 12 ký tự để đảm bảo an toàn.</div>
      </div>

      <div class="mb-3">
        <label class="form-label" for="reg-confirm">Xác nhận lại mật khẩu</label>
        <input class="form-control" type="password" id="reg-confirm" name="confirmPassword" required autocomplete="new-password" placeholder="Nhập lại mật khẩu ở trên">
      </div>

      <div class="small text-danger mb-3 d-none" id="standalone-reg-error"></div>

      <button class="btn btn-primary w-100 py-2 mb-3" type="submit" id="reg-submit-btn">Tạo tài khoản Học sinh &rarr;</button>
    </form>

    <div class="text-center small text-muted">
      Đã có tài khoản? <a class="text-primary fw-bold" id="link-to-login" href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
    </div>

    <hr class="my-3">
    <div class="text-center">
      <a class="btn btn-light btn-sm w-100" href="${pageContext.request.contextPath}/">&larr; Quay lại trang chủ xem thử</a>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/local-config.js"></script>
<script>
  let currentRegRole = 'STUDENT';

  function switchRegisterRole(role) {
    const tabStudent = document.getElementById('reg-tab-student');
    const tabTeacher = document.getElementById('reg-tab-teacher');
    const eyebrow = document.getElementById('reg-eyebrow');
    const title = document.getElementById('reg-title');
    const subtitle = document.getElementById('reg-subtitle');
    const labelFullname = document.getElementById('label-fullname');
    const inputFullname = document.getElementById('reg-fullname');
    const submitBtn = document.getElementById('reg-submit-btn');
    const linkLogin = document.getElementById('link-to-login');

    if (role === 'teacher') {
      currentRegRole = 'TEACHER';
      tabTeacher.classList.add('active', 'bg-primary', 'text-white');
      tabTeacher.classList.remove('text-secondary');
      tabStudent.classList.remove('active', 'bg-primary', 'text-white');
      tabStudent.classList.add('text-secondary');

      eyebrow.textContent = 'MATH10 AI — ĐĂNG KÝ GIÁO VIÊN';
      title.textContent = 'Tạo tài khoản Giáo viên';
      subtitle.textContent = 'Đăng ký để quản lý lớp học, biên soạn câu hỏi và tạo đề trắc nghiệm AI.';
      labelFullname.textContent = 'Họ và tên Giáo viên';
      inputFullname.placeholder = 'Ví dụ: Thầy Trần Minh Tuấn';
      submitBtn.textContent = 'Tạo tài khoản Giáo viên →';
      linkLogin.href = '${pageContext.request.contextPath}/login?role=teacher';
    } else {
      currentRegRole = 'STUDENT';
      tabStudent.classList.add('active', 'bg-primary', 'text-white');
      tabStudent.classList.remove('text-secondary');
      tabTeacher.classList.remove('active', 'bg-primary', 'text-white');
      tabTeacher.classList.add('text-secondary');

      eyebrow.textContent = 'MATH10 AI — ĐĂNG KÝ HỌC SINH';
      title.textContent = 'Tạo tài khoản học sinh';
      subtitle.textContent = 'Đăng ký để học Toán 10 và nhận phản hồi chi tiết từ AI.';
      labelFullname.textContent = 'Họ và tên học sinh';
      inputFullname.placeholder = 'Ví dụ: Nguyễn Văn A';
      submitBtn.textContent = 'Tạo tài khoản Học sinh →';
      linkLogin.href = '${pageContext.request.contextPath}/login?role=student';
    }
  }

  // Pre-select role if URL has ?role=teacher
  const params = new URLSearchParams(window.location.search);
  if (params.get('role') === 'teacher') {
    switchRegisterRole('teacher');
  } else {
    switchRegisterRole('student');
  }

  const form = document.getElementById('standalone-register-form');
  const errorBox = document.getElementById('standalone-reg-error');
  const submitBtn = document.getElementById('reg-submit-btn');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    errorBox.classList.add('d-none');

    const fullName = document.getElementById('reg-fullname').value.trim();
    const username = document.getElementById('reg-username').value.trim();
    const email = document.getElementById('reg-email').value.trim();
    const password = document.getElementById('reg-password').value;
    const confirmPassword = document.getElementById('reg-confirm').value;

    if (password !== confirmPassword) {
      errorBox.textContent = 'Mật khẩu xác nhận không khớp.';
      errorBox.classList.remove('d-none');
      return;
    }

    if (password.length < 12) {
      errorBox.textContent = 'Mật khẩu cần ít nhất 12 ký tự theo chuẩn bảo mật.';
      errorBox.classList.remove('d-none');
      return;
    }

    submitBtn.disabled = true;
    submitBtn.textContent = 'Đang xử lý đăng ký...';

    const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');

    try {
      const res = await fetch(apiBase + '/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({
          fullName,
          username,
          email,
          password,
          role: currentRegRole
        })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data?.detail || 'Đăng ký tài khoản không thành công.');

      // Save user session to localStorage & redirect
      try { localStorage.setItem('math10_session_user', JSON.stringify(data)); } catch (e) {}
      window.location.href = '${pageContext.request.contextPath}/';
    } catch (err) {
      errorBox.textContent = err.message || 'Lỗi kết nối máy chủ.';
      errorBox.classList.remove('d-none');
      submitBtn.disabled = false;
      submitBtn.textContent = (currentRegRole === 'TEACHER' ? 'Tạo tài khoản Giáo viên →' : 'Tạo tài khoản Học sinh →');
    }
  });
</script>
</body>
</html>
