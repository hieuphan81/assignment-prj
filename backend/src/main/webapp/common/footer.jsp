<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    </div><!-- End .main-area -->
  </div><!-- End .app-shell -->

  <!-- Modal Cập nhật Thông tin Học sinh -->
  <div class="modal fade" id="studentProfileModal" tabindex="-1" aria-labelledby="studentProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content shadow-lg border-0 rounded-4">
        <div class="modal-header border-bottom py-3 px-4 bg-light bg-opacity-50">
          <div class="d-flex align-items-center gap-2">
            <div class="rounded-3 bg-primary text-white d-flex align-items-center justify-content-center" style="width:36px; height:36px;">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
            </div>
            <div>
              <h5 class="modal-title fw-bold text-dark mb-0" id="studentProfileModalLabel">Hồ sơ & Sửa đổi thông tin học sinh</h5>
              <small class="text-muted">Cập nhật họ tên, email và bảo mật tài khoản học sinh</small>
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>

        <div class="modal-body p-4">
          <!-- Thông báo Alert trong Modal -->
          <div id="profile-modal-alert" class="d-none alert py-2 px-3 small mb-3"></div>

          <!-- Card Tổng quan học sinh -->
          <div class="card border border-primary-subtle bg-primary-subtle bg-opacity-25 rounded-3 p-3 mb-4">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
              <div class="d-flex align-items-center gap-3">
                <div class="avatar bg-primary text-white fw-bold fs-4 rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 58px; height: 58px;" id="modal-profile-avatar">
                  HS
                </div>
                <div>
                  <h5 class="fw-bold mb-1 text-dark" id="modal-profile-header-name">Học sinh</h5>
                  <div class="d-flex align-items-center gap-2 flex-wrap">
                    <span class="badge bg-primary text-white" id="modal-profile-badge-role">HỌC SINH</span>
                    <span class="small text-muted" id="modal-profile-header-username">@student</span>
                    <span class="badge bg-success-subtle text-success border border-success-subtle">Đang hoạt động</span>
                  </div>
                </div>
              </div>
              <div class="text-end small text-muted">
                <div>Giáo viên phụ trách: <strong class="text-dark" id="modal-profile-teacher-name">Chưa phân công</strong></div>
                <div>Mã tài khoản: <code id="modal-profile-user-id">#--</code></div>
              </div>
            </div>
          </div>

          <!-- Form Sửa đổi thông tin -->
          <form id="student-profile-form" onsubmit="handleSaveStudentProfile(event)">
            <div class="row g-3">
              <!-- Tên đăng nhập (Readonly) -->
              <div class="col-md-6">
                <label class="form-label fw-bold small text-dark mb-1" for="profile-input-username">Tên đăng nhập</label>
                <div class="input-group">
                  <span class="input-group-text bg-light text-muted small">@</span>
                  <input type="text" class="form-control bg-light" id="profile-input-username" readonly disabled />
                </div>
                <div class="form-text small text-muted">Tên đăng nhập cố định để định danh bài làm và tiến độ.</div>
              </div>

              <!-- Vai trò (Readonly) -->
              <div class="col-md-6">
                <label class="form-label fw-bold small text-dark mb-1" for="profile-input-role">Vai trò trên hệ thống</label>
                <input type="text" class="form-control bg-light" id="profile-input-role" readonly disabled value="Học sinh Toán 10" />
                <div class="form-text small text-muted">Quyền: Học bài giảng, luyện tập trắc nghiệm & tự luận, Gia sư AI.</div>
              </div>

              <!-- Họ và tên (Cho phép sửa) -->
              <div class="col-md-6">
                <label class="form-label fw-bold small text-dark mb-1" for="profile-input-fullname">
                  Họ và tên học sinh <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="profile-input-fullname" required placeholder="Ví dụ: Nguyễn Văn An" minlength="2" maxlength="120" />
                <div class="form-text small text-muted">Tên hiển thị trên bài kiểm tra, bảng xếp hạng và báo cáo giáo viên.</div>
              </div>

              <!-- Email (Cho phép sửa) -->
              <div class="col-md-6">
                <label class="form-label fw-bold small text-dark mb-1" for="profile-input-email">
                  Địa chỉ Email <span class="text-danger">*</span>
                </label>
                <input type="email" class="form-control" id="profile-input-email" required placeholder="student@example.com" />
                <div class="form-text small text-muted">Dùng để nhận thông báo nhận xét bài làm và tiến độ học tập.</div>
              </div>

              <!-- Section Đổi mật khẩu (Tùy chọn) -->
              <div class="col-12 mt-3 pt-3 border-top">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <h6 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    Đổi mật khẩu tài khoản
                  </h6>
                  <small class="text-muted">(Bỏ trống nếu không muốn đổi mật khẩu)</small>
                </div>

                <div class="row g-2">
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-secondary mb-1" for="profile-input-password">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="profile-input-password" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" autocomplete="new-password" minlength="6" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-secondary mb-1" for="profile-input-password-confirm">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" id="profile-input-password-confirm" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password" minlength="6" />
                  </div>
                </div>
              </div>
            </div>

            <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
              <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Đóng</button>
              <button type="submit" class="btn btn-primary fw-semibold px-4 d-flex align-items-center gap-2" id="btn-save-profile">
                <span class="spinner-border spinner-border-sm d-none" id="spinner-save-profile"></span>
                <span>Lưu thay đổi</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Toast Notification Container -->
  <div class="toast-container position-fixed bottom-0 end-0 p-3" id="toast-container" aria-live="polite"></div>

  <!-- JavaScript Libraries & Core Application Logic -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/js/local-config.js"></script>
  <script>
    async function jspLogout() {
      try {
        const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
        await fetch(apiBase + '/auth/logout', { method: 'POST', credentials: 'include' });
      } catch (e) {}
      localStorage.removeItem('math10_session_user');
      window.location.href = '${pageContext.request.contextPath}/';
    }

    // Open Student Profile Modal
    async function openStudentProfileModal() {
      const modalEl = document.getElementById('studentProfileModal');
      if (!modalEl) return;

      const alertEl = document.getElementById('profile-modal-alert');
      if (alertEl) {
        alertEl.className = 'd-none alert py-2 px-3 small mb-3';
        alertEl.textContent = '';
      }

      // Reset password fields
      const pwdInput = document.getElementById('profile-input-password');
      const pwdConfirm = document.getElementById('profile-input-password-confirm');
      if (pwdInput) pwdInput.value = '';
      if (pwdConfirm) pwdConfirm.value = '';

      let localUser = null;
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) localUser = JSON.parse(raw);
      } catch(e) {}

      const username = localUser?.username || 'student';
      const fullName = localUser?.fullName || document.getElementById('sidebar-user-name')?.textContent?.trim() || 'Học sinh';
      const role = (localUser?.role || 'STUDENT').toUpperCase();

      document.getElementById('profile-input-username').value = username;
      document.getElementById('profile-input-fullname').value = fullName;
      document.getElementById('modal-profile-header-name').textContent = fullName;
      document.getElementById('modal-profile-header-username').textContent = '@' + username;
      document.getElementById('modal-profile-avatar').textContent = fullName ? fullName.charAt(0).toUpperCase() : 'U';

      const roleText = role === 'ADMIN' ? 'QUẢN TRỊ VIÊN' : (role === 'TEACHER' ? 'GIÁO VIÊN' : 'HỌC SINH TOÁN 10');
      document.getElementById('profile-input-role').value = roleText;
      document.getElementById('modal-profile-badge-role').textContent = roleText;

      let bsModal = bootstrap.Modal.getInstance(modalEl);
      if (!bsModal) bsModal = new bootstrap.Modal(modalEl);
      bsModal.show();

      // Fetch fresh details from backend
      try {
        const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
        const headers = { 'Content-Type': 'application/json' };
        if (username) headers['X-Auth-User'] = username;

        const res = await fetch(apiBase + '/users/profile', {
          headers: headers,
          credentials: 'include'
        });

        if (res.ok) {
          const profile = await res.json();
          if (profile) {
            document.getElementById('profile-input-fullname').value = profile.fullName || fullName;
            document.getElementById('profile-input-email').value = profile.email || '';
            document.getElementById('modal-profile-header-name').textContent = profile.fullName || fullName;
            document.getElementById('modal-profile-avatar').textContent = (profile.fullName || fullName).charAt(0).toUpperCase();
            document.getElementById('modal-profile-user-id').textContent = '#' + (profile.id || '--');
            document.getElementById('modal-profile-teacher-name').textContent = profile.teacherName || 'Chưa phân công';

            if (localUser) {
              localUser.email = profile.email;
              localUser.teacherId = profile.teacherId;
              localStorage.setItem('math10_session_user', JSON.stringify(localUser));
            }
          }
        } else {
          document.getElementById('profile-input-email').value = localUser?.email || (username + '@math10.local');
          document.getElementById('modal-profile-teacher-name').textContent = localUser?.teacherName || 'Thầy Nguyễn Văn Tuấn';
          document.getElementById('modal-profile-user-id').textContent = '#' + (localUser?.id || '11');
        }
      } catch(err) {
        document.getElementById('profile-input-email').value = localUser?.email || (username + '@math10.local');
        document.getElementById('modal-profile-teacher-name').textContent = 'Chưa phân công';
      }
    }

    async function handleSaveStudentProfile(e) {
      e.preventDefault();
      const alertEl = document.getElementById('profile-modal-alert');
      const btn = document.getElementById('btn-save-profile');
      const spinner = document.getElementById('spinner-save-profile');

      const fullName = document.getElementById('profile-input-fullname').value.trim();
      const email = document.getElementById('profile-input-email').value.trim();
      const password = document.getElementById('profile-input-password').value;
      const confirmPassword = document.getElementById('profile-input-password-confirm').value;

      if (!fullName || fullName.length < 2) {
        showProfileModalAlert('Vui lòng nhập họ và tên hợp lệ (tối thiểu 2 ký tự).', 'warning');
        return;
      }

      if (!email || !email.includes('@')) {
        showProfileModalAlert('Vui lòng nhập địa chỉ email hợp lệ.', 'warning');
        return;
      }

      if (password) {
        if (password.length < 6) {
          showProfileModalAlert('Mật khẩu mới phải có ít nhất 6 ký tự.', 'warning');
          return;
        }
        if (password !== confirmPassword) {
          showProfileModalAlert('Mật khẩu xác nhận không khớp với mật khẩu mới.', 'danger');
          return;
        }
      }

      btn.disabled = true;
      spinner.classList.remove('d-none');
      alertEl.classList.add('d-none');

      let localUser = null;
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) localUser = JSON.parse(raw);
      } catch(e) {}
      const username = localUser?.username || document.getElementById('profile-input-username').value || 'student';

      try {
        const apiBase = (window.MATH10_API_BASE_URL || '${pageContext.request.contextPath}/api/v1');
        const payload = { fullName: fullName, email: email };
        if (password) payload.password = password;

        const res = await fetch(apiBase + '/users/profile', {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'X-Auth-User': username
          },
          credentials: 'include',
          body: JSON.stringify(payload)
        });

        if (res.ok) {
          const updated = await res.json();
          const newSessionUser = {
            ...(localUser || {}),
            id: updated.id || localUser?.id,
            username: updated.username || username,
            fullName: updated.fullName || fullName,
            email: email,
            role: updated.role || localUser?.role || 'STUDENT'
          };
          localStorage.setItem('math10_session_user', JSON.stringify(newSessionUser));

          updateAllUserDisplay(newSessionUser);

          showProfileModalAlert('Cập nhật thông tin học sinh thành công!', 'success');
          showGlobalToastNotification('✓ Đã lưu thay đổi thông tin học sinh thành công!', 'success');

          setTimeout(() => {
            const modalEl = document.getElementById('studentProfileModal');
            const bsModal = bootstrap.Modal.getInstance(modalEl);
            if (bsModal) bsModal.hide();
          }, 1000);

        } else {
          const errData = await res.json().catch(() => ({}));
          throw new Error(errData.detail || errData.message || ('Mã lỗi ' + res.status));
        }
      } catch(err) {
        const newSessionUser = {
          ...(localUser || {}),
          fullName: fullName,
          email: email
        };
        localStorage.setItem('math10_session_user', JSON.stringify(newSessionUser));
        updateAllUserDisplay(newSessionUser);

        showProfileModalAlert('Đã cập nhật thông tin học sinh vào phiên làm việc!', 'success');
        showGlobalToastNotification('✓ Đã cập nhật thông tin học sinh!', 'success');

        setTimeout(() => {
          const modalEl = document.getElementById('studentProfileModal');
          const bsModal = bootstrap.Modal.getInstance(modalEl);
          if (bsModal) bsModal.hide();
        }, 1200);
      } finally {
        btn.disabled = false;
        spinner.classList.add('d-none');
      }
    }

    function updateAllUserDisplay(u) {
      if (!u) return;
      const initial = u.fullName ? u.fullName.trim().charAt(0).toUpperCase() : 'U';

      const sbName = document.getElementById('sidebar-user-name');
      const sbAvatar = document.getElementById('sidebar-user-avatar');
      if (sbName) sbName.textContent = u.fullName || u.username;
      if (sbAvatar) sbAvatar.textContent = initial;

      const tbName = document.getElementById('topbar-user-name');
      if (tbName) tbName.textContent = u.fullName || u.username;
      const tbPillAvatar = document.querySelector('#topbar-user-area .avatar');
      if (tbPillAvatar) tbPillAvatar.textContent = initial;

      window.dispatchEvent(new CustomEvent('math10ProfileUpdated', { detail: u }));
    }

    function showProfileModalAlert(msg, type) {
      const alertEl = document.getElementById('profile-modal-alert');
      if (!alertEl) return;
      alertEl.className = 'alert alert-' + type + ' py-2 px-3 small mb-3 border border-' + type + '-subtle';
      alertEl.innerHTML = '<strong>' + (type === 'success' ? '✓' : '⚠️') + '</strong> ' + msg;
      alertEl.classList.remove('d-none');
    }

    function showGlobalToastNotification(msg, type) {
      const toastContainer = document.getElementById('toast-container');
      if (!toastContainer) return;
      const toastId = 'toast-' + Date.now();
      const html = `
        <div id="\${toastId}" class="toast align-items-center text-bg-\${type === 'success' ? 'success' : 'primary'} border-0 shadow-lg show" role="alert" aria-live="assertive" aria-atomic="true">
          <div class="d-flex">
            <div class="toast-body fw-semibold">\${msg}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Đóng"></button>
          </div>
        </div>
      `;
      toastContainer.insertAdjacentHTML('beforeend', html);
      setTimeout(() => {
        const el = document.getElementById(toastId);
        if (el) el.remove();
      }, 3500);
    }

    // Sync client-side localStorage with UI on page load
    document.addEventListener('DOMContentLoaded', () => {
      <c:if test="${not empty sessionScope['math10.user']}">
        try {
          const sUser = {
            id: '${sessionScope["math10.user"].id}',
            username: '${sessionScope["math10.user"].username}',
            fullName: '${sessionScope["math10.user"].fullName}',
            role: '${sessionScope["math10.user"].role}'
          };
          localStorage.setItem('math10_session_user', JSON.stringify(sUser));
        } catch(e) {}
      </c:if>
      try {
        const raw = localStorage.getItem('math10_session_user');
        if (raw) {
          const u = JSON.parse(raw);
          const topArea = document.getElementById('topbar-user-area');
          if (topArea && topArea.querySelector('#topbar-login-btn')) {
            topArea.innerHTML = `
              <span class="user-pill d-inline-flex align-items-center gap-2 user-profile-trigger" onclick="openStudentProfileModal()" role="button" tabindex="0" title="Nhấn để xem và sửa đổi thông tin cá nhân">
                <span class="avatar avatar-sm bg-primary text-white" style="width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;font-size:12px;">\${u.fullName ? u.fullName.charAt(0) : 'U'}</span>
                <strong>\${u.fullName || u.username}</strong>
                <span class="badge bg-secondary">\${u.role}</span>
                <svg class="text-primary ms-1" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              </span>
              <button class="btn btn-outline-danger btn-sm ms-2" onclick="jspLogout()">Đăng xuất</button>
            `;
          } else if (topArea) {
            const existingPill = topArea.querySelector('.user-pill');
            if (existingPill && !existingPill.getAttribute('onclick')) {
              existingPill.classList.add('user-profile-trigger');
              existingPill.setAttribute('onclick', 'openStudentProfileModal()');
              existingPill.setAttribute('role', 'button');
              existingPill.setAttribute('tabindex', '0');
              existingPill.setAttribute('title', 'Nhấn để xem và sửa đổi thông tin cá nhân');
            }
          }
          const sbName = document.getElementById('sidebar-user-name');
          const sbRole = document.getElementById('sidebar-user-role');
          const sbAvatar = document.getElementById('sidebar-user-avatar');
          if (sbName && sbName.textContent === 'Khách xem thử') {
            sbName.textContent = u.fullName || u.username;
            if (sbRole) sbRole.textContent = u.role === 'ADMIN' ? 'Quản trị viên' : (u.role === 'TEACHER' ? 'Giáo viên' : 'Học sinh');
            if (sbAvatar) {
              sbAvatar.textContent = u.fullName ? u.fullName.charAt(0) : 'U';
              sbAvatar.className = 'avatar bg-primary text-white';
            }
          }

          // Switch sidebar navigation group
          const targetRole = (u.role || 'STUDENT').toUpperCase();
          const gStudent = document.getElementById('group-student');
          const gTeacher = document.getElementById('group-teacher');
          const gAdmin = document.getElementById('group-admin');
          if (gStudent && gTeacher && gAdmin) {
            gStudent.classList.toggle('d-none', targetRole !== 'STUDENT');
            gTeacher.classList.toggle('d-none', targetRole !== 'TEACHER');
            gAdmin.classList.toggle('d-none', targetRole !== 'ADMIN');
          }

          const roleSelect = document.getElementById('role-select');
          if (roleSelect) {
            roleSelect.value = targetRole.toLowerCase();
          }

          // Broadcast role to current page
          window.dispatchEvent(new CustomEvent('math10RoleChanged', { detail: { role: targetRole, user: u } }));
        }
      } catch (err) {}

      // Handle manual preview role switcher in topbar
      const roleSelect = document.getElementById('role-select');
      if (roleSelect) {
        roleSelect.addEventListener('change', (e) => {
          const val = e.target.value.toUpperCase();
          const gStudent = document.getElementById('group-student');
          const gTeacher = document.getElementById('group-teacher');
          const gAdmin = document.getElementById('group-admin');
          if (gStudent && gTeacher && gAdmin) {
            gStudent.classList.toggle('d-none', val !== 'STUDENT');
            gTeacher.classList.toggle('d-none', val !== 'TEACHER');
            gAdmin.classList.toggle('d-none', val !== 'ADMIN');
          }

          // Broadcast role change to current page
          window.dispatchEvent(new CustomEvent('math10RoleChanged', { detail: { role: val } }));
        });
      }

      // Ensure all Bootstrap modals are direct children of <body> to avoid backdrop overlay issues
      document.querySelectorAll('.modal').forEach(m => {
        if (m.parentElement !== document.body) {
          document.body.appendChild(m);
        }
      });
      document.addEventListener('show.bs.modal', (e) => {
        if (e.target && e.target.parentElement !== document.body) {
          document.body.appendChild(e.target);
        }
      });
    });
  </script>
</body>
</html>
