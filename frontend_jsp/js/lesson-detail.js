// Detailed Textbook Lessons Data for Math10 AI (All 27 Lessons)
window.MATH10_LESSON_VIDEOS = {
  1: { id: 1, videoId: "vZF3rsOSDAU", title: "Bài 1. Mệnh đề (Kết nối tri thức)", channel: "VietJack THPT Official" },
  2: { id: 2, videoId: "z03it51WKlI", title: "Bài 2. Tập hợp và các phép toán trên tập hợp", channel: "VietJack THPT Official" },
  3: { id: 3, videoId: "eC4qjvwCz2U", title: "Bài 3. Bất phương trình bậc nhất hai ẩn", channel: "VietJack THPT Official" },
  4: { id: 4, videoId: "0xWriKx7erc", title: "Bài 4. Hệ bất phương trình bậc nhất hai ẩn", channel: "VietJack THPT Official" },
  5: { id: 5, videoId: "VTnESgEXhhs", title: "Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°", channel: "VietJack THPT Official" },
  6: { id: 6, videoId: "JDzCEjDonH4", title: "Bài 6. Hệ thức lượng trong tam giác", channel: "VietJack THPT Official" },
  7: { id: 7, videoId: "iAxQrZltzps", title: "Bài 7. Các khái niệm mở đầu về vectơ", channel: "VietJack THPT Official" },
  8: { id: 8, videoId: "fWc2zQr5t0c", title: "Bài 8. Tổng và hiệu của hai vectơ", channel: "VietJack THPT Official" },
  9: { id: 9, videoId: "36O7v1h3nOM", title: "Bài 9. Tích của một vectơ với một số", channel: "VietJack THPT Official" },
  10: { id: 10, videoId: "6NpDvZnXbrQ", title: "Bài 10. Vectơ trong mặt phẳng tọa độ", channel: "VietJack THPT Official" },
  11: { id: 11, videoId: "xjA5-1CFnVQ", title: "Bài 11. Tích vô hướng của hai vectơ", channel: "VietJack THPT Official" },
  12: { id: 12, videoId: "kbgg05MSXr0", title: "Bài 12. Số gần đúng và sai số", channel: "VietJack THPT Official" },
  13: { id: 13, videoId: "eCVISQi9HgA", title: "Bài 13. Các số đặc trưng đo xu thế trung tâm", channel: "VietJack THPT Official" },
  14: { id: 14, videoId: "HWdBv4Oqzeg", title: "Bài 14. Các số đặc trưng đo độ phân tán", channel: "VietJack THPT Official" },
  15: { id: 15, videoId: "n6A8U1kxDcw", title: "Bài 15. Hàm số và đồ thị", channel: "VietJack THPT Official" },
  16: { id: 16, videoId: "Cy0C_WYdHl4", title: "Bài 16. Hàm số bậc hai", channel: "VietJack THPT Official" },
  17: { id: 17, videoId: "jVEcTPr0c1U", title: "Bài 17. Dấu của tam thức bậc hai", channel: "Thầy Nguyễn Phan Tiến" },
  18: { id: 18, videoId: "NT8gxgx57S4", title: "Bài 18. Phương trình quy về phương trình bậc hai", channel: "Thầy Quang" },
  19: { id: 19, videoId: "eDKRGo5soY8", title: "Bài 19. Phương trình đường thẳng", channel: "VietJack THPT Official" },
  20: { id: 20, videoId: "OyjU2b4MVk8", title: "Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách", channel: "VietJack THPT Official" },
  21: { id: 21, videoId: "7g0KsKuzIXc", title: "Bài 21. Đường tròn trong mặt phẳng tọa độ", channel: "VietJack THPT Official" },
  22: { id: 22, videoId: "ZRbKhSrUgdY", title: "Bài 22. Ba đường conic trong mặt phẳng tọa độ", channel: "VietJack THPT Official" },
  23: { id: 23, videoId: "WTAu7ztA7vQ", title: "Bài 23. Quy tắc đếm", channel: "VietJack THPT Official" },
  24: { id: 24, videoId: "7NRi6VV6CSc", title: "Bài 24. Hoán vị, chỉnh hợp và tổ hợp", channel: "Thầy Quang" },
  25: { id: 25, videoId: "lS17THBBJYs", title: "Bài 25. Nhị thức Newton", channel: "VietJack THPT Official" },
  26: { id: 26, videoId: "6Z7P_nTCdfo", title: "Bài 26. Biến cố và định nghĩa cổ điển của xác suất", channel: "Thầy Quang" },
  27: { id: 27, videoId: "QxEesYXezzg", title: "Bài 27. Thực hành tính xác suất trong một số bài toán thực tế", channel: "SGK Kết nối tri thức" }
};

window.MATH10_SERVER_VIDEOS = window.MATH10_SERVER_VIDEOS || {};

