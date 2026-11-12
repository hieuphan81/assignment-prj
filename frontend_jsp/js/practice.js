// Practice Page Logic for JSP views with all 27 textbook questions
(function() {
  const allQuestions = [
    {
      id: 7,
      lessonId: 1,
      lessonTitle: "Bài 1. Mệnh đề",
      topic: "Chương I. Mệnh đề và tập hợp",
      difficulty: "EASY",
      text: "Câu nào sau đây là mệnh đề?",
      options: [
        { letter: "A", text: "x > 2" },
        { letter: "B", text: "Bạn đang học Toán à?" },
        { letter: "C", text: "2 + 3 = 5" },
        { letter: "D", text: "Hãy giải phương trình này." }
      ],
      correctAnswer: "C",
      explanation: "Mệnh đề là câu khẳng định có giá trị đúng hoặc sai xác định. Câu 2 + 3 = 5 là khẳng định đúng."
    },
    {
      id: 8,
      lessonId: 2,
      lessonTitle: "Bài 2. Tập hợp và các phép toán trên tập hợp",
      topic: "Chương I. Mệnh đề và tập hợp",
      difficulty: "EASY",
      text: "Cho A={1,2,3} và B={2,3,4}. Tập A ∩ B là gì?",
      options: [
        { letter: "A", text: "{1,2,3,4}" },
        { letter: "B", text: "{2,3}" },
        { letter: "C", text: "{1,4}" },
        { letter: "D", text: "{1,2}" }
      ],
      correctAnswer: "B",
      explanation: "Giao của hai tập hợp gồm các phần tử chung của cả A và B."
    },
    {
      id: 9,
      lessonId: 3,
      lessonTitle: "Bài 3. Bất phương trình bậc nhất hai ẩn",
      topic: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn",
      difficulty: "EASY",
      text: "Điểm nào thuộc miền nghiệm của x + y ≤ 4?",
      options: [
        { letter: "A", text: "(3,2)" },
        { letter: "B", text: "(5,0)" },
        { letter: "C", text: "(0,0)" },
        { letter: "D", text: "(4,1)" }
      ],
      correctAnswer: "C",
      explanation: "Thay x=0, y=0 được 0≤4 nên điểm (0,0) thỏa mãn."
    },
    {
      id: 10,
      lessonId: 4,
      lessonTitle: "Bài 4. Hệ bất phương trình bậc nhất hai ẩn",
      topic: "Chương II. Bất phương trình và hệ bất phương trình bậc nhất hai ẩn",
      difficulty: "EASY",
      text: "Điểm nào là nghiệm của hệ x ≥ 0, y ≥ 0, x + y ≤ 4?",
      options: [
        { letter: "A", text: "(-1,2)" },
        { letter: "B", text: "(2,3)" },
        { letter: "C", text: "(3,2)" },
        { letter: "D", text: "(1,1)" }
      ],
      correctAnswer: "D",
      explanation: "(1,1) có hai tọa độ không âm và tổng bằng 2≤4."
    },
    {
      id: 11,
      lessonId: 5,
      lessonTitle: "Bài 5. Giá trị lượng giác của một góc từ 0° đến 180°",
      topic: "Chương III. Hệ thức lượng trong tam giác",
      difficulty: "EASY",
      text: "Giá trị sin 150° bằng bao nhiêu?",
      options: [
        { letter: "A", text: "−√3/2" },
        { letter: "B", text: "1/2" },
        { letter: "C", text: "√3/2" },
        { letter: "D", text: "−1/2" }
      ],
      correctAnswer: "B",
      explanation: "sin(180°−α)=sin α nên sin150°=sin30°=1/2."
    },
    {
      id: 12,
      lessonId: 6,
      lessonTitle: "Bài 6. Hệ thức lượng trong tam giác",
      topic: "Chương III. Hệ thức lượng trong tam giác",
      difficulty: "EASY",
      text: "Tam giác có hai cạnh 3 và 4, góc xen giữa 90°. Diện tích bằng bao nhiêu?",
      options: [
        { letter: "A", text: "6" },
        { letter: "B", text: "7" },
        { letter: "C", text: "12" },
        { letter: "D", text: "24" }
      ],
      correctAnswer: "A",
      explanation: "Diện tích S=1/2·3·4·sin90°=6."
    },
    {
      id: 13,
      lessonId: 7,
      lessonTitle: "Bài 7. Các khái niệm mở đầu",
      topic: "Chương IV. Vectơ",
      difficulty: "EASY",
      text: "Vectơ AB có điểm đầu và điểm cuối lần lượt là gì?",
      options: [
        { letter: "A", text: "B và A" },
        { letter: "B", text: "A và B" },
        { letter: "C", text: "A và A" },
        { letter: "D", text: "B và B" }
      ],
      correctAnswer: "B",
      explanation: "Trong kí hiệu vectơ AB, điểm viết trước là điểm đầu, điểm viết sau là điểm cuối."
    },
    {
      id: 14,
      lessonId: 8,
      lessonTitle: "Bài 8. Tổng và hiệu của hai vectơ",
      topic: "Chương IV. Vectơ",
      difficulty: "EASY",
      text: "Với ba điểm A, B, C, tổng vectơ AB + vectơ BC bằng vectơ nào?",
      options: [
        { letter: "A", text: "Vectơ BA" },
        { letter: "B", text: "Vectơ CB" },
        { letter: "C", text: "Vectơ AC" },
        { letter: "D", text: "Vectơ CA" }
      ],
      correctAnswer: "C",
      explanation: "Theo quy tắc ba điểm, vectơ AB + vectơ BC = vectơ AC."
    },
    {
      id: 15,
      lessonId: 9,
      lessonTitle: "Bài 9. Tích của một vectơ với một số",
      topic: "Chương IV. Vectơ",
      difficulty: "EASY",
      text: "Với k=−2, vectơ k·a có đặc điểm nào so với vectơ a?",
      options: [
        { letter: "A", text: "Cùng hướng và dài gấp 2" },
        { letter: "B", text: "Ngược hướng và dài gấp 2" },
        { letter: "C", text: "Cùng hướng và dài bằng một nửa" },
        { letter: "D", text: "Bằng vectơ-không" }
      ],
      correctAnswer: "B",
      explanation: "Độ dài |ka|=|k||a|=2|a|; hệ số âm làm vectơ đổi hướng."
    },
    {
      id: 16,
      lessonId: 10,
      lessonTitle: "Bài 10. Vectơ trong mặt phẳng tọa độ",
      topic: "Chương IV. Vectơ",
      difficulty: "EASY",
      text: "Cho A(1,2), B(4,6). Tọa độ vectơ AB là gì?",
      options: [
        { letter: "A", text: "(5,8)" },
        { letter: "B", text: "(−3,−4)" },
        { letter: "C", text: "(3,4)" },
        { letter: "D", text: "(4,6)" }
      ],
      correctAnswer: "C",
      explanation: "Vectơ AB=(xB−xA,yB−yA)=(4−1,6−2)=(3,4)."
    },
    {
      id: 17,
      lessonId: 11,
      lessonTitle: "Bài 11. Tích vô hướng của hai vectơ",
      topic: "Chương IV. Vectơ",
      difficulty: "EASY",
      text: "Cho a=(2,1), b=(1,−2). Tích vô hướng a·b bằng bao nhiêu?",
      options: [
        { letter: "A", text: "0" },
        { letter: "B", text: "2" },
        { letter: "C", text: "4" },
        { letter: "D", text: "−4" }
      ],
      correctAnswer: "A",
      explanation: "a·b=2·1+1·(−2)=0."
    },
    {
      id: 18,
      lessonId: 12,
      lessonTitle: "Bài 12. Số gần đúng và sai số",
      topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
      difficulty: "EASY",
      text: "Làm tròn số 3,146 đến hàng phần trăm được kết quả nào?",
      options: [
        { letter: "A", text: "3,14" },
        { letter: "B", text: "3,15" },
        { letter: "C", text: "3,10" },
        { letter: "D", text: "3,20" }
      ],
      correctAnswer: "B",
      explanation: "Chữ số hàng phần nghìn là 6 nên tăng chữ số hàng phần trăm từ 4 lên 5."
    },
    {
      id: 19,
      lessonId: 13,
      lessonTitle: "Bài 13. Các số đặc trưng đo xu thế trung tâm",
      topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
      difficulty: "EASY",
      text: "Số trung bình cộng của 2, 4, 6 là bao nhiêu?",
      options: [
        { letter: "A", text: "3" },
        { letter: "B", text: "4" },
        { letter: "C", text: "5" },
        { letter: "D", text: "12" }
      ],
      correctAnswer: "B",
      explanation: "(2+4+6)/3=12/3=4."
    },
    {
      id: 20,
      lessonId: 14,
      lessonTitle: "Bài 14. Các số đặc trưng đo độ phân tán",
      topic: "Chương V. Các số đặc trưng của mẫu số liệu không ghép nhóm",
      difficulty: "EASY",
      text: "Khoảng biến thiên của mẫu số liệu 2, 3, 8, 10 là bao nhiêu?",
      options: [
        { letter: "A", text: "6" },
        { letter: "B", text: "7" },
        { letter: "C", text: "8" },
        { letter: "D", text: "10" }
      ],
      correctAnswer: "C",
      explanation: "Khoảng biến thiên bằng giá trị lớn nhất trừ giá trị nhỏ nhất: 10−2=8."
    },
    {
      id: 21,
      lessonId: 15,
      lessonTitle: "Bài 15. Hàm số",
      topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
      difficulty: "EASY",
      text: "Tập xác định của hàm số f(x)=√(x−1) là gì?",
      options: [
        { letter: "A", text: "x≤1" },
        { letter: "B", text: "x≥1" },
        { letter: "C", text: "x>1" },
        { letter: "D", text: "Mọi số thực" }
      ],
      correctAnswer: "B",
      explanation: "Biểu thức dưới căn phải không âm: x−1≥0, suy ra x≥1."
    },
    {
      id: 4,
      lessonId: 16,
      lessonTitle: "Bài 16. Hàm số bậc hai",
      topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
      difficulty: "EASY",
      text: "Trục đối xứng của parabol y = 2x² − 4x + 1 là gì?",
      options: [
        { letter: "A", text: "x = −1" },
        { letter: "B", text: "x = 1" },
        { letter: "C", text: "x = 2" },
        { letter: "D", text: "x = −2" }
      ],
      correctAnswer: "B",
      explanation: "Trục đối xứng có phương trình x = −b/(2a) = −(−4)/(2·2) = 1."
    },
    {
      id: 22,
      lessonId: 17,
      lessonTitle: "Bài 17. Dấu của tam thức bậc hai",
      topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
      difficulty: "MEDIUM",
      text: "Với f(x)=x²−5x+6, f(x) dương trên khoảng nào?",
      options: [
        { letter: "A", text: "(2,3)" },
        { letter: "B", text: "(−∞,2) ∪ (3,+∞)" },
        { letter: "C", text: "(−∞,3)" },
        { letter: "D", text: "(2,+∞)" }
      ],
      correctAnswer: "B",
      explanation: "f(x)=(x−2)(x−3), hệ số bậc hai dương nên tam thức dương ngoài hai nghiệm."
    },
    {
      id: 23,
      lessonId: 18,
      lessonTitle: "Bài 18. Phương trình quy về phương trình bậc hai",
      topic: "Chương VI. Hàm số, đồ thị và ứng dụng",
      difficulty: "EASY",
      text: "Giải phương trình x²=9 với điều kiện x≥0.",
      options: [
        { letter: "A", text: "x=−3" },
        { letter: "B", text: "x=3" },
        { letter: "C", text: "x=±3" },
        { letter: "D", text: "Phương trình vô nghiệm" }
      ],
      correctAnswer: "B",
      explanation: "x²=9 cho x=±3; điều kiện x≥0 chỉ nhận x=3."
    },
    {
      id: 24,
      lessonId: 19,
      lessonTitle: "Bài 19. Phương trình đường thẳng",
      topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
      difficulty: "MEDIUM",
      text: "Đường thẳng qua M(1,2), có vectơ pháp tuyến n=(2,−1), có phương trình nào?",
      options: [
        { letter: "A", text: "2x−y=0" },
        { letter: "B", text: "x+2y−5=0" },
        { letter: "C", text: "2x+y−4=0" },
        { letter: "D", text: "x−2y+3=0" }
      ],
      correctAnswer: "A",
      explanation: "Phương trình 2(x−1)−(y−2)=0 rút gọn thành 2x−y=0."
    },
    {
      id: 25,
      lessonId: 20,
      lessonTitle: "Bài 20. Vị trí tương đối giữa hai đường thẳng. Góc và khoảng cách",
      topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
      difficulty: "EASY",
      text: "Khoảng cách từ O(0,0) đến đường thẳng 3x+4y−10=0 là bao nhiêu?",
      options: [
        { letter: "A", text: "1" },
        { letter: "B", text: "2" },
        { letter: "C", text: "5" },
        { letter: "D", text: "10" }
      ],
      correctAnswer: "B",
      explanation: "d=|3·0+4·0−10|/√(3²+4²)=10/5=2."
    },
    {
      id: 26,
      lessonId: 21,
      lessonTitle: "Bài 21. Đường tròn trong mặt phẳng tọa độ",
      topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
      difficulty: "EASY",
      text: "Đường tròn tâm I(2,−1), bán kính 3 có phương trình nào?",
      options: [
        { letter: "A", text: "(x+2)²+(y−1)²=9" },
        { letter: "B", text: "(x−2)²+(y+1)²=9" },
        { letter: "C", text: "(x−2)²+(y+1)²=3" },
        { letter: "D", text: "(x+2)²+(y−1)²=3" }
      ],
      correctAnswer: "B",
      explanation: "Dạng chuẩn là (x−a)²+(y−b)²=R². Thay a=2, b=−1, R=3."
    },
    {
      id: 27,
      lessonId: 22,
      lessonTitle: "Bài 22. Ba đường conic",
      topic: "Chương VII. Phương pháp tọa độ trong mặt phẳng",
      difficulty: "EASY",
      text: "Với elip x²/25 + y²/9 = 1, nửa trục lớn dài bao nhiêu?",
      options: [
        { letter: "A", text: "3" },
        { letter: "B", text: "4" },
        { letter: "C", text: "5" },
        { letter: "D", text: "25" }
      ],
      correctAnswer: "C",
      explanation: "Ở dạng chuẩn elip, mẫu số lớn hơn là a²=25, nên nửa trục lớn a=5."
    },
    {
      id: 28,
      lessonId: 23,
      lessonTitle: "Bài 23. Quy tắc đếm",
      topic: "Chương VIII. Đại số tổ hợp",
      difficulty: "EASY",
      text: "Có 3 áo và 4 quần. Chọn một bộ gồm một áo và một quần có bao nhiêu cách?",
      options: [
        { letter: "A", text: "7" },
        { letter: "B", text: "12" },
        { letter: "C", text: "16" },
        { letter: "D", text: "24" }
      ],
      correctAnswer: "B",
      explanation: "Theo quy tắc nhân, số cách chọn là 3·4=12."
    },
    {
      id: 29,
      lessonId: 24,
      lessonTitle: "Bài 24. Hoán vị, chỉnh hợp và tổ hợp",
      topic: "Chương VIII. Đại số tổ hợp",
      difficulty: "EASY",
      text: "Chọn 2 học sinh từ 5 học sinh để lập một nhóm có bao nhiêu cách?",
      options: [
        { letter: "A", text: "10" },
        { letter: "B", text: "20" },
        { letter: "C", text: "25" },
        { letter: "D", text: "5" }
      ],
      correctAnswer: "A",
      explanation: "Không xét thứ tự nên số cách là C(5,2)=5!/(2!3!)=10."
    },
    {
      id: 30,
      lessonId: 25,
      lessonTitle: "Bài 25. Nhị thức Newton",
      topic: "Chương VIII. Đại số tổ hợp",
      difficulty: "EASY",
      text: "Hệ số của x² trong khai triển (x+1)³ là bao nhiêu?",
      options: [
        { letter: "A", text: "1" },
        { letter: "B", text: "2" },
        { letter: "C", text: "3" },
        { letter: "D", text: "6" }
      ],
      correctAnswer: "C",
      explanation: "(x+1)³=x³+3x²+3x+1 nên hệ số của x² là 3."
    },
    {
      id: 31,
      lessonId: 26,
      lessonTitle: "Bài 26. Biến cố và định nghĩa cổ điển của xác suất",
      topic: "Chương IX. Tính xác suất theo định nghĩa cổ điển",
      difficulty: "EASY",
      text: "Gieo một con xúc xắc cân đối. Xác suất xuất hiện số chẵn là bao nhiêu?",
      options: [
        { letter: "A", text: "1/6" },
        { letter: "B", text: "1/3" },
        { letter: "C", text: "1/2" },
        { letter: "D", text: "2/3" }
      ],
      correctAnswer: "C",
      explanation: "Có 3 kết quả chẵn trong 6 kết quả đồng khả năng nên xác suất bằng 3/6=1/2."
    },
    {
      id: 32,
      lessonId: 27,
      lessonTitle: "Bài 27. Thực hành tính xác suất theo định nghĩa cổ điển",
      topic: "Chương IX. Tính xác suất theo định nghĩa cổ điển",
      difficulty: "EASY",
      text: "Gieo hai đồng xu cân đối. Xác suất có đúng một mặt sấp là bao nhiêu?",
      options: [
        { letter: "A", text: "1/4" },
        { letter: "B", text: "1/2" },
        { letter: "C", text: "3/4" },
        { letter: "D", text: "1" }
      ],
      correctAnswer: "B",
      explanation: "Có 4 kết quả đồng khả năng; đúng một mặt sấp xảy ra ở 2 kết quả."
    }
  ];

  let questions = allQuestions;
  let currentIndex = 0;
  let selectedAnswers = {};
  let checkedStates = {};
  let currentResults = {};
  let currentMode = null;

  const modeContainer = document.getElementById('practice-mode-container');
  const quizView = document.getElementById('practice-quiz-view');
  const lessonSelect = document.getElementById('practice-lesson-select');
  const startLessonBtn = document.getElementById('practice-start-lesson-btn');
  const startRandomBtn = document.getElementById('practice-start-random-btn');
  const changeModeBtn = document.getElementById('practice-change-mode-btn');
  const modeBadge = document.getElementById('practice-mode-badge');

  const progressText = document.getElementById('practice-progress-text');
  const progressBar = document.getElementById('practice-progress-bar');
  const diffTag = document.getElementById('practice-difficulty-tag');
  const topicName = document.getElementById('practice-topic-name');
  const questionText = document.getElementById('practice-question-text');
  const optionsGroup = document.getElementById('practice-options-group');
  const resultBox = document.getElementById('practice-result-box');
  const prevBtn = document.getElementById('practice-prev-btn');
  const submitBtn = document.getElementById('practice-submit-btn');
  const nextBtn = document.getElementById('practice-next-btn');
  const finishBtn = document.getElementById('practice-finish-btn');
  const nextLessonBtn = document.getElementById('practice-next-lesson-btn');
  let currentLessonId = 1;

  if (!optionsGroup) return;

  // Populate lessons dropdown grouped by topic
  if (lessonSelect) {
    const lessonMap = new Map();
    allQuestions.forEach(q => {
      if (!lessonMap.has(q.lessonId)) {
        lessonMap.set(q.lessonId, { id: q.lessonId, title: q.lessonTitle, topic: q.topic });
      }
    });

    const lessonsList = Array.from(lessonMap.values()).sort((a, b) => a.id - b.id);
    const grouped = {};
    lessonsList.forEach(l => {
      if (!grouped[l.topic]) grouped[l.topic] = [];
      grouped[l.topic].push(l);
    });

    let selectHtml = '';
    for (const [topic, items] of Object.entries(grouped)) {
      selectHtml += `<optgroup label="${topic}">`;
      items.forEach(item => {
        selectHtml += `<option value="${item.id}">${item.title}</option>`;
      });
      selectHtml += `</optgroup>`;
    }
    lessonSelect.innerHTML = selectHtml;
  }

  function showModeSelection() {
    if (modeContainer) modeContainer.classList.remove('d-none');
    if (quizView) quizView.classList.add('d-none');
    currentMode = null;
  }

  function startPracticeByLesson(lessonId) {
    currentMode = 'lesson';
    currentLessonId = lessonId;
    const filtered = allQuestions.filter(q => q.lessonId === lessonId);
    questions = filtered.length > 0 ? filtered : allQuestions;
    currentIndex = 0;
    selectedAnswers = {};
    checkedStates = {};
    currentResults = {};

    const lessonObj = allQuestions.find(q => q.lessonId === lessonId);
    if (modeBadge) {
      modeBadge.textContent = lessonObj ? `Theo bài: ${lessonObj.lessonTitle}` : 'Luyện tập theo bài';
      modeBadge.className = 'badge bg-primary-subtle text-primary border';
    }

    if (modeContainer) modeContainer.classList.add('d-none');
    if (quizView) quizView.classList.remove('d-none');
    renderQuestion();
  }

  function startPracticeRandom() {
    currentMode = 'random';
    const shuffled = [...allQuestions];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    questions = shuffled;
    currentIndex = 0;
    selectedAnswers = {};
    checkedStates = {};
    currentResults = {};

    if (modeBadge) {
      modeBadge.textContent = `Ngẫu nhiên bộ câu hỏi (${questions.length} câu)`;
      modeBadge.className = 'badge bg-success-subtle text-success border';
    }

    if (modeContainer) modeContainer.classList.add('d-none');
    if (quizView) quizView.classList.remove('d-none');
    renderQuestion();
  }

  if (startLessonBtn && lessonSelect) {
    startLessonBtn.addEventListener('click', () => {
      const selectedId = parseInt(lessonSelect.value, 10);
      if (selectedId) startPracticeByLesson(selectedId);
    });
  }

  if (startRandomBtn) {
    startRandomBtn.addEventListener('click', () => {
      startPracticeRandom();
    });
  }

  if (changeModeBtn) {
    changeModeBtn.addEventListener('click', () => {
      showModeSelection();
    });
  }

  function formatMathInContent(text) {
    if (!text) return '';
    let s = String(text).trim();

    // If the string starts with LaTeX command or contains math symbols without any $ or \(
    if (!s.includes('$') && !s.includes('\\(')) {
      if (s.includes('\\') || s.includes('^') || s.includes('_')) {
        return '$' + s + '$';
      }
    }

    // If text has inline LaTeX commands like \dfrac{...}{...} that are NOT wrapped in $...$
    s = s.replace(/(^|[^\$\\])(\\(?:d?frac|sqrt|mathbf|text|left|right|vec|alpha|beta|gamma|Delta|delta|theta|pi|sigma|pm|mp|cdot|times|div|le|ge|ne|approx|sim|in|subset|cap|cup|emptyset|forall|exists|infty|angle|sin|cos|tan|cot|log|ln)\b[^{\$]*?(?:\{[^{}]*\})*)/g, function(match, prefix, expr) {
      return prefix + '$' + expr + '$';
    });

    return s;
  }

  function renderQuestion() {
    if (!questions || questions.length === 0) return;
    const q = questions[currentIndex];
    const total = questions.length;

    if (progressText) progressText.textContent = `Câu ${currentIndex + 1} / ${total}`;
    if (progressBar) progressBar.style.width = `${((currentIndex + 1) / total) * 100}%`;
    if (diffTag) diffTag.textContent = q.difficulty || 'CƠ BẢN';
    if (topicName) topicName.textContent = `${q.topic} • ${q.lessonTitle}`;
    if (questionText) questionText.innerHTML = formatMathInContent(q.text);

    const isChecked = Boolean(checkedStates[currentIndex]);
    const selected = selectedAnswers[currentIndex] || null;
    const res = currentResults[currentIndex] || null;

    optionsGroup.innerHTML = q.options.map(opt => {
      const isSel = selected === opt.letter;
      const isCorrectOpt = isChecked && (opt.letter === q.correctAnswer || (res && res.correctAnswer === opt.letter));
      const isWrongOpt = isChecked && isSel && !(res ? res.correct : opt.letter === q.correctAnswer);

      const classes = ['answer-option'];
      if (isSel) classes.push('selected');
      if (isCorrectOpt) classes.push('is-correct');
      if (isWrongOpt) classes.push('is-wrong');

      return `
        <div class="${classes.join(' ')}" data-answer="${opt.letter}" style="${isChecked ? 'pointer-events: none; cursor: default;' : 'cursor: pointer;'}">
          <div class="answer-letter">${opt.letter}</div>
          <div class="answer-text">${formatMathInContent(opt.text)}</div>
          ${isCorrectOpt ? '<span class="answer-result text-success fw-bold ms-auto">Đáp án đúng</span>' : ''}
          ${isWrongOpt ? '<span class="answer-result text-danger fw-bold ms-auto">Bạn chọn</span>' : ''}
        </div>
      `;
    }).join('');

    // Instant feedback: clicking an option immediately checks it!
    optionsGroup.querySelectorAll('.answer-option').forEach(el => {
      el.addEventListener('click', () => {
        if (checkedStates[currentIndex]) return;
        const chosenLetter = el.dataset.answer;
        selectedAnswers[currentIndex] = chosenLetter;
        checkedStates[currentIndex] = true;

        const isCorrect = (chosenLetter === q.correctAnswer);
        currentResults[currentIndex] = {
          correct: isCorrect,
          correctAnswer: q.correctAnswer,
          explanation: q.explanation
        };

        // Persist real-time practice stats and completed lessons
        try {
          const stats = JSON.parse(localStorage.getItem('math10_practice_stats') || '{"total":0,"correct":0}');
          stats.total = (stats.total || 0) + 1;
          if (isCorrect) stats.correct = (stats.correct || 0) + 1;
          localStorage.setItem('math10_practice_stats', JSON.stringify(stats));

          const completed = JSON.parse(localStorage.getItem('math10_completed_lessons') || '[]');
          if (q.lessonId && !completed.includes(Number(q.lessonId))) {
            completed.push(Number(q.lessonId));
            localStorage.setItem('math10_completed_lessons', JSON.stringify(completed));
          }
        } catch(e) {}

        // Send attempt asynchronously to backend API to persist progress
        try {
          const apiBase = (window.MATH10_API_BASE_URL || '/api/v1');
          const savedUser = localStorage.getItem('math10_session_user');
          const headers = { 'Content-Type': 'application/json' };
          if (savedUser) {
            try {
              const uObj = JSON.parse(savedUser);
              if (uObj && uObj.username) {
                headers['X-Auth-User'] = uObj.username;
              }
            } catch(e) {}
          }
          fetch(apiBase + '/attempts', {
            method: 'POST',
            headers: headers,
            credentials: 'include',
            body: JSON.stringify({ questionId: q.id, answerText: chosenLetter })
          }).then(r => r.ok ? r.json() : null).then(data => {
            if (data && (data.explanation || data.solutionSteps)) {
              currentResults[currentIndex].explanation = data.explanation || data.solutionSteps;
              if (checkedStates[currentIndex]) {
                const explEl = resultBox.querySelector('.explanation-text');
                if (explEl) {
                  explEl.innerHTML = formatMathInContent(currentResults[currentIndex].explanation);
                  if (window.MathJax && window.MathJax.typesetPromise) {
                    window.MathJax.typesetPromise([explEl]).catch(() => {});
                  }
                }
              }
            }
          }).catch(() => {});
        } catch (e) {}

        // Instant re-render
        renderQuestion();
      });
    });

    if (isChecked) {
      const isCorrect = res ? res.correct : (selected === q.correctAnswer);
      const expl = (res && (res.explanation || res.solutionSteps)) ? (res.explanation || res.solutionSteps) : q.explanation;
      const cAns = res ? res.correctAnswer : q.correctAnswer;
      const cText = q.options.find(o => o.letter === cAns)?.text || cAns;

      resultBox.classList.remove('d-none');
      if (isCorrect) {
        resultBox.innerHTML = `
          <div class="alert alert-success py-3 px-3 rounded-3 mt-3" role="status">
            <div class="fw-bold mb-1">Chính xác!</div>
            <div class="explanation-text">${formatMathInContent(expl) || 'Bạn đã chọn đúng đáp án.'}</div>
          </div>
        `;
      } else {
        resultBox.innerHTML = `
          <div class="alert alert-danger py-3 px-3 rounded-3 mt-3" role="status">
            <div class="fw-bold mb-1">Chưa chính xác</div>
            <div class="mb-2"><strong>Đáp án đúng:</strong> ${cAns} — ${formatMathInContent(cText)}</div>
            ${expl ? `<div class="pt-2 border-top border-danger border-opacity-25"><strong>Giải thích:</strong> <span class="explanation-text">${formatMathInContent(expl)}</span></div>` : ''}
          </div>
        `;
      }

      if (submitBtn) submitBtn.classList.add('d-none');
      if (finishBtn) finishBtn.classList.remove('d-none');
      if (nextLessonBtn) nextLessonBtn.classList.remove('d-none');

      if (currentIndex + 1 < total) {
        if (nextBtn) {
          nextBtn.classList.remove('d-none');
          nextBtn.textContent = 'Câu kế tiếp →';
        }
      } else {
        if (nextBtn) nextBtn.classList.add('d-none');
      }
    } else {
      resultBox.classList.add('d-none');
      resultBox.innerHTML = '';
      if (submitBtn) submitBtn.classList.add('d-none');
      if (finishBtn) finishBtn.classList.add('d-none');
      if (nextBtn) nextBtn.classList.add('d-none');
      if (nextLessonBtn) nextLessonBtn.classList.remove('d-none');
    }

    if (prevBtn) prevBtn.disabled = (currentIndex === 0);

    if (window.MathJax && window.MathJax.typesetPromise) {
      window.MathJax.typesetPromise([questionText, optionsGroup, resultBox]).catch(() => {});
    }
  }

  function goToNextLesson() {
    const nextLessonId = (currentLessonId % 27) + 1;
    if (lessonSelect) lessonSelect.value = String(nextLessonId);
    startPracticeByLesson(nextLessonId);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function finishPracticeSession() {
    let correctCount = 0;
    for (let i = 0; i < questions.length; i++) {
      if (currentResults[i] && currentResults[i].correct) correctCount++;
    }
    resultBox.classList.remove('d-none');
    resultBox.innerHTML = `
      <div class="alert alert-primary py-3 px-3 rounded-3 text-center mt-3 shadow-xs">
        <h4 class="fw-bold mb-2">Hoàn thành bài luyện tập!</h4>
        <p class="mb-3">Bạn đã trả lời đúng <strong>${correctCount} / ${questions.length}</strong> câu hỏi.</p>
        <div class="d-flex justify-content-center gap-2 flex-wrap">
          <button class="btn btn-primary fw-semibold" id="practice-summary-next-lesson-btn">Bài tiếp theo &rarr;</button>
          <button class="btn btn-outline-primary" id="practice-restart-btn">Làm lại bài này</button>
          <button class="btn btn-light border" id="practice-pick-mode-btn">Chọn chế độ khác</button>
        </div>
      </div>
    `;
    document.getElementById('practice-summary-next-lesson-btn')?.addEventListener('click', () => {
      goToNextLesson();
    });
    document.getElementById('practice-restart-btn')?.addEventListener('click', () => {
      currentIndex = 0;
      selectedAnswers = {};
      checkedStates = {};
      currentResults = {};
      renderQuestion();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
    document.getElementById('practice-pick-mode-btn')?.addEventListener('click', () => {
      showModeSelection();
    });
    if (nextBtn) nextBtn.classList.add('d-none');
    if (finishBtn) finishBtn.classList.add('d-none');
    if (nextLessonBtn) nextLessonBtn.classList.add('d-none');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  if (finishBtn) {
    finishBtn.addEventListener('click', finishPracticeSession);
  }

  if (nextLessonBtn) {
    nextLessonBtn.addEventListener('click', goToNextLesson);
  }

  if (nextBtn) {
    nextBtn.addEventListener('click', () => {
      if (currentIndex + 1 < questions.length) {
        currentIndex++;
        renderQuestion();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      } else {
        finishPracticeSession();
      }
    });
  }

  if (prevBtn) {
    prevBtn.addEventListener('click', () => {
      if (currentIndex > 0) {
        currentIndex--;
        renderQuestion();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    });
  }

  // Handle URL query parameters or default to mode selection
  const urlParams = new URLSearchParams(window.location.search);
  const paramLessonId = urlParams.get('lessonId');
  const paramMode = urlParams.get('mode');

  if (paramLessonId) {
    startPracticeByLesson(parseInt(paramLessonId, 10));
  } else if (paramMode === 'random') {
    startPracticeRandom();
  } else {
    showModeSelection();
  }
})();
