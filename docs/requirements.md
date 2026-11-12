# Math10 AI — Requirements and use cases

## 1. Purpose and scope

Math10 AI is a Vietnamese learning website for Grade 10 Mathematics. Students study structured topics and lessons, practice multiple-choice and essay questions, and receive step-by-step AI guidance. Teachers create learning content and questions and follow the progress of students assigned to them. Admins manage accounts, topics, content, and AI settings.

The MVP supports one subject (Grade 10 Mathematics), exactly three roles, SQL Server, and six core database tables: `USERS`, `TOPICS`, `LESSONS`, `QUESTIONS`, `ATTEMPTS`, and `AI_INTERACTIONS`. It does not include a multi-subject catalog, payments, messaging, leaderboard, or gamification. The selected curriculum is **Toán 10 – Kết nối tri thức với cuộc sống**, Tập 1 and Tập 2. Seed chapter and lesson titles follow this choice; draft rows still require teacher-authored content before publication.

## 2. Actors and permissions

| Actor | Main permissions |
|---|---|
| **Admin** | Create/manage users and roles; assign students to teachers; manage all topics, lessons, and questions; configure AI provider/model and feature settings; inspect system state. |
| **Teacher** | Create/manage topics they created and their own lessons; create/edit questions; request AI question drafts and review them before publication; view only assigned students and their learning results. |
| **Student** | View published lessons; practice published MCQ and essay questions; submit text or a solution image; receive and continue AI tutoring; view only their own results and history. |
| **AI provider** | External service called by the server for question generation, tutoring, and image feedback. It is not an application role and receives only the data needed for the current request. |

### Authorization rules

- Every protected action is checked on the server. Hiding a button is not authorization.
- A student can access only their own attempts, AI interactions, and progress.
- A teacher can access only students whose `USERS.teacher_id` points to that teacher, and only content they own unless an Admin grants broader management.
- Only Admin can create Admin accounts, assign/reassign students, and change system-wide AI configuration.
- A generated AI question stays `PENDING_REVIEW` or `DRAFT` until a teacher/admin reviews and publishes it.
- Students can practice only `PUBLISHED` lessons and questions.

## 3. Functional requirements

### FR-01 Authentication and role access

1. Users sign in with a unique username and password.
2. Passwords are stored as a secure one-way hash; plaintext passwords are never stored or returned.
3. The application creates a server-side session after successful authentication and supports logout.
4. The server rejects access to routes and records outside the user's role/ownership scope.

### FR-02 User and teacher assignment management

1. Admin creates, edits, activates, deactivates, and locks accounts.
2. Admin assigns each student to one responsible teacher; Admin can reassign them.
3. Teacher views and manages only the students assigned to that teacher, within the allowed student-management fields.
4. Username and email are unique. Required values, format, role, and status are validated server-side.

### FR-03 Topic and lesson management

1. Admin creates/edits/deactivates all topics and controls their display order. Teacher can create/edit topics they created.
2. Teacher creates/edits their own lessons and associates each lesson with a topic they may access.
3. A lesson supports title, description, text content, optional YouTube URL, optional external resource URL, order, and publication status.
4. The server validates required lesson fields and URL schemes.
5. Students browse topics and published lessons, read lesson text, open approved links, and continue from the lesson into practice.

### FR-04 Question bank and AI generation

1. Teacher creates MCQ and essay questions manually.
2. MCQ questions have four options and one correct option; essay questions can have solution notes/steps and no MCQ options.
3. Teacher requests AI question drafts using topic, lesson, type, difficulty, quantity, and optional instructions.
4. AI output is parsed and validated by the server before it is shown as a draft.
5. Teacher previews, edits, deletes, or publishes each draft. AI-generated questions are never published automatically.
6. Admin can manage questions across the system.

### FR-05 MCQ practice and step-by-step tutoring

1. Student selects a topic/lesson and starts a practice set of published MCQ questions.
2. The server grades the selected option and persists the attempt.
3. Correct answers receive confirmation and can continue to the next question.
4. For an incorrect answer, AI identifies the first likely error, gives one hint, and asks the student to provide the next calculation/value/explanation.
5. The next AI response uses the current question, trusted solution where available, current input, step number, and prior interaction history.
6. AI must wait for student input between tutoring turns and must not immediately reveal the full answer after the first mistake.
7. The application enforces a configurable hint limit, handles a final-solution state, and stores every turn in `AI_INTERACTIONS`.

### FR-06 Essay practice and image feedback

