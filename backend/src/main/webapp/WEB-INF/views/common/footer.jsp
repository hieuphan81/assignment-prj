<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    </div><!-- End .main-area -->
  </div><!-- End .app-shell -->

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
              <span class="user-pill d-inline-flex align-items-center gap-2">
                <span class="avatar avatar-sm bg-primary text-white" style="width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;font-size:12px;">\${u.fullName ? u.fullName.charAt(0) : 'U'}</span>
                <strong>\${u.fullName || u.username}</strong>
                <span class="badge bg-secondary">\${u.role}</span>
              </span>
              <button class="btn btn-outline-danger btn-sm ms-2" onclick="jspLogout()">Đăng xuất</button>
            `;
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
