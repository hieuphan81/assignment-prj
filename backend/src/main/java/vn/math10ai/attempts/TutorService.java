package vn.math10ai.attempts;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import vn.math10ai.ai.AiProviderClient;
import vn.math10ai.auth.SessionUser;

@Service
public class TutorService {
 private final TutorRepository repository;private final AiProviderClient ai;private final ObjectMapper json;
 @Value("${math10.ai.hint-limit:3}") private int hintLimit;
 public TutorService(TutorRepository repository,AiProviderClient ai,ObjectMapper json){this.repository=repository;this.ai=ai;this.json=json;}
 public TutorTurnDto next(SessionUser user,long attemptId,String studentInput){
  TutorRepository.Context c=repository.context(attemptId,user.id());if(c==null)throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Không tìm thấy bài làm.");
  if(!"MCQ".equals(c.type())||Boolean.TRUE.equals(c.initiallyCorrect()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Gia sư từng bước chỉ mở cho câu trắc nghiệm trả lời sai.");
  List<TutorRepository.Turn> previous=repository.turns(attemptId);int step=previous.size()+1;if(step>1&&(studentInput==null||studentInput.isBlank()))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Nhập bước tính tiếp theo rồi gửi cho gia sư.");String input=studentInput==null||studentInput.isBlank()?c.originalAnswer():studentInput.trim();boolean finalStep=step>=Math.max(1,hintLimit);
  try{
   String result=ai.complete(buildSystem(c,finalStep),buildConversation(c,previous,input));
   TutorTurnDto parsed=parse(result,attemptId,step,finalStep);
   repository.insert(attemptId,step,input,parsed.message(),parsed.action(),parsed.correct(),parsed.finalStep());repository.updateAttemptFeedback(attemptId,parsed.message(),"CONFIRM".equals(parsed.action())&&Boolean.TRUE.equals(parsed.correct()));return parsed;
  }catch(ResponseStatusException ex){String message="Gia sư AI hiện chưa phản hồi được. Bài làm đã được lưu; hãy thử lại sau.";repository.insert(attemptId,step,input,message,"ERROR",null,false);return new TutorTurnDto(attemptId,step,"ERROR",null,false,message);}
 }
 private String buildSystem(TutorRepository.Context c,boolean finalStep){return "Bạn là gia sư Toán phổ thông bằng tiếng Việt. Hướng dẫn từng bước và không làm hộ học sinh. Trả về DUY NHẤT JSON: {\"action\":\"HINT|ASK_INPUT|CONFIRM|FINAL_SOLUTION|CLARIFICATION\",\"correct\":true|false|null,\"message\":\"...\"}. Bài toán: "+c.question()+". Đáp án chuẩn chỉ dùng để kiểm tra: "+c.answer()+". Lời giải tham khảo: "+(c.steps()==null?c.explanation():c.steps())+". Lượt hiện tại là "+(finalStep?"lượt cuối; được phép nêu lời giải ngắn gọn":"gợi ý; không được lộ đáp án đầy đủ")+". Hãy chỉ phản hồi một gợi ý cụ thể và yêu cầu học sinh nhập giá trị/bước kế tiếp. Nếu học sinh đã đưa đúng bước, xác nhận rồi yêu cầu bước kế tiếp, hoặc kết luận CONFIRM nếu đã hoàn tất.";}
 private String buildConversation(TutorRepository.Context c,List<TutorRepository.Turn> previous,String input){StringBuilder b=new StringBuilder("Câu trả lời ban đầu của học sinh: ").append(c.originalAnswer());for(var t:previous){if(t.studentInput()!=null&&!t.studentInput().isBlank())b.append("\nBước học sinh: ").append(t.studentInput());b.append("\nGia sư: ").append(t.response());}return b.append("\nBước mới nhất của học sinh: ").append(input).toString();}
 private TutorTurnDto parse(String text,long attemptId,int step,boolean finalStep){try{String clean=text.replaceAll("(?s)^```(?:json)?\\s*|\\s*```$","").trim();var node=json.readTree(clean);String action=node.path("action").asText(finalStep?"FINAL_SOLUTION":"HINT");if(!List.of("HINT","ASK_INPUT","CONFIRM","FINAL_SOLUTION","CLARIFICATION").contains(action))action=finalStep?"FINAL_SOLUTION":"ASK_INPUT";String message=node.path("message").asText("").trim();if(message.isBlank())throw new IllegalArgumentException();Boolean correct=node.path("correct").isBoolean()?node.path("correct").asBoolean():null;return new TutorTurnDto(attemptId,step,finalStep?"FINAL_SOLUTION":action,correct,finalStep,message);}catch(Exception ex){throw new ResponseStatusException(HttpStatus.BAD_GATEWAY,"AI trả về gợi ý không hợp lệ.");}}
}
