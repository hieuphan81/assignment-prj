package vn.math10ai.attempts;
import java.time.Instant;
public record AttemptDto(long id,int questionId,String questionText,String answerText,Boolean correct,
                         java.math.BigDecimal score,String feedback,String correctAnswer,
                         String explanation,String solutionSteps,Instant submittedAt,
                         String lessonTitle,String questionType) {}
