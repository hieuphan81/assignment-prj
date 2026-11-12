# Math10 AI — Website học Toán 10

Ứng dụng học Toán 10 gồm giao diện responsive, backend Spring MVC/JDBC, SQL Server và tích hợp AI theo cấu hình máy chủ.

## Mở giao diện

Mở terminal ở thư mục gốc và chạy `py -m http.server 5500` (hoặc `python -m http.server 5500`), sau đó truy cập `http://localhost:5500`. Cần kết nối mạng để tải Bootstrap, font và MathJax từ CDN.

## Điều hướng và màn hình

- Dùng menu bên trái để chuyển trang.
- Khi chưa đăng nhập, bộ chọn vai trò chỉ đổi chế độ xem thử. Sau khi đăng nhập, server quyết định vai trò và khóa bộ chọn này.
- Học sinh: tổng quan, danh sách bài học, chi tiết bài, trắc nghiệm, nộp ảnh tự luận, lịch sử và tiến độ.
- Giáo viên: tổng quan, học sinh được phân công, bài giảng, ngân hàng câu hỏi, tạo câu hỏi AI và tiến độ.
- Quản trị viên: tổng quan, tài khoản, chủ đề, câu hỏi và cấu hình AI.

`styles.css` chứa giao diện responsive. `app.js` dựng các màn hình và gọi API. Chế độ xem thử không đăng nhập còn hiển thị dữ liệu minh họa; các thao tác lưu, luyện tập, quản lý và AI cần đăng nhập.

## Chương trình học đã chọn

Dự án dùng **Toán 10 – Kết nối tri thức với cuộc sống**, Tập 1 và Tập 2. Seed tạo đủ 9 chủ đề, 27 bài có ghi chú kiến thức, ví dụ tự biên soạn và phần ghi nhớ; mỗi bài có ít nhất một câu trắc nghiệm và một câu tự luận mẫu. Bài 16 có thêm câu tự luận mẫu để trình diễn chấm bài. Giáo viên nên rà soát, mở rộng nội dung và thêm câu hỏi trước khi dùng chính thức. Xem [bản đồ chương trình](docs/curriculum.md).

## Database

Thư mục [`database`](database/ERD.md) có schema SQL Server với đúng sáu bảng theo bản Final, ERD, ghi chú chuẩn hóa và seed theo bộ sách đã chọn. Chạy `database/schema.sql`, sau đó nạp `database/sample_data.sql` bằng UTF-8. Một số cấu hình `sqlcmd` trên Windows vẫn làm hỏng dấu tiếng Việt trong phần nội dung dài; sau khi backend chạy, đồng bộ lại nội dung chuẩn từ tệp seed qua API UTF-8 bằng `node database/sync-seed-lessons.js`. Trên PowerShell, nạp cấu hình local (`. backend/.env.local.ps1`) và đặt `$env:MATH10_API_BASE_URL='http://127.0.0.1:8081/api/v1'` nếu backend đang dùng cổng 8081. Script đăng nhập bằng bootstrap Admin và tự kiểm tra 27 bài sau khi cập nhật.

## Backend — Spring MVC và SQL Server

Thư mục `backend` là ứng dụng Spring Boot dùng Spring MVC, JDBC và driver SQL Server. Một số endpoint chính:

- `GET /api/v1/topics` — chủ đề đang hoạt động.
- `GET /api/v1/lessons` — bài học đã xuất bản; có thể lọc bằng `?topicId=1`.
- `POST /api/v1/attempts` — chấm câu trắc nghiệm đã xuất bản và lưu bài làm.
- `POST /api/v1/attempts/essay` — lưu lời giải/ảnh và gọi AI để nhận xét.
- `POST /api/v1/tutor/ask` — gia sư mở cho câu hỏi Toán tự do (lịch sử gần đây lưu cục bộ trên trình duyệt theo tài khoản, không lưu ảnh và không đồng bộ giữa thiết bị).

Khởi tạo database bằng `database/schema.sql`, sau đó chạy ứng dụng từ thư mục `backend` bằng `mvn spring-boot:run`. Đặt `DB_URL`, `DB_USERNAME` và `DB_PASSWORD` trong môi trường chạy; không đưa mật khẩu thật vào source code. Mẫu biến môi trường nằm trong `backend/.env.example`.

Các nội dung mẫu trong seed chỉ nhằm kiểm tra luồng. Tài khoản demo cũ bị vô hiệu hóa và mật khẩu placeholder; dùng bootstrap Admin bên dưới để tạo tài khoản quản trị đầu tiên.

### Hiển thị dữ liệu API trên giao diện

