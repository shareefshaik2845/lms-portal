class VideoModel {
  final int? id;
  final String title;
  final String youtubeUrl;
  final int duration;
  final int courseId;

  VideoModel({
    this.id,
    required this.title,
    required this.youtubeUrl,
    required this.duration,
    required this.courseId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: _toIntNullable(json['id']),
      title: json['title']?.toString() ?? '',
      youtubeUrl: json['youtube_url']?.toString() ?? '',
      duration: _toInt(json['duration']),
      courseId: _toInt(json['course_id']),
    );
  }

  static int? _toIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'youtube_url': youtubeUrl,
      'duration': duration,
      'course_id': courseId,
    };
  }
}