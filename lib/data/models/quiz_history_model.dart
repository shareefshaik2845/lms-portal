class QuizHistoryModel {
  final int? id;
  final int userId;
  final int checkpointId;
  final int courseId;
  final String answer;
  final String result;
  final String question;
  final String? completedAt;

  QuizHistoryModel({
    this.id,
    required this.userId,
    required this.checkpointId,
    required this.courseId,
    required this.answer,
    required this.result,
    required this.question,
    this.completedAt,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      id: json['id'],
      userId: json['user_id'],
      checkpointId: json['checkpoint_id'],
      courseId: json['course_id'],
      answer: json['answer'] ?? '',
      result: json['result'] ?? '',
      question: json['question'] ?? '',
      completedAt: json['completed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'checkpoint_id': checkpointId,
      'course_id': courseId,
      'answer': answer,
      'result': result,
      'question': question,
    };
  }
}
