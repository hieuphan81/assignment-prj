package vn.math10ai.questions;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class QuestionRepository {
    private final JdbcTemplate jdbc;

    public QuestionRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    private static final String C = "q.question_id,q.lesson_id,q.question_type,q.question_text,q.option_a,q.option_b,q.option_c,q.option_d,q.correct_answer,q.explanation,q.solution_steps,q.difficulty,q.status,q.source";
    private static final org.springframework.jdbc.core.RowMapper<QuestionDto> M = (r, n) -> new QuestionDto(
            r.getInt("question_id"), r.getInt("lesson_id"), r.getString("question_type"),
            r.getString("question_text"), r.getString("option_a"), r.getString("option_b"),
            r.getString("option_c"), r.getString("option_d"), r.getString("correct_answer"),
            r.getString("explanation"), r.getString("solution_steps"), r.getString("difficulty"),
            r.getString("status"), r.getString("source")
    );

    public List<QuestionDto> manage(int userId, boolean admin) {
        String sql = "SELECT " + C + " FROM dbo.QUESTIONS q JOIN dbo.LESSONS l ON l.lesson_id=q.lesson_id ORDER BY q.created_at DESC";
        return jdbc.query(sql, M);
    }

    public List<QuestionDto> publishedForLesson(int lessonId) {
        return jdbc.query("SELECT " + C + " FROM dbo.QUESTIONS q JOIN dbo.LESSONS l ON l.lesson_id=q.lesson_id JOIN dbo.TOPICS t ON t.topic_id=l.topic_id WHERE q.lesson_id=? AND q.status='PUBLISHED' AND l.status='PUBLISHED' AND t.status='ACTIVE' ORDER BY q.question_id", M, lessonId);
    }

    public QuestionDto find(int id) {
        return jdbc.query("SELECT " + C + " FROM dbo.QUESTIONS q WHERE q.question_id=?", rs -> rs.next() ? M.mapRow(rs, 0) : null, id);
    }

    public QuestionDto findPublished(int id) {
        return jdbc.query("SELECT " + C + " FROM dbo.QUESTIONS q JOIN dbo.LESSONS l ON l.lesson_id=q.lesson_id JOIN dbo.TOPICS t ON t.topic_id=l.topic_id WHERE q.question_id=? AND q.status='PUBLISHED' AND l.status='PUBLISHED' AND t.status='ACTIVE'", rs -> rs.next() ? M.mapRow(rs, 0) : null, id);
    }

    public String findLessonTitle(int lessonId) {
        if (lessonId <= 0) return "Toàn bộ chương trình Toán 10";
        return jdbc.query("SELECT title FROM dbo.LESSONS WHERE lesson_id=?", rs -> rs.next() ? rs.getString(1) : "Bài học Toán 10", lessonId);
    }

    public boolean ownsLesson(int lessonId, int userId, boolean admin) {
        if (lessonId <= 0) return true;
        String sql = "SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.LESSONS WHERE lesson_id=?) THEN 1 ELSE 0 END AS BIT)";
        return Boolean.TRUE.equals(jdbc.query(sql, rs -> rs.next() && rs.getBoolean(1), lessonId));
    }

    public int insert(int userId, QuestionRequest q, String source) {
        return jdbc.queryForObject("INSERT dbo.QUESTIONS(lesson_id,created_by,source,question_type,question_text,option_a,option_b,option_c,option_d,correct_answer,explanation,solution_steps,difficulty,status) OUTPUT INSERTED.question_id VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                Integer.class, q.lessonId(), userId, source, q.type(), q.text(), q.optionA(), q.optionB(), q.optionC(), q.optionD(), q.correctAnswer(), q.explanation(), q.solutionSteps(), q.difficulty(), q.status() == null ? "DRAFT" : q.status());
    }

    public int insertAi(int userId, QuestionRequest q) {
        return jdbc.queryForObject("INSERT dbo.QUESTIONS(lesson_id,created_by,source,question_type,question_text,option_a,option_b,option_c,option_d,correct_answer,explanation,solution_steps,difficulty,status) OUTPUT INSERTED.question_id VALUES(?,?,'AI',?,?,?,?,?,?,?,?,?,?,?)",
                Integer.class, q.lessonId(), userId, q.type(), q.text(), q.optionA(), q.optionB(), q.optionC(), q.optionD(), q.correctAnswer(), q.explanation(), q.solutionSteps(), q.difficulty(), "PENDING_REVIEW");
    }

    @Transactional
    public List<Integer> insertAiBatch(int userId, List<QuestionRequest> questions) {
        return questions.stream().map(q -> insertAi(userId, q)).toList();
    }

    public int update(int id, int userId, boolean admin, QuestionRequest q) {
        String sql = "UPDATE dbo.QUESTIONS SET lesson_id=?,question_type=?,question_text=?,option_a=?,option_b=?,option_c=?,option_d=?,correct_answer=?,explanation=?,solution_steps=?,difficulty=?,status=? WHERE question_id=?";
        return jdbc.update(sql, q.lessonId(), q.type(), q.text(), q.optionA(), q.optionB(), q.optionC(), q.optionD(), q.correctAnswer(), q.explanation(), q.solutionSteps(), q.difficulty(), q.status() == null ? "DRAFT" : q.status(), id);
    }

    public int publish(int id, int reviewer, boolean admin) {
        String sql = "UPDATE dbo.QUESTIONS SET status='PUBLISHED',reviewed_by=?,reviewed_at=SYSUTCDATETIME() WHERE question_id=?";
        return jdbc.update(sql, reviewer, id);
    }

    @Transactional
    public int delete(int id) {
        jdbc.update("DELETE FROM dbo.ATTEMPTS WHERE question_id=?", id);
        return jdbc.update("DELETE FROM dbo.QUESTIONS WHERE question_id=?", id);
    }
}
