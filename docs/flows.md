# Math10 AI — Business flows

These flows describe the intended server behavior. The current frontend is still a visual prototype; buttons do not yet call these backend operations.

## 1. Use case overview

```mermaid
flowchart LR
    Admin[Admin]
    Teacher[Teacher]
    Student[Student]
    AI[AI Provider]
    Auth((Sign in / role access))
    Accounts((Manage users / assignment))
    Topics((Manage topics))
    Lessons((Manage lessons / resources))
    Questions((Manage question bank))
    Gen((Generate and review AI questions))
    Learn((Browse and study lessons))
    MCQ((Practice MCQ))
    Essay((Practice essay / upload image))
    Tutor((Step-by-step tutoring))
    Progress((View history / progress))
    Config((Configure AI))

    Admin --> Auth
    Teacher --> Auth
    Student --> Auth
    Admin --> Accounts
    Admin --> Topics
    Admin --> Lessons
    Admin --> Questions
    Admin --> Config
    Teacher --> Lessons
    Teacher --> Questions
    Teacher --> Gen
    Teacher --> Progress
    Student --> Learn
    Student --> MCQ
    Student --> Essay
    Student --> Progress
    MCQ --> Tutor
    Essay --> Tutor
    Gen --> AI
    Tutor --> AI
```

## 2. Student learning flow

```mermaid
flowchart TD
    A[Sign in as Student] --> B[Student dashboard]
    B --> C[Browse topics]
    C --> D[Select a published lesson]
    D --> E[Read text / open video or resource]
    E --> F{Choose practice type}
    F -->|MCQ| G[Start published MCQ practice]
    F -->|Essay| H[Open published essay question]
    G --> I[Submit answer]
    H --> J[Write solution and/or upload image]
    I --> K[Server validates and stores attempt]
    J --> L[Server validates image/text and stores private image key]
    K --> M{Answer correct?}
    M -->|Yes| N[Show result and continue]
    M -->|No| O[Start AI tutor with attempt context]
    L --> P[Analyze solution and return feedback]
    O --> Q[Give one hint and ask for next input]
    Q --> R[Student enters next step]
    R --> S{Solved or hint limit reached?}
    S -->|No| O
    S -->|Solved| N
    S -->|Hint limit| T[Show configured final explanation]
    P --> U[Student retries or finishes]
    N --> V[View saved history and progress]
    T --> V
    U --> V
```

## 3. MCQ tutoring state flow

```mermaid
stateDiagram-v2
    [*] --> Answering
    Answering --> Correct: correct option submitted
    Answering --> NeedsHint: incorrect option submitted
    NeedsHint --> WaitingForStudent: persist HINT / ASK_INPUT
    WaitingForStudent --> EvaluatingStep: student sends next calculation
    EvaluatingStep --> Continue: step is valid
    EvaluatingStep --> NeedsHint: step is still incorrect
    Continue --> WaitingForStudent: more solution steps remain
    Continue --> Correct: trusted solution completed
    NeedsHint --> FinalExplanation: configured hint limit reached
    Correct --> Saved: persist score and tutor history
    FinalExplanation --> Saved: persist final tutor turn
    Answering --> SafeError: AI unavailable / response invalid
    WaitingForStudent --> SafeError: AI unavailable / response invalid
    SafeError --> Saved: preserve attempt; offer retry
    Saved --> [*]
```

The backend keeps the trusted correct answer and reference steps in server context. The student sees only the current hint or requested next step until the final-solution condition is reached. Every AI response includes a structured action (`HINT`, `ASK_INPUT`, `CONFIRM`, `ERROR`, `FINAL_SOLUTION`, or `CLARIFICATION`) and is saved as an `AI_INTERACTIONS` row.

## 4. Essay submission and feedback flow

