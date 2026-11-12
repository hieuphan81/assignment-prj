/*
  Math10 AI - SQL Server schema
  Final MVP: exactly six core tables; no SUBJECTS table.
  Run in SQL Server Management Studio or sqlcmd with permission to create a database.
*/

IF DB_ID(N'Math10AI') IS NULL
BEGIN
    CREATE DATABASE Math10AI;
END;
GO

USE Math10AI;
GO

/* USERS: ADMIN, TEACHER, STUDENT. teacher_id assigns a student to one teacher. */
IF OBJECT_ID(N'dbo.USERS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.USERS
    (
        user_id       INT IDENTITY(1,1) NOT NULL,
        username      NVARCHAR(50) NOT NULL,
        password_hash NVARCHAR(255) NOT NULL,
        full_name     NVARCHAR(120) NOT NULL,
        email         NVARCHAR(254) NOT NULL,
        role          VARCHAR(10) NOT NULL,
        teacher_id    INT NULL,
        status        VARCHAR(12) NOT NULL CONSTRAINT DF_USERS_status DEFAULT ('ACTIVE'),
        created_at    DATETIME2(0) NOT NULL CONSTRAINT DF_USERS_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_USERS PRIMARY KEY CLUSTERED (user_id),
        CONSTRAINT UQ_USERS_username UNIQUE (username),
        CONSTRAINT UQ_USERS_email UNIQUE (email),
        CONSTRAINT FK_USERS_teacher FOREIGN KEY (teacher_id) REFERENCES dbo.USERS(user_id),
        CONSTRAINT CK_USERS_role CHECK (role IN ('ADMIN', 'TEACHER', 'STUDENT')),
        CONSTRAINT CK_USERS_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
        CONSTRAINT CK_USERS_teacher_assignment CHECK
            ((role = 'STUDENT') OR teacher_id IS NULL)
    );
END;
GO

/* TOPICS: the project has one subject (Grade 10 Mathematics), so SUBJECTS is omitted. */
IF OBJECT_ID(N'dbo.TOPICS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TOPICS
    (
        topic_id    INT IDENTITY(1,1) NOT NULL,
        created_by  INT NOT NULL,
        topic_name  NVARCHAR(160) NOT NULL,
        description NVARCHAR(1000) NULL,
        topic_order INT NOT NULL,
        status      VARCHAR(12) NOT NULL CONSTRAINT DF_TOPICS_status DEFAULT ('ACTIVE'),
        created_at  DATETIME2(0) NOT NULL CONSTRAINT DF_TOPICS_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_TOPICS PRIMARY KEY CLUSTERED (topic_id),
        CONSTRAINT FK_TOPICS_creator FOREIGN KEY (created_by) REFERENCES dbo.USERS(user_id),
        CONSTRAINT UQ_TOPICS_name UNIQUE (topic_name),
        CONSTRAINT UQ_TOPICS_order UNIQUE (topic_order),
        CONSTRAINT CK_TOPICS_order CHECK (topic_order > 0),
        CONSTRAINT CK_TOPICS_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
    );
END;
GO

/* LESSONS: topic and teacher ownership; text, video, and external resource are optional. */
IF OBJECT_ID(N'dbo.LESSONS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LESSONS
    (
        lesson_id   INT IDENTITY(1,1) NOT NULL,
        topic_id    INT NOT NULL,
        teacher_id  INT NOT NULL,
        title       NVARCHAR(200) NOT NULL,
        description NVARCHAR(1000) NULL,
        content     NVARCHAR(MAX) NULL,
        video_url   NVARCHAR(2048) NULL,
        resource_url NVARCHAR(2048) NULL,
        order_index INT NOT NULL CONSTRAINT DF_LESSONS_order DEFAULT (1),
        status      VARCHAR(12) NOT NULL CONSTRAINT DF_LESSONS_status DEFAULT ('DRAFT'),
        created_at  DATETIME2(0) NOT NULL CONSTRAINT DF_LESSONS_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_LESSONS PRIMARY KEY CLUSTERED (lesson_id),
        CONSTRAINT FK_LESSONS_topic FOREIGN KEY (topic_id) REFERENCES dbo.TOPICS(topic_id),
        CONSTRAINT FK_LESSONS_teacher FOREIGN KEY (teacher_id) REFERENCES dbo.USERS(user_id),
        CONSTRAINT CK_LESSONS_order CHECK (order_index > 0),
        CONSTRAINT CK_LESSONS_status CHECK (status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),
        CONSTRAINT CK_LESSONS_video_url CHECK (video_url IS NULL OR video_url LIKE N'https://%' OR video_url LIKE N'http://%'),
        CONSTRAINT CK_LESSONS_resource_url CHECK (resource_url IS NULL OR resource_url LIKE N'https://%' OR resource_url LIKE N'http://%')
    );
END;
GO

/* QUESTIONS: AI drafts stay unpublished until a teacher/admin reviews them. */
IF OBJECT_ID(N'dbo.QUESTIONS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.QUESTIONS
    (
        question_id    INT IDENTITY(1,1) NOT NULL,
        lesson_id      INT NOT NULL,
        created_by     INT NOT NULL,
        source         VARCHAR(10) NOT NULL CONSTRAINT DF_QUESTIONS_source DEFAULT ('MANUAL'),
        reviewed_by    INT NULL,
        reviewed_at    DATETIME2(0) NULL,
        question_type  VARCHAR(5) NOT NULL,
        question_text  NVARCHAR(MAX) NOT NULL,
        option_a       NVARCHAR(1000) NULL,
        option_b       NVARCHAR(1000) NULL,
        option_c       NVARCHAR(1000) NULL,
        option_d       NVARCHAR(1000) NULL,
        correct_answer NVARCHAR(MAX) NULL,
        explanation    NVARCHAR(MAX) NULL,
        solution_steps NVARCHAR(MAX) NULL,
        difficulty     VARCHAR(10) NOT NULL,
        status         VARCHAR(18) NOT NULL CONSTRAINT DF_QUESTIONS_status DEFAULT ('DRAFT'),
        created_at     DATETIME2(0) NOT NULL CONSTRAINT DF_QUESTIONS_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_QUESTIONS PRIMARY KEY CLUSTERED (question_id),
        CONSTRAINT FK_QUESTIONS_lesson FOREIGN KEY (lesson_id) REFERENCES dbo.LESSONS(lesson_id),
        CONSTRAINT FK_QUESTIONS_creator FOREIGN KEY (created_by) REFERENCES dbo.USERS(user_id),
        CONSTRAINT FK_QUESTIONS_reviewer FOREIGN KEY (reviewed_by) REFERENCES dbo.USERS(user_id),
        CONSTRAINT CK_QUESTIONS_source CHECK (source IN ('MANUAL', 'AI')),
        CONSTRAINT CK_QUESTIONS_type CHECK (question_type IN ('MCQ', 'ESSAY')),
        CONSTRAINT CK_QUESTIONS_difficulty CHECK (difficulty IN ('EASY', 'MEDIUM', 'HARD')),
        CONSTRAINT CK_QUESTIONS_status CHECK (status IN ('DRAFT', 'PENDING_REVIEW', 'PUBLISHED', 'ARCHIVED')),
        CONSTRAINT CK_QUESTIONS_mcq_or_essay CHECK
        (
            (question_type = 'MCQ'
                AND option_a IS NOT NULL AND option_b IS NOT NULL
                AND option_c IS NOT NULL AND option_d IS NOT NULL
                AND correct_answer IS NOT NULL
                AND correct_answer IN (N'A', N'B', N'C', N'D'))
            OR
            (question_type = 'ESSAY'
                AND option_a IS NULL AND option_b IS NULL
                AND option_c IS NULL AND option_d IS NULL)
        ),
        CONSTRAINT CK_QUESTIONS_ai_review CHECK
        (
            source <> 'AI'
            OR status <> 'PUBLISHED'
            OR (reviewed_by IS NOT NULL AND reviewed_at IS NOT NULL)
        )
    );
END;
GO

/* ATTEMPTS: one row per submitted answer; image_path stores a private storage key, not image bytes. */
IF OBJECT_ID(N'dbo.ATTEMPTS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ATTEMPTS
    (
        attempt_id   BIGINT IDENTITY(1,1) NOT NULL,
        question_id  INT NOT NULL,
        student_id   INT NOT NULL,
        answer_text  NVARCHAR(MAX) NULL,
        image_path   NVARCHAR(500) NULL,
        is_correct   BIT NULL,
        score        DECIMAL(5,2) NULL,
        feedback     NVARCHAR(MAX) NULL,
        submitted_at DATETIME2(0) NOT NULL CONSTRAINT DF_ATTEMPTS_submitted_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_ATTEMPTS PRIMARY KEY CLUSTERED (attempt_id),
        CONSTRAINT FK_ATTEMPTS_question FOREIGN KEY (question_id) REFERENCES dbo.QUESTIONS(question_id),
        CONSTRAINT FK_ATTEMPTS_student FOREIGN KEY (student_id) REFERENCES dbo.USERS(user_id),
        CONSTRAINT CK_ATTEMPTS_score CHECK (score IS NULL OR (score >= 0 AND score <= 10)),
        CONSTRAINT CK_ATTEMPTS_has_answer CHECK
            (NULLIF(LTRIM(RTRIM(answer_text)), N'') IS NOT NULL OR image_path IS NOT NULL)
    );
END;
GO

/* AI_INTERACTIONS: each tutor turn is stored separately to preserve state and history. */
IF OBJECT_ID(N'dbo.AI_INTERACTIONS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AI_INTERACTIONS
    (
        interaction_id BIGINT IDENTITY(1,1) NOT NULL,
        attempt_id     BIGINT NOT NULL,
        step_number    INT NOT NULL,
        student_input  NVARCHAR(MAX) NULL,
        ai_response    NVARCHAR(MAX) NOT NULL,
        ai_action      VARCHAR(20) NOT NULL,
        is_correct     BIT NULL,
        is_final       BIT NOT NULL CONSTRAINT DF_AI_INTERACTIONS_is_final DEFAULT (0),
        created_at     DATETIME2(0) NOT NULL CONSTRAINT DF_AI_INTERACTIONS_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_AI_INTERACTIONS PRIMARY KEY CLUSTERED (interaction_id),
        CONSTRAINT FK_AI_INTERACTIONS_attempt FOREIGN KEY (attempt_id) REFERENCES dbo.ATTEMPTS(attempt_id),
        CONSTRAINT UQ_AI_INTERACTIONS_attempt_step UNIQUE (attempt_id, step_number),
        CONSTRAINT CK_AI_INTERACTIONS_step CHECK (step_number > 0),
        CONSTRAINT CK_AI_INTERACTIONS_action CHECK
            (ai_action IN ('HINT', 'ASK_INPUT', 'CONFIRM', 'ERROR', 'FINAL_SOLUTION', 'CLARIFICATION'))
    );
END;
GO

/* Required session options for SQL Server filtered indexes. */
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

/* Indexes for common role dashboards, lesson browsing, question practice, and attempt history. */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_USERS_teacher_id' AND object_id = OBJECT_ID(N'dbo.USERS'))
    CREATE INDEX IX_USERS_teacher_id ON dbo.USERS(teacher_id) WHERE teacher_id IS NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_LESSONS_topic_status_order' AND object_id = OBJECT_ID(N'dbo.LESSONS'))
    CREATE INDEX IX_LESSONS_topic_status_order ON dbo.LESSONS(topic_id, status, order_index);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_LESSONS_teacher_created' AND object_id = OBJECT_ID(N'dbo.LESSONS'))
    CREATE INDEX IX_LESSONS_teacher_created ON dbo.LESSONS(teacher_id, created_at DESC);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_QUESTIONS_lesson_status_type' AND object_id = OBJECT_ID(N'dbo.QUESTIONS'))
    CREATE INDEX IX_QUESTIONS_lesson_status_type ON dbo.QUESTIONS(lesson_id, status, question_type);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ATTEMPTS_student_submitted' AND object_id = OBJECT_ID(N'dbo.ATTEMPTS'))
    CREATE INDEX IX_ATTEMPTS_student_submitted ON dbo.ATTEMPTS(student_id, submitted_at DESC);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_AI_INTERACTIONS_attempt_step' AND object_id = OBJECT_ID(N'dbo.AI_INTERACTIONS'))
    CREATE INDEX IX_AI_INTERACTIONS_attempt_step ON dbo.AI_INTERACTIONS(attempt_id, step_number);
GO

/*
  Cross-table role rules (teacher_id must reference a TEACHER, student_id a STUDENT,
  etc.) are enforced in the Spring service layer inside the same transaction as writes.
  SQL Server CHECK constraints cannot validate the role on a referenced row.
*/
