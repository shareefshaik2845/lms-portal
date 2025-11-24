class EnrollmentModel {
  final int? id;
  final int userId;
  final int courseId;
  final String? enrolledAt;

  EnrollmentModel({
    this.id,
    required this.userId,
    required this.courseId,
    this.enrolledAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      enrolledAt: json['enrolled_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'course_id': courseId,
    };
  }
}