Giao diện gọi backend tại `http://localhost:8080/api/v1` theo mặc định. Để trình duyệt cho phép gọi backend, mở terminal ở thư mục gốc và chạy `py -m http.server 5500` (hoặc `python -m http.server 5500`), sau đó mở `http://localhost:5500`. Khi API không sẵn sàng, trang bài học báo trạng thái và hiển thị nội dung minh họa. Có thể cấu hình base URL bằng `window.MATH10_API_BASE_URL` trong `local-config.js`; giữ cùng hostname `localhost` giữa web và API để trình duyệt gửi cookie phiên đăng nhập.

### Khởi chạy backend

1. Cài JDK 17+, Maven và SQL Server. Chạy `database/schema.sql` trong SQL Server Management Studio rồi nạp `database/sample_data.sql`; nếu dùng `sqlcmd`, thêm `-f 65001` để đọc UTF-8. Sau khi backend khởi động, chạy `node database/sync-seed-lessons.js` theo hướng dẫn ở mục Database để bảo đảm nội dung bài giữ đúng dấu.
2. Trong PowerShell, chuyển vào thư mục `backend`, sau đó đặt biến môi trường cho terminal hiện tại, ví dụ: `$env:DB_URL='jdbc:sqlserver://localhost:1433;databaseName=Math10AI;encrypt=true;trustServerCertificate=true'`, `$env:DB_USERNAME='sa'`, `$env:DB_PASSWORD='your-local-db-password'`, `$env:BOOTSTRAP_ADMIN_USERNAME='admin'`, `$env:BOOTSTRAP_ADMIN_PASSWORD='your-random-password-12-chars-or-more'`, `$env:BOOTSTRAP_ADMIN_EMAIL='admin@math10.local'`. Mật khẩu bootstrap phải có ít nhất 12 ký tự. `backend/.env.example` chỉ là danh sách tên biến; Maven/Spring không tự nạp tệp này.
3. Đặt `AI_API_URL`, `AI_API_KEY`, `AI_MODEL` để bật AI. Endpoint cần tương thích API Chat Completions và hỗ trợ vision nếu muốn chấm ảnh. Để trống thì phần còn lại vẫn chạy và trả thông báo AI chưa cấu hình.
4. Chạy `mvn spring-boot:run` trong `backend`. Bootstrap Admin chỉ được tạo khi username chưa tồn tại. Ảnh bài làm lưu ngoài web root trong `private-uploads` (có thể đổi bằng `MATH10_UPLOAD_DIR`).

Trên máy đã được cấu hình SQL Express local, có thể chạy `.start-local.ps1` từ thư mục `backend`. Launcher đọc thông tin kết nối và bootstrap Admin trong `backend/.env.local.ps1` (tệp bị Git bỏ qua), dùng Windows Authentication và chỉ mở backend tại `127.0.0.1`. Nếu cần dùng cổng backend khác 8080, đặt `window.MATH10_API_BASE_URL` trong `local-config.js` ở thư mục gốc; tệp này cũng bị Git bỏ qua. Dừng backend bằng `Ctrl+C`. Cấu hình này dành cho môi trường phát triển local; khi chuyển máy, tạo lại tệp cấu hình riêng và cài Maven/JDBC auth phù hợp.

### API đã có

- Xác thực: `POST /auth/register` (đăng ký học sinh và đăng nhập ngay), `POST /auth/login`, `GET /auth/me`, `POST /auth/logout`.
- Chủ đề/bài học: xem nội dung đã xuất bản; Admin/Giáo viên quản lý nội dung trong phạm vi quyền.
- Tài khoản: Admin tạo/sửa/kích hoạt/khóa và phân công; Giáo viên tạo học sinh (tự động gán cho mình) và chỉ xem học sinh được phân công.
- Câu hỏi: tạo thủ công, yêu cầu AI tạo bản nháp, duyệt và xuất bản; học sinh chỉ nhận câu hỏi đã xuất bản, không nhận đáp án đúng.
- Bài làm: chấm trắc nghiệm ở server, nhận gợi ý AI theo từng lượt, nộp tự luận bằng chữ/ảnh, lưu lịch sử và phản hồi.
- Tiến độ: học sinh xem của mình; giáo viên xem học sinh được giao; Admin xem tổng hợp.
- AI: `GET /admin/ai/status`, `POST /admin/ai/test`; bí mật chỉ đọc từ biến môi trường máy chủ.

API dùng session server-side và kiểm tra role/ownership. Chỉ cho phép CORS từ localhost port 5500/3000 trong cấu hình hiện tại; cập nhật origin trước khi triển khai ở host khác.

Xem [hướng dẫn chạy và trình bày demo](docs/demo-guide.md) để thực hiện luồng Admin → Giáo viên → Học sinh.

## Công thức Toán 10

Học sinh có mục **Công thức Toán 10** để tra cứu theo chủ đề; một số công thức cũng được trình bày trong chi tiết bài học. MathJax 3 hiển thị ký hiệu LaTeX và cần kết nối mạng để tải thư viện từ CDN. Nút bên cạnh mỗi công thức sao chép mã LaTeX khi trình duyệt cho phép clipboard.

