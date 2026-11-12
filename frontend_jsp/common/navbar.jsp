<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="topbar">
  <div class="d-flex align-items-center gap-3">
    <button class="icon-button mobile-toggle d-md-none" id="mobile-toggle" aria-label="Menu" type="button">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
    </button>
    <div class="breadcrumb-title">
      Math10 AI / <strong>${not empty param.pageTitle ? param.pageTitle : 'Không gian học tập'}</strong>
    </div>
  </div>

  <div class="top-actions">
    <!-- Global search (Ctrl+K) -->
    <div class="searchbox position-relative" id="global-search-container">
      <span class="search-symbol" style="display:inline-flex;align-items:center;justify-content:center;">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="text-muted"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
      </span>
      <input type="search" id="global-search" placeholder="Tìm bài học, chủ đề... (Ctrl+K)" autocomplete="off" aria-label="Tìm kiếm">
      <div class="search-results d-none shadow-lg" id="global-search-results" role="listbox" aria-label="Kết quả tìm kiếm"></div>
    </div>

    <!-- Role select preview (when not logged in) -->
    <select class="role-select" id="role-select" aria-label="Xem thử vai trò">
      <option value="student">Xem: Học sinh</option>
      <option value="teacher">Xem: Giáo viên</option>
      <option value="admin">Xem: Quản trị</option>
    </select>

    <!-- Auth Button / User Dropdown -->
    <div id="topbar-user-area">
      <c:choose>
        <c:when test="${not empty sessionScope['math10.user']}">
          <span class="user-pill d-inline-flex align-items-center gap-2 user-profile-trigger" onclick="openStudentProfileModal()" role="button" tabindex="0" title="Nhấn để xem và sửa đổi thông tin cá nhân">
            <span class="avatar avatar-sm bg-primary text-white" style="width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;font-size:12px;">${sessionScope['math10.user'].initial}</span>
            <strong id="topbar-user-name">${sessionScope['math10.user'].fullName}</strong>
            <span class="badge bg-secondary" id="topbar-user-role">${sessionScope['math10.user'].role}</span>
            <svg class="text-primary ms-1" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
          </span>
          <button class="btn btn-outline-danger btn-sm ms-2" id="topbar-logout-btn" onclick="jspLogout()">Đăng xuất</button>
        </c:when>
        <c:otherwise>
          <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/login" id="topbar-login-btn">Đăng nhập</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<script>
