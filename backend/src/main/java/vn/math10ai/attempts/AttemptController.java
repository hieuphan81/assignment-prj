package vn.math10ai.attempts;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.math10ai.auth.RequireRoles;
import vn.math10ai.auth.SessionUser;
@RestController @RequestMapping("/api/v1/attempts")
public class AttemptController {
 private final AttemptService service;private final TutorService tutor;public AttemptController(AttemptService service,TutorService tutor){this.service=service;this.tutor=tutor;}
 @PostMapping @RequireRoles({"STUDENT"}) @ResponseStatus(HttpStatus.CREATED) public AttemptDto submit(@SessionAttribute("math10.user") SessionUser user,@Valid @RequestBody AttemptRequest request){return service.submit(user,request);}
 @PostMapping(value="/essay",consumes="multipart/form-data") @RequireRoles({"STUDENT"}) @ResponseStatus(HttpStatus.CREATED)
 public AttemptDto essay(@SessionAttribute("math10.user") SessionUser user,@RequestParam int questionId,@RequestParam(required=false) String answerText,@RequestPart(required=false) MultipartFile image){return service.submitEssay(user,questionId,answerText,image);}
 @GetMapping("/mine") @RequireRoles({"STUDENT"}) public List<AttemptDto> mine(@SessionAttribute("math10.user") SessionUser user){return service.mine(user);}
 @GetMapping("/students/{studentId}") @RequireRoles({"TEACHER","ADMIN"}) public List<AttemptDto> forStudent(@SessionAttribute("math10.user") SessionUser user,@PathVariable int studentId){return service.forStudent(user,studentId);}
 @GetMapping("/{attemptId}/image") @RequireRoles({"STUDENT","TEACHER","ADMIN"}) public ResponseEntity<byte[]> image(@SessionAttribute("math10.user") SessionUser user,@PathVariable long attemptId){return ResponseEntity.ok().contentType(MediaType.parseMediaType(service.imageMediaType(user,attemptId))).header("X-Content-Type-Options","nosniff").header("Content-Disposition","inline; filename=student-work").body(service.image(user,attemptId));}
 @PostMapping("/{attemptId}/tutor-turn") @RequireRoles({"STUDENT"}) public TutorTurnDto tutor(@SessionAttribute("math10.user") SessionUser user,@PathVariable long attemptId,@Valid @RequestBody TutorTurnRequest request){return tutor.next(user,attemptId,request.studentInput());}
}