```mermaid
flowchart TD
    A[Student opens essay question] --> B[Enter solution text and/or choose one image]
    B --> C{Image provided?}
    C -->|Yes| D[Check extension, content/MIME, and 10 MB limit]
    C -->|No| E{Non-empty text provided?}
    D --> F{Image valid?}
    F -->|No| X[Reject upload and show safe validation message]
    F -->|Yes| G[Generate random name and store privately]
    G --> H[Save ATTEMPTS row with private image key]
    E -->|Yes| H
    E -->|No| Y[Ask student to enter text or attach image]
    H --> I[Send question and authorized attempt content to vision AI]
    I --> J{Readable and sufficiently clear?}
    J -->|No| K[Ask for clearer image or typed steps]
    J -->|Yes| L[Identify first likely incorrect or missing step]
    L --> M[Return feedback and one corrective hint]
    K --> N[Persist feedback and AI interaction]
    M --> N
    N --> O[Student retries or views result]
```

The image is not exposed through a public static URL. Each retrieval checks that the requester is the student who owns the attempt, the student's assigned teacher, or an Admin.

## 5. Teacher content and question flow

```mermaid
flowchart TD
    A[Sign in as Teacher] --> B[Teacher dashboard]
    B --> C[Select owned topic/lesson]
    C --> D{Content action}
    D -->|Lesson| E[Enter title, text, video/resource URLs, order]
    E --> F[Server validates and saves DRAFT]
    F --> G[Preview lesson]
    G --> H[Publish lesson]
    D -->|Manual question| I[Choose MCQ or essay]
    I --> J[Enter prompt, answer, difficulty, solution steps]
    J --> K[Server validates question]
    K --> L[Save as DRAFT or publish]
    D -->|AI question| M[Set topic, lesson, type, difficulty, count]
    M --> N[AI returns structured draft]
    N --> O[Server parses and validates each question]
    O --> P[Teacher previews and edits]
    P --> Q{Teacher decision}
    Q -->|Publish| R[Save review metadata and publish]
    Q -->|Keep editing| P
    Q -->|Discard| S[Delete draft]
    B --> T[Open assigned student progress]
    T --> U[Server checks teacher_id ownership]
    U --> V[Show allowed result/history]
```

## 6. Admin flow

```mermaid
flowchart TD
    A[Sign in as Admin] --> B[Admin dashboard]
    B --> C[Manage users]
    C --> D[Create or update Teacher / Student]
    D --> E[Assign each Student to one Teacher]
    B --> F[Manage topics]
    F --> G[Reorder / activate / deactivate topics]
    B --> H[Manage lessons and questions]
    B --> I[Configure provider, model, feature flags, hint limit]
    I --> J[Read credential from server-side secret config]
    J --> K[Run safe connection check]
    K --> L{Provider available?}
    L -->|Yes| M[Show connected status]
    L -->|No| N[Show safe error; do not reveal key/provider payload]
```

## 7. AI question generator flow

```mermaid
sequenceDiagram
    actor T as Teacher
    participant UI as Web UI
    participant S as Spring Service
    participant AI as AI Provider
    participant DB as SQL Server
    T->>UI: Select topic, lesson, type, difficulty, count
    UI->>S: Submit generation request
    S->>S: Check role, ownership, inputs, and limits
    S->>AI: Send prompt and structured generation request
    AI-->>S: Return structured draft response
    S->>S: Parse JSON and validate options/answer/steps
    S->>DB: Save valid drafts with source=AI and PENDING_REVIEW
    DB-->>S: Return draft IDs
    S-->>UI: Show previewable drafts
    T->>UI: Edit, delete, or approve each question
    UI->>S: Submit review decision
    S->>S: Recheck teacher role and lesson ownership
    S->>DB: Save review metadata; publish only approved questions
    S-->>UI: Show saved status
```

## 8. Frontend pages mapped to flows

| Role | Current prototype pages | Backend operations to connect later |
|---|---|---|
| Student | Dashboard, lesson list/detail, MCQ, essay upload, history, progress | Authenticated reads; published lesson/question queries; attempt and interaction writes; private image upload/retrieval. |
| Teacher | Dashboard, students, lessons, question bank, AI generator, progress | Owned lesson CRUD; assigned-student queries; manual/AI question draft review; progress queries. |
| Admin | Dashboard, users, topics, questions, AI settings | User/assignment/topic CRUD; system content moderation; safe provider configuration. |
