package vn.math10ai.attempts;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.auth.SessionUser;
import vn.math10ai.questions.QuestionDto;
import vn.math10ai.questions.QuestionRepository;
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;
import java.io.IOException;
import java.util.Base64;
import org.springframework.beans.factory.annotation.Value;
import vn.math10ai.ai.AiProviderClient;

@Service
public class AttemptService {
 private final AttemptRepository attempts;private final QuestionRepository questions;private final TutorRepository tutorRepository;private final AiProviderClient ai;
 @Value("${math10.upload-dir:./private-uploads}") private String uploadDir;
 public AttemptService(AttemptRepository attempts,QuestionRepository questions,TutorRepository tutorRepository,AiProviderClient ai){this.attempts=attempts;this.questions=questions;this.tutorRepository=tutorRepository;this.ai=ai;}
 public AttemptDto submit(SessionUser user,AttemptRequest request){QuestionDto q=published(request.questionId());String answer=request.answerText()==null?"":request.answerText().trim();if(answer.isBlank())throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Nhập câu trả lời trước khi gửi.");if("ESSAY".equals(q.type()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Dùng endpoint nộp tự luận cho câu hỏi này.");return save(q,user,answer,null);}
 public AttemptDto submitEssay(SessionUser user,int questionId,String answerText,MultipartFile image){QuestionDto q=published(questionId);if(!"ESSAY".equals(q.type()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Câu hỏi này không phải tự luận.");String answer=answerText==null?"":answerText.trim();if(answer.isBlank()&&(image==null||image.isEmpty()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Nhập lời giải hoặc tải ảnh bài làm lên.");if(image==null||image.isEmpty()){AttemptDto saved=save(q,user,answer,null);return reviewEssay(saved,user.id(),q,answer,null,null);}if(image.getSize()>10L*1024*1024)throw new ResponseStatusException(HttpStatus.PAYLOAD_TOO_LARGE,"Ảnh không được vượt quá 10 MB.");String ext=validImage(image);String mime=image.getContentType();try{Path dir=Path.of(uploadDir).toAbsolutePath().normalize();Files.createDirectories(dir);String key=UUID.randomUUID()+ext;Path target=dir.resolve(key).normalize();if(!target.startsWith(dir))throw new IOException("Invalid path");byte[] bytes=image.getBytes();Files.write(target,bytes);try{AttemptDto saved=save(q,user,answer,key);return reviewEssay(saved,user.id(),q,answer,mime,Base64.getEncoder().encodeToString(bytes));}catch(RuntimeException ex){Files.deleteIfExists(target);throw ex;}}catch(IOException ex){throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,"Không thể lưu ảnh bài làm.");}}
 private AttemptDto reviewEssay(AttemptDto attempt,int studentId,QuestionDto question,String answer,String mime,String imageBase64){String feedback;String action="HINT";Boolean correct=null;try{String prompt="Đề bài: "+question.text()+"\nLời giải tham khảo (chỉ dùng để kiểm tra): "+question.solutionSteps()+"\nLời giải học sinh (có thể rỗng nếu chỉ có ảnh): "+answer+"\nHãy nhận xét bằng tiếng Việt, chỉ ra bước đầu tiên đúng/sai hoặc còn thiếu và đặt một câu hỏi/gợi ý để học sinh tự làm tiếp. Chưa đưa đáp án cuối.";feedback=imageBase64==null?ai.complete("Bạn là gia sư Toán 10, hướng dẫn nhẹ nhàng từng bước, không tiết lộ đáp án cuối.",prompt):ai.completeWithImage("Bạn là gia sư Toán 10. Đọc bài làm trong ảnh, chỉ rõ bước đầu tiên sai hoặc thiếu và đưa một gợi ý để học sinh tự sửa; không chỉ đưa đáp án cuối.",prompt,mime,imageBase64);}catch(ResponseStatusException ex){feedback="Bài làm đã được lưu nhưng AI chưa thể nhận xét. "+(ex.getReason()==null?"Hãy thử lại sau.":ex.getReason());action="ERROR";}attempts.updateFeedback(attempt.id(),feedback,correct,null);tutorRepository.insert(attempt.id(),1,answer,feedback,action,correct,false);return attempts.find(attempt.id(),studentId);}
 private QuestionDto published(int id){QuestionDto q=questions.findPublished(id);if(q==null)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Câu hỏi không tồn tại hoặc chưa được xuất bản.");return q;}
 private AttemptDto save(QuestionDto q,SessionUser user,String answer,String imageKey){Boolean correct=null;BigDecimal score=null;String feedback="Bài tự luận đã được lưu, chờ AI nhận xét.";if("MCQ".equals(q.type())){correct=answer.equalsIgnoreCase(q.correctAnswer());score=correct?BigDecimal.TEN:BigDecimal.ZERO;feedback=correct?"Chính xác!":"Chưa đúng. Hãy xem gợi ý từng bước.";}long id=attempts.insert(q.id(),user.id(),answer,correct,score,feedback,imageKey);return attempts.find(id,user.id());}
 private String validImage(MultipartFile image){try{byte[] b=image.getBytes();String declared=image.getContentType();if(b.length>=3&&(b[0]&255)==255&&(b[1]&255)==216&&(b[2]&255)==255&&"image/jpeg".equals(declared))return ".jpg";if(b.length>=8&&(b[0]&255)==137&&b[1]==80&&b[2]==78&&b[3]==71&&"image/png".equals(declared))return ".png";if(b.length>=12&&b[0]==82&&b[1]==73&&b[2]==70&&b[3]==70&&b[8]==87&&b[9]==69&&b[10]==66&&b[11]==80&&"image/webp".equals(declared))return ".webp";}catch(IOException ignored){}throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Chỉ nhận ảnh JPEG, PNG hoặc WEBP hợp lệ.");}
 public List<AttemptDto> mine(SessionUser user){return attempts.history(user.id());}
 public byte[] image(SessionUser user,long attemptId){String key=privateImageKey(user,attemptId);try{Path base=Path.of(uploadDir).toAbsolutePath().normalize();Path target=base.resolve(key).normalize();if(!target.startsWith(base)||!Files.isRegularFile(target))throw new IOException("Missing file");return Files.readAllBytes(target);}catch(IOException ex){throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy ảnh bài làm.");}}
 public String imageMediaType(SessionUser user,long attemptId){String key=privateImageKey(user,attemptId);return key.endsWith(".png")?"image/png":key.endsWith(".webp")?"image/webp":"image/jpeg";}
 private String privateImageKey(SessionUser user,long attemptId){String key=attempts.imageKey(attemptId,user.id(),user.role());if(key==null||key.contains("/")||key.contains("\\")||key.contains(".."))throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy ảnh hoặc bạn không có quyền xem.");return key;}
 public List<AttemptDto> forStudent(SessionUser viewer,int studentId){if("TEACHER".equals(viewer.role())&&!attempts.ownsStudent(viewer.id(),studentId))throw new ResponseStatusException(HttpStatus.FORBIDDEN,"Học sinh này không thuộc lớp bạn phụ trách.");return attempts.history(studentId);}
}
