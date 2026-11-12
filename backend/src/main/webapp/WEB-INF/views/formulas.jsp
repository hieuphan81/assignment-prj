<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/common/header.jsp">
  <jsp:param name="title" value="Sổ tay công thức Toán 10 — Math10 AI" />
</jsp:include>

<jsp:include page="/common/sidebar.jsp">
  <jsp:param name="active" value="formulas" />
</jsp:include>

<div class="main-area">
  <jsp:include page="/common/navbar.jsp">
    <jsp:param name="pageTitle" value="Sổ tay công thức" />
  </jsp:include>

  <main class="page-content" id="main-content">
    <div class="page-heading">
      <div>
        <div class="eyebrow">TRA CỨU NHANH &bull; TOÁN 10 KNTT</div>
        <h1>Sổ tay công thức Toán 10</h1>
        <p>Tra cứu công thức cốt lõi theo từng chuyên đề, hiển thị ký hiệu chuẩn LaTeX và sao chép mã nguồn một chạm.</p>
      </div>
      <div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/practice">Luyện tập áp dụng &rarr;</a>
      </div>
    </div>

    <!-- Filter Pills -->
    <div class="cardx card-pad mb-4">
      <div class="filter-row">
        <button class="btn btn-soft formula-filter active" data-topic="all" onclick="filterFormulas('all', this)">Tất cả chuyên đề (10)</button>
        <button class="btn btn-light formula-filter" data-topic="Tập hợp" onclick="filterFormulas('Tập hợp', this)">Tập hợp</button>
        <button class="btn btn-light formula-filter" data-topic="Hàm số" onclick="filterFormulas('Hàm số', this)">Hàm số bậc hai</button>
        <button class="btn btn-light formula-filter" data-topic="Lượng giác" onclick="filterFormulas('Lượng giác', this)">Lượng giác trong $\triangle$</button>
        <button class="btn btn-light formula-filter" data-topic="Vectơ" onclick="filterFormulas('Vectơ', this)">Vectơ & Tọa độ</button>
        <button class="btn btn-light formula-filter" data-topic="Thống kê" onclick="filterFormulas('Thống kê', this)">Thống kê</button>
        <button class="btn btn-light formula-filter" data-topic="Xác suất" onclick="filterFormulas('Xác suất', this)">Xác suất</button>
      </div>
    </div>

    <!-- 10 Formula Cards Grid -->
    <div class="row g-3" id="formula-cards-grid">
      <!-- 1 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Tập hợp">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-blue">TẬP HỢP</span>
          <h3>Giao và hợp của hai tập hợp</h3>
          <p>Phép toán cơ bản trên tập hợp.</p>
          <div class="formula-library">
            \[ A \cap B = \{x \mid x \in A \text{ và } x \in B\} \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="A \cap B = \{x \mid x \in A \text{ và } x \in B\}">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 2 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Hàm số">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-purple">HÀM SỐ BẬC HAI</span>
          <h3>Biệt thức Delta</h3>
          <p>Xác định nghiệm và dấu của tam thức bậc hai.</p>
          <div class="formula-library">
            \[ \Delta = b^2 - 4ac \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="\Delta = b^2 - 4ac">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 3 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Hàm số">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-purple">HÀM SỐ BẬC HAI</span>
          <h3>Toạ độ đỉnh Parabol</h3>
          <p>Điểm cực trị của đồ thị hàm số bậc hai.</p>
          <div class="formula-library">
            \[ I\left(-\frac{b}{2a}; -\frac{\Delta}{4a}\right) \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="I\left(-\frac{b}{2a}; -\frac{\Delta}{4a}\right)">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 4 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Lượng giác">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-green">HỆ THỨC LƯỢNG</span>
          <h3>Định lý Côsin</h3>
          <p>Tính độ dài cạnh thứ ba hoặc góc trong tam giác.</p>
          <div class="formula-library">
            \[ a^2 = b^2 + c^2 - 2bc \cos A \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="a^2 = b^2 + c^2 - 2bc \cos A">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 5 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Lượng giác">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-green">HỆ THỨC LƯỢNG</span>
          <h3>Định lý Sin</h3>
          <p>Mối liên hệ giữa cạnh, góc và bán kính ngoại tiếp $R$.</p>
          <div class="formula-library">
            \[ \frac{a}{\sin A} = \frac{b}{\sin B} = \frac{c}{\sin C} = 2R \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="\frac{a}{\sin A} = \frac{b}{\sin B} = \frac{c}{\sin C} = 2R">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 6 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Vectơ">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-blue">VECTƠ</span>
          <h3>Tích vô hướng hai vectơ</h3>
          <p>Tích độ dài nhân cosin góc giữa hai vectơ.</p>
          <div class="formula-library">
            \[ \vec{u} \cdot \vec{v} = |\vec{u}| \cdot |\vec{v}| \cdot \cos(\vec{u}, \vec{v}) \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="\vec{u} \cdot \vec{v} = |\vec{u}| \cdot |\vec{v}| \cdot \cos(\vec{u}, \vec{v})">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 7 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Vectơ">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-blue">VECTƠ TOẠ ĐỘ</span>
          <h3>Biểu thức toạ độ tích vô hướng</h3>
          <p>Tính tích vô hướng qua toạ độ trong mặt phẳng $Oxy$.</p>
          <div class="formula-library">
            \[ \vec{u} \cdot \vec{v} = x_1 x_2 + y_1 y_2 \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="\vec{u} \cdot \vec{v} = x_1 x_2 + y_1 y_2">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 8 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Thống kê">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-orange">THỐNG KÊ</span>
          <h3>Số trung bình của mẫu số liệu</h3>
          <p>Giá trị trung bình cộng của các quan sát.</p>
          <div class="formula-library">
            \[ \bar{x} = \frac{x_1 + x_2 + \cdots + x_n}{n} \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="\bar{x} = \frac{x_1 + x_2 + \cdots + x_n}{n}">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 9 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Xác suất">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-orange">XÁC SUẤT</span>
          <h3>Xác suất cổ điển của biến cố</h3>
          <p>Tỷ số giữa số kết quả thuận lợi và tổng số kết quả đồng khả năng.</p>
          <div class="formula-library">
            \[ P(A) = \frac{n(A)}{n(\Omega)} \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="P(A) = \frac{n(A)}{n(\Omega)}">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>

      <!-- 10 -->
      <div class="col-md-6 col-lg-4 formula-item" data-topic-name="Lượng giác">
        <div class="cardx formula-card h-100 d-flex flex-column">
          <span class="tag tag-green">HỆ THỨC LƯỢNG</span>
          <h3>Công thức diện tích Hê-rông</h3>
          <p>Tính diện tích tam giác qua nửa chu vi $p = (a+b+c)/2$.</p>
          <div class="formula-library">
            \[ S = \sqrt{p(p-a)(p-b)(p-c)} \]
          </div>
          <button class="btn btn-sm btn-light w-100 mt-auto copy-formula" data-latex="S = \sqrt{p(p-a)(p-b)(p-c)}">
            Sao chép Sao chép mã LaTeX
          </button>
        </div>
      </div>
    </div>
  </main>

  <script>
    function filterFormulas(topic, btnEl) {
      const buttons = document.querySelectorAll('.formula-filter');
      buttons.forEach(b => {
        b.classList.remove('active', 'btn-soft');
        b.classList.add('btn-light');
      });
      if (btnEl) {
        btnEl.classList.add('active', 'btn-soft');
        btnEl.classList.remove('btn-light');
      }

      const items = document.querySelectorAll('#formula-cards-grid .formula-item');
      items.forEach(card => {
        const cardTopic = (card.getAttribute('data-topic-name') || '').trim();
        const match = (topic === 'all' || cardTopic === topic || cardTopic.toLowerCase().includes(topic.toLowerCase()));
        if (match) {
          card.style.display = '';
          card.classList.remove('d-none');
        } else {
          card.style.display = 'none';
          card.classList.add('d-none');
        }
      });

      if (window.MathJax && window.MathJax.typesetPromise) {
        window.MathJax.typesetPromise();
      }
    }

    document.addEventListener('DOMContentLoaded', () => {
      // Copy formula buttons
      document.querySelectorAll('.copy-formula').forEach(btn => {
        btn.addEventListener('click', () => {
          const latex = btn.getAttribute('data-latex') || '';
          if (navigator.clipboard) {
            navigator.clipboard.writeText(latex).then(() => {
              const originalText = btn.innerHTML;
              btn.innerHTML = '<span class="text-success fw-bold">✓ Đã sao chép!</span>';
              setTimeout(() => { btn.innerHTML = originalText; }, 1500);
            }).catch(() => {});
          }
        });
      });

      // Topic filter buttons click
      document.querySelectorAll('.formula-filter').forEach(btn => {
        btn.addEventListener('click', () => {
          filterFormulas(btn.dataset.topic, btn);
        });
      });
    });
  </script>

<jsp:include page="/common/footer.jsp" />
