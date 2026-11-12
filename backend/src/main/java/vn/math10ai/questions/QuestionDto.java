package vn.math10ai.questions;
public record QuestionDto(int id,int lessonId,String type,String text,String optionA,String optionB,
        String optionC,String optionD,String correctAnswer,String explanation,String solutionSteps,
        String difficulty,String status,String source) {}
