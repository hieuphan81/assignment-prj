<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Quản lý tài khoản — Quản trị viên — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="admin-users" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Quản lý tài khoản" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow">QUẢN TRỊ VIÊN &bull; PHÂN QUYỀN HỆ THỐNG</div>
        <h1>Quản lý tài khoản & Phân công giáo viên</h1>
        <p>Quản lý toàn bộ tài khoản Admin, Giáo viên và Học sinh theo dữ liệu thực từ CSDL. Kích hoạt/khoá tài khoản, phân công giáo viên và xóa tài khoản thừa.</p>
      </div>
      <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary d-flex align-items-center gap-1" id="btn-refresh-users" onclick="loadUsers()">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"/></svg> Làm mới
        </button>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#adminCreateUserModal">
          + Tạo tài khoản mới
        </button>
      </div>
    </div>

    <!-- 4 Stats Cards -->
    <div class="row g-3 mb-4">
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Quản trị viên (ADMIN)</div>
          <div class="metric-value" id="stat-admin-count">0</div>
          <div class="metric-icon purple">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a5 5 0 0 0-5 5v3H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8a2 2 0 0 0-2-2h-1V7a5 5 0 0 0-5-5z"/></svg>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Giáo viên (TEACHER)</div>
          <div class="metric-value" id="stat-teacher-count">0</div>
          <div class="metric-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Học sinh (STUDENT)</div>
          <div class="metric-value" id="stat-student-count">0</div>
          <div class="metric-icon green">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-xl-3">
        <div class="cardx metric-card">
          <div class="metric-label">Tổng người dùng hệ thống</div>
          <div class="metric-value" id="stat-total-count" style="color:var(--brand-primary, #4361ee);">0</div>
          <div class="metric-icon orange">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Filter & Search Controls -->
    <div class="cardx card-pad mb-4">
      <div class="row g-2 align-items-center">
        <div class="col-md-5">
          <div class="input-group">
            <span class="input-group-text bg-white border-end-0">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            </span>
            <input type="text" id="userSearchInput" class="form-control border-start-0" placeholder="Tìm theo họ tên, username hoặc email..." oninput="applyFilters()">
          </div>
        </div>
        <div class="col-md-3">
          <select id="roleFilter" class="form-select" onchange="applyFilters()">
            <option value="ALL">-- Tất cả vai trò --</option>
            <option value="ADMIN">Quản trị viên (ADMIN)</option>
            <option value="TEACHER">Giáo viên (TEACHER)</option>
            <option value="STUDENT">Học sinh (STUDENT)</option>
          </select>
        </div>
        <div class="col-md-2">
          <select id="statusFilter" class="form-select" onchange="applyFilters()">
            <option value="ALL">-- Tất cả trạng thái --</option>
            <option value="ACTIVE">Hoạt động (ACTIVE)</option>
            <option value="LOCKED">Bị khóa (LOCKED)</option>
          </select>
        </div>
        <div class="col-md-2 text-end">
          <span class="badge bg-light text-dark border px-3 py-2" id="filteredCountBadge">0 tài khoản</span>
        </div>
      </div>
    </div>

    <!-- Users Table -->
    <div class="cardx card-pad">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="card-title mb-0">Danh sách tài khoản trong cơ sở dữ liệu</h2>
        <span class="text-muted small" id="lastUpdatedTime">Đang tải dữ liệu...</span>
      </div>

      <div class="table-responsive">
        <table class="table align-middle">
          <thead>
            <tr>
              <th scope="col" style="width: 50px; text-align: center;">ID</th>
              <th scope="col" style="min-width: 160px;">Họ và tên</th>
              <th scope="col" style="min-width: 120px;">Tên đăng nhập</th>
              <th scope="col" style="min-width: 180px;">Email</th>
              <th scope="col" style="width: 100px; text-align: center;">Vai trò</th>
              <th scope="col" style="min-width: 160px;">Giáo viên phụ trách</th>
              <th scope="col" style="width: 90px; text-align: center;">Trạng thái</th>
              <th scope="col" class="text-end" style="width: 250px; min-width: 240px; white-space: nowrap;">Thao tác</th>
            </tr>
          </thead>
          <tbody id="usersTableBody">
            <tr>
              <td colspan="8" class="text-center py-5 text-muted">
                <div class="spinner-border text-primary spinner-border-sm me-2" role="status"></div>
                Đang tải danh sách tài khoản từ máy chủ...
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <!-- Modal 1: Create User -->
  <div class="modal fade" id="adminCreateUserModal" tabindex="-1" aria-labelledby="adminCreateUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" id="adminCreateUserModalLabel">Tạo tài khoản người dùng mới</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="adminCreateUserForm" onsubmit="handleCreateUser(event)">
          <div class="modal-body">
            <div id="createUserAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="createUserFullName">Họ và tên <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="createUserFullName" required placeholder="Ví dụ: Trần Quang Nam" maxlength="120">
            </div>

            <div class="row g-2 mb-3">
              <div class="col-md-6">
                <label class="form-label fw-semibold" for="createUserUsername">Tên đăng nhập <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="createUserUsername" required placeholder="Ví dụ: nam.tq" maxlength="50" pattern="[a-zA-Z0-9_\.]+" title="Chỉ chứa chữ cái, số, dấu gạch dưới hoặc chấm">
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold" for="createUserRole">Vai trò <span class="text-danger">*</span></label>
                <select id="createUserRole" class="form-select" required onchange="toggleTeacherSelectForCreate()">
                  <option value="STUDENT" selected>Học sinh (STUDENT)</option>
                  <option value="TEACHER">Giáo viên (TEACHER)</option>
                  <option value="ADMIN">Quản trị viên (ADMIN)</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="createUserEmail">Địa chỉ Email <span class="text-danger">*</span></label>
              <input type="email" class="form-control" id="createUserEmail" required placeholder="Ví dụ: nam.tq@math10.edu.vn" maxlength="254">
            </div>

            <div class="mb-3">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label fw-semibold mb-0" for="createUserPassword">Mật khẩu ban đầu <span class="text-danger">*</span></label>
                <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none" onclick="generateRandomPassword('createUserPassword')">
                  Tạo mật khẩu tự động
                </button>
              </div>
              <input type="text" class="form-control" id="createUserPassword" required minlength="6" placeholder="Tối thiểu 6 ký tự">
              <div class="form-text small">Mật khẩu tối thiểu 6 ký tự. Người dùng có thể đổi sau khi đăng nhập.</div>
            </div>

            <div class="mb-3" id="createUserTeacherGroup">
              <label class="form-label fw-semibold" for="createUserTeacherId">Giáo viên phụ trách (Dành cho Học sinh)</label>
              <select id="createUserTeacherId" class="form-select">
                <option value="">-- Chưa phân công giáo viên --</option>
              </select>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-primary" id="btn-submit-create-user">
              <span class="spinner-border spinner-border-sm me-1 d-none" id="spinner-create-user" role="status"></span>
              + Tạo tài khoản
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal 2: Edit User Modal -->
  <div class="modal fade" id="adminEditUserModal" tabindex="-1" aria-labelledby="adminEditUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" id="adminEditUserModalLabel">Cập nhật thông tin tài khoản</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="adminEditUserForm" onsubmit="handleEditUser(event)">
          <input type="hidden" id="editUserId">
          <div class="modal-body">
            <div id="editUserAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="editUserFullName">Họ và tên <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="editUserFullName" required maxlength="120">
            </div>

            <div class="row g-2 mb-3">
              <div class="col-md-6">
                <label class="form-label fw-semibold" for="editUserUsername">Tên đăng nhập <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="editUserUsername" required maxlength="50">
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold" for="editUserRole">Vai trò <span class="text-danger">*</span></label>
                <select id="editUserRole" class="form-select" required onchange="toggleTeacherSelectForEdit()">
                  <option value="STUDENT">Học sinh (STUDENT)</option>
                  <option value="TEACHER">Giáo viên (TEACHER)</option>
                  <option value="ADMIN">Quản trị viên (ADMIN)</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="editUserEmail">Email <span class="text-danger">*</span></label>
              <input type="email" class="form-control" id="editUserEmail" required maxlength="254">
            </div>

            <div class="mb-3">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label fw-semibold mb-0" for="editUserPassword">Mật khẩu mới (Nếu muốn đổi)</label>
                <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none" onclick="generateRandomPassword('editUserPassword')">
                  Tạo mật khẩu mới
                </button>
              </div>
              <input type="text" class="form-control" id="editUserPassword" placeholder="Nhập mật khẩu mới (hoặc bấm tạo ngẫu nhiên)" minlength="6">
              <div class="form-text small">Nếu đổi thông tin, vui lòng nhập mật khẩu mới hoặc bấm "Tạo mật khẩu mới" (tối thiểu 6 ký tự).</div>
            </div>

            <div class="mb-3" id="editUserTeacherGroup">
              <label class="form-label fw-semibold" for="editUserTeacherId">Giáo viên phụ trách</label>
              <select id="editUserTeacherId" class="form-select">
                <option value="">-- Chưa phân công --</option>
              </select>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-primary" id="btn-submit-edit-user">Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal 3: Assign Teacher Modal -->
  <div class="modal fade" id="adminAssignTeacherModal" tabindex="-1" aria-labelledby="adminAssignTeacherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" id="adminAssignTeacherModalLabel">Phân công giáo viên phụ trách</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <form id="adminAssignTeacherForm" onsubmit="handleAssignTeacher(event)">
          <input type="hidden" id="assignStudentId">
          <div class="modal-body">
            <div id="assignTeacherAlert" class="alert d-none py-2 px-3 small" role="alert"></div>

            <p class="mb-3">Học sinh: <strong id="assignStudentName" class="text-primary">-</strong></p>

            <div class="mb-3">
              <label class="form-label fw-semibold" for="assignTeacherSelect">Chọn giáo viên phụ trách</label>
              <select id="assignTeacherSelect" class="form-select">
                <option value="">-- Chưa phân công giáo viên --</option>
              </select>
            </div>
            <div class="form-text small">Sau khi phân công, giáo viên được chọn sẽ có thể theo dõi tiến độ, xem kết quả bài làm và tạo bài tập cho học sinh này.</div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary" id="btn-submit-assign">Xác nhận phân công</button>
          </div>
        </form>
      </div>
    </div>
  </div>

