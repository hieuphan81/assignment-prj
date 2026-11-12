# Hướng dẫn chạy demo Math10 AI

## Chuẩn bị

1. Chạy `database/schema.sql` trong SQL Server Management Studio để tạo database và sáu bảng.
2. Chạy `database/sample_data.sql` bằng UTF-8 để nạp 9 chương, 27 bài học, ít nhất một câu trắc nghiệm và một câu tự luận mẫu cho mỗi bài. Tài khoản mẫu trong seed đang bị vô hiệu hóa.
3. Cài JDK 17+, Maven và chạy backend với `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `BOOTSTRAP_ADMIN_USERNAME`, `BOOTSTRAP_ADMIN_PASSWORD`, `BOOTSTRAP_ADMIN_EMAIL`. Mật khẩu bootstrap tối thiểu 12 ký tự.
4. Cấu hình `AI_API_URL`, `AI_API_KEY`, `AI_MODEL` cho endpoint tương thích Chat Completions. Không ghi API key vào tệp source hoặc trình duyệt.
5. Chạy `mvn spring-boot:run` trong `backend` và mở một terminal khác ở thư mục gốc để chạy `py -m http.server 5500`; mở `http://localhost:5500`.

## Kịch bản trình bày

1. Đăng nhập Admin; tạo Giáo viên và Học sinh, sau đó phân công học sinh bằng ID giáo viên.
2. Tạo chủ đề và bài giảng; giáo viên có thể xuất bản bài để học sinh thấy.
3. Giáo viên thêm câu trắc nghiệm/tự luận hoặc sinh bản nháp bằng AI; kiểm tra rồi mới bấm **Duyệt và xuất bản**.
4. Đăng xuất, đăng nhập học sinh; mở bài đã xuất bản, làm trắc nghiệm hoặc nộp lời giải tự luận/ảnh.
5. Với đáp án sai, tiếp tục nhập bước tính cho gia sư AI. Mở **Lịch sử học** và **Tiến độ** để xem các lần làm đã lưu.
6. Đăng nhập lại Giáo viên để xem học sinh được phân công và kết quả của họ.

## Giới hạn demo

- Bộ sách đã chọn là **Toán 10 – Kết nối tri thức với cuộc sống**. Seed có ghi chú cơ bản, câu trắc nghiệm và câu tự luận cho mỗi bài; giáo viên cần rà soát và bổ sung nội dung trước khi dùng làm khóa học chính thức.
- Gia sư hỏi tự do trả lời trọn lời giải trong một lượt. 20 câu gần đây được lưu cục bộ trên trình duyệt theo tài khoản, không lưu ảnh và không đồng bộ giữa thiết bị. Luyện tập từ câu hỏi đã xuất bản và tự luận có lưu trong database ở `ATTEMPTS`/`AI_INTERACTIONS`.
- Cấu hình AI lấy từ biến môi trường và cần khởi động lại backend sau khi đổi. Giao diện chỉ kiểm tra trạng thái; không thu API key.
- Admin tạo tài khoản giáo viên/học sinh và phân công giáo viên; giáo viên tạo tài khoản học sinh trực tiếp trong trang “Học sinh của tôi”, học sinh mới tự động được gán cho giáo viên đang đăng nhập. API giới hạn việc xem danh sách theo phân công.
- Cần chạy backend, SQL Server và cấu hình AI trong môi trường của máy demo để xác nhận luồng thực tế.
