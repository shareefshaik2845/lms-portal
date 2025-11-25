class ProgressModel {
  final int? id;
  final int userId;
  final int courseId;
  final int watchedMinutes;
  final int progressPercentage;
  final String? createdAt;
  final String? updatedAt;

  ProgressModel({
    this.id,
    required this.userId,
    required this.courseId,
    required this.watchedMinutes,
    required this.progressPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      watchedMinutes: json['watched_minutes'] ?? 0,
      progressPercentage: json['progress_percentage'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'course_id': courseId,
      'watched_minutes': watchedMinutes,
      'progress_percentage': progressPercentage,
    };
  }
}
