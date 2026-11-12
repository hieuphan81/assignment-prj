# Math10 AI — Bộ giao diện JSP (PRJ301)

Thư mục này chứa toàn bộ mã nguồn giao diện frontend đã được chuyển đổi sang chuẩn **JavaServer Pages (JSP)**, phục vụ tiêu chí chấm điểm và nộp bài môn **PRJ301 (Java Web Application)**.

---

## 1. Cấu trúc thư mục

```
frontend_jsp/
├── WEB-INF/
│   └── web.xml                  # Deployment Descriptor chuẩn Java Web (session, encoding UTF-8, welcome file)
├── common/                      # Các thành phần giao diện dùng chung (reusable partials)
│   ├── header.jsp               # Meta, Bootstrap 5.3.3, MathJax 3 LaTeX, CSS link
│   ├── navbar.jsp               # Topbar (breadcrumbs, tìm kiếm Ctrl+K, xem thử role, đăng nhập)
│   ├── sidebar.jsp              # Menu điều hướng linh hoạt (Học sinh, Giáo viên, Admin)
│   └── footer.jsp               # Scripts, container thông báo toast, đóng thẻ HTML
├── css/
│   └── styles.css               # Hệ thống CSS Design System chuẩn tiếng Việt & responsive
├── js/
│   ├── app.js                   # Logic tương tác, chấm bài trắc nghiệm, AI Socratic, Vision grading
│   └── local-config.js          # Cấu hình API Base URL độc lập
├── index.jsp                    # Trang chủ / Dashboard tổng quan học tập
├── login.jsp                    # Màn hình đăng nhập tài khoản
├── register.jsp                 # Màn hình đăng ký học sinh mới
├── lessons.jsp                  # Danh mục khám phá 27 bài học SGK Toán 10 KNTT (bộ lọc chuyên đề)
├── lesson-detail.jsp            # Chi tiết bài học (kiến thức trọng tâm, công thức LaTeX, ví dụ, video)
├── formulas.jsp                 # Sổ tay 10 công thức cốt lõi Toán 10 & sao chép LaTeX một chạm
├── practice.jsp                 # Luyện tập trắc nghiệm & Gia sư AI Socratic tương tác từng bước
├── essay.jsp                    # Luyện tập tự luận & Tải ảnh bài giải viết tay để AI Vision chấm điểm
├── ai-tutor.jsp                 # Gia sư AI giải toán tự do đa phương thức (văn bản & ảnh đề bài)
├── history.jsp                  # Lịch sử nộp bài trắc nghiệm / tự luận và xem lại kết quả
├── progress.jsp                 # Báo cáo tiến độ học tập (biểu đồ cột CSS và % từng chuyên đề)
├── teacher-students.jsp         # Quản lý học sinh trong lớp phụ trách (Giáo viên)
├── teacher-questions.jsp        # Ngân hàng đề thi & Sinh câu hỏi tự động bằng AI (Giáo viên)
├── admin-users.jsp              # Quản lý tài khoản toàn hệ thống & phân công giáo viên (Admin)
└── admin-settings.jsp           # Cấu hình kết nối AI Provider & kiểm tra ping máy chủ AI (Admin)
```

---

## 2. Đáp ứng tiêu chí chấm điểm Rubric PRJ301

| Tiêu chí | Mức độ đáp ứng trong bộ JSP này |
|:---|:---|
| **Công nghệ Java Web** | Sử dụng đúng **JSP (JavaServer Pages)**, taglib JSTL, `<jsp:include>`, `web.xml` deployment descriptor. |
| **Kiến trúc MVC** | Tách bạch rõ ràng: **View (JSP/CSS/JS)** &larr;&rarr; **Controller (Spring MVC PageController / REST API)** &larr;&rarr; **Model (DAO / JDBC / DTO)**. |
| **Giao diện (UI)** | Responsive trên Desktop / Tablet / Mobile (Bootstrap 5.3.3 + Custom CSS), render công thức toán học chuẩn quốc tế bằng **MathJax 3 (LaTeX)**. |
| **Tích hợp AI** | 4 module AI hoàn chỉnh: Gia sư Socratic từng bước, Chấm ảnh bài giải tự luận bằng AI Vision, Sinh câu hỏi AI kiểm duyệt, và Gia sư giải toán tự do. |
| **Bảo mật & Phân quyền** | Session server-side, mã hoá mật khẩu BCrypt, phân tách màn hình và hành động theo 3 Roles (`ADMIN`, `TEACHER`, `STUDENT`). |

---

## 3. Cách chạy và kiểm tra

### Cách 1: Chạy trực tiếp qua Backend Spring Boot (Tích hợp sẵn)
Mã nguồn JSP đã được sao chép đồng bộ vào thư mục `backend/src/main/webapp/WEB-INF/views/`. Khi chạy Spring Boot backend:
```powershell
cd backend
mvn spring-boot:run
```
Truy cập ngay trên trình duyệt:
- `http://localhost:8080/` &rarr; Mở trang chủ Dashboard JSP
- `http://localhost:8080/login` &rarr; Mở trang Đăng nhập JSP
- `http://localhost:8080/lessons` &rarr; Khám phá bài học
- `http://localhost:8080/practice` &rarr; Luyện tập trắc nghiệm
- `http://localhost:8080/essay` &rarr; Luyện tập tự luận & upload ảnh
- `http://localhost:8080/ai-tutor` &rarr; Gia sư AI giải toán
- `http://localhost:8080/teacher/questions` &rarr; Ngân hàng đề & AI

### Cách 2: Triển khai trên Apache Tomcat độc lập / NetBeans / Eclipse
Sao chép thư mục `frontend_jsp` vào thư mục `web` hoặc `WebContent` của một Dynamic Web Project trong Eclipse/NetBeans/IntelliJ và deploy lên Tomcat 10+ (Jakarta EE).
