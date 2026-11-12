package vn.math10ai.ai;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

@Component
public class AiProviderClient {
 private final ObjectMapper json;private final HttpClient http;
 @Value("${math10.ai.url:}") private String endpoint;
 @Value("${math10.ai.key:}") private String apiKey;
 @Value("${math10.ai.model:gpt-4o-mini}") private String model;
 private String stepPrompt = "Bạn là Gia sư AI Socratic Toán lớp 10. Hướng dẫn giải tự luận từng bước: với mỗi bước chỉ đưa ra công thức và phương pháp, dừng lại yêu cầu học sinh điền đáp số. Sau khi hoàn thành các bước, bắt buộc học sinh tự làm lại vào vở và nộp lại ảnh chụp.";
 private String mcqPrompt = "Bạn là giáo viên giải thích trắc nghiệm Toán 10. Hãy phân tích ngắn gọn lý do vì sao đáp án đúng và chỉ ra lỗi sai học sinh thường mắc phải.";

 public AiProviderClient(ObjectMapper json){this.json=json;this.http=HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();}
 public boolean configured(){return endpoint!=null&&!endpoint.isBlank()&&apiKey!=null&&!apiKey.isBlank();}
 public String model(){return model;}
 public void setModel(String model){this.model=model;}
 public String getEndpoint(){return endpoint;}
 public void setEndpoint(String endpoint){this.endpoint=endpoint;}
 public String getApiKey(){return apiKey;}
 public void setApiKey(String apiKey){this.apiKey=apiKey;}
 public String getStepPrompt(){return stepPrompt;}
 public void setStepPrompt(String stepPrompt){this.stepPrompt=stepPrompt;}
 public String getMcqPrompt(){return mcqPrompt;}
 public void setMcqPrompt(String mcqPrompt){this.mcqPrompt=mcqPrompt;}
 public String provider(){if(endpoint!=null&&endpoint.contains("generativelanguage.googleapis.com"))return "Google Gemini";return configured()?"OpenAI compatible":"Chưa cấu hình";}
 public String complete(String system,String user){return completeMessages(List.of(Map.<String,Object>of("role","system","content",system),Map.<String,Object>of("role","user","content",user)));}
 public String completeWithImage(String system,String prompt,String mimeType,String base64Image){
  List<Map<String,Object>> content=List.of(Map.<String,Object>of("type","text","text",prompt),Map.<String,Object>of("type","image_url","image_url",Map.of("url","data:"+mimeType+";base64,"+base64Image)));
  return completeMessages(List.of(Map.<String,Object>of("role","system","content",system),Map.<String,Object>of("role","user","content",content)));
 }
 public String completeMessages(List<Map<String,Object>> messages){
  if(!configured())throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,"Dịch vụ AI chưa được cấu hình.");
  try{
   String body=json.writeValueAsString(Map.of("model",model,"messages",messages,"temperature",0.25));
   HttpRequest request=HttpRequest.newBuilder(URI.create(endpoint)).timeout(Duration.ofSeconds(45)).header("Authorization","Bearer "+apiKey).header("Content-Type","application/json").POST(HttpRequest.BodyPublishers.ofString(body)).build();
   HttpResponse<String> response=http.send(request,HttpResponse.BodyHandlers.ofString());
   if(response.statusCode()<200||response.statusCode()>=300)throw upstreamFailure(response.statusCode());
   JsonNode node=json.readTree(response.body());JsonNode content=node.path("choices").path(0).path("message").path("content");
   if(!content.isTextual()||content.asText().isBlank())throw new ResponseStatusException(HttpStatus.BAD_GATEWAY,"AI trả về nội dung không hợp lệ.");
   return content.asText();
  }catch(ResponseStatusException ex){throw ex;}catch(HttpTimeoutException ex){throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,"AI phản hồi quá thời gian chờ. Hãy thử lại sau.");}catch(InterruptedException ex){Thread.currentThread().interrupt();throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,"Yêu cầu AI đã bị gián đoạn. Hãy thử lại.");}catch(Exception ex){throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,"Không kết nối được máy chủ AI. Hãy kiểm tra mạng và địa chỉ API.");}
 }
 private ResponseStatusException upstreamFailure(int status){String reason=switch(status){case 400->"Gemini từ chối yêu cầu (HTTP 400). Kiểm tra tên model và nội dung gửi.";case 401,403->"Gemini từ chối API key (HTTP "+status+"). Hãy kiểm tra hoặc tạo lại key trong AI Studio.";case 404->"Gemini không tìm thấy model hoặc endpoint (HTTP 404). Kiểm tra cấu hình AI.";case 429->"Gemini đã giới hạn yêu cầu hoặc hết quota (HTTP 429). Kiểm tra hạn mức của dự án.";default->"Gemini hiện không xử lý được yêu cầu (HTTP "+status+"). Hãy thử lại sau.";};return new ResponseStatusException(HttpStatus.BAD_GATEWAY,reason);}
}
