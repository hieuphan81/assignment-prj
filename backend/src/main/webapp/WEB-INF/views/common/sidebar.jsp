<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" id="app-sidebar">
  <a class="brand" href="${pageContext.request.contextPath}/">
    <div class="brand-mark">
      <svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg>
    </div>
    <span>Math10 AI</span>
  </a>

  <!-- Determine current active role: default to session role, or student -->
  <c:set var="userRole" value="${not empty sessionScope['math10.user'] ? sessionScope['math10.user'].role : 'STUDENT'}" />

  <!-- 1. KHÔNG GIAN HỌC SINH -->
  <div class="role-nav-group ${userRole == 'STUDENT' ? '' : 'd-none'}" id="group-student">
    <div class="role-label">KHÔNG GIAN HỌC SINH</div>
    <nav class="side-nav mb-3">
      <a class="side-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/" data-page="dashboard">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg></span>
        <span>Tổng quan</span>
      </a>
      <a class="side-link ${param.active == 'lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/lessons" data-page="lessons">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></span>
        <span>Bài học</span>
      </a>
      <a class="side-link ${param.active == 'formulas' ? 'active' : ''}" href="${pageContext.request.contextPath}/formulas" data-page="formulas">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M4 4h16v16H4z"/><path d="M4 12h16M12 4v16"/></svg></span>
        <span>Công thức Toán 10</span>
      </a>
      <a class="side-link ${param.active == 'practice' ? 'active' : ''}" href="${pageContext.request.contextPath}/practice" data-page="practice">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M9 12.5 11 14.5 15.5 9.5"/></svg></span>
        <span>Luyện tập</span>
      </a>
      <a class="side-link ${param.active == 'ai-tutor' ? 'active' : ''}" href="${pageContext.request.contextPath}/ai-tutor" data-page="ai-tutor">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="m12 3 1.7 5.3L19 10l-5.3 1.7L12 17l-1.7-5.3L5 10l5.3-1.7z"/></svg></span>
        <span>Gia sư AI</span>
      </a>
      <a class="side-link ${param.active == 'history' ? 'active' : ''}" href="${pageContext.request.contextPath}/history" data-page="history">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></span>
        <span>Lịch sử học</span>
      </a>
      <a class="side-link ${param.active == 'progress' ? 'active' : ''}" href="${pageContext.request.contextPath}/progress" data-page="progress">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></span>
        <span>Tiến độ</span>
      </a>
    </nav>
  </div>

  <!-- 2. KHÔNG GIAN GIÁO VIÊN -->
  <div class="role-nav-group ${userRole == 'TEACHER' ? '' : 'd-none'}" id="group-teacher">
    <div class="role-label">KHÔNG GIAN GIÁO VIÊN</div>
    <nav class="side-nav mb-3">
      <a class="side-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/" data-page="dashboard">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg></span>
        <span>Tổng quan</span>
      </a>
      <a class="side-link ${param.active == 'teacher-students' ? 'active' : ''}" href="${pageContext.request.contextPath}/teacher/students" data-page="students">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
        <span>Học sinh</span>
      </a>
      <a class="side-link ${param.active == 'lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/lessons" data-page="lessons">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></span>
        <span>Bài giảng</span>
      </a>
      <a class="side-link ${param.active == 'teacher-questions' ? 'active' : ''}" href="${pageContext.request.contextPath}/teacher/questions" data-page="questions">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="4" y="4" width="6" height="6" rx="1"/><rect x="14" y="4" width="6" height="6" rx="1"/><rect x="4" y="14" width="6" height="6" rx="1"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg></span>
        <span>Ngân hàng câu hỏi</span>
      </a>
      <a class="side-link ${param.active == 'teacher-generator' ? 'active' : ''}" href="${pageContext.request.contextPath}/teacher/questions?openAi=true" data-page="generator" onclick="if (window.location.pathname.includes('/teacher/questions')) { if (window.openGenerateAiModal) window.openGenerateAiModal(); return false; }">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="m12 3 1.7 5.3L19 10l-5.3 1.7L12 17l-1.7-5.3L5 10l5.3-1.7z"/></svg></span>
        <span>Tạo câu hỏi AI</span>
      </a>
      <a class="side-link ${param.active == 'progress' ? 'active' : ''}" href="${pageContext.request.contextPath}/progress" data-page="progress">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></span>
        <span>Kết quả học tập</span>
      </a>
    </nav>
  </div>

  <!-- 3. KHÔNG GIAN QUẢN TRỊ VIÊN -->
  <div class="role-nav-group ${userRole == 'ADMIN' ? '' : 'd-none'}" id="group-admin">
    <div class="role-label">KHÔNG GIAN QUẢN TRỊ VIÊN</div>
    <nav class="side-nav mb-3">
      <a class="side-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/" data-page="dashboard">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg></span>
        <span>Tổng quan</span>
      </a>
      <a class="side-link ${param.active == 'admin-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users" data-page="users">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
        <span>Người dùng</span>
      </a>
      <a class="side-link ${param.active == 'lessons' ? 'active' : ''}" href="${pageContext.request.contextPath}/lessons" data-page="lessons">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10M6 10h10"/></svg></span>
        <span>Bài học</span>
      </a>
      <a class="side-link ${param.active == 'teacher-questions' ? 'active' : ''}" href="${pageContext.request.contextPath}/teacher/questions" data-page="questions">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M9 12.5 11 14.5 15.5 9.5"/></svg></span>
        <span>Câu hỏi</span>
      </a>
      <a class="side-link ${param.active == 'admin-settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/settings" data-page="settings">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>
        <span>Cấu hình AI</span>
      </a>
    </nav>
  </div>

  <div class="side-bottom">
    <div class="support-card">
      <strong>Toán 10 KNTT</strong>
      <p>SGK Kết nối tri thức với cuộc sống. 9 chủ đề, 27 bài học.</p>
      <a href="${pageContext.request.contextPath}/lessons">Xem mục lục &rarr;</a>
    </div>
    <div class="user-mini" id="sidebar-user-badge">
      <c:choose>
        <c:when test="${not empty sessionScope['math10.user']}">
          <div class="avatar bg-primary text-white" id="sidebar-user-avatar">${sessionScope['math10.user'].initial}</div>
          <div>
            <div class="user-name" id="sidebar-user-name">${sessionScope['math10.user'].fullName}</div>
            <div class="user-meta" id="sidebar-user-role">${sessionScope['math10.user'].role}</div>
          </div>
        </c:when>
        <c:otherwise>
          <div class="avatar" id="sidebar-user-avatar">M</div>
          <div>
            <div class="user-name" id="sidebar-user-name">Khách xem thử</div>
            <div class="user-meta" id="sidebar-user-role">Chế độ trải nghiệm</div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</aside>
