package vn.math10ai.attempts;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
@Repository
public class TutorRepository {
 private final JdbcTemplate jdbc;public TutorRepository(JdbcTemplate jdbc){this.jdbc=jdbc;}
 public Context context(long attemptId,int studentId){return jdbc.query("SELECT a.attempt_id,a.answer_text,a.is_correct,q.question_type,q.question_text,q.correct_answer,q.solution_steps,q.explanation FROM dbo.ATTEMPTS a JOIN dbo.QUESTIONS q ON q.question_id=a.question_id WHERE a.attempt_id=? AND a.student_id=?",r->r.next()?new Context(r.getLong(1),r.getString(2),(Boolean)r.getObject(3),r.getString(4),r.getString(5),r.getString(6),r.getString(7),r.getString(8)):null,attemptId,studentId);}
 public List<Turn> turns(long attemptId){return jdbc.query("SELECT student_input,ai_response,ai_action,is_correct,is_final FROM dbo.AI_INTERACTIONS WHERE attempt_id=? ORDER BY step_number",(r,n)->new Turn(r.getString(1),r.getString(2),r.getString(3),(Boolean)r.getObject(4),r.getBoolean(5)),attemptId);}
 public void insert(long attemptId,int step,String input,String response,String action,Boolean correct,boolean finalStep){jdbc.update("INSERT dbo.AI_INTERACTIONS(attempt_id,step_number,student_input,ai_response,ai_action,is_correct,is_final) VALUES(?,?,?,?,?,?,?)",attemptId,step,input,response,action,correct,finalStep);}
 public void updateAttemptFeedback(long attemptId,String feedback,Boolean solved){jdbc.update("UPDATE dbo.ATTEMPTS SET feedback=?,is_correct=CASE WHEN ?=1 THEN 1 ELSE is_correct END,score=CASE WHEN ?=1 THEN 10 ELSE score END WHERE attempt_id=?",feedback,solved,solved,attemptId);}
 public record Context(long attemptId,String originalAnswer,Boolean initiallyCorrect,String type,String question,String answer,String steps,String explanation){}
 public record Turn(String studentInput,String response,String action,Boolean correct,boolean finalStep){}
}