<jsp:include page="/common/footer.jsp" />

<!-- Admin Users Management Script -->
<script>
  let allUsersList = [];
  let allTeachersList = [];

  function getApiBase() {
    return window.MATH10_API_BASE_URL || 'http://localhost:8081/api/v1';
  }

  function getAuthSessionUser() {
    try {
      const raw = localStorage.getItem('math10_session_user');
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return { username: 'admin', role: 'ADMIN' };
  }

  function getAuthHeaders(extraHeaders = {}) {
    const su = getAuthSessionUser();
    return {
      'Content-Type': 'application/json',
      'X-Auth-User': su.username || 'admin',
      ...extraHeaders
    };
  }

  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function generateRandomPassword(targetInputId) {
    const chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$';
    let pwd = 'M10@';
    for (let i = 0; i < 6; i++) {
      pwd += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    const input = document.getElementById(targetInputId);
    if (input) {
      input.value = pwd;
      input.focus();
    }
  }

  function toggleTeacherSelectForCreate() {
    const role = document.getElementById('createUserRole').value;
    const group = document.getElementById('createUserTeacherGroup');
    if (group) {
      group.classList.toggle('d-none', role !== 'STUDENT');
    }
  }

  function toggleTeacherSelectForEdit() {
    const role = document.getElementById('editUserRole').value;
    const group = document.getElementById('editUserTeacherGroup');
    if (group) {
      group.classList.toggle('d-none', role !== 'STUDENT');
    }
  }

  async function loadUsers() {
    const tbody = document.getElementById('usersTableBody');
    const updateTimeEl = document.getElementById('lastUpdatedTime');
    tbody.innerHTML = `
      <tr>
        <td colspan="8" class="text-center py-5 text-muted">
          <div class="spinner-border text-primary spinner-border-sm me-2" role="status"></div>
          Đang cập nhật danh sách người dùng...
        </td>
      </tr>
    `;

    try {
      const res = await fetch(getApiBase() + '/users', {
        headers: getAuthHeaders(),
        credentials: 'include'
      });

      if (!res.ok) {
        throw new Error('Máy chủ trả về mã lỗi HTTP ' + res.status);
      }

      const users = await res.json();
      allUsersList = Array.isArray(users) ? users : [];
      allTeachersList = allUsersList.filter(u => u.role === 'TEACHER' && u.status === 'ACTIVE');

      // Update stat cards
      const adminCount = allUsersList.filter(u => u.role === 'ADMIN').length;
      const teacherCount = allUsersList.filter(u => u.role === 'TEACHER').length;
      const studentCount = allUsersList.filter(u => u.role === 'STUDENT').length;

      document.getElementById('stat-admin-count').textContent = adminCount;
      document.getElementById('stat-teacher-count').textContent = teacherCount;
      document.getElementById('stat-student-count').textContent = studentCount;
      document.getElementById('stat-total-count').textContent = allUsersList.length;

      // Populate teacher dropdowns
      populateTeacherOptions();

      // Render Table
      applyFilters();

      if (updateTimeEl) {
        const now = new Date();
        updateTimeEl.textContent = 'Cập nhật lúc ' + now.toLocaleTimeString('vi-VN');
      }
    } catch (err) {
      console.error('Lỗi khi tải danh sách người dùng:', err);
      tbody.innerHTML = `
        <tr>
          <td colspan="8" class="text-center py-5 text-danger">
            <p class="fw-semibold mb-1">Không thể tải danh sách tài khoản: \${escapeHtml(err.message)}</p>
            <p class="small text-muted mb-3">Vui lòng kiểm tra kết nối với Backend hoặc đăng nhập tài khoản ADMIN (admin).</p>
            <button class="btn btn-sm btn-outline-primary" onclick="loadUsers()">Thử lại</button>
          </td>
        </tr>
      `;
    }
  }

  function populateTeacherOptions() {
    const selects = [
      document.getElementById('createUserTeacherId'),
      document.getElementById('editUserTeacherId'),
      document.getElementById('assignTeacherSelect')
    ];

    selects.forEach(sel => {
      if (!sel) return;
      const currentVal = sel.value;
      sel.innerHTML = '<option value="">-- Chưa phân công giáo viên --</option>';
      allTeachersList.forEach(t => {
        const opt = document.createElement('option');
        opt.value = t.id;
        opt.textContent = `\${t.fullName} (@\${t.username}) [#\${t.id}]`;
        sel.appendChild(opt);
      });
      if (currentVal) sel.value = currentVal;
    });
  }

  function applyFilters() {
    const search = (document.getElementById('userSearchInput').value || '').toLowerCase().trim();
    const roleFilter = document.getElementById('roleFilter').value;
    const statusFilter = document.getElementById('statusFilter').value;

    const filtered = allUsersList.filter(u => {
      if (roleFilter !== 'ALL' && u.role !== roleFilter) return false;
      if (statusFilter !== 'ALL' && u.status !== statusFilter) return false;
      if (search) {
        const matchName = (u.fullName || '').toLowerCase().includes(search);
        const matchUser = (u.username || '').toLowerCase().includes(search);
        const matchEmail = (u.email || '').toLowerCase().includes(search);
        if (!matchName && !matchUser && !matchEmail) return false;
      }
      return true;
    });

    const badge = document.getElementById('filteredCountBadge');
    if (badge) badge.textContent = filtered.length + ' / ' + allUsersList.length + ' tài khoản';

    renderTable(filtered);
  }

  function renderTable(users) {
    const tbody = document.getElementById('usersTableBody');
    if (users.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="8" class="text-center py-5 text-muted">
            <p class="mb-0">Không tìm thấy người dùng nào phù hợp với bộ lọc hiện tại.</p>
          </td>
        </tr>
      `;
      return;
    }

    const teacherMap = {};
    allUsersList.forEach(u => {
      if (u.role === 'TEACHER') {
        teacherMap[u.id] = u.fullName;
      }
    });

    const currentLoggedInUser = getAuthSessionUser();

    tbody.innerHTML = users.map(u => {
      let roleBadge = '';
      if (u.role === 'ADMIN') {
        roleBadge = '<span class="badge bg-danger">ADMIN</span>';
      } else if (u.role === 'TEACHER') {
        roleBadge = '<span class="badge bg-primary">TEACHER</span>';
      } else {
        roleBadge = '<span class="badge bg-success">STUDENT</span>';
      }

      let statusBadge = '';
      if (u.status === 'ACTIVE') {
        statusBadge = '<span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">ACTIVE</span>';
      } else {
        statusBadge = '<span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">LOCKED</span>';
      }

      let teacherCol = '<span class="text-muted">--</span>';
      if (u.role === 'STUDENT') {
        if (u.teacherId && teacherMap[u.teacherId]) {
          teacherCol = `<strong class="text-primary">\${escapeHtml(teacherMap[u.teacherId])}</strong> <span class="small text-muted">(#\${u.teacherId})</span>`;
        } else if (u.teacherId) {
          teacherCol = `<span class="text-primary">GV #\${u.teacherId}</span>`;
        } else {
          teacherCol = '<span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Chưa phân công</span>';
        }
      }

      const isLocked = (u.status === 'LOCKED');
      const toggleBtnText = isLocked ? 'Mở khóa' : 'Khóa';
      const toggleBtnClass = isLocked ? 'btn-outline-success' : 'btn-outline-warning';
      const nextStatus = isLocked ? 'ACTIVE' : 'LOCKED';

      let assignBtn = '';
      if (u.role === 'STUDENT') {
        assignBtn = `<button class="btn btn-sm btn-outline-primary px-2 py-1" onclick="openAssignModal(\${u.id}, '\${escapeHtml(u.fullName)}', \${u.teacherId || 'null'})" title="Phân công giáo viên">Đổi GV</button>`;
      }

      // Do not allow deleting own account or primary admin #4
      const isSelf = (currentLoggedInUser && (currentLoggedInUser.username === u.username || currentLoggedInUser.id === u.id));
      let deleteBtn = '';
      if (!isSelf && u.id !== 4) {
        deleteBtn = `<button class="btn btn-sm btn-outline-danger px-2 py-1" onclick="handleDeleteUser(\${u.id}, '\${escapeHtml(u.fullName)}', '\${escapeHtml(u.username)}')" title="Xóa tài khoản">Xóa</button>`;
      }

      return `
        <tr>
          <td class="text-center"><span class="text-muted fw-bold">#\${u.id}</span></td>
          <td><strong class="text-dark">\${escapeHtml(u.fullName)}</strong></td>
          <td><code class="text-secondary fw-semibold">\${escapeHtml(u.username)}</code></td>
          <td class="text-muted small">\${escapeHtml(u.email || '-')}</td>
          <td class="text-center">\${roleBadge}</td>
          <td>\${teacherCol}</td>
          <td class="text-center">\${statusBadge}</td>
          <td class="text-end" style="white-space: nowrap;">
            <div class="d-inline-flex align-items-center justify-content-end gap-1 flex-nowrap">
              \${assignBtn}
              <button class="btn btn-sm btn-light border px-2 py-1" onclick="openEditModal(\${u.id})" title="Chỉnh sửa thông tin">Sửa</button>
              <button class="btn btn-sm \${toggleBtnClass} px-2 py-1" onclick="toggleUserStatus(\${u.id}, '\${nextStatus}')" title="\${toggleBtnText}">\${toggleBtnText}</button>
              \${deleteBtn}
            </div>
          </td>
        </tr>
      `;
    }).join('');
  }

  // Handle Delete User
  async function handleDeleteUser(userId, fullName, username) {
    const confirmMsg = `Bạn có chắc chắn muốn xóa vĩnh viễn tài khoản: \n- Họ tên: \${fullName}\n- Tên đăng nhập: @\${username} (#\${userId})\n\nLưu ý: Hành động này không thể hoàn tác!`;
    if (!confirm(confirmMsg)) return;

    try {
      const res = await fetch(getApiBase() + '/users/' + userId, {
        method: 'DELETE',
        headers: getAuthHeaders(),
        credentials: 'include'
      });

      if (!res.ok) {
        let msg = 'Xóa người dùng thất bại (' + res.status + ')';
        try {
          const body = await res.json();
          if (body.message) msg = body.message;
        } catch (_) {}
        throw new Error(msg);
      }

      alert('Đã xóa tài khoản ' + fullName + ' (@' + username + ') thành công!');
      loadUsers();
    } catch (err) {
      alert('Lỗi: ' + err.message);
    }
  }

  // Handle Create User
  async function handleCreateUser(e) {
    e.preventDefault();
    const alertEl = document.getElementById('createUserAlert');
    const spinner = document.getElementById('spinner-create-user');
    const submitBtn = document.getElementById('btn-submit-create-user');

    alertEl.className = 'alert d-none py-2 px-3 small';
    alertEl.textContent = '';
    spinner.classList.remove('d-none');
    submitBtn.disabled = true;

    const fullName = document.getElementById('createUserFullName').value.trim();
    const username = document.getElementById('createUserUsername').value.trim();
    const email = document.getElementById('createUserEmail').value.trim();
    const password = document.getElementById('createUserPassword').value;
    const role = document.getElementById('createUserRole').value;
    const teacherIdVal = document.getElementById('createUserTeacherId').value;
    const teacherId = (role === 'STUDENT' && teacherIdVal) ? parseInt(teacherIdVal, 10) : null;

    if (password.length < 6) {
      alertEl.className = 'alert alert-danger py-2 px-3 small';
      alertEl.textContent = 'Mật khẩu phải chứa ít nhất 6 ký tự.';
      spinner.classList.add('d-none');
      submitBtn.disabled = false;
      return;
    }

    try {
      const res = await fetch(getApiBase() + '/users', {
        method: 'POST',
        headers: getAuthHeaders(),
        credentials: 'include',
        body: JSON.stringify({
          fullName,
          username,
          email,
          password,
          role,
          teacherId
        })
      });

      if (!res.ok) {
        let msg = 'Tạo tài khoản thất bại (Mã lỗi ' + res.status + ')';
        try {
          const body = await res.json();
          if (body.message) msg = body.message;
        } catch (_) {}
        throw new Error(msg);
      }

      // Success
      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.textContent = 'Đã tạo tài khoản thành công!';

      setTimeout(() => {
        const modalEl = document.getElementById('adminCreateUserModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        document.getElementById('adminCreateUserForm').reset();
        alertEl.classList.add('d-none');
        loadUsers();
      }, 700);

    } catch (err) {
      alertEl.className = 'alert alert-danger py-2 px-3 small';
      alertEl.textContent = err.message || 'Lỗi khi gửi dữ liệu lên máy chủ.';
    } finally {
      spinner.classList.add('d-none');
      submitBtn.disabled = false;
    }
  }

  // Open Edit Modal
  function openEditModal(userId) {
    const user = allUsersList.find(u => u.id === userId);
    if (!user) return;

    document.getElementById('editUserId').value = user.id;
    document.getElementById('editUserFullName').value = user.fullName || '';
    document.getElementById('editUserUsername').value = user.username || '';
    document.getElementById('editUserEmail').value = user.email || '';
    document.getElementById('editUserRole').value = user.role;
    document.getElementById('editUserPassword').value = '';
    
    populateTeacherOptions();
    if (user.teacherId) {
      document.getElementById('editUserTeacherId').value = user.teacherId;
    } else {
      document.getElementById('editUserTeacherId').value = '';
    }

    toggleTeacherSelectForEdit();
    const alertEl = document.getElementById('editUserAlert');
    alertEl.className = 'alert d-none';

    const modalEl = document.getElementById('adminEditUserModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
  }

  // Handle Edit User
  async function handleEditUser(e) {
    e.preventDefault();
    const userId = document.getElementById('editUserId').value;
    const alertEl = document.getElementById('editUserAlert');
    const submitBtn = document.getElementById('btn-submit-edit-user');

    alertEl.className = 'alert d-none';
    submitBtn.disabled = true;

    const fullName = document.getElementById('editUserFullName').value.trim();
    const username = document.getElementById('editUserUsername').value.trim();
    const email = document.getElementById('editUserEmail').value.trim();
    let password = document.getElementById('editUserPassword').value;
    const role = document.getElementById('editUserRole').value;
    const teacherIdVal = document.getElementById('editUserTeacherId').value;
    const teacherId = (role === 'STUDENT' && teacherIdVal) ? parseInt(teacherIdVal, 10) : null;

    if (!password) {
      alertEl.className = 'alert alert-warning py-2 px-3 small';
      alertEl.textContent = 'Vui lòng nhập mật khẩu mới hoặc bấm "Tạo mật khẩu mới" để cập nhật.';
      submitBtn.disabled = false;
      return;
    }

    try {
      const res = await fetch(getApiBase() + '/users/' + userId, {
        method: 'PUT',
        headers: getAuthHeaders(),
        credentials: 'include',
        body: JSON.stringify({
          fullName,
          username,
          email,
          password,
          role,
          teacherId
        })
      });

      if (!res.ok) {
        let msg = 'Cập nhật tài khoản thất bại (' + res.status + ')';
        try {
          const body = await res.json();
          if (body.message) msg = body.message;
        } catch (_) {}
        throw new Error(msg);
      }

      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.textContent = 'Cập nhật thành công!';

      setTimeout(() => {
        const modalEl = document.getElementById('adminEditUserModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        loadUsers();
      }, 700);
    } catch (err) {
      alertEl.className = 'alert alert-danger py-2 px-3 small';
      alertEl.textContent = err.message;
    } finally {
      submitBtn.disabled = false;
    }
  }

  // Toggle user status (ACTIVE / LOCKED)
  async function toggleUserStatus(userId, nextStatus) {
    const actionName = (nextStatus === 'LOCKED') ? 'khoá' : 'kích hoạt lại';
    if (!confirm('Bạn có chắc muốn ' + actionName + ' tài khoản này không?')) return;

    try {
      let res;
      try {
        res = await fetch(getApiBase() + '/users/' + userId + '/status', {
          method: 'PUT',
          headers: getAuthHeaders(),
          credentials: 'include',
          body: JSON.stringify({ status: nextStatus })
        });
      } catch (fetchErr) {
        // Fallback to PATCH if PUT had network error
        res = await fetch(getApiBase() + '/users/' + userId + '/status', {
          method: 'PATCH',
          headers: getAuthHeaders(),
          credentials: 'include',
          body: JSON.stringify({ status: nextStatus })
        });
      }

      if (!res.ok && res.status === 405) {
        res = await fetch(getApiBase() + '/users/' + userId + '/status', {
          method: 'PATCH',
          headers: getAuthHeaders(),
          credentials: 'include',
          body: JSON.stringify({ status: nextStatus })
        });
      }

      if (!res.ok) {
        const errJson = await res.json().catch(() => null);
        throw new Error(errJson?.detail || ('Không thể thay đổi trạng thái (' + res.status + ')'));
      }

      // Success
      loadUsers();
    } catch (err) {
      if (err.message && (err.message.includes('Failed to fetch') || err.message.includes('NetworkError'))) {
        alert('Không thể kết nối đến máy chủ Backend (Port 8081). Vui lòng kiểm tra lại dịch vụ Backend.');
      } else {
        alert('Lỗi: ' + err.message);
      }
    }
  }

  // Open Assign Teacher Modal
  function openAssignModal(studentId, studentName, teacherId) {
    document.getElementById('assignStudentId').value = studentId;
    document.getElementById('assignStudentName').textContent = studentName + ' (#' + studentId + ')';
    populateTeacherOptions();
    document.getElementById('assignTeacherSelect').value = teacherId || '';

    const alertEl = document.getElementById('assignTeacherAlert');
    alertEl.className = 'alert d-none';

    const modalEl = document.getElementById('adminAssignTeacherModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
  }

  // Handle Assign Teacher Submit
  async function handleAssignTeacher(e) {
    e.preventDefault();
    const studentId = document.getElementById('assignStudentId').value;
    const teacherIdVal = document.getElementById('assignTeacherSelect').value;
    const teacherId = teacherIdVal ? parseInt(teacherIdVal, 10) : null;
    const alertEl = document.getElementById('assignTeacherAlert');
    const submitBtn = document.getElementById('btn-submit-assign');

    submitBtn.disabled = true;
    alertEl.className = 'alert d-none';

    try {
      const res = await fetch(getApiBase() + '/users/' + studentId + '/teacher', {
        method: 'PUT',
        headers: getAuthHeaders(),
        credentials: 'include',
        body: JSON.stringify({ teacherId })
      });

      if (!res.ok) {
        throw new Error('Không thể phân công giáo viên (' + res.status + ')');
      }

      alertEl.className = 'alert alert-success py-2 px-3 small';
      alertEl.textContent = 'Phân công thành công!';

      setTimeout(() => {
        const modalEl = document.getElementById('adminAssignTeacherModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        loadUsers();
      }, 700);
    } catch (err) {
      alertEl.className = 'alert alert-danger py-2 px-3 small';
      alertEl.textContent = err.message;
    } finally {
      submitBtn.disabled = false;
    }
  }

  // Auto load when page is ready
  document.addEventListener('DOMContentLoaded', () => {
    loadUsers();
  });
</script>
