package vn.math10ai.attempts;
public record TutorTurnDto(long attemptId,int stepNumber,String action,Boolean correct,boolean finalStep,String message) {}
