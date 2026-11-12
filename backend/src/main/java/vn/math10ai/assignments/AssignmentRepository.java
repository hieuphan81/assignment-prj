package vn.math10ai.assignments;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

@Repository
public class AssignmentRepository {
    private final JdbcTemplate jdbc;

    public AssignmentRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public int create(int teacherId, AssignmentRequest req) {
        String sql = """
            INSERT INTO dbo.ASSIGNMENTS (teacher_id, lesson_id, lesson_title, type, target_type, target_value, deadline, note, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE')
        """;
        KeyHolder kh = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, teacherId);
            ps.setInt(2, req.lessonId());
            ps.setString(3, req.lessonTitle());
            ps.setString(4, req.type() != null ? req.type() : "ALL");
            ps.setString(5, req.targetType() != null ? req.targetType() : "ALL");
            ps.setString(6, req.targetValue() != null ? req.targetValue() : "all");
            ps.setString(7, req.deadline());
            ps.setString(8, req.note());
            return ps;
        }, kh);
        Number key = kh.getKey();
        return key != null ? key.intValue() : 0;
    }

    public List<AssignmentDto> listForTeacher(int teacherId) {
        String sql = """
            SELECT a.assignment_id, a.teacher_id, u.full_name as teacher_name,
                   a.lesson_id, a.lesson_title, a.type, a.target_type, a.target_value,
                   a.deadline, a.note, a.status, CONVERT(VARCHAR, a.created_at, 120) as created_at,
                   (SELECT COUNT(*) FROM dbo.ASSIGNMENT_SUBMISSIONS s WHERE s.assignment_id = a.assignment_id) as submission_count
            FROM dbo.ASSIGNMENTS a
            LEFT JOIN dbo.USERS u ON a.teacher_id = u.user_id
            WHERE a.teacher_id = ? AND a.status = 'ACTIVE'
            ORDER BY a.assignment_id DESC
        """;
        return jdbc.query(sql, (rs, rowNum) -> new AssignmentDto(
            rs.getInt("assignment_id"),
            rs.getInt("teacher_id"),
            rs.getString("teacher_name"),
            rs.getInt("lesson_id"),
            rs.getString("lesson_title"),
            rs.getString("type"),
            rs.getString("target_type"),
            rs.getString("target_value"),
            rs.getString("deadline"),
            rs.getString("note"),
            rs.getString("status"),
            rs.getString("created_at"),
            rs.getInt("submission_count"),
            false
        ), teacherId);
    }

    public List<AssignmentDto> listForStudent(int studentId, String username, Integer teacherId) {
        String sql = """
            SELECT a.assignment_id, a.teacher_id, u.full_name as teacher_name,
                   a.lesson_id, a.lesson_title, a.type, a.target_type, a.target_value,
                   a.deadline, a.note, a.status, CONVERT(VARCHAR, a.created_at, 120) as created_at,
                   (SELECT COUNT(*) FROM dbo.ASSIGNMENT_SUBMISSIONS s WHERE s.assignment_id = a.assignment_id) as submission_count,
                   (CASE WHEN EXISTS (SELECT 1 FROM dbo.ASSIGNMENT_SUBMISSIONS s WHERE s.assignment_id = a.assignment_id AND s.student_id = ?) THEN 1 ELSE 0 END) as is_submitted
            FROM dbo.ASSIGNMENTS a
            LEFT JOIN dbo.USERS u ON a.teacher_id = u.user_id
            WHERE a.status = 'ACTIVE'
              AND (a.teacher_id = ? OR a.teacher_id IS NULL OR ? = 0)
              AND (a.target_value = 'all' OR a.target_value = ? OR a.target_value = CAST(? AS VARCHAR))
            ORDER BY a.assignment_id DESC
        """;
        int tId = teacherId != null ? teacherId : 0;
        return jdbc.query(sql, (rs, rowNum) -> new AssignmentDto(
            rs.getInt("assignment_id"),
            rs.getInt("teacher_id"),
            rs.getString("teacher_name"),
            rs.getInt("lesson_id"),
            rs.getString("lesson_title"),
            rs.getString("type"),
            rs.getString("target_type"),
            rs.getString("target_value"),
            rs.getString("deadline"),
            rs.getString("note"),
            rs.getString("status"),
            rs.getString("created_at"),
            rs.getInt("submission_count"),
            rs.getInt("is_submitted") == 1
        ), studentId, tId, tId, username, studentId);
    }

    public void delete(int assignmentId, int teacherId) {
        jdbc.update("UPDATE dbo.ASSIGNMENTS SET status = 'DELETED' WHERE assignment_id = ? AND (teacher_id = ? OR ? = 1)", assignmentId, teacherId, teacherId);
    }

    public void submit(int assignmentId, int studentId, String username, Double score) {
        String sql = """
            IF NOT EXISTS (SELECT 1 FROM dbo.ASSIGNMENT_SUBMISSIONS WHERE assignment_id = ? AND student_id = ?)
            BEGIN
                INSERT INTO dbo.ASSIGNMENT_SUBMISSIONS (assignment_id, student_id, student_username, score, status)
                VALUES (?, ?, ?, ?, 'COMPLETED')
            END
        """;
        jdbc.update(sql, assignmentId, studentId, assignmentId, studentId, username, score != null ? score : 10.0);
    }
}