(function() {
  const ctx = '${pageContext.request.contextPath}';
  const lessonsData = [
    { id: 1, chapter: 'Chương I. Mệnh đề và tập hợp', title: 'Bài 1. Mệnh đề' },
    { id: 2, chapter: 'Chương I. Mệnh đề và tập hợp', title: 'Bài 2. Tập hợp và các phép toán trên tập hợp' },
    { id: 3, chapter: 'Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', title: 'Bài 3. Bất phương trình bậc nhất hai ẩn' },
    { id: 4, chapter: 'Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', title: 'Bài 4. Hệ bất phương trình bậc nhất hai ẩn' },
    { id: 5, chapter: 'Chương III. Hệ thức lượng trong tam giác', title: 'Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°' },
    { id: 6, chapter: 'Chương III. Hệ thức lượng trong tam giác', title: 'Bài 6. Hệ thức lượng trong tam giác' },
    { id: 7, chapter: 'Chương IV. Vectơ', title: 'Bài 7. Các khái niệm mở đầu về vectơ' },
    { id: 8, chapter: 'Chương IV. Vectơ', title: 'Bài 8. Tổng và hiệu của hai vectơ' },
    { id: 9, chapter: 'Chương IV. Vectơ', title: 'Bài 9. Tích của một vectơ với một số' },
    { id: 10, chapter: 'Chương IV. Vectơ', title: 'Bài 10. Vectơ trong mặt phẳng toạ độ' },
    { id: 11, chapter: 'Chương IV. Vectơ', title: 'Bài 11. Tích vô hướng của hai vectơ' },
    { id: 12, chapter: 'Chương V. Các số đặc trưng đo xu thế trung tâm', title: 'Bài 12. Số gần đúng và sai số' },
    { id: 13, chapter: 'Chương V. Các số đặc trưng đo xu thế trung tâm', title: 'Bài 13. Các số đặc trưng đo xu thế trung tâm' },
    { id: 14, chapter: 'Chương V. Các số đặc trưng đo xu thế trung tâm', title: 'Bài 14. Các số đặc trưng đo độ phân tán' },
    { id: 15, chapter: 'Chương VI. Hàm số, đồ thị và ứng dụng', title: 'Bài 15. Hàm số và đồ thị' },
    { id: 16, chapter: 'Chương VI. Hàm số, đồ thị và ứng dụng', title: 'Bài 16. Hàm số bậc hai' },
    { id: 17, chapter: 'Chương VI. Hàm số, đồ thị và ứng dụng', title: 'Bài 17. Dấu của tam thức bậc hai' },
    { id: 18, chapter: 'Chương VI. Hàm số, đồ thị và ứng dụng', title: 'Bài 18. Phương trình quy về phương trình bậc hai' },
    { id: 19, chapter: 'Chương VII. Phương pháp toạ độ trong mặt phẳng', title: 'Bài 19. Phương trình đường thẳng' },
    { id: 20, chapter: 'Chương VII. Phương pháp toạ độ trong mặt phẳng', title: 'Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách' },
    { id: 21, chapter: 'Chương VII. Phương pháp toạ độ trong mặt phẳng', title: 'Bài 21. Đường tròn trong mặt phẳng toạ độ' },
    { id: 22, chapter: 'Chương VII. Phương pháp toạ độ trong mặt phẳng', title: 'Bài 22. Ba đường conic' },
    { id: 23, chapter: 'Chương VIII. Đại số tổ hợp', title: 'Bài 23. Quy tắc đếm' },
    { id: 24, chapter: 'Chương VIII. Đại số tổ hợp', title: 'Bài 24. Hoán vị, chỉnh hợp và tổ hợp' },
    { id: 25, chapter: 'Chương VIII. Đại số tổ hợp', title: 'Bài 25. Nhị thức Newton' },
    { id: 26, chapter: 'Chương IX. Tính xác suất theo định nghĩa cổ điển', title: 'Bài 26. Biến cố và định nghĩa cổ điển của xác suất' },
    { id: 27, chapter: 'Chương IX. Tính xác suất theo định nghĩa cổ điển', title: 'Bài 27. Thực hành tính xác suất trong thực tế' }
  ];

  const quickFeatures = [
    { title: 'Luyện tập Trắc nghiệm (MCQ)', desc: 'Ôn luyện câu hỏi trắc nghiệm Toán 10', url: ctx + '/practice?tab=mcq', tag: 'Luyện tập' },
    { title: 'Luyện tập Tự luận (AI chấm bài)', desc: 'Làm bài tự luận, nhận giải thích từng bước từ AI', url: ctx + '/practice?tab=essay', tag: 'Tự luận' },
    { title: 'Gia sư AI Toán 10', desc: 'Trò chuyện và hỏi bài Gia sư AI 24/7', url: ctx + '/ai-tutor', tag: 'Gia sư AI' },
    { title: 'Ngân hàng câu hỏi & AI', desc: 'Kho đề trắc nghiệm, tự luận và sinh câu hỏi AI', url: ctx + '/teacher/questions', tag: 'Câu hỏi' },
    { title: 'Tra cứu Công thức Toán 10', desc: '10 thẻ công thức trọng tâm chương trình SGK', url: ctx + '/formulas', tag: 'Công thức' },
    { title: 'Tiến độ học tập', desc: 'Báo cáo tỉ lệ hoàn thành bài học và kết quả làm bài', url: ctx + '/progress', tag: 'Tiến độ' },
    { title: 'Lịch sử học & làm bài', desc: 'Danh sách các lần luyện tập và điểm số', url: ctx + '/history', tag: 'Lịch sử' }
  ];

  function stripAccents(str) {
    if (!str) return '';
    return str.toString().toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd');
  }

  function initGlobalSearch() {
    const input = document.getElementById('global-search');
    const resultsBox = document.getElementById('global-search-results');
    if (!input || !resultsBox) return;

    function renderResults(query) {
      const q = (query || '').trim();
      const rawQ = stripAccents(q);

      if (!rawQ) {
        resultsBox.innerHTML = '';
        resultsBox.classList.add('d-none');
        return;
      }

      // Check matching lessons
      const matchedLessons = lessonsData.filter(function(item) {
        const full = stripAccents(item.id + ' ' + item.title + ' ' + item.chapter);
        return full.includes(rawQ);
      });

      // Check matching quick features
      const matchedFeatures = quickFeatures.filter(function(feat) {
        const full = stripAccents(feat.title + ' ' + feat.desc + ' ' + feat.tag);
        return full.includes(rawQ);
      });

      if (matchedLessons.length === 0 && matchedFeatures.length === 0) {
        resultsBox.innerHTML = '<div class="search-empty text-center py-3 text-muted">Không tìm thấy bài học hoặc chức năng phù hợp với "<strong>' + encodeXml(q) + '</strong>"</div>';
        resultsBox.classList.remove('d-none');
        return;
      }

      let html = '';

      if (matchedFeatures.length > 0) {
        matchedFeatures.slice(0, 3).forEach(function(feat) {
          html += '<a href="' + feat.url + '" class="search-result text-decoration-none d-flex align-items-center gap-2 p-2 border-bottom">'
            + '<span class="badge bg-success-subtle text-success border border-success-subtle">' + encodeXml(feat.tag) + '</span>'
            + '<div class="search-result-copy" style="min-width:0;flex:1;">'
            + '<strong class="text-dark d-block text-truncate">' + encodeXml(feat.title) + '</strong>'
            + '<small class="text-muted d-block text-truncate">' + encodeXml(feat.desc) + '</small>'
            + '</div></a>';
        });
      }

      if (matchedLessons.length > 0) {
        matchedLessons.slice(0, 8).forEach(function(l) {
          html += '<a href="' + ctx + '/lesson-detail?id=' + l.id + '" class="search-result text-decoration-none d-flex align-items-center gap-2 p-2 border-bottom">'
            + '<span class="badge bg-primary-subtle text-primary border border-primary-subtle">Bài ' + l.id + '</span>'
            + '<div class="search-result-copy" style="min-width:0;flex:1;">'
            + '<strong class="text-dark d-block text-truncate">' + encodeXml(l.title) + '</strong>'
            + '<small class="text-muted d-block text-truncate">' + encodeXml(l.chapter) + '</small>'
            + '</div></a>';
        });
      }

      resultsBox.innerHTML = html;
      resultsBox.classList.remove('d-none');
    }

    function encodeXml(str) {
      if (!str) return '';
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    input.addEventListener('input', function(e) {
      renderResults(e.target.value);
    });

    input.addEventListener('focus', function(e) {
      if (e.target.value.trim()) {
        renderResults(e.target.value);
      }
    });

    input.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        resultsBox.classList.add('d-none');
      } else if (e.key === 'Enter') {
        const firstLink = resultsBox.querySelector('.search-result');
        if (firstLink) {
          e.preventDefault();
          window.location.href = firstLink.getAttribute('href');
        }
      }
    });

    // Close on outside click
    document.addEventListener('click', function(e) {
      if (!e.target.closest('#global-search-container')) {
        resultsBox.classList.add('d-none');
      }
    });

    // Ctrl+K or Cmd+K shortcut
    document.addEventListener('keydown', function(e) {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        if (!e.target.closest('input, textarea, select')) {
          e.preventDefault();
          input.focus();
          input.select();
        }
      }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGlobalSearch);
  } else {
    initGlobalSearch();
  }
})();
</script>
