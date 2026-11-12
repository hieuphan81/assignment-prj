# Hướng dẫn mở và chạy dự án Math10 AI trên Apache NetBeans (PRJ301)

Dự án đã được tích hợp đầy đủ file cấu hình chuyên biệt cho **Apache NetBeans IDE** (`nbactions.xml`, `nb-configuration.xml`, và `pom.xml` đa tầng).

---

## 1. Cách mở dự án trong NetBeans

1. Mở **Apache NetBeans** (khuyên dùng NetBeans 17, 18, 19, 20 hoặc mới hơn).
2. Chọn menu **File** &rarr; **Open Project...** (hoặc phím tắt `Ctrl + Shift + O`).
3. Điều hướng đến thư mục dự án `Math10AI_Project_Source_2026-10-04`.
4. Bạn sẽ thấy biểu tượng dự án Maven được NetBeans nhận diện tự động:
   - **Cách 1 (Khuyên dùng - Mở toàn bộ dự án)**: Chọn thư mục gốc `Math10AI_Project_Source_2026-10-04` &rarr; Nhấn **Open Project**.
     NetBeans sẽ hiển thị một cụm gồm:
     - `Math10 AI — Project Suite (PRJ301)` (Dự án cha)
     - `math10ai-backend` (Mã nguồn Backend Spring Boot + JSP)
     - `math10ai-frontend-jsp` (Giao diện JSP độc lập dạng WebApp WAR)
   - **Cách 2 (Mở trực tiếp backend)**: Mở thư mục con `backend`.

---

## 2. Thao tác trên NetBeans

Dự án đã được cấu hình sẵn trong `nbactions.xml`:

| Thao tác | Phím tắt NetBeans | Lệnh Maven thực thi |
|:---|:---:|:---|
| **Chạy dự án (Run)** | `F6` | `mvn spring-boot:run` (Khởi chạy ứng dụng máy chủ) |
| **Gỡ lỗi (Debug)** | `Ctrl + F5` | `mvn spring-boot:run` kèm cờ JPDA debug của NetBeans |
| **Biên dịch & Đóng gói (Build)** | `F11` | `mvn install` |
| **Xoá & Biên dịch lại (Clean and Build)** | `Shift + F11` | `mvn clean install` |

---

## 3. Cấu hình biến môi trường khi chạy từ NetBeans (tuỳ chọn)

Nếu bạn cần cấu hình tài khoản SQL Server hoặc AI Key riêng khi chạy từ NetBeans:
1. Chuột phải vào project `math10ai-backend` &rarr; Chọn **Properties**.
2. Chọn thẻ **Run** &rarr; Trong mục **VM Options** hoặc **Environment Variables**:
   - Thêm biến kết nối DB: `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`
   - Thêm cấu hình Admin: `BOOTSTRAP_ADMIN_PASSWORD` (tối thiểu 12 ký tự)
   - Thêm AI key: `AI_API_URL`, `AI_API_KEY`, `AI_MODEL`
3. Nhấn **OK** và ấn **F6** để chạy.

---

## 4. Truy cập giao diện sau khi chạy

Sau khi NetBeans báo log máy chủ đã sẵn sàng ở cổng `8080`, mở trình duyệt truy cập:
- `http://localhost:8080/` &rarr; Trang chủ / Dashboard JSP
- `http://localhost:8080/login` &rarr; Đăng nhập
- `http://localhost:8080/lessons` &rarr; Bài học Toán 10
- `http://localhost:8080/practice` &rarr; Luyện tập trắc nghiệm & AI Socratic
- `http://localhost:8080/essay` &rarr; Luyện tập tự luận & Chấm ảnh AI
- `http://localhost:8080/ai-tutor` &rarr; Gia sư AI giải toán
