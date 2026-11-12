-- =====================================================================
-- MATH10 AI — HỆ THỐNG CƠ SỞ DỮ LIỆU ĐẦY ĐỦ (32 BẢNG CHUẨN HOÁ 3NF)
-- HỆ QUẢN TRỊ: MySQL 8.0+ / MariaDB / phpMyAdmin
-- BỘ SÁCH: TOÁN 10 — KẾT NỐI TRI THỨC VỚI CUỘC SỐNG
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 1: TÀI KHOẢN, PHÂN QUYỀN RBAC & HỒ SƠ NGƯỜI DÙNG (6 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `user_roles`;
DROP TABLE IF EXISTS `role_permissions`;
DROP TABLE IF EXISTS `permissions`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `user_profiles`;
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `email` VARCHAR(254) NOT NULL UNIQUE,
    `role` VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `roles` (
    `role_id` INT AUTO_INCREMENT PRIMARY KEY,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_roles` (
    `user_id` INT NOT NULL,
    `role_id` INT NOT NULL,
    PRIMARY KEY (`user_id`, `role_id`),
    CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `permissions` (
    `perm_id` INT AUTO_INCREMENT PRIMARY KEY,
    `perm_code` VARCHAR(80) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `role_permissions` (
    `role_id` INT NOT NULL,
    `perm_id` INT NOT NULL,
    PRIMARY KEY (`role_id`, `perm_id`),
    CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_rp_perm` FOREIGN KEY (`perm_id`) REFERENCES `permissions` (`perm_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_profiles` (
    `profile_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `full_name` VARCHAR(120) NOT NULL,
    `avatar_url` VARCHAR(500) NULL,
    `phone` VARCHAR(20) NULL,
    `parent_phone` VARCHAR(20) NULL,
    `bio` TEXT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_up_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 2: TRƯỜNG HỌC, NIÊN KHÓA & LỚP HỌC (4 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `class_students`;
DROP TABLE IF EXISTS `classes`;
DROP TABLE IF EXISTS `academic_years`;
DROP TABLE IF EXISTS `schools`;

CREATE TABLE `schools` (
    `school_id` INT AUTO_INCREMENT PRIMARY KEY,
    `school_name` VARCHAR(200) NOT NULL,
    `province` VARCHAR(100) NOT NULL,
    `address` VARCHAR(300) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `academic_years` (
    `year_id` INT AUTO_INCREMENT PRIMARY KEY,
    `year_name` VARCHAR(50) NOT NULL,
    `semester` VARCHAR(20) NOT NULL DEFAULT 'HK1',
    `is_current` TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `classes` (
    `class_id` INT AUTO_INCREMENT PRIMARY KEY,
    `school_id` INT NULL,
    `year_id` INT NULL,
    `teacher_id` INT NOT NULL,
    `class_name` VARCHAR(100) NOT NULL,
    `grade_level` INT NOT NULL DEFAULT 10,
    `enrollment_code` VARCHAR(20) NULL UNIQUE,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_cls_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_cls_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_cls_year` FOREIGN KEY (`year_id`) REFERENCES `academic_years` (`year_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `class_students` (
    `class_id` INT NOT NULL,
    `student_id` INT NOT NULL,
    `enrolled_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (`class_id`, `student_id`),
    CONSTRAINT `fk_cs_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cs_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 3: CHƯƠNG TRÌNH & HỌC LIỆU TOÁN 10 (4 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `lesson_attachments`;
DROP TABLE IF EXISTS `lessons`;
DROP TABLE IF EXISTS `topics`;
DROP TABLE IF EXISTS `curriculums`;

CREATE TABLE `curriculums` (
    `curriculum_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `grade` INT NOT NULL DEFAULT 10,
    `publisher` VARCHAR(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `topics` (
    `topic_id` INT AUTO_INCREMENT PRIMARY KEY,
    `curriculum_id` INT NULL,
    `created_by` INT NOT NULL,
    `topic_name` VARCHAR(160) NOT NULL UNIQUE,
    `description` VARCHAR(1000) NULL,
    `topic_order` INT NOT NULL UNIQUE,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_top_curr` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculums` (`curriculum_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_top_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lessons` (
    `lesson_id` INT AUTO_INCREMENT PRIMARY KEY,
    `topic_id` INT NOT NULL,
    `teacher_id` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` VARCHAR(1000) NULL,
    `content` LONGTEXT NULL,
    `video_url` VARCHAR(2048) NULL,
    `resource_url` VARCHAR(2048) NULL,
    `order_index` INT NOT NULL DEFAULT 1,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_les_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_les_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lesson_attachments` (
    `attachment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `lesson_id` INT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(1000) NOT NULL,
    `file_type` VARCHAR(50) NOT NULL,
    `file_size_bytes` BIGINT NULL,
    `uploaded_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_la_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 4: NGÂN HÀNG CÂU HỎI & PHƯƠNG ÁN (4 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `question_tags`;
DROP TABLE IF EXISTS `tags`;
DROP TABLE IF EXISTS `question_options`;
DROP TABLE IF EXISTS `questions`;

CREATE TABLE `questions` (
    `question_id` INT AUTO_INCREMENT PRIMARY KEY,
    `lesson_id` INT NOT NULL,
    `created_by` INT NOT NULL,
    `source` VARCHAR(20) NOT NULL DEFAULT 'MANUAL',
    `reviewed_by` INT NULL,
    `reviewed_at` DATETIME NULL,
    `question_type` VARCHAR(10) NOT NULL DEFAULT 'MCQ',
    `question_text` LONGTEXT NOT NULL,
    `correct_answer` VARCHAR(255) NULL,
    `explanation` LONGTEXT NULL,
    `difficulty` VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    `status` VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_q_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_q_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_q_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `question_options` (
    `option_id` INT AUTO_INCREMENT PRIMARY KEY,
    `question_id` INT NOT NULL,
    `option_key` VARCHAR(5) NOT NULL,
    `option_text` TEXT NOT NULL,
    `is_correct` TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT `fk_qo_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tags` (
    `tag_id` INT AUTO_INCREMENT PRIMARY KEY,
    `tag_name` VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `question_tags` (
    `question_id` INT NOT NULL,
    `tag_id` INT NOT NULL,
    PRIMARY KEY (`question_id`, `tag_id`),
    CONSTRAINT `fk_qt_q` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_qt_t` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 5: ĐỀ THI, BÀI TẬP & BÀI NỘP (4 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `exam_submissions`;
DROP TABLE IF EXISTS `exam_questions`;
DROP TABLE IF EXISTS `assignments`;
DROP TABLE IF EXISTS `exams`;

CREATE TABLE `exams` (
    `exam_id` INT AUTO_INCREMENT PRIMARY KEY,
    `class_id` INT NULL,
    `created_by` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `duration_minutes` INT NOT NULL DEFAULT 45,
    `pass_score` DECIMAL(4,2) NOT NULL DEFAULT 5.00,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_ex_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_ex_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `exam_questions` (
    `exam_id` INT NOT NULL,
    `question_id` INT NOT NULL,
    `question_order` INT NOT NULL DEFAULT 1,
    `points` DECIMAL(4,2) NOT NULL DEFAULT 1.00,
    PRIMARY KEY (`exam_id`, `question_id`),
    CONSTRAINT `fk_eq_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_eq_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `exam_submissions` (
    `submission_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `exam_id` INT NOT NULL,
    `student_id` INT NOT NULL,
    `total_score` DECIMAL(5,2) NULL,
    `start_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `submit_time` DATETIME NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'COMPLETED',
    CONSTRAINT `fk_es_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_es_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `assignments` (
    `assignment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `class_id` INT NOT NULL,
    `lesson_id` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `due_date` DATETIME NULL,
    `instructions` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_asg_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_asg_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 6: LUYỆN TẬP, TỰ LUẬN & GIA SƯ AI SOCRATIC (3 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `ai_interactions`;
DROP TABLE IF EXISTS `essay_submissions`;
DROP TABLE IF EXISTS `attempts`;

CREATE TABLE `attempts` (
    `attempt_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `question_id` INT NOT NULL,
    `student_id` INT NOT NULL,
    `answer_text` TEXT NULL,
    `is_correct` TINYINT(1) NULL,
    `score` DECIMAL(5,2) NULL,
    `feedback` TEXT NULL,
    `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_att_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_att_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `essay_submissions` (
    `essay_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `attempt_id` BIGINT NULL,
    `question_id` INT NOT NULL,
    `student_id` INT NOT NULL,
    `image_path` VARCHAR(500) NULL,
    `ocr_text` LONGTEXT NULL,
    `ai_score` DECIMAL(5,2) NULL,
    `ai_feedback` LONGTEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_esb_att` FOREIGN KEY (`attempt_id`) REFERENCES `attempts` (`attempt_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_esb_q` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`),
    CONSTRAINT `fk_esb_s` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ai_interactions` (
    `interaction_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `attempt_id` BIGINT NOT NULL,
    `step_number` INT NOT NULL,
    `student_input` TEXT NULL,
    `ai_response` LONGTEXT NOT NULL,
    `ai_action` VARCHAR(30) NOT NULL DEFAULT 'HINT',
    `is_correct` TINYINT(1) NULL,
    `is_final` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_ai_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `attempts` (`attempt_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 7: QUẢN TRỊ AI ENGINE & GIÁM SÁT (3 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `ai_audit_logs`;
DROP TABLE IF EXISTS `ai_prompt_templates`;
DROP TABLE IF EXISTS `ai_generated_drafts`;

CREATE TABLE `ai_prompt_templates` (
    `template_id` INT AUTO_INCREMENT PRIMARY KEY,
    `template_name` VARCHAR(100) NOT NULL UNIQUE,
    `task_type` VARCHAR(50) NOT NULL,
    `system_prompt` LONGTEXT NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ai_audit_logs` (
    `log_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NULL,
    `action_type` VARCHAR(50) NOT NULL,
    `model_name` VARCHAR(80) NOT NULL,
    `tokens_used` INT NULL DEFAULT 0,
    `latency_ms` INT NULL DEFAULT 0,
    `http_status` INT NOT NULL DEFAULT 200,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_aal_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ai_generated_drafts` (
    `draft_id` INT AUTO_INCREMENT PRIMARY KEY,
    `lesson_id` INT NOT NULL,
    `prompt_used` TEXT NULL,
    `raw_ai_response` LONGTEXT NOT NULL,
    `generated_question_id` INT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING_REVIEW',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_agd_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_agd_q` FOREIGN KEY (`generated_question_id`) REFERENCES `questions` (`question_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PHÂN HỆ 8: TƯƠNG TÁC, SỔ TAY CÔNG THỨC & THÔNG BÁO (4 BẢNG)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `comments`;
DROP TABLE IF EXISTS `formulas`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `student_streaks`;

CREATE TABLE `formulas` (
    `formula_id` INT AUTO_INCREMENT PRIMARY KEY,
    `topic_id` INT NOT NULL,
    `title` VARCHAR(160) NOT NULL,
    `latex_code` VARCHAR(500) NOT NULL,
    `description` VARCHAR(1000) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_form_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `comments` (
    `comment_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `lesson_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `parent_id` BIGINT NULL,
    `content` TEXT NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_cm_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_cm_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notifications` (
    `notification_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `message` TEXT NOT NULL,
    `is_read` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `student_streaks` (
    `student_id` INT PRIMARY KEY,
    `current_streak_days` INT NOT NULL DEFAULT 1,
    `longest_streak_days` INT NOT NULL DEFAULT 1,
    `last_active_date` DATE NOT NULL,
    `total_points` INT NOT NULL DEFAULT 0,
    CONSTRAINT `fk_strk_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- NẠP DỮ LIỆU KHỞI TẠO MẪU (SEED DATA)
-- =====================================================================

-- 1. Roles
INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'ADMIN', 'Quản trị viên toàn hệ thống'),
(2, 'TEACHER', 'Giáo viên bộ môn Toán 10'),
(3, 'STUDENT', 'Học sinh luyện tập Toán 10'),
(4, 'PARENT', 'Phụ huynh theo dõi tiến độ');

-- 2. Users (Mật khẩu mặc định hash BCrypt: $2a$10$7zV.k/8a8y...)
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `email`, `role`, `status`) VALUES
(1, 'admin', '$2a$10$w09u7uR/y1sQx3kYjXv70eN1Xg3R2qjJ01H21J300K01L02M03N04', 'admin@math10.local', 'ADMIN', 'ACTIVE'),
(2, 'teacher1', '$2a$10$w09u7uR/y1sQx3kYjXv70eN1Xg3R2qjJ01H21J300K01L02M03N04', 'teacher1@math10.local', 'TEACHER', 'ACTIVE'),
(3, 'student1', '$2a$10$w09u7uR/y1sQx3kYjXv70eN1Xg3R2qjJ01H21J300K01L02M03N04', 'student1@math10.local', 'STUDENT', 'ACTIVE');

-- 3. User profiles
INSERT INTO `user_profiles` (`profile_id`, `user_id`, `full_name`, `phone`, `bio`) VALUES
(1, 1, 'Quản Trị Viên Hệ Thống', '0901234567', 'Quản trị viên hạ tầng Math10 AI'),
(2, 2, 'Thầy Nguyễn Văn Tuấn', '0912345678', 'Giáo viên Toán THPT chuyên'),
(3, 3, 'Phan Văn Hiếu', '01655871172', 'Học sinh lớp 10A1');

-- 4. Schools & Academic Year
INSERT INTO `schools` (`school_id`, `school_name`, `province`, `address`) VALUES
(1, 'THPT Chuyên Hà Nội - Amsterdam', 'Hà Nội', 'Hoàng Minh Giám, Cầu Giấy');

INSERT INTO `academic_years` (`year_id`, `year_name`, `semester`, `is_current`) VALUES
(1, '2026-2027', 'HK1', 1);

-- 5. Classes & Class Students
INSERT INTO `classes` (`class_id`, `school_id`, `year_id`, `teacher_id`, `class_name`, `enrollment_code`) VALUES
(1, 1, 1, 2, 'Toán 10A1', 'TOAN10A1');

INSERT INTO `class_students` (`class_id`, `student_id`, `status`) VALUES
(1, 3, 'ACTIVE');

-- 6. Curriculums & Topics (9 Chuyên đề Kết Nối Tri Thức)
INSERT INTO `curriculums` (`curriculum_id`, `name`, `grade`, `publisher`) VALUES
(1, 'Kết nối tri thức với cuộc sống', 10, 'NXB Giáo Dục Việt Nam');

INSERT INTO `topics` (`topic_id`, `curriculum_id`, `created_by`, `topic_name`, `description`, `topic_order`) VALUES
(1, 1, 1, 'Mệnh đề và tập hợp', 'Chương I: Mệnh đề toán học, các phép toán tập hợp', 1),
(2, 1, 1, 'Bất phương trình và hệ bất phương trình bậc nhất hai ẩn', 'Chương II: Biểu diễn miền nghiệm', 2),
(3, 1, 1, 'Hệ thức lượng trong tam giác', 'Chương III: Định lý cosin, định lý sin, công thức diện tích', 3),
(4, 1, 1, 'Vectơ', 'Chương IV: Khái niệm vectơ, tổng, hiệu và tích vô hướng', 4),
(5, 1, 1, 'Các số đặc trưng đo xu thế trung tâm và mức độ phân tán', 'Chương V: Số trung bình, trung vị, phương sai', 5),
(6, 1, 1, 'Hàm số, đồ thị và ứng dụng', 'Chương VI: Hàm số bậc hai, đồ thị parabol', 6),
(7, 1, 1, 'Phương pháp toạ độ trong mặt phẳng', 'Chương VII: Phương trình đường thẳng, đường tròn', 7),
(8, 1, 1, 'Đại số tổ hợp', 'Chương VIII: Quy tắc đếm, hoán vị, chỉnh hợp, tổ hợp', 8),
(9, 1, 1, 'Tính xác suất theo định nghĩa cổ điển', 'Chương IX: Biến cố và công thức xác suất cổ điển', 9);

-- 7. Sample Lessons
INSERT INTO `lessons` (`lesson_id`, `topic_id`, `teacher_id`, `title`, `description`, `content`, `video_url`, `order_index`, `status`) VALUES
(1, 1, 2, 'Bài 1: Mệnh đề toán học', 'Khái niệm mệnh đề, mệnh đề phủ định và mệnh đề kéo theo', 'KIẾN THỨC CỐT LÕI: Mệnh đề là khẳng định có tính đúng hoặc sai...', 'https://www.youtube.com', 1, 'PUBLISHED'),
(16, 6, 2, 'Bài 16: Hàm số bậc hai', 'Khảo sát và vẽ đồ thị hàm số bậc hai y = ax^2 + bx + c', 'KIẾN THỨC CỐT LÕI: Đồ thị hàm số bậc hai là một parabol có đỉnh I(-b/2a; -Delta/4a)...', 'https://www.youtube.com', 1, 'PUBLISHED');

-- 8. Sample Questions & Options
INSERT INTO `questions` (`question_id`, `lesson_id`, `created_by`, `source`, `question_type`, `question_text`, `correct_answer`, `explanation`, `difficulty`, `status`) VALUES
(1, 16, 2, 'MANUAL', 'MCQ', 'Toạ độ đỉnh I của parabol y = 2x^2 - 4x + 1 là:', 'A', 'Áp dụng công thức x = -b/(2a) = -(-4)/4 = 1, y = 2(1)^2 - 4(1) + 1 = -1', 'EASY', 'PUBLISHED');

INSERT INTO `question_options` (`question_id`, `option_key`, `option_text`, `is_correct`) VALUES
(1, 'A', 'I(1; -1)', 1),
(1, 'B', 'I(-1; 7)', 0),
(1, 'C', 'I(2; 1)', 0),
(1, 'D', 'I(1; 1)', 0);

-- 9. Sample Formulas
INSERT INTO `formulas` (`formula_id`, `topic_id`, `title`, `latex_code`, `description`) VALUES
(1, 1, 'Giao của hai tập hợp', 'A \\cap B = \\{x \\mid x \\in A \\text{ và } x \\in B\\}', 'Tập hợp các phần tử thuộc cả A và B'),
(2, 6, 'Toạ độ đỉnh Parabol', 'I\\left(-\\frac{b}{2a}; -\\frac{\\Delta}{4a}\\right)', 'Toạ độ đỉnh của đồ thị hàm số bậc hai y = ax^2 + bx + c'),
(3, 3, 'Định lý Côsin', 'a^2 = b^2 + c^2 - 2bc \\cos A', 'Hệ thức lượng trong tam giác bất kỳ');

-- 10. AI Prompt Templates
INSERT INTO `ai_prompt_templates` (`template_id`, `template_name`, `task_type`, `system_prompt`) VALUES
(1, 'socratic_tutor_math10', 'SOCRATIC_TUTOR', 'Bạn là gia sư AI dạy Toán 10. Khi học sinh trả lời sai, không giải ngay mà gợi mở từng bước, bắt học sinh nhập số liệu mới giải tiếp.'),
(2, 'essay_vision_grader', 'ESSAY_VISION', 'Bạn là giám khảo chấm bài tự luận Toán 10 qua hình ảnh. Đọc chữ viết tay, kiểm tra tính toán và chỉ ra vị trí sai sót.');

SET FOREIGN_KEY_CHECKS = 1;
