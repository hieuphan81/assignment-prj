/*
  Math10 AI - curriculum-aligned demo seed data.
  Curriculum: Toán 10, bộ Kết nối tri thức với cuộc sống (Tập 1 và Tập 2).
  The seed includes concise original notes for every catalogued lesson.

  Sample users intentionally have INACTIVE accounts and placeholder password
  hashes. Generate real BCrypt hashes in the application and activate users
  before using them to test login. Never put a real password/API key here.
*/
USE Math10AI;
GO

SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM dbo.USERS WHERE username = N'demo.admin')
        INSERT dbo.USERS(username, password_hash, full_name, email, role, status)
        VALUES (N'demo.admin', N'REPLACE_WITH_BCRYPT_HASH', N'Quản trị viên mẫu', N'admin.demo@math10.local', 'ADMIN', 'INACTIVE');

    DECLARE @AdminId INT = (SELECT user_id FROM dbo.USERS WHERE username = N'demo.admin');

    IF NOT EXISTS (SELECT 1 FROM dbo.USERS WHERE username = N'demo.teacher')
        INSERT dbo.USERS(username, password_hash, full_name, email, role, status)
        VALUES (N'demo.teacher', N'REPLACE_WITH_BCRYPT_HASH', N'Giáo viên mẫu', N'teacher.demo@math10.local', 'TEACHER', 'INACTIVE');

    DECLARE @TeacherId INT = (SELECT user_id FROM dbo.USERS WHERE username = N'demo.teacher');
    DECLARE @StudentId INT;

    IF NOT EXISTS (SELECT 1 FROM dbo.USERS WHERE username = N'demo.student')
        INSERT dbo.USERS(username, password_hash, full_name, email, role, teacher_id, status)
        VALUES (N'demo.student', N'REPLACE_WITH_BCRYPT_HASH', N'Học sinh mẫu', N'student.demo@math10.local', 'STUDENT', @TeacherId, 'INACTIVE');

    SET @StudentId = (SELECT user_id FROM dbo.USERS WHERE username = N'demo.student');

    /* Upgrade the earlier illustrative seed in-place when it has already been run. */
    IF EXISTS (SELECT 1 FROM dbo.TOPICS WHERE topic_name = N'Hàm số bậc hai (dữ liệu minh họa)')
       AND NOT EXISTS (SELECT 1 FROM dbo.TOPICS WHERE topic_name = N'Chương VI. Hàm số, đồ thị và ứng dụng')
        UPDATE dbo.TOPICS
        SET topic_name = N'Chương VI. Hàm số, đồ thị và ứng dụng',
            description = N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 2.', topic_order = 6
        WHERE topic_name = N'Hàm số bậc hai (dữ liệu minh họa)';

    IF EXISTS (SELECT 1 FROM dbo.LESSONS WHERE title = N'Hàm số bậc hai và đồ thị (mẫu)')
       AND NOT EXISTS (SELECT 1 FROM dbo.LESSONS WHERE title = N'Bài 16. Hàm số bậc hai')
        UPDATE dbo.LESSONS
        SET title = N'Bài 16. Hàm số bậc hai', order_index = 2,
            description = N'Nội dung mẫu do dự án biên soạn theo chủ đề trong Toán 10 – Kết nối tri thức với cuộc sống.',
            content = N'Hàm số bậc hai có dạng y = ax² + bx + c, với a ≠ 0. Đồ thị là một parabol. Hoành độ đỉnh là x = −b/(2a); tung độ đỉnh là giá trị hàm số tại hoành độ đó. Giáo viên cần rà soát nội dung trước khi dùng chính thức.',
            video_url = NULL, status = 'PUBLISHED'
        WHERE title = N'Hàm số bậc hai và đồ thị (mẫu)';

    DECLARE @CurriculumTopics TABLE (topic_name NVARCHAR(160), description NVARCHAR(1000), topic_order INT);
    INSERT @CurriculumTopics(topic_name, description, topic_order) VALUES
      (N'Chương I. Mệnh đề và tập hợp', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 1.', 1),
      (N'Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 1.', 2),
      (N'Chương III. Hệ thức lượng trong tam giác', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 1.', 3),
      (N'Chương IV. Vectơ', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 1.', 4),
      (N'Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 1.', 5),
      (N'Chương VI. Hàm số, đồ thị và ứng dụng', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 2.', 6),
      (N'Chương VII. Phương pháp tọa độ trong mặt phẳng', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 2.', 7),
      (N'Chương VIII. Đại số tổ hợp', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 2.', 8),
      (N'Chương IX. Tính xác suất theo định nghĩa cổ điển', N'Toán 10 – Kết nối tri thức với cuộc sống, Tập 2.', 9);

    /* Repair/refresh existing seed chapters by stable curriculum order. */
    UPDATE old
    SET old.topic_name = src.topic_name, old.description = src.description, old.status = 'ACTIVE'
    FROM dbo.TOPICS old
    JOIN @CurriculumTopics src ON src.topic_order = old.topic_order;

    INSERT dbo.TOPICS(created_by, topic_name, description, topic_order, status)
    SELECT @AdminId, t.topic_name, t.description, t.topic_order, 'ACTIVE'
    FROM @CurriculumTopics t
    WHERE NOT EXISTS (SELECT 1 FROM dbo.TOPICS old WHERE old.topic_name = t.topic_name);

    DECLARE @TopicId INT = (SELECT topic_id FROM dbo.TOPICS WHERE topic_name = N'Chương VI. Hàm số, đồ thị và ứng dụng');
    DECLARE @LessonId INT;

    /* Original concise lesson notes: core idea, worked example, and takeaway. */
    DECLARE @CatalogLessons TABLE
    (topic_name NVARCHAR(160), title NVARCHAR(200), order_index INT,
     description NVARCHAR(1000), content NVARCHAR(MAX));
    INSERT @CatalogLessons(topic_name, title, order_index, description, content) VALUES
      (N'Chương I. Mệnh đề và tập hợp', N'Bài 1. Mệnh đề', 1, N'Nhận biết mệnh đề, phủ định, lượng từ và mệnh đề kéo theo.', N'KIẾN THỨC CỐT LÕI: Mệnh đề là câu khẳng định có giá trị đúng hoặc sai xác định. Câu hỏi, câu cảm thán và câu mệnh lệnh không phải mệnh đề. Câu chứa biến như x > 3 là mệnh đề chứa biến; chỉ xác định được đúng sai khi thay giá trị cho biến hoặc gắn lượng từ.'+NCHAR(10)+N'PHỦ ĐỊNH: Phủ định của P kí hiệu ¬P, có giá trị chân lí ngược với P. Phủ định của “mọi x có tính chất P” là “tồn tại x không có tính chất P”; phủ định của “tồn tại x có tính chất P” là “mọi x đều không có tính chất P”. Với tập số thực, phủ định của ∀x, x² ≥ 0 là ∃x sao cho x² < 0.'+NCHAR(10)+N'MỆNH ĐỀ KÉO THEO: P ⇒ Q chỉ sai khi P đúng và Q sai; có thể viết tương đương ¬P ∨ Q. P là điều kiện đủ để có Q, Q là điều kiện cần của P. P ⇔ Q đúng khi P và Q cùng giá trị chân lí, tức là cả hai chiều kéo theo đều đúng.'+NCHAR(10)+N'VÍ DỤ CÓ HƯỚNG DẪN: “12 chia hết cho 3” là mệnh đề đúng; phủ định “12 không chia hết cho 3” là mệnh đề sai. Gọi P là “n chia hết cho 4”, Q là “n chẵn”. Nếu P đúng thì Q đúng, nên P ⇒ Q đúng. Chiều ngược Q ⇒ P sai với n=2.'+NCHAR(10)+N'TỰ KIỂM TRA: “x² ≥ 0 với mọi x thuộc R” là mệnh đề đúng. “x² = 1” chưa có giá trị chân lí khi chưa biết x. Mệnh đề “n chia hết cho 6 ⇒ n chia hết cho 3” là đúng.'+NCHAR(10)+N'GHI NHỚ: Khi phủ định mệnh đề có lượng từ, đổi mọi thành tồn tại và tồn tại thành mọi, đồng thời phủ định tính chất theo sau. Luôn xác định miền giá trị của biến trước khi xét đúng sai.'),
      (N'Chương I. Mệnh đề và tập hợp', N'Bài 2. Tập hợp và các phép toán trên tập hợp', 2, N'Biểu diễn tập hợp và thực hiện hợp, giao, hiệu, phần bù.', N'KIẾN THỨC: Tập hợp có thể mô tả bằng cách liệt kê phần tử hoặc nêu tính chất. A ⊂ B nghĩa là mọi phần tử của A thuộc B. A ∪ B gồm phần tử thuộc ít nhất một tập; A ∩ B gồm phần tử thuộc cả hai; A\\B gồm phần tử thuộc A mà không thuộc B.'+NCHAR(10)+'VÍ DỤ: A={1,2,3}, B={3,4}; khi đó A∪B={1,2,3,4}, A∩B={3}, A\\B={1,2}.'+NCHAR(10)+'GHI NHỚ: Vẽ biểu đồ Ven trước khi tính phần bù; phần bù của A được xác định tương đối trong tập vũ trụ U.'),
      (N'Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', N'Bài 3. Bất phương trình bậc nhất hai ẩn', 1, N'Biểu diễn miền nghiệm của bất phương trình tuyến tính hai ẩn.', N'KIẾN THỨC: Bất phương trình bậc nhất hai ẩn có dạng ax+by≤c (hoặc đổi chiều/dấu nghiêm), với a,b không đồng thời bằng 0. Đường thẳng ax+by=c chia mặt phẳng thành hai nửa mặt phẳng; miền nghiệm là một trong hai phía.'+NCHAR(10)+'VÍ DỤ: Với x+y≤4, vẽ đường biên x+y=4. Điểm O(0,0) thỏa 0≤4 nên chọn nửa mặt phẳng chứa O; đường biên được lấy vì có dấu ≤.'+NCHAR(10)+'GHI NHỚ: Với dấu < hoặc >, không lấy đường biên. Thử một điểm không nằm trên đường thẳng để xác định phía cần tô.'),
      (N'Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', N'Bài 4. Hệ bất phương trình bậc nhất hai ẩn', 2, N'Tìm miền nghiệm chung và vận dụng vào bài toán tối ưu đơn giản.', N'KIẾN THỨC: Miền nghiệm của một hệ là giao các miền nghiệm của từng bất phương trình. Mỗi bất phương trình cho một nửa mặt phẳng; miền giao có thể rỗng hoặc tạo thành một đa giác.'+NCHAR(10)+'VÍ DỤ: Hệ x≥0, y≥0, x+y≤4 có miền nghiệm là tam giác trong góc phần tư thứ nhất, giới hạn bởi hai trục và đường x+y=4. Các đỉnh là (0,0), (4,0), (0,4).'+NCHAR(10)+'GHI NHỚ: Xác định riêng từng miền rồi lấy phần giao. Trong bài toán tối ưu tuyến tính, giá trị biểu thức mục tiêu đạt cực trị tại ít nhất một đỉnh miền đa giác nghiệm.'),
      (N'Chương III. Hệ thức lượng trong tam giác', N'Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°', 1, N'Hiểu dấu và các giá trị lượng giác của góc tù, góc nhọn.', N'KIẾN THỨC: Với 0°≤α≤180°, sinα≥0; cosα dương khi α nhọn, bằng 0 khi α=90°, âm khi α tù. Ta có tanα=sinα/cosα khi cosα≠0.'+NCHAR(10)+'VÍ DỤ: sin150°=sin30°=1/2 và cos150°=−cos30°=−√3/2. Vì 150° thuộc góc phần tư II nên sin dương, cos âm.'+NCHAR(10)+'GHI NHỚ: Dùng các hệ thức sin(180°−α)=sinα, cos(180°−α)=−cosα; kiểm tra góc thuộc khoảng đã cho trước khi chọn dấu.'),
      (N'Chương III. Hệ thức lượng trong tam giác', N'Bài 6. Hệ thức lượng trong tam giác', 2, N'Áp dụng định lí sin, cosin và công thức diện tích.', N'KIẾN THỨC: Với tam giác ABC, a=BC, b=CA, c=AB. Định lí cosin: a²=b²+c²−2bc cosA. Định lí sin: a/sinA=b/sinB=c/sinC=2R. Diện tích S=½bc sinA.'+NCHAR(10)+'VÍ DỤ: Nếu b=3, c=4, A=60° thì a²=9+16−24·½=13, nên a=√13.'+NCHAR(10)+'GHI NHỚ: Chọn định lí cosin khi biết hai cạnh và góc xen giữa; chọn định lí sin khi có một cặp cạnh–góc đối diện.'),
      (N'Chương IV. Vectơ', N'Bài 7. Các khái niệm mở đầu', 1, N'Nhận biết vectơ, độ dài, phương, hướng và vectơ bằng nhau.', N'KIẾN THỨC: Vectơ AB có điểm đầu A, điểm cuối B; độ dài kí hiệu |AB|. Hai vectơ bằng nhau khi cùng hướng và cùng độ dài. Vectơ-không có độ dài 0 và điểm đầu trùng điểm cuối.'+NCHAR(10)+'VÍ DỤ: Nếu ABCD là hình bình hành thì AB và DC cùng hướng, cùng độ dài nên vectơ AB = vectơ DC.'+NCHAR(10)+'GHI NHỚ: Hai đoạn thẳng bằng nhau chưa đủ để hai vectơ bằng nhau; phải xét thêm hướng.'),
      (N'Chương IV. Vectơ', N'Bài 8. Tổng và hiệu của hai vectơ', 2, N'Dùng quy tắc ba điểm, hình bình hành và vectơ đối.', N'KIẾN THỨC: Quy tắc ba điểm: vectơ AB + vectơ BC = vectơ AC. Quy tắc hình bình hành: tổng hai vectơ cùng gốc là đường chéo xuất phát từ gốc. Hiệu a−b=a+(−b), trong đó −b đối hướng với b.'+NCHAR(10)+'VÍ DỤ: Với ba điểm A,B,C, vectơ AB+vectơ BC= vectơ AC. Do đó tổng được rút gọn bằng cách nối cuối vectơ trước với đầu vectơ sau.'+NCHAR(10)+'GHI NHỚ: Khi biến đổi biểu thức vectơ, viết rõ điểm đầu–cuối và dùng quy tắc ba điểm để tránh nhầm hướng.'),
      (N'Chương IV. Vectơ', N'Bài 9. Tích của một vectơ với một số', 3, N'Hiểu hướng và độ dài của vectơ k·a.', N'KIẾN THỨC: Với số thực k và vectơ a, |ka|=|k||a|. Nếu k>0, ka cùng hướng a; nếu k<0, ka ngược hướng; nếu k=0, ka là vectơ-không.'+NCHAR(10)+'VÍ DỤ: Nếu M là trung điểm AB thì AM=½AB theo nghĩa vectơ: vectơ AM=½ vectơ AB.'+NCHAR(10)+'GHI NHỚ: Hệ thức vectơ có thể dùng để chứng minh thẳng hàng: nếu vectơ AB=k vectơ AC thì A,B,C thẳng hàng (với điều kiện các vectơ xác định).'),
      (N'Chương IV. Vectơ', N'Bài 10. Vectơ trong mặt phẳng tọa độ', 4, N'Tính tọa độ vectơ, độ dài và tọa độ trung điểm.', N'KIẾN THỨC: Nếu A(x₁,y₁), B(x₂,y₂) thì vectơ AB=(x₂−x₁,y₂−y₁), |AB|=√((x₂−x₁)²+(y₂−y₁)²). Trung điểm M của AB có tọa độ ((x₁+x₂)/2,(y₁+y₂)/2).'+NCHAR(10)+'VÍ DỤ: A(1,−2), B(4,2) thì vectơ AB=(3,4), |AB|=5.'+NCHAR(10)+'GHI NHỚ: Tọa độ vectơ lấy tọa độ điểm cuối trừ điểm đầu theo cùng thứ tự x,y.'),
      (N'Chương IV. Vectơ', N'Bài 11. Tích vô hướng của hai vectơ', 5, N'Tính tích vô hướng và dùng để nhận biết vuông góc.', N'KIẾN THỨC: a·b=|a||b|cosθ. Với a=(x₁,y₁), b=(x₂,y₂), a·b=x₁x₂+y₁y₂. Hai vectơ khác vectơ-không vuông góc khi và chỉ khi tích vô hướng bằng 0.'+NCHAR(10)+'VÍ DỤ: a=(2,1), b=(1,−2) thì a·b=2−2=0, nên a vuông góc b.'+NCHAR(10)+'GHI NHỚ: Dùng công thức tọa độ khi biết thành phần; dùng công thức góc khi cần tìm cosθ.'),
      (N'Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm', N'Bài 12. Số gần đúng và sai số', 1, N'Làm tròn số và ước lượng sai số tuyệt đối, tương đối.', N'KIẾN THỨC: Số gần đúng x̃ xấp xỉ giá trị đúng x. Sai số tuyệt đối Δ=|x̃−x|; sai số tương đối δ=Δ/|x| (x≠0), thường biểu diễn theo phần trăm. Làm tròn theo hàng yêu cầu: xét chữ số ngay bên phải hàng đó.'+NCHAR(10)+'VÍ DỤ: Làm tròn 12,347 đến hàng phần trăm được 12,35 vì chữ số hàng phần nghìn là 7.'+NCHAR(10)+'GHI NHỚ: Khi làm tròn lên đến một hàng, sai số do làm tròn không vượt quá nửa đơn vị của hàng đó.'),
      (N'Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm', N'Bài 13. Các số đặc trưng đo xu thế trung tâm', 2, N'Tính số trung bình, trung vị và mốt để mô tả dữ liệu.', N'KIẾN THỨC: Số trung bình x̄=(x₁+…+xₙ)/n. Trung vị là giá trị ở giữa sau khi sắp xếp; nếu n chẵn thì lấy trung bình hai giá trị giữa. Mốt là giá trị xuất hiện nhiều nhất.'+NCHAR(10)+'VÍ DỤ: Với 2, 3, 3, 8, trung bình là 4; trung vị là (3+3)/2=3; mốt là 3.'+NCHAR(10)+'GHI NHỚ: Trung bình nhạy với giá trị ngoại lệ; trung vị thường đại diện tốt hơn khi dữ liệu có một giá trị quá lớn hoặc quá nhỏ.'),
      (N'Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm', N'Bài 14. Các số đặc trưng đo độ phân tán', 3, N'Dùng khoảng biến thiên, khoảng tứ phân vị và độ lệch chuẩn.', N'KIẾN THỨC: Khoảng biến thiên R=xmax−xmin. Khoảng tứ phân vị ΔQ=Q₃−Q₁. Phương sai s²=(1/n)Σ(xᵢ−x̄)²; độ lệch chuẩn s=√s². Các đại lượng này mô tả độ phân tán quanh tâm.'+NCHAR(10)+'VÍ DỤ: Dữ liệu 1,2,3 có x̄=2, phương sai=(1+0+1)/3=2/3, độ lệch chuẩn=√(2/3).'+NCHAR(10)+'GHI NHỚ: Đơn vị của độ lệch chuẩn giống đơn vị dữ liệu; phương sai có đơn vị bình phương.'),
      (N'Chương VI. Hàm số, đồ thị và ứng dụng', N'Bài 15. Hàm số', 1, N'Xác định tập xác định, giá trị và đọc đồ thị hàm số.', N'KIẾN THỨC: Hàm số f xác định trên tập D khi mỗi x∈D được gán đúng một giá trị f(x). Đồ thị gồm các điểm (x,f(x)). Với phân thức, mẫu khác 0; với căn bậc hai, biểu thức dưới căn không âm.'+NCHAR(10)+'VÍ DỤ: f(x)=√(x−1) có tập xác định [1,+∞), vì x−1≥0. Tại x=5, f(5)=2.'+NCHAR(10)+'GHI NHỚ: Nêu điều kiện xác định trước khi tính; điểm (a,b) thuộc đồ thị khi b=f(a).'),
      (N'Chương VI. Hàm số, đồ thị và ứng dụng', N'Bài 16. Hàm số bậc hai', 2, N'Khảo sát dạng, đỉnh, trục đối xứng và chiều mở của parabol.', N'KIẾN THỨC: Hàm số bậc hai có dạng y=ax²+bx+c, a≠0; đồ thị là parabol. Trục đối xứng x=−b/(2a), đỉnh I(−b/(2a),−Δ/(4a)), Δ=b²−4ac. Nếu a>0 parabol mở lên, nếu a<0 mở xuống.'+NCHAR(10)+'VÍ DỤ: y=2x²−4x+1 có x đỉnh=1, y(1)=−1; đỉnh I(1,−1), trục x=1, parabol mở lên.'+NCHAR(10)+'GHI NHỚ: Tìm đỉnh trước khi lập bảng giá trị; các điểm đối xứng qua trục có cùng tung độ.'),
      (N'Chương VI. Hàm số, đồ thị và ứng dụng', N'Bài 17. Dấu của tam thức bậc hai', 3, N'Xét dấu ax²+bx+c theo nghiệm và hệ số a.', N'KIẾN THỨC: Với f(x)=ax²+bx+c, Δ=b²−4ac. Nếu Δ<0, f luôn cùng dấu a. Nếu Δ=0, f cùng dấu a và bằng 0 tại nghiệm kép. Nếu Δ>0 có hai nghiệm x₁<x₂: f cùng dấu a ngoài khoảng hai nghiệm, trái dấu a ở giữa.'+NCHAR(10)+'VÍ DỤ: f(x)=x²−5x+6=(x−2)(x−3). Vì a>0 nên f>0 khi x<2 hoặc x>3; f<0 khi 2<x<3.'+NCHAR(10)+'GHI NHỚ: Lập bảng xét dấu theo thứ tự nghiệm; đừng quên các điểm làm tam thức bằng 0.'),
      (N'Chương VI. Hàm số, đồ thị và ứng dụng', N'Bài 18. Phương trình quy về phương trình bậc hai', 4, N'Giải phương trình chứa căn, phân thức bằng điều kiện và phép đặt ẩn.', N'KIẾN THỨC: Khi biến đổi phương trình chứa căn hoặc phân thức, phải ghi điều kiện xác định. Bình phương hai vế có thể sinh nghiệm ngoại lai, nên luôn thay nghiệm vào phương trình ban đầu. Có thể đặt t=x² (t≥0) để đưa về phương trình bậc hai theo t.'+NCHAR(10)+'VÍ DỤ: √(x+1)=x cần x≥0. Bình phương được x+1=x², suy ra x=(1+√5)/2 hoặc x=(1−√5)/2; chỉ nghiệm không âm thứ nhất thỏa phương trình gốc.'+NCHAR(10)+'GHI NHỚ: Điều kiện → biến đổi tương đương hoặc nêu rõ phép biến đổi → thử lại nghiệm.'),
      (N'Chương VII. Phương pháp tọa độ trong mặt phẳng', N'Bài 19. Phương trình đường thẳng', 1, N'Viết phương trình đường thẳng từ điểm và vectơ pháp tuyến.', N'KIẾN THỨC: Đường thẳng qua M₀(x₀,y₀), có vectơ pháp tuyến n=(a,b) có phương trình a(x−x₀)+b(y−y₀)=0, tương đương ax+by+c=0. Vectơ chỉ phương có thể lấy u=(−b,a).'+NCHAR(10)+'VÍ DỤ: Qua M(1,2), pháp tuyến n=(2,−1): 2(x−1)−(y−2)=0, hay 2x−y=0.'+NCHAR(10)+'GHI NHỚ: Thay tọa độ điểm đã cho vào phương trình để kiểm tra; pháp tuyến vuông góc với đường thẳng.'),
      (N'Chương VII. Phương pháp tọa độ trong mặt phẳng', N'Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách', 2, N'Xét giao điểm, song song, góc và khoảng cách điểm–đường.', N'KIẾN THỨC: Với d₁:a₁x+b₁y+c₁=0 và d₂:a₂x+b₂y+c₂=0, xét tỉ số hệ số để nhận biết song song/trùng nhau. Góc giữa hai đường thẳng thỏa tanθ=|a₁b₂−a₂b₁|/|a₁a₂+b₁b₂|. Khoảng cách từ M(x₀,y₀) đến d là |ax₀+by₀+c|/√(a²+b²).'+NCHAR(10)+'VÍ DỤ: Khoảng cách từ O(0,0) đến 3x+4y−10=0 là 10/5=2.'+NCHAR(10)+'GHI NHỚ: Rút gọn phương trình trước khi so sánh; khoảng cách luôn không âm.'),
      (N'Chương VII. Phương pháp tọa độ trong mặt phẳng', N'Bài 21. Đường tròn trong mặt phẳng tọa độ', 3, N'Nhận dạng tâm, bán kính và lập phương trình đường tròn.', N'KIẾN THỨC: Đường tròn tâm I(a,b), bán kính R có phương trình (x−a)²+(y−b)²=R². Dạng x²+y²+Ax+By+C=0 có tâm I(−A/2,−B/2), R²=(A²+B²)/4−C.'+NCHAR(10)+'VÍ DỤ: Tâm I(2,−1), R=3 cho phương trình (x−2)²+(y+1)²=9.'+NCHAR(10)+'GHI NHỚ: Muốn kiểm tra điểm M thuộc đường tròn, thay tọa độ vào và xem khoảng cách IM có bằng R hay không.'),
      (N'Chương VII. Phương pháp tọa độ trong mặt phẳng', N'Bài 22. Ba đường conic', 4, N'Nhận biết elip, hypebol, parabol qua tiêu điểm và phương trình.', N'KIẾN THỨC: Elip gồm điểm có tổng khoảng cách đến hai tiêu điểm không đổi; hypebol có trị tuyệt đối hiệu hai khoảng cách không đổi; parabol gồm điểm cách đều tiêu điểm và đường chuẩn. Dạng chuẩn thường gặp: x²/a²+y²/b²=1; x²/a²−y²/b²=1; y²=2px.'+NCHAR(10)+'VÍ DỤ: Với elip x²/25+y²/9=1, nửa trục lớn a=5 nằm theo trục Ox, nửa trục bé b=3.'+NCHAR(10)+'GHI NHỚ: Đưa phương trình về dạng chuẩn rồi mới xác định các tham số, tiêu điểm và hướng trục.'),
      (N'Chương VIII. Đại số tổ hợp', N'Bài 23. Quy tắc đếm', 1, N'Phân biệt quy tắc cộng và quy tắc nhân trong bài đếm.', N'KIẾN THỨC: Nếu một công việc chọn một trong các phương án rời nhau có m hoặc n cách thì có m+n cách (quy tắc cộng). Nếu công việc gồm hai bước lần lượt có m và n cách thì có mn cách (quy tắc nhân).'+NCHAR(10)+'VÍ DỤ: Có 3 áo và 4 quần; chọn một bộ gồm áo rồi quần có 3·4=12 cách.'+NCHAR(10)+'GHI NHỚ: Hỏi các lựa chọn thay thế hay các bước nối tiếp: thay thế dùng cộng, nối tiếp dùng nhân.'),
      (N'Chương VIII. Đại số tổ hợp', N'Bài 24. Hoán vị, chỉnh hợp và tổ hợp', 2, N'Chọn công thức đếm có xét hay không xét thứ tự.', N'KIẾN THỨC: Hoán vị n phần tử: Pₙ=n!. Chỉnh hợp chập k: Aₙᵏ=n!/(n−k)!, có xét thứ tự. Tổ hợp chập k: Cₙᵏ=n!/[k!(n−k)!], không xét thứ tự.'+NCHAR(10)+'VÍ DỤ: Chọn lớp trưởng và lớp phó từ 5 bạn có 5·4=20 cách; chọn một đội 2 bạn từ 5 bạn có C₅²=10 cách.'+NCHAR(10)+'GHI NHỚ: Nếu đổi thứ tự tạo kết quả khác, dùng chỉnh hợp; nếu chỉ quan tâm nhóm được chọn, dùng tổ hợp.'),
      (N'Chương VIII. Đại số tổ hợp', N'Bài 25. Nhị thức Newton', 3, N'Khai triển (a+b)ⁿ bằng hệ số nhị thức.', N'KIẾN THỨC: (a+b)ⁿ=Σ(k=0 đến n) Cₙᵏ aⁿ⁻ᵏbᵏ. Hệ số Cₙᵏ cũng là các phần tử hàng n của tam giác Pascal.'+NCHAR(10)+'VÍ DỤ: (x+2)³=x³+3x²·2+3x·2²+2³=x³+6x²+12x+8.'+NCHAR(10)+'GHI NHỚ: Số mũ của a giảm dần từ n về 0, số mũ của b tăng dần từ 0 lên n; tổng số mũ ở mỗi hạng luôn bằng n.'),
      (N'Chương IX. Tính xác suất theo định nghĩa cổ điển', N'Bài 26. Biến cố và định nghĩa cổ điển của xác suất', 1, N'Mô tả không gian mẫu, biến cố và tính xác suất đồng khả năng.', N'KIẾN THỨC: Phép thử có không gian mẫu Ω gồm các kết quả có thể xảy ra. Biến cố A là tập con của Ω. Khi các kết quả đồng khả năng, P(A)=n(A)/n(Ω), nên 0≤P(A)≤1.'+NCHAR(10)+'VÍ DỤ: Gieo xúc xắc cân đối; A là “ra số chẵn”, A={2,4,6}, Ω={1,2,3,4,5,6}, vậy P(A)=3/6=1/2.'+NCHAR(10)+'GHI NHỚ: Liệt kê kết quả đồng khả năng trước, đếm số kết quả thuận lợi sau; không áp dụng công thức cổ điển nếu kết quả không đồng khả năng.'),
      (N'Chương IX. Tính xác suất theo định nghĩa cổ điển', N'Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển', 2, N'Tổ chức phép thử đơn giản và đếm kết quả thuận lợi.', N'KIẾN THỨC: Để tính xác suất cổ điển, xác định phép thử, không gian mẫu hữu hạn, tính đồng khả năng, rồi đếm biến cố cần xét. Có thể dùng sơ đồ cây hoặc bảng để không bỏ sót trường hợp.'+NCHAR(10)+'VÍ DỤ: Gieo hai đồng xu cân đối. Ω={(S,S),(S,N),(N,S),(N,N)} có 4 kết quả đồng khả năng. Biến cố “có đúng một mặt sấp” có 2 kết quả, xác suất bằng 2/4=1/2.'+NCHAR(10)+'GHI NHỚ: Phân biệt kết quả có thứ tự khi các lần thử khác nhau; kiểm tra tổng xác suất của các kết quả sơ cấp bằng 1.');

    UPDATE l
    SET l.title = c.title, l.description = c.description, l.content = c.content,
        l.order_index = c.order_index, l.status = 'PUBLISHED'
    FROM dbo.LESSONS l
    JOIN dbo.TOPICS t ON t.topic_id = l.topic_id
    JOIN @CurriculumTopics topic ON topic.topic_order = t.topic_order
    JOIN @CatalogLessons c ON c.topic_name = topic.topic_name AND c.order_index = l.order_index
    WHERE l.teacher_id = @TeacherId;

    INSERT dbo.LESSONS(topic_id, teacher_id, title, description, content, order_index, status)
    SELECT t.topic_id, @TeacherId, c.title, c.description, c.content, c.order_index, 'PUBLISHED'
    FROM @CatalogLessons c
    JOIN dbo.TOPICS t ON t.topic_name = c.topic_name
    WHERE NOT EXISTS (SELECT 1 FROM dbo.LESSONS old WHERE old.title = c.title);

    SET @LessonId = (SELECT lesson_id FROM dbo.LESSONS WHERE title = N'Bài 16. Hàm số bậc hai');

    IF NOT EXISTS (SELECT 1 FROM dbo.QUESTIONS WHERE question_text = N'Trục đối xứng của parabol y = 2x² − 4x + 1 là gì?')
        INSERT dbo.QUESTIONS
        (lesson_id, created_by, source, question_type, question_text, option_a, option_b, option_c, option_d,
         correct_answer, explanation, solution_steps, difficulty, status)
        VALUES
        (@LessonId, @TeacherId, 'MANUAL', 'MCQ', N'Trục đối xứng của parabol y = 2x² − 4x + 1 là gì?',
         N'x = −1', N'x = 1', N'x = 2', N'x = −2', N'B',
         N'Trục đối xứng có phương trình x = −b/(2a) = −(−4)/(2·2) = 1.',
         N'Bước 1: Xác định a = 2 và b = −4. Bước 2: Tính x = −b/(2a). Bước 3: Thay số để được x = 1.',
         'EASY', 'PUBLISHED');

    IF NOT EXISTS (SELECT 1 FROM dbo.QUESTIONS WHERE question_text = N'Tìm tọa độ đỉnh của parabol y = x² − 6x + 5.')
        INSERT dbo.QUESTIONS
        (lesson_id, created_by, source, question_type, question_text, correct_answer, explanation,
         solution_steps, difficulty, status)
        VALUES
        (@LessonId, @TeacherId, 'MANUAL', 'ESSAY', N'Tìm tọa độ đỉnh của parabol y = x² − 6x + 5.',
         N'(3, -4)', N'Hoành độ đỉnh là 3; thay vào hàm số được tung độ −4.',
         N'Bước 1: a = 1, b = −6. Bước 2: x đỉnh = −b/(2a) = 3. Bước 3: y(3) = 9 − 18 + 5 = −4. Kết luận đỉnh I(3, −4).',
         'MEDIUM', 'PUBLISHED');

    IF NOT EXISTS (SELECT 1 FROM dbo.QUESTIONS WHERE question_text = N'Đỉnh của parabol y = −x² + 4x − 1 có tọa độ là gì?')
        INSERT dbo.QUESTIONS
        (lesson_id, created_by, source, question_type, question_text, option_a, option_b, option_c, option_d,
         correct_answer, explanation, solution_steps, difficulty, status)
        VALUES
        (@LessonId, @TeacherId, 'AI', 'MCQ', N'Đỉnh của parabol y = −x² + 4x − 1 có tọa độ là gì?',
         N'(2, 3)', N'(−2, 3)', N'(2, −3)', N'(−2, −3)', N'A',
         N'x đỉnh = −b/(2a) = 2; thay x = 2 vào hàm số được y = 3.',
         N'Bước 1: Xác định a = −1, b = 4. Bước 2: Tính x đỉnh = −4/(−2) = 2. Bước 3: Tính y(2) = −4 + 8 − 1 = 3.',
         'MEDIUM', 'PENDING_REVIEW');

    /* One reviewed, published practice MCQ for every lesson that lacks one. */
    DECLARE @PracticeSeed TABLE
    (lesson_title NVARCHAR(200), question_text NVARCHAR(MAX), option_a NVARCHAR(1000), option_b NVARCHAR(1000),
     option_c NVARCHAR(1000), option_d NVARCHAR(1000), correct_answer NVARCHAR(MAX), explanation NVARCHAR(MAX),
     solution_steps NVARCHAR(MAX), difficulty VARCHAR(10));
    INSERT @PracticeSeed VALUES
    (N'Bài 1. Mệnh đề',N'Câu nào sau đây là mệnh đề?',N'x > 2',N'Bạn đang học Toán à?',N'2 + 3 = 5',N'Hãy giải phương trình này.',N'C',N'Mệnh đề là câu khẳng định có giá trị đúng hoặc sai xác định. Câu 2 + 3 = 5 là khẳng định đúng.',N'Bước 1: Loại câu hỏi và câu mệnh lệnh vì chúng không có giá trị đúng sai. Bước 2: x > 2 còn phụ thuộc vào x. Bước 3: 2 + 3 = 5 là khẳng định đúng, chọn C.','EASY'),
    (N'Bài 2. Tập hợp và các phép toán trên tập hợp',N'Cho A={1,2,3} và B={2,3,4}. Tập A ∩ B là gì?',N'{1,2,3,4}',N'{2,3}',N'{1,4}',N'{1,2}',N'B',N'Giao của hai tập hợp gồm các phần tử chung của cả A và B.',N'Bước 1: Liệt kê các phần tử của A và B. Bước 2: Tìm phần tử xuất hiện ở cả hai tập. Bước 3: A ∩ B = {2,3}.','EASY'),
    (N'Bài 3. Bất phương trình bậc nhất hai ẩn',N'Điểm nào thuộc miền nghiệm của x + y ≤ 4?',N'(3,2)',N'(5,0)',N'(0,0)',N'(4,1)',N'C',N'Thay x=0, y=0 được 0≤4 nên điểm (0,0) thỏa mãn.',N'Bước 1: Thay từng cặp tọa độ vào vế trái. Bước 2: Với (0,0), ta có 0+0=0. Bước 3: Vì 0≤4 nên chọn C.','EASY'),
    (N'Bài 4. Hệ bất phương trình bậc nhất hai ẩn',N'Điểm nào là nghiệm của hệ x ≥ 0, y ≥ 0, x + y ≤ 4?',N'(-1,2)',N'(2,3)',N'(3,2)',N'(1,1)',N'D',N'(1,1) có hai tọa độ không âm và tổng bằng 2≤4.',N'Bước 1: Kiểm tra x,y không âm. Bước 2: Tính x+y. Bước 3: Với (1,1), tổng bằng 2≤4 nên thỏa cả ba bất phương trình.','EASY'),
    (N'Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°',N'Giá trị sin 150° bằng bao nhiêu?',N'−√3/2',N'1/2',N'√3/2',N'−1/2',N'B',N'sin(180°−α)=sin α nên sin150°=sin30°=1/2.',N'Bước 1: Viết 150°=180°−30°. Bước 2: Dùng sin(180°−α)=sinα. Bước 3: sin30°=1/2.','EASY'),
    (N'Bài 6. Hệ thức lượng trong tam giác',N'Tam giác có hai cạnh 3 và 4, góc xen giữa 90°. Diện tích bằng bao nhiêu?',N'6',N'7',N'12',N'24',N'A',N'Diện tích S=1/2·3·4·sin90°=6.',N'Bước 1: Dùng công thức S=1/2 ab sin C. Bước 2: Thay a=3, b=4, sin90°=1. Bước 3: S=6.','EASY'),
    (N'Bài 7. Các khái niệm mở đầu',N'Vectơ AB có điểm đầu và điểm cuối lần lượt là gì?',N'B và A',N'A và B',N'A và A',N'B và B',N'B',N'Trong kí hiệu vectơ AB, điểm viết trước là điểm đầu, điểm viết sau là điểm cuối.',N'Bước 1: Đọc kí hiệu từ trái sang phải. Bước 2: A đứng trước nên là điểm đầu. Bước 3: B là điểm cuối.','EASY'),
    (N'Bài 8. Tổng và hiệu của hai vectơ',N'Với ba điểm A, B, C, tổng vectơ AB + vectơ BC bằng vectơ nào?',N'Vectơ BA',N'Vectơ CB',N'Vectơ AC',N'Vectơ CA',N'C',N'Theo quy tắc ba điểm, vectơ AB + vectơ BC = vectơ AC.',N'Bước 1: Điểm cuối của vectơ AB là B. Bước 2: Vectơ BC bắt đầu tại B. Bước 3: Nối điểm đầu A với điểm cuối C được vectơ AC.','EASY'),
    (N'Bài 9. Tích của một vectơ với một số',N'Với k=−2, vectơ k·a có đặc điểm nào so với vectơ a?',N'Cùng hướng và dài gấp 2',N'Ngược hướng và dài gấp 2',N'Cùng hướng và dài bằng một nửa',N'Bằng vectơ-không',N'B',N'Độ dài |ka|=|k||a|=2|a|; hệ số âm làm vectơ đổi hướng.',N'Bước 1: Tính |k|=2 nên độ dài tăng gấp 2. Bước 2: Vì k<0 nên hướng ngược với a.','EASY'),
    (N'Bài 10. Vectơ trong mặt phẳng tọa độ',N'Cho A(1,2), B(4,6). Tọa độ vectơ AB là gì?',N'(5,8)',N'(−3,−4)',N'(3,4)',N'(4,6)',N'C',N'Vectơ AB=(xB−xA,yB−yA)=(4−1,6−2)=(3,4).',N'Bước 1: Lấy hoành độ B trừ hoành độ A: 4−1=3. Bước 2: Lấy tung độ B trừ tung độ A: 6−2=4.','EASY'),
    (N'Bài 11. Tích vô hướng của hai vectơ',N'Cho a=(2,1), b=(1,−2). Tích vô hướng a·b bằng bao nhiêu?',N'0',N'2',N'4',N'−4',N'A',N'a·b=2·1+1·(−2)=0.',N'Bước 1: Nhân các tọa độ tương ứng. Bước 2: Cộng 2·1+1·(−2)=2−2=0.','EASY'),
    (N'Bài 12. Số gần đúng và sai số',N'Làm tròn số 3,146 đến hàng phần trăm được kết quả nào?',N'3,14',N'3,15',N'3,10',N'3,20',N'B',N'Chữ số hàng phần nghìn là 6 nên tăng chữ số hàng phần trăm từ 4 lên 5.',N'Bước 1: Xác định hàng phần trăm là chữ số 4. Bước 2: Xét chữ số kế tiếp là 6. Bước 3: Vì 6≥5 nên làm tròn lên thành 3,15.','EASY'),
    (N'Bài 13. Các số đặc trưng đo xu thế trung tâm',N'Số trung bình cộng của 2, 4, 6 là bao nhiêu?',N'3',N'4',N'5',N'12',N'B',N'(2+4+6)/3=12/3=4.',N'Bước 1: Cộng các số liệu: 2+4+6=12. Bước 2: Chia cho số lượng số liệu là 3. Kết quả bằng 4.','EASY'),
    (N'Bài 14. Các số đặc trưng đo độ phân tán',N'Khoảng biến thiên của mẫu số liệu 2, 3, 8, 10 là bao nhiêu?',N'6',N'7',N'8',N'10',N'C',N'Khoảng biến thiên bằng giá trị lớn nhất trừ giá trị nhỏ nhất: 10−2=8.',N'Bước 1: Giá trị lớn nhất là 10. Bước 2: Giá trị nhỏ nhất là 2. Bước 3: R=10−2=8.','EASY'),
    (N'Bài 15. Hàm số',N'Tập xác định của hàm số f(x)=√(x−1) là gì?',N'x≤1',N'x≥1',N'x>1',N'Mọi số thực',N'B',N'Biểu thức dưới căn phải không âm: x−1≥0, suy ra x≥1.',N'Bước 1: Đặt điều kiện x−1≥0. Bước 2: Cộng 1 hai vế. Bước 3: Tập xác định là [1,+∞).','EASY'),
    (N'Bài 17. Dấu của tam thức bậc hai',N'Với f(x)=x²−5x+6, f(x) dương trên khoảng nào?',N'(2,3)',N'(−∞,2) ∪ (3,+∞)',N'(−∞,3)',N'(2,+∞)',N'B',N'f(x)=(x−2)(x−3), hệ số bậc hai dương nên tam thức dương ngoài hai nghiệm.',N'Bước 1: Phân tích x²−5x+6=(x−2)(x−3). Bước 2: Hai nghiệm là 2 và 3. Bước 3: Vì a=1>0, f(x)>0 khi x<2 hoặc x>3.','MEDIUM'),
    (N'Bài 18. Phương trình quy về phương trình bậc hai',N'Giải phương trình x²=9 với điều kiện x≥0.',N'x=−3',N'x=3',N'x=±3',N'Phương trình vô nghiệm',N'B',N'x²=9 cho x=±3; điều kiện x≥0 chỉ nhận x=3.',N'Bước 1: Giải x²=9 được x=3 hoặc x=−3. Bước 2: Đối chiếu điều kiện x≥0. Bước 3: Nhận x=3.','EASY'),
    (N'Bài 19. Phương trình đường thẳng',N'Đường thẳng qua M(1,2), có vectơ pháp tuyến n=(2,−1), có phương trình nào?',N'2x−y=0',N'x+2y−5=0',N'2x+y−4=0',N'x−2y+3=0',N'A',N'Phương trình 2(x−1)−(y−2)=0 rút gọn thành 2x−y=0.',N'Bước 1: Dùng a(x−x₀)+b(y−y₀)=0. Bước 2: Thay (a,b)=(2,−1), M=(1,2). Bước 3: 2(x−1)−(y−2)=0 ⇔ 2x−y=0.','MEDIUM'),
    (N'Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách',N'Khoảng cách từ O(0,0) đến đường thẳng 3x+4y−10=0 là bao nhiêu?',N'1',N'2',N'5',N'10',N'B',N'd=|3·0+4·0−10|/√(3²+4²)=10/5=2.',N'Bước 1: Dùng công thức khoảng cách điểm đến đường thẳng. Bước 2: Tử số bằng |−10|=10. Bước 3: Mẫu số √25=5, vậy d=2.','EASY'),
    (N'Bài 21. Đường tròn trong mặt phẳng tọa độ',N'Đường tròn tâm I(2,−1), bán kính 3 có phương trình nào?',N'(x+2)²+(y−1)²=9',N'(x−2)²+(y+1)²=9',N'(x−2)²+(y+1)²=3',N'(x+2)²+(y−1)²=3',N'B',N'Dạng chuẩn là (x−a)²+(y−b)²=R². Thay a=2, b=−1, R=3.',N'Bước 1: Thay tâm (a,b)=(2,−1). Bước 2: Viết (x−2)²+(y−(−1))²=3². Bước 3: Thu được (x−2)²+(y+1)²=9.','EASY'),
    (N'Bài 22. Ba đường conic',N'Với elip x²/25 + y²/9 = 1, nửa trục lớn dài bao nhiêu?',N'3',N'4',N'5',N'25',N'C',N'Ở dạng chuẩn elip, mẫu số lớn hơn là a²=25, nên nửa trục lớn a=5.',N'Bước 1: So sánh 25 và 9; mẫu lớn hơn là 25. Bước 2: a²=25. Bước 3: a=5.','EASY'),
    (N'Bài 23. Quy tắc đếm',N'Có 3 áo và 4 quần. Chọn một bộ gồm một áo và một quần có bao nhiêu cách?',N'7',N'12',N'16',N'24',N'B',N'Theo quy tắc nhân, số cách chọn là 3·4=12.',N'Bước 1: Chọn áo có 3 cách. Bước 2: Với mỗi áo, chọn quần có 4 cách. Bước 3: Tổng số cách là 3·4=12.','EASY'),
    (N'Bài 24. Hoán vị, chỉnh hợp và tổ hợp',N'Chọn 2 học sinh từ 5 học sinh để lập một nhóm có bao nhiêu cách?',N'10',N'20',N'25',N'5',N'A',N'Không xét thứ tự nên số cách là C(5,2)=5!/(2!3!)=10.',N'Bước 1: Đây là chọn nhóm nên không xét thứ tự. Bước 2: Dùng tổ hợp C(5,2). Bước 3: C(5,2)=5·4/(2·1)=10.','EASY'),
    (N'Bài 25. Nhị thức Newton',N'Hệ số của x² trong khai triển (x+1)³ là bao nhiêu?',N'1',N'2',N'3',N'6',N'C',N'(x+1)³=x³+3x²+3x+1 nên hệ số của x² là 3.',N'Bước 1: Khai triển nhị thức (x+1)³. Bước 2: Thu được x³+3x²+3x+1. Bước 3: Đọc hệ số của x² là 3.','EASY'),
    (N'Bài 26. Biến cố và định nghĩa cổ điển của xác suất',N'Gieo một con xúc xắc cân đối. Xác suất xuất hiện số chẵn là bao nhiêu?',N'1/6',N'1/3',N'1/2',N'2/3',N'C',N'Có 3 kết quả chẵn trong 6 kết quả đồng khả năng nên xác suất bằng 3/6=1/2.',N'Bước 1: Không gian mẫu có 6 kết quả. Bước 2: Các mặt chẵn là 2,4,6 nên có 3 kết quả thuận lợi. Bước 3: P=3/6=1/2.','EASY'),
    (N'Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển',N'Gieo hai đồng xu cân đối. Xác suất có đúng một mặt sấp là bao nhiêu?',N'1/4',N'1/2',N'3/4',N'1',N'B',N'Có 4 kết quả đồng khả năng; đúng một mặt sấp xảy ra ở 2 kết quả.',N'Bước 1: Liệt kê SS, SN, NS, NN (S là sấp, N là ngửa). Bước 2: Thuận lợi là SN và NS, có 2 kết quả. Bước 3: P=2/4=1/2.','EASY');

    INSERT dbo.QUESTIONS
    (lesson_id, created_by, source, question_type, question_text, option_a, option_b, option_c, option_d,
     correct_answer, explanation, solution_steps, difficulty, status)
    SELECT l.lesson_id, @TeacherId, 'MANUAL', 'MCQ', s.question_text, s.option_a, s.option_b, s.option_c, s.option_d,
           s.correct_answer, s.explanation, s.solution_steps, s.difficulty, 'PUBLISHED'
    FROM @PracticeSeed s
    JOIN dbo.LESSONS l ON l.title=s.lesson_title AND l.status='PUBLISHED'
    WHERE NOT EXISTS (SELECT 1 FROM dbo.QUESTIONS q WHERE q.lesson_id=l.lesson_id AND q.status='PUBLISHED' AND q.question_type='MCQ');

    /* One written-response prompt with a reference solution for every lesson. */
    DECLARE @EssaySeed TABLE
    (lesson_title NVARCHAR(200), question_text NVARCHAR(MAX), explanation NVARCHAR(MAX),
     solution_steps NVARCHAR(MAX), difficulty VARCHAR(10));
    INSERT @EssaySeed VALUES
    (N'Bài 1. Mệnh đề',N'Giải thích vì sao câu “x > 3” chưa là mệnh đề khi chưa biết x. Viết phủ định của mệnh đề “7 là số nguyên tố”.',N'Câu chứa biến chưa xác định giá trị đúng sai; 7 là số nguyên tố là mệnh đề đúng.',N'Bước 1: “x > 3” đúng hay sai còn phụ thuộc giá trị x nên chưa xác định chân trị. Bước 2: Phủ định của “7 là số nguyên tố” là “7 không là số nguyên tố”.','EASY'),
    (N'Bài 2. Tập hợp và các phép toán trên tập hợp',N'Cho A={1,2,3} và B={3,4,5}. Tìm A ∪ B và A ∩ B.',N'Hợp gồm mọi phần tử xuất hiện ở ít nhất một tập; giao gồm các phần tử chung.',N'A ∪ B={1,2,3,4,5}. Phần tử chung duy nhất là 3 nên A ∩ B={3}.','EASY'),
    (N'Bài 3. Bất phương trình bậc nhất hai ẩn',N'Kiểm tra điểm M(1,2) có thuộc miền nghiệm của x+y≤4 không. Nêu cách kiểm tra một điểm bằng phép thử.',N'M(1,2) thuộc miền nghiệm vì 1+2≤4.',N'Bước 1: Thay x=1, y=2 vào bất phương trình. Bước 2: Tính 1+2=3. Bước 3: Vì 3≤4 nên M thuộc miền nghiệm.','EASY'),
    (N'Bài 4. Hệ bất phương trình bậc nhất hai ẩn',N'Mô tả miền nghiệm của hệ x≥0, y≥0, x+y≤4 bằng các đỉnh của miền.',N'Miền nghiệm là tam giác trong góc phần tư thứ nhất có các đỉnh (0,0), (4,0), (0,4).',N'Bước 1: x≥0 và y≥0 giới hạn miền ở góc phần tư thứ nhất. Bước 2: Đường x+y=4 cắt hai trục tại (4,0) và (0,4). Bước 3: Giao miền là tam giác có thêm đỉnh (0,0).','MEDIUM'),
    (N'Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°',N'Tính sin150° và cos150°. Trình bày công thức góc bù đã dùng.',N'sin150°=1/2 và cos150°=−√3/2.',N'Bước 1: 150°=180°−30°. Bước 2: sin(180°−α)=sinα nên sin150°=sin30°=1/2. Bước 3: cos(180°−α)=−cosα nên cos150°=−cos30°=−√3/2.','EASY'),
    (N'Bài 6. Hệ thức lượng trong tam giác',N'Tam giác ABC có b=3, c=4 và góc A=60°. Dùng định lí cosin tính cạnh a.',N'a=√13.',N'Bước 1: Định lí cosin: a²=b²+c²−2bc cosA. Bước 2: a²=9+16−24·1/2=13. Bước 3: Vì độ dài dương nên a=√13.','MEDIUM'),
    (N'Bài 7. Các khái niệm mở đầu',N'Cho A(1,1), B(4,5). Tính độ dài vectơ AB và nêu điều kiện để hai vectơ bằng nhau.',N'AB có tọa độ (3,4), độ dài 5; hai vectơ bằng nhau khi cùng hướng và cùng độ dài.',N'Bước 1: AB=(4−1,5−1)=(3,4). Bước 2: |AB|=√(3²+4²)=5. Bước 3: Hai vectơ bằng nhau khi chúng cùng hướng và có độ dài bằng nhau.','EASY'),
    (N'Bài 8. Tổng và hiệu của hai vectơ',N'Phát biểu quy tắc ba điểm và áp dụng để rút gọn vectơ AB + vectơ BC.',N'Quy tắc ba điểm cho vectơ AB + vectơ BC = vectơ AC.',N'Bước 1: Hai vectơ có điểm cuối/đầu nối tiếp nhau tại B. Bước 2: Theo quy tắc ba điểm, tổng được thay bằng vectơ nối điểm đầu A với điểm cuối C.','EASY'),
    (N'Bài 9. Tích của một vectơ với một số',N'Cho |a|=3. Tính độ dài và xác định hướng của vectơ −2a so với vectơ a.',N'|−2a|=6 và −2a ngược hướng với a.',N'Bước 1: |ka|=|k||a| nên |−2a|=2·3=6. Bước 2: Hệ số −2 âm nên vectơ mới ngược hướng với a.','EASY'),
    (N'Bài 10. Vectơ trong mặt phẳng tọa độ',N'Cho A(1,−2), B(4,2). Tính tọa độ vectơ AB và độ dài AB.',N'AB=(3,4), |AB|=5.',N'Bước 1: AB=(4−1,2−(−2))=(3,4). Bước 2: |AB|=√(3²+4²)=5.','EASY'),
    (N'Bài 11. Tích vô hướng của hai vectơ',N'Cho a=(2,1), b=(1,−2). Tính a·b và kết luận về góc giữa hai vectơ.',N'a·b=0 nên hai vectơ khác vectơ-không vuông góc.',N'Bước 1: a·b=2·1+1·(−2)=0. Bước 2: Tích vô hướng bằng 0 nên hai vectơ vuông góc.','EASY'),
    (N'Bài 12. Số gần đúng và sai số',N'Làm tròn 12,347 đến hàng phần trăm. Tính sai số tuyệt đối do làm tròn so với số đã cho.',N'Kết quả làm tròn là 12,35; sai số tuyệt đối bằng |12,35−12,347|=0,003.',N'Bước 1: Chữ số hàng phần trăm là 4. Bước 2: Chữ số kế tiếp là 7 nên làm tròn lên được 12,35. Bước 3: Sai số tuyệt đối là |12,35−12,347|=0,003.','EASY'),
    (N'Bài 13. Các số đặc trưng đo xu thế trung tâm',N'Với mẫu số liệu 2, 3, 3, 8, hãy tính số trung bình, trung vị và mốt.',N'Số trung bình bằng 4, trung vị bằng 3 và mốt bằng 3.',N'Bước 1: Trung bình=(2+3+3+8)/4=4. Bước 2: Dãy đã sắp xếp, trung vị=(3+3)/2=3. Bước 3: Giá trị xuất hiện nhiều nhất là 3 nên mốt bằng 3.','EASY'),
    (N'Bài 14. Các số đặc trưng đo độ phân tán',N'Với mẫu số liệu 1, 2, 3, hãy tính khoảng biến thiên và phương sai.',N'Khoảng biến thiên R=2; phương sai s²=2/3.',N'Bước 1: R=3−1=2. Bước 2: Trung bình x̄=2. Bước 3: s²=((1−2)²+(2−2)²+(3−2)²)/3=2/3.','MEDIUM'),
    (N'Bài 15. Hàm số',N'Tìm tập xác định của f(x)=√(x−1) và tính f(5).',N'Tập xác định [1,+∞); f(5)=2.',N'Bước 1: Điều kiện x−1≥0 nên x≥1. Bước 2: Tập xác định là [1,+∞). Bước 3: f(5)=√(5−1)=2.','EASY'),
    (N'Bài 17. Dấu của tam thức bậc hai',N'Giải bất phương trình x²−5x+6≤0 bằng cách phân tích thành nhân tử.',N'Nghiệm là x∈[2,3].',N'Bước 1: x²−5x+6=(x−2)(x−3). Bước 2: Hai nghiệm là 2 và 3, hệ số bậc hai dương nên tam thức không dương giữa hai nghiệm. Bước 3: Lấy cả hai đầu mút vì dấu ≤.','MEDIUM'),
    (N'Bài 18. Phương trình quy về phương trình bậc hai',N'Giải phương trình √(x+1)=x và kiểm tra điều kiện nghiệm.',N'Nghiệm duy nhất x=(1+√5)/2.',N'Bước 1: Điều kiện x≥0. Bước 2: Bình phương được x+1=x², hay x²−x−1=0. Bước 3: Hai nghiệm là (1±√5)/2; chỉ nghiệm dương (1+√5)/2 thỏa điều kiện và phương trình ban đầu.','MEDIUM'),
    (N'Bài 19. Phương trình đường thẳng',N'Viết phương trình đường thẳng qua M(1,2), có vectơ pháp tuyến n=(2,−1).',N'Phương trình là 2x−y=0.',N'Bước 1: Dùng a(x−x₀)+b(y−y₀)=0. Bước 2: Thay n=(2,−1), M=(1,2): 2(x−1)−(y−2)=0. Bước 3: Rút gọn được 2x−y=0.','MEDIUM'),
    (N'Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách',N'Tính khoảng cách từ O(0,0) đến đường thẳng 3x+4y−10=0.',N'Khoảng cách bằng 2.',N'Bước 1: Dùng d=|ax₀+by₀+c|/√(a²+b²). Bước 2: Tử số |−10|=10, mẫu số √(9+16)=5. Bước 3: d=10/5=2.','EASY'),
    (N'Bài 21. Đường tròn trong mặt phẳng tọa độ',N'Viết phương trình đường tròn tâm I(2,−1), bán kính 3.',N'(x−2)²+(y+1)²=9.',N'Bước 1: Dạng chuẩn là (x−a)²+(y−b)²=R². Bước 2: Thay a=2, b=−1, R=3. Bước 3: Thu được (x−2)²+(y+1)²=9.','EASY'),
    (N'Bài 22. Ba đường conic',N'Cho elip x²/25+y²/9=1. Xác định a, b, c và tọa độ hai tiêu điểm.',N'a=5, b=3, c=4; hai tiêu điểm là (−4,0) và (4,0).',N'Bước 1: a²=25, b²=9 nên a=5, b=3. Bước 2: c²=a²−b²=25−9=16, do đó c=4. Bước 3: Trục lớn nằm trên Ox nên hai tiêu điểm là (±4,0).','MEDIUM'),
    (N'Bài 23. Quy tắc đếm',N'Có 3 áo và 4 quần. Hỏi có bao nhiêu cách chọn một bộ gồm một áo và một quần?',N'Có 12 cách.',N'Bước 1: Có 3 cách chọn áo. Bước 2: Với mỗi áo có 4 cách chọn quần. Bước 3: Theo quy tắc nhân, có 3·4=12 cách.','EASY'),
    (N'Bài 24. Hoán vị, chỉnh hợp và tổ hợp',N'Có 5 học sinh. Hỏi chọn 2 bạn lập một nhóm có bao nhiêu cách? Giải thích vì sao dùng tổ hợp.',N'Có C(5,2)=10 cách; thứ tự chọn không làm thay đổi nhóm.',N'Bước 1: Đây là chọn nhóm nên không xét thứ tự. Bước 2: Dùng tổ hợp C(5,2)=5!/(2!3!). Bước 3: Tính được 10 cách.','EASY'),
    (N'Bài 25. Nhị thức Newton',N'Khai triển (x+2)³ bằng nhị thức Newton.',N'(x+2)³=x³+6x²+12x+8.',N'Bước 1: Dùng (a+b)³=a³+3a²b+3ab²+b³. Bước 2: Thay a=x, b=2. Bước 3: Kết quả x³+6x²+12x+8.','EASY'),
    (N'Bài 26. Biến cố và định nghĩa cổ điển của xác suất',N'Gieo một con xúc xắc cân đối. Tính xác suất xuất hiện mặt chẵn.',N'Xác suất bằng 1/2.',N'Bước 1: Không gian mẫu có 6 kết quả đồng khả năng. Bước 2: Các kết quả chẵn là 2,4,6 nên có 3 kết quả thuận lợi. Bước 3: P=3/6=1/2.','EASY'),
    (N'Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển',N'Gieo hai đồng xu cân đối. Tính xác suất có đúng một mặt sấp.',N'Xác suất bằng 1/2.',N'Bước 1: Không gian mẫu gồm SS, SN, NS, NN. Bước 2: Có đúng một mặt sấp ở SN và NS. Bước 3: P=2/4=1/2.','EASY');

    INSERT dbo.QUESTIONS
    (lesson_id, created_by, source, question_type, question_text, correct_answer, explanation,
     solution_steps, difficulty, status)
    SELECT l.lesson_id, @TeacherId, 'MANUAL', 'ESSAY', s.question_text, NULL, s.explanation,
           s.solution_steps, s.difficulty, 'PUBLISHED'
    FROM @EssaySeed s
    JOIN dbo.LESSONS l ON l.title=s.lesson_title AND l.status='PUBLISHED'
    WHERE NOT EXISTS (SELECT 1 FROM dbo.QUESTIONS q WHERE q.lesson_id=l.lesson_id AND q.status='PUBLISHED' AND q.question_type='ESSAY');

    DECLARE @McqId INT = (SELECT question_id FROM dbo.QUESTIONS WHERE question_text = N'Trục đối xứng của parabol y = 2x² − 4x + 1 là gì?');
    DECLARE @EssayId INT = (SELECT question_id FROM dbo.QUESTIONS WHERE question_text = N'Tìm tọa độ đỉnh của parabol y = x² − 6x + 5.');
    DECLARE @AttemptId BIGINT;

    UPDATE dbo.QUESTIONS SET lesson_id = @LessonId
    WHERE question_text IN
      (N'Trục đối xứng của parabol y = 2x² − 4x + 1 là gì?',
       N'Tìm tọa độ đỉnh của parabol y = x² − 6x + 5.',
       N'Đỉnh của parabol y = −x² + 4x − 1 có tọa độ là gì?');

    IF NOT EXISTS (SELECT 1 FROM dbo.ATTEMPTS WHERE student_id = @StudentId AND question_id = @McqId)
    BEGIN
        INSERT dbo.ATTEMPTS(question_id, student_id, answer_text, is_correct, score, feedback)
        VALUES (@McqId, @StudentId, N'A', 0, 0, N'Bài làm chưa đúng; gia sư đưa gợi ý để học sinh thử lại.');
        SET @AttemptId = SCOPE_IDENTITY();

        INSERT dbo.AI_INTERACTIONS
        (attempt_id, step_number, student_input, ai_response, ai_action, is_correct, is_final)
        VALUES
        (@AttemptId, 1, N'A', N'Hãy xác định a và b trong công thức trục đối xứng x = −b/(2a). Sau đó thay các hệ số của đề vào công thức nhé.', 'HINT', 0, 0);
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.ATTEMPTS WHERE student_id = @StudentId AND question_id = @EssayId)
        INSERT dbo.ATTEMPTS(question_id, student_id, answer_text, image_path, is_correct, score, feedback)
        VALUES (@EssayId, @StudentId, N'x đỉnh = 3; y đỉnh = -4', NULL, 1, 10, N'Lời giải mẫu đã xác định đúng tọa độ đỉnh.');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