window.extractYouTubeId = function(input) {
  if (!input) return null;
  const trimmed = String(input).trim();
  if (!trimmed) return null;
  const m = trimmed.match(/(?:youtube\.com\/(?:watch\?(?:.*&)?v=|embed\/|v\/|shorts\/|live\/)|youtu\.be\/)([A-Za-z0-9_-]{11})|^([A-Za-z0-9_-]{11})$/);
  if (m) {
    const id = m[1] || m[2];
    return {
      videoId: id,
      videoUrl: 'https://www.youtube.com/watch?v=' + id
    };
  }
  return null;
};

window.getLessonVideoConfig = function(lessonId) {
  const lid = Number(lessonId);
  const def = (window.MATH10_LESSON_VIDEOS && window.MATH10_LESSON_VIDEOS[lid]) || {
    id: lid,
    videoId: 'vZF3rsOSDAU',
    title: 'Bài ' + lid,
    channel: 'VietJack THPT Official'
  };

  let serverData = (window.MATH10_SERVER_VIDEOS && window.MATH10_SERVER_VIDEOS[lid]) || null;
  let localData = null;
  try {
    const customLessons = JSON.parse(localStorage.getItem('math10_custom_lessons') || '{}');
    if (customLessons[lid]) localData = customLessons[lid];
  } catch (e) {}

  let active = null;
  if (serverData && localData && (localData.videoId || (localData.extraVideos && localData.extraVideos.length)) && localData.updatedAt && serverData.updatedAt) {
    active = (new Date(localData.updatedAt) > new Date(serverData.updatedAt)) ? localData : serverData;
  } else {
    active = serverData || (localData && (localData.videoId || (localData.extraVideos && localData.extraVideos.length)) ? localData : null);
  }

  const videoId = (active && active.videoId) || def.videoId;
  const title = (active && active.videoTitle) || (active && active.title && (active.videoId || active.videoUrl) ? active.title : def.title);
  const channel = (active && active.videoChannel) || (active && active.channel) || def.channel;
  const extraVideos = Array.isArray(active && active.extraVideos) ? active.extraVideos : [];

  return {
    id: lid,
    videoId: videoId,
    videoUrl: 'https://www.youtube.com/watch?v=' + videoId,
    title: title,
    channel: channel,
    defaultVideoId: def.videoId,
    defaultTitle: def.title,
    defaultChannel: def.channel,
    isCustom: !!(active && (active.videoId || extraVideos.length > 0)),
    extraVideos: extraVideos
  };
};

window.saveLocalLessonVideoConfig = function(lessonId, cfg) {
  const lid = String(lessonId);
  try {
    const customLessons = JSON.parse(localStorage.getItem('math10_custom_lessons') || '{}');
    const existing = customLessons[lid] || {};
    if (cfg && cfg.resetToDefault) {
      delete existing.videoId;
      delete existing.videoUrl;
      delete existing.videoTitle;
      delete existing.videoChannel;
      delete existing.extraVideos;
      existing.updatedAt = new Date().toISOString();
      if (Object.keys(existing).length <= 1) {
        delete customLessons[lid];
      } else {
        customLessons[lid] = existing;
      }
      if (window.MATH10_SERVER_VIDEOS) delete window.MATH10_SERVER_VIDEOS[Number(lid)];
    } else if (cfg) {
      customLessons[lid] = {
        ...existing,
        videoId: cfg.videoId || existing.videoId,
        videoUrl: cfg.videoUrl || (cfg.videoId ? ('https://www.youtube.com/watch?v=' + cfg.videoId) : existing.videoUrl),
        videoTitle: cfg.videoTitle !== undefined ? cfg.videoTitle : (cfg.title !== undefined ? cfg.title : existing.videoTitle),
        videoChannel: cfg.videoChannel !== undefined ? cfg.videoChannel : (cfg.channel !== undefined ? cfg.channel : existing.videoChannel),
        extraVideos: Array.isArray(cfg.extraVideos) ? cfg.extraVideos : (existing.extraVideos || []),
        updatedAt: cfg.updatedAt || new Date().toISOString()
      };
      if (window.MATH10_SERVER_VIDEOS) {
        window.MATH10_SERVER_VIDEOS[Number(lid)] = {
          lessonId: Number(lid),
          videoId: customLessons[lid].videoId,
          videoUrl: customLessons[lid].videoUrl,
          title: customLessons[lid].videoTitle,
          channel: customLessons[lid].videoChannel,
          extraVideos: customLessons[lid].extraVideos,
          updatedAt: customLessons[lid].updatedAt
        };
      }
    }
    localStorage.setItem('math10_custom_lessons', JSON.stringify(customLessons));
  } catch (e) {}
};

window.syncServerLessonVideos = async function(apiBase) {
  try {
    const base = apiBase || window.MATH10_API_BASE_URL || 'http://localhost:8081/api/v1';
    const res = await fetch(base + '/lessons/videos', { credentials: 'include' });
    if (res.ok) {
      const data = await res.json();
      if (data && typeof data === 'object') {
        window.MATH10_SERVER_VIDEOS = data;
        return data;
      }
    }
  } catch (e) {}
  return null;
};

