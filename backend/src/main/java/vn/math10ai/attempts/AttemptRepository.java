package vn.math10ai.attempts;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AttemptRepository {
 private final JdbcTemplate jdbc;public AttemptRepository(JdbcTemplate jdbc){this.jdbc=jdbc;}
 public long insert(int questionId,int studentId,String answer,Boolean correct,java.math.BigDecimal score,String feedback,String imageKey){return jdbc.queryForObject("INSERT dbo.ATTEMPTS(question_id,student_id,answer_text,image_path,is_correct,score,feedback) OUTPUT INSERTED.attempt_id VALUES(?,?,?,?,?,?,?)",Long.class,questionId,studentId,answer,imageKey,correct,score,feedback);}
 public List<AttemptDto> history(int studentId){return jdbc.query("SELECT a.attempt_id,a.question_id,q.question_text,a.answer_text,a.is_correct,a.score,a.feedback,q.correct_answer,q.explanation,q.solution_steps,a.submitted_at,COALESCE(l.title,'Toán 10'),q.question_type FROM dbo.ATTEMPTS a JOIN dbo.QUESTIONS q ON q.question_id=a.question_id LEFT JOIN dbo.LESSONS l ON l.lesson_id=q.lesson_id WHERE a.student_id=? ORDER BY a.submitted_at DESC",(r,n)->new AttemptDto(r.getLong(1),r.getInt(2),r.getString(3),r.getString(4),(Boolean)r.getObject(5),r.getBigDecimal(6),r.getString(7),r.getString(8),r.getString(9),r.getString(10),r.getTimestamp(11)!=null?r.getTimestamp(11).toInstant():null,r.getString(12),r.getString(13)),studentId);}
 public AttemptDto find(long id,int owner){return jdbc.query("SELECT a.attempt_id,a.question_id,q.question_text,a.answer_text,a.is_correct,a.score,a.feedback,q.correct_answer,q.explanation,q.solution_steps,a.submitted_at,COALESCE(l.title,'Toán 10'),q.question_type FROM dbo.ATTEMPTS a JOIN dbo.QUESTIONS q ON q.question_id=a.question_id LEFT JOIN dbo.LESSONS l ON l.lesson_id=q.lesson_id WHERE a.attempt_id=? AND a.student_id=?",r->r.next()?new AttemptDto(r.getLong(1),r.getInt(2),r.getString(3),r.getString(4),(Boolean)r.getObject(5),r.getBigDecimal(6),r.getString(7),r.getString(8),r.getString(9),r.getString(10),r.getTimestamp(11)!=null?r.getTimestamp(11).toInstant():null,r.getString(12),r.getString(13)):null,id,owner);}
 public boolean teacherCanRead(long attemptId,int teacherId){return jdbc.query("SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.ATTEMPTS a JOIN dbo.USERS s ON s.user_id=a.student_id WHERE a.attempt_id=? AND s.teacher_id=?) THEN 1 ELSE 0 END AS BIT)",r->r.next()&&r.getBoolean(1),attemptId,teacherId);}
 public boolean ownsStudent(int teacherId,int studentId){return jdbc.query("SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.USERS WHERE user_id=? AND teacher_id=? AND role='STUDENT') THEN 1 ELSE 0 END AS BIT)",r->r.next()&&r.getBoolean(1),studentId,teacherId);}
 public void updateFeedback(long attemptId,String feedback,Boolean correct,java.math.BigDecimal score){jdbc.update("UPDATE dbo.ATTEMPTS SET feedback=?,is_correct=COALESCE(?,is_correct),score=COALESCE(?,score) WHERE attempt_id=?",feedback,correct,score,attemptId);}
 public String imageKey(long id, int userId, String role){String sql="SELECT a.image_path FROM dbo.ATTEMPTS a JOIN dbo.USERS s ON s.user_id=a.student_id WHERE a.attempt_id=?";if("STUDENT".equals(role))sql+=" AND a.student_id=?";else if("TEACHER".equals(role))sql+=" AND s.teacher_id=?";return "ADMIN".equals(role)?jdbc.query(sql,r->r.next()?r.getString(1):null,id):jdbc.query(sql,r->r.next()?r.getString(1):null,id,userId);}
}