1. Student opens a published essay question and submits written answer text, one image, or both.
2. The server accepts JPEG/JPG, PNG, and WEBP only; checks actual MIME/content and enforces a 10 MB MVP limit.
3. The file receives a random server-generated name and is stored outside the public web root or in private object storage. `ATTEMPTS.image_path` stores only its private key/path.
4. Only the attempt owner, assigned teacher, or Admin may retrieve the image.
5. A vision-capable AI service analyzes the question and work, identifies likely incorrect/missing steps, and gives a corrective hint instead of only the final result.
6. The attempt and AI feedback are stored; the student can retry.

### FR-07 Results and progress

1. Student views scores, submitted answers, AI feedback, practice history, and progress by topic.
2. Teacher views results/progress only for assigned students.
3. Admin can inspect global content/account summaries as required for system administration.

### FR-08 AI configuration and reliability

1. Admin selects provider/model and controls question generation, tutoring, image feedback, and tutor hint limit.
2. API credentials are read from environment variables or a protected server-side secret store. They are never stored in source control or browser code, included in responses, or written to logs.
3. A connection check returns a safe status message and does not expose provider payloads or credentials.
4. Timeouts, rate limits, invalid credentials, unavailable providers, malformed model output, and unreadable images produce safe user-facing messages.
5. AI may answer high-school mathematics questions beyond the local bank only to the extent the configured provider can do so reliably. It asks for clarification or indicates uncertainty when it cannot verify a solution.

## 4. Non-functional requirements

| ID | Requirement |
|---|---|
| NFR-01 | **Architecture:** Java Spring MVC with Controller, Service, DAO/Repository, Model, and JSP view responsibilities kept separate. |
| NFR-02 | **Database:** Microsoft SQL Server; six normalized core tables; explicit PK/FK, uniqueness, domain checks, and indexes for common lookups. |
| NFR-03 | **Security:** Password hashing, session-based authentication, server-side role and ownership checks, parameterized SQL, safe upload handling, and secret isolation. |
| NFR-04 | **Validation:** All important input is validated on the server; browser validation is supplemental only. |
| NFR-05 | **Reliability:** External AI calls use timeouts and controlled error handling. A provider failure must not corrupt a saved attempt or expose a stack trace. |
| NFR-06 | **Usability:** Vietnamese interface, responsive layout, role-specific navigation, clear forms/statuses, and understandable tutor hints. |
| NFR-07 | **Maintainability:** AI provider code stays behind an AI service abstraction; prompt templates and repeated UI elements are reusable/configurable. |
| NFR-08 | **Privacy:** Store only information needed for learning. Uploaded work is private and retrievable only by authorized roles. |
| NFR-09 | **Demonstrability:** The demo can show Admin → Teacher → Student → practice → AI feedback → saved result → teacher progress. |

## 5. Use cases

| ID | Use case | Actor | Preconditions | Main result |
|---|---|---|---|---|
| UC-01 | Sign in / sign out | All roles | Active account exists | User enters the correct role workspace; session ends on logout. |
| UC-02 | Manage accounts and assign students | Admin | Admin is authenticated | Accounts are saved and student-to-teacher assignment is updated. |
| UC-03 | Manage topic | Admin, Teacher | Admin is authenticated, or Teacher owns the topic | Topic is created/edited and ordered. |
| UC-04 | Create and publish lesson | Teacher, Admin | Topic exists; user has permission | Lesson is saved as draft or published with text/resources. |
| UC-05 | Browse and study lesson | Student | Published lesson exists | Student views lesson and available learning resources. |
| UC-06 | Create/edit question | Teacher, Admin | Lesson exists | MCQ/essay question is saved with validated answer/solution. |
| UC-07 | Generate and review question drafts | Teacher | AI configured; topic/lesson selected | AI drafts are validated, edited/reviewed, and explicitly published or discarded. |
| UC-08 | Practice MCQ | Student | Published MCQ exists | Answer and score are stored. |
| UC-09 | Continue AI tutoring | Student | An incorrect answer exists; AI is enabled | Hints and student steps are stored until solved, hint limit, or safe failure. |
| UC-10 | Submit essay/image | Student | Published essay exists | Text/image attempt is validated, stored privately, and sent for feedback. |
| UC-11 | View learning history/progress | Student | Prior attempts exist | Student sees only their own results and progress. |
| UC-12 | View assigned student progress | Teacher | Student is assigned to teacher | Teacher sees authorized result/history summaries. |
| UC-13 | Configure AI | Admin | Admin is authenticated | Provider/model settings and safe secret status are updated. |

## 6. Curriculum and content status

The project has selected **Toán 10 – Kết nối tri thức với cuộc sống** (Tập 1 and Tập 2). The seed defines all nine chapter topics and 27 curriculum-aligned lessons. Each lesson has concise original notes with a key idea, example, and takeaway. Teachers should review and expand these notes and create broader question coverage before using the material as an official course.