window.MATH10_LESSONS_DATA = {
  1: {
    id: 1,
    title: "Bài 1. Mệnh đề",
    topic: "Chương I. Mệnh đề và tập hợp",
    desc: "Nhận biết mệnh đề, phủ định và mệnh đề chứa biến.",
    sections: [
      { heading: "1. Khái niệm mệnh đề và mệnh đề chứa biến", body: "Mệnh đề là một câu khẳng định có tính đúng hoặc sai rõ ràng. Một câu không thể vừa đúng vừa sai.<br>• Câu hỏi, câu cảm thán, câu cầu khiến không phải là mệnh đề.<br>• <em>Mệnh đề chứa biến</em> là câu chứa biến số (ví dụ: \\( P(x): x > 3 \\)), câu này chỉ trở thành mệnh đề khi biến nhận một giá trị cụ thể." },
      { heading: "2. Mệnh đề phủ định, kéo theo và tương đương", body: "• <strong>Phủ định:</strong> Kí hiệu \\( \\overline{P} \\). Nếu \\( P \\) đúng thì \\( \\overline{P} \\) sai và ngược lại.<br>• <strong>Mệnh đề kéo theo:</strong> \\( P \\Rightarrow Q \\) (Đọc là: \"Nếu P thì Q\"). Mệnh đề này chỉ sai khi \\( P \\) đúng mà \\( Q \\) sai.<br>• <strong>Mệnh đề đảo:</strong> Mệnh đề đảo của \\( P \\Rightarrow Q \\) là \\( Q \\Rightarrow P \\).<br>• <strong>Mệnh đề tương đương:</strong> \\( P \\Leftrightarrow Q \\) đúng khi \\( P \\) và \\( Q \\) cùng đúng hoặc cùng sai." },
      { heading: "3. Kí hiệu với mọi (∀) và tồn tại (∃)", body: "• \\( \\forall x \\in X, P(x) \\): \"Với mọi \\( x \\) thuộc \\( X \\), \\( P(x) \\) đúng\".<br>• \\( \\exists x \\in X, P(x) \\): \"Tồn tại \\( x \\) thuộc \\( X \\) sao cho \\( P(x) \\) đúng\".<br>• Phủ định của \\( \\forall \\) là \\( \\exists \\): \\( \\overline{\\forall x, P(x)} \\equiv \\exists x, \\overline{P(x)} \\).<br>• Phủ định của \\( \\exists \\) là \\( \\forall \\): \\( \\overline{\\exists x, P(x)} \\equiv \\forall x, \\overline{P(x)} \\)." },
      { heading: "4. Ví dụ minh họa và ghi nhớ", body: "<strong>Ví dụ:</strong> Phủ định mệnh đề: \\( P: \"\\forall x \\in \\mathbb{R}, x^2 + 1 > 0\" \\).<br><em>Lời giải:</em> Phủ định là \\( \\overline{P}: \"\\exists x \\in \\mathbb{R}, x^2 + 1 \\le 0\" \\).<br><em>Ghi nhớ:</em> Khi phủ định mệnh đề có lượng từ, phải đổi lượng từ \\( \\forall \\leftrightarrow \\exists \\) và đổi khẳng định sang phủ định tính chất." },
    ]
  },
  2: {
    id: 2,
    title: "Bài 2. Tập hợp và các phép toán trên tập hợp",
    topic: "Chương I. Mệnh đề và tập hợp",
    desc: "Biểu diễn tập hợp và thực hiện hợp, giao, hiệu, phần bù.",
    sections: [
      { heading: "1. Khái niệm tập hợp và tập con", body: "Tập hợp là khái niệm cơ bản. Phần tử \\( a \\) thuộc tập \\( A \\) kí hiệu \\( a \\in A \\).<br>• Tập rỗng kí hiệu \\( \\emptyset \\), là tập không chứa phần tử nào.<br>• \\( A \\subset B \\) (A là tập con của B) nếu mọi phần tử của \\( A \\) đều thuộc \\( B \\). Quy ước: \\( \\emptyset \\subset A \\) với mọi \\( A \\)." },
      { heading: "2. Các phép toán trên tập hợp", body: "• <strong>Giao của hai tập hợp:</strong> \\( A \\cap B = \\{ x \\mid x \\in A \\text{ và } x \\in B \\} \\).<br>• <strong>Hợp của hai tập hợp:</strong> \\( A \\cup B = \\{ x \\mid x \\in A \\text{ hoặc } x \\in B \\} \\).<br>• <strong>Hiệu của hai tập hợp:</strong> \\( A \\setminus B = \\{ x \\mid x \\in A \\text{ và } x \\notin B \\} \\).<br>• <strong>Phần bù:</strong> Khi \\( A \\subset X \\), phần bù của \\( A \\) trong \\( X \\) là \\( C_X A = X \\setminus A \\)." },
      { heading: "3. Các tập hợp con của số thực ℝ", body: "• Khoảng: \\( (a; b) = \\{ x \\in \\mathbb{R} \\mid a < x < b \\} \\).<br>• Đoạn: \\( [a; b] = \\{ x \\in \\mathbb{R} \\mid a \\le x \\le b \\} \\).<br>• Nửa khoảng: \\( [a; b), (a; b], [a; +\\infty), (-\\infty; b] \\)." },
      { heading: "4. Ví dụ minh họa", body: "<strong>Ví dụ:</strong> Cho \\( A = [-2; 3] \\) và \\( B = (1; 5) \\). Tìm \\( A \\cap B \\), \\( A \\cup B \\), \\( A \\setminus B \\).<br><em>Lời giải:</em><br>• \\( A \\cap B = (1; 3] \\)<br>• \\( A \\cup B = [-2; 5) \\)<br>• \\( A \\setminus B = [-2; 1] \\)." },
    ]
  },
  3: {
    id: 3,
    title: "Bài 3. Bất phương trình bậc nhất hai ẩn",
    topic: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn",
    desc: "Biểu diễn miền nghiệm của bất phương trình tuyến tính hai ẩn.",
    sections: [
      { heading: "1. Định nghĩa bất phương trình bậc nhất hai ẩn", body: "Bất phương trình bậc nhất hai ẩn \\( x, y \\) có dạng tổng quát là:<br>\\[ ax + by \\le c \\quad (\\text{hoặc } ax + by < c, \\; ax + by \\ge c, \\; ax + by > c) \\]<br>trong đó \\( a, b, c \\) là các số thực đã cho, \\( a \\) và \\( b \\) không đồng thời bằng 0." },
      { heading: "2. Biểu diễn miền nghiệm trên mặt phẳng tọa độ", body: "Trên mặt phẳng tọa độ \\( Oxy \\), đường thẳng \\( d: ax + by = c \\) chia mặt phẳng thành hai nửa mặt phẳng.<br>1. Vẽ đường thẳng \\( d: ax + by = c \\).<br>2. Lấy một điểm \\( M_0(x_0, y_0) \\notin d \\) (thường chọn gốc tọa độ \\( O(0; 0) \\) nếu \\( c \\ne 0 \\)).<br>3. Tính \\( ax_0 + by_0 \\) và so sánh với \\( c \\). Nếu thỏa mãn BPT thì nửa mặt phẳng chứa \\( M_0 \\) là miền nghiệm; nếu không thỏa mãn thì nửa mặt phẳng còn lại là miền nghiệm." },
      { heading: "3. Ví dụ minh họa", body: "<strong>Ví dụ:</strong> Biểu diễn miền nghiệm của BPT: \\( 2x - y + 2 \\ge 0 \\).<br><em>Lời giải:</em> Vẽ đường thẳng \\( d: 2x - y + 2 = 0 \\) đi qua \\( (0; 2) \\) và \\( (-1; 0) \\).<br>Xét điểm \\( O(0; 0) \\): \\( 2(0) - 0 + 2 = 2 \\ge 0 \\) (đúng).<br>Vậy miền nghiệm là nửa mặt phẳng bờ \\( d \\) chứa gốc tọa độ \\( O \\) (kể cả bờ \\( d \\))." },
      { heading: "4. Ghi nhớ quan trọng", body: "Nếu BPT có dấu \\( \\le \\) hoặc \\( \\ge \\), miền nghiệm tính cả bờ \\( d \\) (vẽ nét liền).<br>Nếu BPT có dấu \\( < \\) hoặc \\( > \\), miền nghiệm không kể bờ \\( d \\) (vẽ nét đứt)." },
    ]
  },
  4: {
    id: 4,
    title: "Bài 4. Hệ bất phương trình bậc nhất hai ẩn",
    topic: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn",
    desc: "Tìm miền nghiệm chung và vận dụng vào bài toán tối ưu đơn giản.",
    sections: [
      { heading: "1. Hệ bất phương trình bậc nhất hai ẩn", body: "Hệ bất phương trình bậc nhất hai ẩn gồm hai hay nhiều bất phương trình bậc nhất hai ẩn.<br>Miền nghiệm của hệ là phần giao (phần chung) của các miền nghiệm của từng bất phương trình trong hệ." },
      { heading: "2. Phương pháp giải và biểu diễn", body: "1. Vẽ các đường thẳng tương ứng với từng bất phương trình trên cùng hệ trục tọa độ \\( Oxy \\).<br>2. Xác định miền nghiệm của từng BPT và gạch bỏ phần không thuộc miền nghiệm.<br>3. Phần mặt phẳng không bị gạch chính là miền nghiệm của hệ." },
      { heading: "3. Ứng dụng bài toán tối ưu quy hoạch tuyến tính", body: "Giá trị lớn nhất và nhỏ nhất của biểu thức \\( F(x, y) = ax + by \\) trên một miền đa giác lồi \\( S \\) luôn đạt được tại một trong các đỉnh của đa giác đó.<br>• Bước 1: Tìm tọa độ tất cả các đỉnh của đa giác miền nghiệm.<br>• Bước 2: Tính giá trị của \\( F(x, y) \\) tại các đỉnh đó và so sánh." },
      { heading: "4. Ví dụ", body: "Tìm giá trị lớn nhất của \\( F(x, y) = 2x + 3y \\) với \\( (x, y) \\) thuộc tam giác có ba đỉnh \\( A(0;0), B(4;0), C(1;3) \\).<br><em>Lời giải:</em> \\( F(A) = 0 \\), \\( F(B) = 2(4) + 0 = 8 \\), \\( F(C) = 2(1) + 3(3) = 11 \\).<br>Vậy giá trị lớn nhất của \\( F \\) là 11 đạt tại \\( C(1; 3) \\)." },
    ]
  },
  5: {
    id: 5,
    title: "Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°",
    topic: "Chương III. Hệ thức lượng trong tam giác",
    desc: "Hiểu dấu và các giá trị lượng giác của góc tù, góc nhọn.",
    sections: [
      { heading: "1. Định nghĩa tỉ số lượng giác góc từ 0° đến 180°", body: "Trên nửa đường tròn đơn vị tâm \\( O \\), bán kính \\( R = 1 \\) nằm phía trên trục hoành:<br>Với góc \\( \\alpha \\) (\\( 0^\\circ \\le \\alpha \\le 180^\\circ \\)), điểm \\( M(x_0; y_0) \\) trên nửa đường tròn sao cho \\( \\widehat{xOM} = \\alpha \\):<br>• \\( \\sin \\alpha = y_0 \\)<br>• \\( \\cos \\alpha = x_0 \\)<br>• \\( \\tan \\alpha = \\frac{y_0}{x_0} = \\frac{\\sin \\alpha}{\\cos \\alpha} \\quad (\\alpha \\ne 90^\\circ) \\)<br>• \\( \\cot \\alpha = \\frac{x_0}{y_0} = \\frac{\\cos \\alpha}{\\sin \\alpha} \\quad (\\alpha \\ne 0^\\circ, 180^\\circ) \\)." },
      { heading: "2. Tính chất hai góc bù nhau", body: "Với hai góc bù nhau (\\( \\alpha \\) và \\( 180^\\circ - \\alpha \\)):<br>• \\( \\sin(180^\\circ - \\alpha) = \\sin \\alpha \\)<br>• \\( \\cos(180^\\circ - \\alpha) = -\\cos \\alpha \\)<br>• \\( \\tan(180^\\circ - \\alpha) = -\\tan \\alpha \\)<br>• \\( \\cot(180^\\circ - \\alpha) = -\\cot \\alpha \\)." },
      { heading: "3. Các hệ thức cơ bản", body: "• \\( \\sin^2 \\alpha + \\cos^2 \\alpha = 1 \\)<br>• \\( 1 + \\tan^2 \\alpha = \\frac{1}{\\cos^2 \\alpha} \\quad (\\alpha \\ne 90^\\circ) \\)<br>• \\( 1 + \\cot^2 \\alpha = \\frac{1}{\\sin^2 \\alpha} \\quad (\\alpha \\ne 0^\\circ, 180^\\circ) \\)<br>• \\( \\tan \\alpha \\cdot \\cot \\alpha = 1 \\)." },
      { heading: "4. Ví dụ tính toán", body: "<strong>Ví dụ:</strong> Tính \\( \\sin 150^\\circ \\) và \\( \\cos 150^\\circ \\).<br><em>Lời giải:</em> Ta có \\( 150^\\circ = 180^\\circ - 30^\\circ \\):<br>• \\( \\sin 150^\\circ = \\sin 30^\\circ = \\frac{1}{2} \\)<br>• \\( \\cos 150^\\circ = -\\cos 30^\\circ = -\\frac{\\sqrt{3}}{2} \\)." },
    ]
  },
  6: {
    id: 6,
    title: "Bài 6. Hệ thức lượng trong tam giác",
    topic: "Chương III. Hệ thức lượng trong tam giác",
    desc: "Áp dụng định lí sin, cosin và công thức diện tích.",
    sections: [
      { heading: "1. Định lí Côsin", body: "Trong tam giác \\( ABC \\) có \\( BC=a, CA=b, AB=c \\):<br>\\[ a^2 = b^2 + c^2 - 2bc \\cos A \\]<br>\\[ b^2 = a^2 + c^2 - 2ac \\cos B \\]<br>\\[ c^2 = a^2 + b^2 - 2ab \\cos C \\]<br>Hệ quả tính góc: \\( \\cos A = \\frac{b^2 + c^2 - a^2}{2bc} \\)." },
      { heading: "2. Định lí Sin", body: "Trong tam giác \\( ABC \\) với \\( R \\) là bán kính đường tròn ngoại tiếp:<br>\\[ \\frac{a}{\\sin A} = \\frac{b}{\\sin B} = \\frac{c}{\\sin C} = 2R \\]" },
      { heading: "3. Các công thức tính diện tích tam giác", body: "• \\( S = \\frac{1}{2} a h_a = \\frac{1}{2} b h_b = \\frac{1}{2} c h_c \\)<br>• \\( S = \\frac{1}{2} ab \\sin C = \\frac{1}{2} bc \\sin A = \\frac{1}{2} ca \\sin B \\)<br>• \\( S = \\frac{abc}{4R} \\)<br>• \\( S = pr \\) (với \\( p = \\frac{a+b+c}{2} \\), \\( r \\) là bán kính nội tiếp)<br>• Công thức Hê-rông: \\( S = \\sqrt{p(p-a)(p-b)(p-c)} \\)." },
      { heading: "4. Ví dụ giải tam giác", body: "<strong>Ví dụ:</strong> Cho \\( \\triangle ABC \\) có \\( b=4, c=5, \\widehat{A}=60^\\circ \\). Tính cạnh \\( a \\) và diện tích \\( S \\).<br><em>Lời giải:</em><br>• \\( a^2 = 4^2 + 5^2 - 2(4)(5)\\cos 60^\\circ = 16 + 25 - 20 = 21 \\Rightarrow a = \\sqrt{21} \\).<br>• \\( S = \\frac{1}{2}bc\\sin A = \\frac{1}{2}(4)(5)\\sin 60^\\circ = 10 \\cdot \\frac{\\sqrt{3}}{2} = 5\\sqrt{3} \\)." },
    ]
  },
  7: {
    id: 7,
    title: "Bài 7. Các khái niệm mở đầu",
    topic: "Chương IV. Vectơ",
    desc: "Nhận biết vectơ, độ dài, phương, hướng và vectơ bằng nhau.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Vectơ AB có điểm đầu A, điểm cuối B; độ dài kí hiệu |AB|. Hai vectơ bằng nhau khi cùng hướng và cùng độ dài. Vectơ-không có độ dài 0 và điểm đầu trùng điểm cuối.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 7. Các khái niệm mở đầu." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 7. Các khái niệm mở đầu." },
    ]
  },
  8: {
    id: 8,
    title: "Bài 8. Tổng và hiệu của hai vectơ",
    topic: "Chương IV. Vectơ",
    desc: "Dùng quy tắc ba điểm, hình bình hành và vectơ đối.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Quy tắc ba điểm: vectơ AB + vectơ BC = vectơ AC. Quy tắc hình bình hành: tổng hai vectơ cùng gốc là đường chéo xuất phát từ gốc. Hiệu a−b=a+(−b), trong đó −b đối hướng với b.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 8. Tổng và hiệu của hai vectơ." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 8. Tổng và hiệu của hai vectơ." },
    ]
  },
  9: {
    id: 9,
    title: "Bài 9. Tích của một vectơ với một số",
    topic: "Chương IV. Vectơ",
    desc: "Hiểu hướng và độ dài của vectơ k·a.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Với số thực k và vectơ a, |ka|=|k||a|. Nếu k>0, ka cùng hướng a; nếu k<0, ka ngược hướng; nếu k=0, ka là vectơ-không.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 9. Tích của một vectơ với một số." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 9. Tích của một vectơ với một số." },
    ]
  },
  10: {
    id: 10,
    title: "Bài 10. Vectơ trong mặt phẳng tọa độ",
    topic: "Chương IV. Vectơ",
    desc: "Tính tọa độ vectơ, độ dài và tọa độ trung điểm.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Nếu A(x₁,y₁), B(x₂,y₂) thì vectơ AB=(x₂−x₁,y₂−y₁), |AB|=√((x₂−x₁)²+(y₂−y₁)²). Trung điểm M của AB có tọa độ ((x₁+x₂)/2,(y₁+y₂)/2).<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 10. Vectơ trong mặt phẳng tọa độ." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 10. Vectơ trong mặt phẳng tọa độ." },
    ]
  },
  11: {
    id: 11,
    title: "Bài 11. Tích vô hướng của hai vectơ",
    topic: "Chương IV. Vectơ",
    desc: "Tính tích vô hướng và dùng để nhận biết vuông góc.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: a·b=|a||b|cosθ. Với a=(x₁,y₁), b=(x₂,y₂), a·b=x₁x₂+y₁y₂. Hai vectơ khác vectơ-không vuông góc khi và chỉ khi tích vô hướng bằng 0.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 11. Tích vô hướng của hai vectơ." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 11. Tích vô hướng của hai vectơ." },
    ]
  },
  12: {
    id: 12,
    title: "Bài 12. Số gần đúng và sai số",
    topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
    desc: "Làm tròn số và ước lượng sai số tuyệt đối, tương đối.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Số gần đúng x̃ xấp xỉ giá trị đúng x. Sai số tuyệt đối Δ=|x̃−x|; sai số tương đối δ=Δ/|x| (x≠0), thường biểu diễn theo phần trăm. Làm tròn theo hàng yêu cầu: xét chữ số ngay bên phải hàng đó.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 12. Số gần đúng và sai số." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 12. Số gần đúng và sai số." },
    ]
  },
  13: {
    id: 13,
    title: "Bài 13. Các số đặc trưng đo xu thế trung tâm",
    topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
    desc: "Tính số trung bình, trung vị và mốt để mô tả dữ liệu.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Số trung bình x̄=(x₁+…+xₙ)/n. Trung vị là giá trị ở giữa sau khi sắp xếp; nếu n chẵn thì lấy trung bình hai giá trị giữa. Mốt là giá trị xuất hiện nhiều nhất.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 13. Các số đặc trưng đo xu thế trung tâm." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 13. Các số đặc trưng đo xu thế trung tâm." },
    ]
  },
  14: {
    id: 14,
    title: "Bài 14. Các số đặc trưng đo độ phân tán",
    topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
    desc: "Dùng khoảng biến thiên, khoảng tứ phân vị và độ lệch chuẩn.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Khoảng biến thiên R=xmax−xmin. Khoảng tứ phân vị ΔQ=Q₃−Q₁. Phương sai s²=(1/n)Σ(xᵢ−x̄)²; độ lệch chuẩn s=√s². Các đại lượng này mô tả độ phân tán quanh tâm.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 14. Các số đặc trưng đo độ phân tán." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 14. Các số đặc trưng đo độ phân tán." },
    ]
  },
  15: {
    id: 15,
    title: "Bài 15. Hàm số",
    topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
    desc: "Xác định tập xác định, giá trị và đọc đồ thị hàm số.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Hàm số f xác định trên tập D khi mỗi x∈D được gán đúng một giá trị f(x). Đồ thị gồm các điểm (x,f(x)). Với phân thức, mẫu khác 0; với căn bậc hai, biểu thức dưới căn không âm.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 15. Hàm số." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 15. Hàm số." },
    ]
  },
  16: {
    id: 16,
    title: "Bài 16. Hàm số bậc hai",
    topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
    desc: "Khảo sát dạng, đỉnh, trục đối xứng và chiều mở của parabol.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Hàm số bậc hai có dạng y=ax²+bx+c, a≠0; đồ thị là parabol. Trục đối xứng x=−b/(2a), đỉnh I(−b/(2a),−Δ/(4a)), Δ=b²−4ac. Nếu a>0 parabol mở lên, nếu a<0 mở xuống.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 16. Hàm số bậc hai." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 16. Hàm số bậc hai." },
    ]
  },
  17: {
    id: 17,
    title: "Bài 17. Dấu của tam thức bậc hai",
    topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
    desc: "Xét dấu ax²+bx+c theo nghiệm và hệ số a.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Với f(x)=ax²+bx+c, Δ=b²−4ac. Nếu Δ<0, f luôn cùng dấu a. Nếu Δ=0, f cùng dấu a và bằng 0 tại nghiệm kép. Nếu Δ>0 có hai nghiệm x₁<x₂: f cùng dấu a ngoài khoảng hai nghiệm, trái dấu a ở giữa.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 17. Dấu của tam thức bậc hai." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 17. Dấu của tam thức bậc hai." },
    ]
  },
  18: {
    id: 18,
    title: "Bài 18. Phương trình quy về phương trình bậc hai",
    topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
    desc: "Giải phương trình chứa căn, phân thức bằng điều kiện và phép đặt ẩn.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Khi biến đổi phương trình chứa căn hoặc phân thức, phải ghi điều kiện xác định. Bình phương hai vế có thể sinh nghiệm ngoại lai, nên luôn thay nghiệm vào phương trình ban đầu. Có thể đặt t=x² (t≥0) để đưa về phương trình bậc hai theo t.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 18. Phương trình quy về phương trình bậc hai." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 18. Phương trình quy về phương trình bậc hai." },
    ]
  },
  19: {
    id: 19,
    title: "Bài 19. Phương trình đường thẳng",
    topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
    desc: "Viết phương trình đường thẳng từ điểm và vectơ pháp tuyến.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Đường thẳng qua M₀(x₀,y₀), có vectơ pháp tuyến n=(a,b) có phương trình a(x−x₀)+b(y−y₀)=0, tương đương ax+by+c=0. Vectơ chỉ phương có thể lấy u=(−b,a).<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 19. Phương trình đường thẳng." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 19. Phương trình đường thẳng." },
    ]
  },
  20: {
    id: 20,
    title: "Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách",
    topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
    desc: "Xét giao điểm, song song, góc và khoảng cách điểm–đường.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Với d₁:a₁x+b₁y+c₁=0 và d₂:a₂x+b₂y+c₂=0, xét tỉ số hệ số để nhận biết song song/trùng nhau. Góc giữa hai đường thẳng thỏa tanθ=|a₁b₂−a₂b₁|/|a₁a₂+b₁b₂|. Khoảng cách từ M(x₀,y₀) đến d là |ax₀+by₀+c|/√(a²+b²).<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách." },
    ]
  },
  21: {
    id: 21,
    title: "Bài 21. Đường tròn trong mặt phẳng tọa độ",
    topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
    desc: "Nhận dạng tâm, bán kính và lập phương trình đường tròn.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Đường tròn tâm I(a,b), bán kính R có phương trình (x−a)²+(y−b)²=R². Dạng x²+y²+Ax+By+C=0 có tâm I(−A/2,−B/2), R²=(A²+B²)/4−C.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 21. Đường tròn trong mặt phẳng tọa độ." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 21. Đường tròn trong mặt phẳng tọa độ." },
    ]
  },
  22: {
    id: 22,
    title: "Bài 22. Ba đường conic",
    topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
    desc: "Nhận biết elip, hypebol, parabol qua tiêu điểm và phương trình.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Elip gồm điểm có tổng khoảng cách đến hai tiêu điểm không đổi; hypebol có trị tuyệt đối hiệu hai khoảng cách không đổi; parabol gồm điểm cách đều tiêu điểm và đường chuẩn. Dạng chuẩn thường gặp: x²/a²+y²/b²=1; x²/a²−y²/b²=1; y²=2px.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 22. Ba đường conic." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 22. Ba đường conic." },
    ]
  },
  23: {
    id: 23,
    title: "Bài 23. Quy tắc đếm",
    topic: "Chương VIII. Đại số tổ hợp",
    desc: "Phân biệt quy tắc cộng và quy tắc nhân trong bài đếm.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Nếu một công việc chọn một trong các phương án rời nhau có m hoặc n cách thì có m+n cách (quy tắc cộng). Nếu công việc gồm hai bước lần lượt có m và n cách thì có mn cách (quy tắc nhân).<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 23. Quy tắc đếm." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 23. Quy tắc đếm." },
    ]
  },
  24: {
    id: 24,
    title: "Bài 24. Hoán vị, chỉnh hợp và tổ hợp",
    topic: "Chương VIII. Đại số tổ hợp",
    desc: "Chọn công thức đếm có xét hay không xét thứ tự.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Hoán vị n phần tử: Pₙ=n!. Chỉnh hợp chập k: Aₙᵏ=n!/(n−k)!, có xét thứ tự. Tổ hợp chập k: Cₙᵏ=n!/[k!(n−k)!], không xét thứ tự.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 24. Hoán vị, chỉnh hợp và tổ hợp." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 24. Hoán vị, chỉnh hợp và tổ hợp." },
    ]
  },
  25: {
    id: 25,
    title: "Bài 25. Nhị thức Newton",
    topic: "Chương VIII. Đại số tổ hợp",
    desc: "Khai triển (a+b)ⁿ bằng hệ số nhị thức.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: (a+b)ⁿ=Σ(k=0 đến n) Cₙᵏ aⁿ⁻ᵏbᵏ. Hệ số Cₙᵏ cũng là các phần tử hàng n của tam giác Pascal.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 25. Nhị thức Newton." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 25. Nhị thức Newton." },
    ]
  },
  26: {
    id: 26,
    title: "Bài 26. Biến cố và định nghĩa cổ điển của xác suất",
    topic: "Chương IX. Tính xác suất theo định nghĩa cổ điển",
    desc: "Mô tả không gian mẫu, biến cố và tính xác suất đồng khả năng.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Phép thử có không gian mẫu Ω gồm các kết quả có thể xảy ra. Biến cố A là tập con của Ω. Khi các kết quả đồng khả năng, P(A)=n(A)/n(Ω), nên 0≤P(A)≤1.<br><br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 26. Biến cố và định nghĩa cổ điển của xác suất." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 26. Biến cố và định nghĩa cổ điển của xác suất." },
    ]
  },
  27: {
    id: 27,
    title: "Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển",
    topic: "Chương IX. Tính xác suất theo định nghĩa cổ điển",
    desc: "Tổ chức phép thử đơn giản và đếm kết quả thuận lợi.",
    sections: [
      { heading: "1. Kiến thức cốt lõi", body: "KIẾN THỨC: Để tính xác suất cổ điển, xác định phép thử, không gian mẫu hữu hạn, tính đồng khả năng, rồi đếm biến cố cần xét. Có thể dùng sơ đồ cây hoặc bảng để không bỏ sót trường hợp.<br>" },
      { heading: "2. Công thức và quy tắc trọng tâm", body: "Nắm vững các quy tắc biến đổi và định lý cơ bản được quy định trong SGK Toán 10 Kết nối tri thức cho Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển." },
      { heading: "3. Ví dụ áp dụng", body: "<strong>Ví dụ tiêu biểu:</strong> Vận dụng định lý và tính chất nêu trên để giải bài tập cơ bản trong SGK.<br><em>Phương pháp:</em> Xác định giả thiết, áp dụng đúng công thức và kiểm tra điều kiện xác định." },
      { heading: "4. Ghi nhớ & Lưu ý", body: "Chú ý các trường hợp đặc biệt, dấu của biểu thức và điều kiện tồn tại khi áp dụng công thức của Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển." },
    ]
  }
};
