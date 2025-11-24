class CheckpointModel {
  final int? id;
  final int videoId;
  final int timestamp;
  final String question;
  final String choices;
  final String correctAnswer;
  final bool required;

  CheckpointModel({
    this.id,
    required this.videoId,
    required this.timestamp,
    required this.question,
    required this.choices,
    required this.correctAnswer,
    this.required = true,
  });

  factory CheckpointModel.fromJson(Map<String, dynamic> json) {
    return CheckpointModel(
      id: json['id'],
      videoId: json['video_id'],
      timestamp: json['timestamp'],
      question: json['question'],
      choices: json['choices'],
      correctAnswer: json['correct_answer'],
      required: json['required'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'video_id': videoId,
      'timestamp': timestamp,
      'question': question,
      'choices': choices,
      'correct_answer': correctAnswer,
      'required': required,
    };
  }

  List<String> getChoicesList() {
    return choices.split(',').map((e) => e.trim()).toList();
  }
}