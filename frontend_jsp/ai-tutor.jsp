<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Gia sư AI giải toán từng bước — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="ai-tutor" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Gia sư AI" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow text-primary fw-semibold">GIA SƯ TOÁN 10 AI &bull; GOOGLE GEMINI POWERED</div>
        <h1 class="mb-2">Gia sư AI giải toán từng bước</h1>
        <p class="text-muted mb-0">Nhập bài toán hoặc đính kèm ảnh đề bài. Gia sư AI sẽ phân tích giả thiết, trích dẫn công thức SGK và hướng dẫn chi tiết từng bước giải.</p>
      </div>
      <div>
        <button class="btn btn-outline-secondary btn-sm" id="ai-tutor-clear-btn" type="button">Xoá lịch sử hội thoại</button>
      </div>
    </div>

    <div class="row g-4">
      <div class="col-lg-8">
        <!-- Input Card -->
        <div class="cardx card-pad mb-4">
          <h2 class="card-title h5 mb-3">Đặt câu hỏi cho Gia sư AI</h2>
          <form id="ai-tutor-ask-form">
            <div class="mb-3">
              <label class="form-label fw-semibold" for="ai-tutor-problem-input">Đề bài hoặc câu hỏi toán của bạn:</label>
              <textarea class="form-control" id="ai-tutor-problem-input" rows="4" placeholder="Ví dụ: Cho tam giác ABC có a = 5, b = 7, c = 8. Hãy hướng dẫn em tính góc A và diện tích tam giác này..."></textarea>
            </div>

            <!-- Optional Image Attachment -->
            <div class="mb-3">
              <div class="d-flex flex-wrap align-items-center gap-2">
                <label class="btn btn-sm btn-light border mb-0 d-inline-flex align-items-center gap-1" for="ai-tutor-image-file" style="cursor: pointer;">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg> Đính kèm ảnh đề bài (tối đa 5MB)
                </label>
                <input type="file" id="ai-tutor-image-file" accept="image/jpeg,image/png,image/webp" class="d-none">
                <span class="small text-muted" id="ai-tutor-image-name">Chưa chọn ảnh</span>
                <button type="button" class="btn btn-sm btn-link text-danger d-none p-0" id="ai-tutor-remove-image">Bỏ ảnh</button>
              </div>
              <div id="ai-tutor-image-preview-box" class="mt-2 d-none">
                <img id="ai-tutor-image-preview" src="" alt="Ảnh đề bài" class="img-thumbnail" style="max-height: 120px; border-radius: 8px;">
              </div>
            </div>

            <button class="btn btn-primary w-100 py-2 fw-semibold shadow-xs" type="submit" id="ai-tutor-send-btn">
              Bắt đầu thảo luận cùng Gia sư AI
            </button>
          </form>
        </div>

        <!-- Chat / Dialogue Stream Container -->
        <div class="cardx card-pad" id="ai-tutor-dialogue-card">
          <div class="section-head mb-3 d-flex justify-content-between align-items-center">
            <h2 class="card-title h5 mb-0">Hội thoại cùng Gia sư AI</h2>
            <span class="badge bg-primary px-2 py-1" id="ai-tutor-turn-badge">Sẵn sàng</span>
          </div>

          <div id="ai-tutor-messages" class="d-flex flex-column gap-3">
            <div class="tutor-bubble p-3 rounded-3 bg-light border border-primary-subtle">
              <div class="tutor-head d-flex align-items-center gap-2 mb-2 text-primary fw-bold">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="10" rx="2"/><circle cx="12" cy="5" r="2"/><path d="M12 7v4M8 16h.01M16 16h.01"/></svg>
                <span>Gia sư AI Toán 10</span>
              </div>
              <p class="mb-0 text-secondary">
                Chào bạn! Mình là Gia sư AI đồng hành cùng bạn học Toán 10. Hãy gửi đề bài toán (bằng chữ hoặc tải ảnh đề bài) để mình phân tích và hướng dẫn bạn từng bước tự giải quyết bài toán nhé!
              </p>
            </div>
          </div>

          <!-- Follow-up input form for Socratic steps -->
          <div class="mt-4 pt-3 border-top d-none" id="ai-tutor-followup-box">
            <label class="form-label fw-bold small text-dark" for="ai-tutor-step-input">Hỏi tiếp hoặc nhập bước giải tiếp theo của bạn:</label>
            <div class="input-group">
              <input type="text" class="form-control" id="ai-tutor-step-input" placeholder="Ví dụ: Em tính được cos A = 0.5 rồi, bước tiếp theo làm sao ạ?">
              <button class="btn btn-primary px-3" id="ai-tutor-step-submit-btn" type="button">Gửi tiếp &rarr;</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Right column: Rules & Local History -->
      <div class="col-lg-4">
        <div class="cardx card-pad mb-4">
          <div class="section-head mb-2">
            <h2 class="card-title h6 fw-bold">Nguyên tắc hướng dẫn Socratic</h2>
          </div>
          <p class="small text-muted mb-2">Phương pháp giúp bạn hiểu bản chất:</p>
          <ul class="small text-muted ps-3 mb-0 lh-lg">
            <li><strong>Chỉ rõ lý thuyết:</strong> Nêu định lý, công thức Toán 10 áp dụng.</li>
            <li><strong>Từng bước tư duy:</strong> Hướng dẫn phép tính trung gian (như $\Delta, \cos A, x_I$).</li>
            <li><strong>Không làm hộ máy móc:</strong> Giúp học sinh tự đưa ra kết quả cuối.</li>
            <li><strong>Hỗ trợ công thức:</strong> Biểu diễn công thức chuẩn đẹp với LaTeX.</li>
          </ul>
        </div>

        <div class="cardx card-pad">
          <div class="section-head mb-2">
            <h2 class="card-title h6 fw-bold">Các câu hỏi gần đây</h2>
          </div>
          <div id="ai-tutor-history-list" class="small text-muted">
            <p class="mb-0">Chưa có câu hỏi nào gần đây.</p>
          </div>
        </div>
      </div>
    </div>
  </main>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const askForm = document.getElementById('ai-tutor-ask-form');
      const problemInput = document.getElementById('ai-tutor-problem-input');
      const sendBtn = document.getElementById('ai-tutor-send-btn');
      const imageFileInput = document.getElementById('ai-tutor-image-file');
      const imageName = document.getElementById('ai-tutor-image-name');
      const removeImageBtn = document.getElementById('ai-tutor-remove-image');
      const previewBox = document.getElementById('ai-tutor-image-preview-box');
      const previewImg = document.getElementById('ai-tutor-image-preview');

      const messagesContainer = document.getElementById('ai-tutor-messages');
      const followupBox = document.getElementById('ai-tutor-followup-box');
      const stepInput = document.getElementById('ai-tutor-step-input');
      const stepSubmitBtn = document.getElementById('ai-tutor-step-submit-btn');
      const turnBadge = document.getElementById('ai-tutor-turn-badge');
      const clearBtn = document.getElementById('ai-tutor-clear-btn');
      const historyList = document.getElementById('ai-tutor-history-list');

      let currentBase64 = null;
      let currentMime = null;
      let currentOriginalQuestion = '';
      let turnsHistory = [];
      let stepNumber = 1;

      // Handle Image Selection
      if (imageFileInput) {
        imageFileInput.addEventListener('change', (e) => {
          const file = e.target.files[0];
          if (!file) return;
          if (file.size > 5 * 1024 * 1024) {
            alert('Kích thước ảnh tối đa là 5MB.');
            imageFileInput.value = '';
            return;
          }
          currentMime = file.type;
          imageName.textContent = file.name;
          removeImageBtn.classList.remove('d-none');

          const reader = new FileReader();
          reader.onload = (re) => {
            const dataUrl = re.target.result;
            currentBase64 = dataUrl.split(',')[1];
            previewImg.src = dataUrl;
            previewBox.classList.remove('d-none');
          };
          reader.readAsDataURL(file);
        });
      }

      if (removeImageBtn) {
        removeImageBtn.addEventListener('click', () => {
          imageFileInput.value = '';
          currentBase64 = null;
          currentMime = null;
          imageName.textContent = 'Chưa chọn ảnh';
          removeImageBtn.classList.add('d-none');
          previewBox.classList.add('d-none');
          previewImg.src = '';
        });
      }

      function renderMath() {
        if (window.MathJax && window.MathJax.typesetPromise) {
          window.MathJax.typesetPromise();
        }
      }

      function appendUserMessage(text, imageSrc) {
        const div = document.createElement('div');
        div.className = 'user-bubble p-3 rounded-3 bg-white border shadow-xs align-self-end text-end';
        div.style.maxWidth = '85%';
        let html = '<div class="fw-bold text-dark small mb-1">Bạn:</div>';
        if (imageSrc) {
          html += '<img src="' + imageSrc + '" class="img-thumbnail mb-2 d-inline-block" style="max-height: 120px;"><br>';
        }
        html += '<div class="text-secondary text-start">' + text.replace(/\n/g, '<br>') + '</div>';
        div.innerHTML = html;
        messagesContainer.appendChild(div);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      }

      function appendTutorMessage(text) {
        const div = document.createElement('div');
        div.className = 'tutor-bubble p-3 rounded-3 bg-light border border-primary-subtle align-self-start';
        div.style.maxWidth = '90%';
        div.innerHTML = '<div class="tutor-head d-flex align-items-center gap-2 mb-2 text-primary fw-bold">'
          + '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="10" rx="2"/><circle cx="12" cy="5" r="2"/><path d="M12 7v4M8 16h.01M16 16h.01"/></svg><span>Gia sư AI Toán 10</span></div>'
          + '<div class="tutor-content text-dark lh-lg">' + formatTutorContent(text) + '</div>';
        messagesContainer.appendChild(div);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        renderMath();
      }

      function appendLoadingBubble() {
        const div = document.createElement('div');
        div.id = 'ai-tutor-loading-bubble';
        div.className = 'tutor-bubble p-3 rounded-3 bg-light border border-light align-self-start text-muted';
        div.innerHTML = '<div class="d-flex align-items-center gap-2">'
          + '<div class="spinner-border spinner-border-sm text-primary" role="status"></div>'
          + '<span>Gia sư AI đang suy nghĩ và chuẩn bị lời giải...</span>'
          + '</div>';
        messagesContainer.appendChild(div);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        return div;
      }

      function formatTutorContent(raw) {
        if (!raw) return '';
        let s = String(raw).trim();

        // 1. If wrapped in JSON string, parse or extract
        if (s.startsWith('{') && s.includes('"message"')) {
          try {
            const parsed = JSON.parse(s);
            if (parsed && parsed.message) s = parsed.message;
          } catch(e) {
            const m = s.match(/"message"\s*:\s*"([\s\S]*?)"(?:\s*\}|,\s*"[a-zA-Z0-9_-]+")/);
            if (m && m[1]) {
              s = m[1].replace(/\\n/g, '\n').replace(/\\"/g, '"').replace(/\\\\/g, '\\');
            } else {
              s = s.replace(/^\s*\{\s*"action"[\s\S]*?"message"\s*:\s*"/, '')
                   .replace(/"\s*\}\s*$/, '')
                   .replace(/\\n/g, '\n').replace(/\\"/g, '"');
            }
          }
        }

        // 2. Unescape escaped literal newlines \n
        s = s.replace(/\\n/g, '\n');

        // 3. Format Markdown headers
        s = s.replace(/^###\s*(.+)$/gm, '<h5 class="fw-bold text-primary mt-3 mb-2">$1</h5>');
        s = s.replace(/^##\s*(.+)$/gm, '<h5 class="fw-bold text-primary mt-3 mb-2">$1</h5>');
        s = s.replace(/^#\s*(.+)$/gm, '<h4 class="fw-bold text-primary mt-3 mb-2">$1</h4>');

        // 4. Format Markdown bold and italic
        s = s.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        s = s.replace(/\*(.*?)\*/g, '<em>$1</em>');

        // 5. Format bullet points
        s = s.replace(/^\s*[-*]\s+(.+)$/gm, '<div class="d-flex align-items-baseline gap-2 mb-1"><span class="text-primary">&#8226;</span><div>$1</div></div>');

        // 6. Format line breaks
        s = s.replace(/\n\n+/g, '<br><br>');
        s = s.replace(/\n/g, '<br>');

        return s;
      }

      async function sendToTutor(question, studentInput) {
        const loading = appendLoadingBubble();
        sendBtn.disabled = true;
        if (stepSubmitBtn) stepSubmitBtn.disabled = true;

        try {
          const apiBase = window.MATH10_API_BASE_URL || '/api/v1';
          const savedUser = localStorage.getItem('math10_session_user');
          const headers = { 'Content-Type': 'application/json' };
          if (savedUser) {
            try {
              const uObj = JSON.parse(savedUser);
              if (uObj && uObj.username) headers['X-Auth-User'] = uObj.username;
            } catch(e) {}
          }

          const payload = {
            question: question,
            studentInput: studentInput || null,
            previousTurns: turnsHistory.join('\n---\n') || null,
            stepNumber: stepNumber,
            imageMimeType: currentMime,
            imageBase64: currentBase64
          };

          const res = await fetch(apiBase + '/tutor/ask', {
            method: 'POST',
            headers: headers,
            credentials: 'include',
            body: JSON.stringify(payload)
          });

          if (loading && loading.parentNode) loading.remove();

          if (!res.ok) {
            const errData = await res.json().catch(() => ({}));
            const msg = errData.message || ('Lỗi máy chủ (' + res.status + '). Hãy thử lại.');
            appendTutorMessage(msg);
            return;
          }

          const data = await res.json();
          const tutorMsg = data.message || 'Gia sư đã nhận câu hỏi của bạn.';
          appendTutorMessage(tutorMsg);

          // Update turns history
          turnsHistory.push('Học sinh: ' + (studentInput || question));
          turnsHistory.push('Gia sư AI: ' + tutorMsg);
          stepNumber++;

          turnBadge.textContent = 'Lượt ' + stepNumber;
          followupBox.classList.remove('d-none');
          if (stepInput) {
            stepInput.value = '';
            stepInput.focus();
          }

          // Save to recent questions list
          saveRecentQuestion(question);
        } catch (err) {
          if (loading && loading.parentNode) loading.remove();
          appendTutorMessage('Không thể kết nối tới dịch vụ AI. Hãy kiểm tra kết nối mạng và thử lại.');
        } finally {
          sendBtn.disabled = false;
          if (stepSubmitBtn) stepSubmitBtn.disabled = false;
        }
      }

      // Main Form Submit
      askForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const q = (problemInput.value || '').trim();
        if (!q && !currentBase64) {
          alert('Vui lòng nhập đề bài hoặc đính kèm ảnh đề bài.');
          problemInput.focus();
          return;
        }

        currentOriginalQuestion = q || 'Đề bài trong ảnh đính kèm';
        const imgSrc = previewImg.src || null;
        appendUserMessage(currentOriginalQuestion, imgSrc);

        sendToTutor(currentOriginalQuestion, null);
      });

      // Follow-up Step Submit
      if (stepSubmitBtn) {
        stepSubmitBtn.addEventListener('click', () => {
          const s = (stepInput.value || '').trim();
          if (!s) return;
          appendUserMessage(s, null);
          sendToTutor(currentOriginalQuestion, s);
        });

        stepInput.addEventListener('keydown', (e) => {
          if (e.key === 'Enter') {
            e.preventDefault();
            stepSubmitBtn.click();
          }
        });
      }

      // Clear Chat
      if (clearBtn) {
        clearBtn.addEventListener('click', () => {
          messagesContainer.innerHTML = '<div class="tutor-bubble p-3 rounded-3 bg-light border border-primary-subtle">'
            + '<div class="tutor-head d-flex align-items-center gap-2 mb-2 text-primary fw-bold">'
            + '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="10" rx="2"/><circle cx="12" cy="5" r="2"/><path d="M12 7v4M8 16h.01M16 16h.01"/></svg><span>Gia sư AI Toán 10</span></div>'
            + '<p class="mb-0 text-secondary">Chào bạn! Mình là Gia sư AI. Hãy gửi đề bài toán mới để cùng bắt đầu nhé!</p></div>';
          turnsHistory = [];
          stepNumber = 1;
          currentOriginalQuestion = '';
          turnBadge.textContent = 'Sẵn sàng';
          followupBox.classList.add('d-none');
          if (removeImageBtn) removeImageBtn.click();
        });
      }

      // Recent History Management
      function saveRecentQuestion(q) {
        if (!q || q.startsWith('Đề bài trong ảnh')) return;
        try {
          let list = JSON.parse(localStorage.getItem('math10_tutor_history') || '[]');
          list = list.filter(item => item !== q);
          list.unshift(q);
          if (list.length > 5) list = list.slice(0, 5);
          localStorage.setItem('math10_tutor_history', JSON.stringify(list));
          renderRecentHistory();
        } catch(e) {}
      }

      function renderRecentHistory() {
        if (!historyList) return;
        try {
          const list = JSON.parse(localStorage.getItem('math10_tutor_history') || '[]');
          if (list.length === 0) {
            historyList.innerHTML = '<p class="mb-0">Chưa có câu hỏi nào gần đây.</p>';
            return;
          }
          let html = '<div class="d-flex flex-column gap-2">';
          list.forEach((item) => {
            const shortText = item.length > 50 ? item.substring(0, 50) + '...' : item;
            html += '<button type="button" class="btn btn-sm btn-light text-start text-truncate w-100 border recent-q-btn" data-q="' + encodeURIComponent(item) + '">' + shortText + '</button>';
          });
          html += '</div>';
          historyList.innerHTML = html;

          historyList.querySelectorAll('.recent-q-btn').forEach(btn => {
            btn.addEventListener('click', () => {
              const fullQ = decodeURIComponent(btn.getAttribute('data-q'));
              problemInput.value = fullQ;
              problemInput.focus();
            });
          });
        } catch(e) {}
      }

      renderRecentHistory();
    });
  </script>

<jsp:include page="/common/footer.jsp" />
