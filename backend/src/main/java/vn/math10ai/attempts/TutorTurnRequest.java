package vn.math10ai.attempts;
import jakarta.validation.constraints.Size;
public record TutorTurnRequest(@Size(max=20000) String studentInput) {}
