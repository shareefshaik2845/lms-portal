import 'video_model.dart';

class CourseModel {
  final int? id;
  final String title;
  final String instructor;
  final String level;
  final double price;
  final double duration;
  final List<VideoModel>? videos;

  CourseModel({
    this.id,
    required this.title,
    required this.instructor,
    required this.level,
    required this.price,
    this.duration = 0,
    this.videos,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: _toInt(json['id']),
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      level: json['level'] ?? '',
      price: _toDouble(json['price']),
      duration: _toDouble(json['duration']),
      videos: json['videos'] != null
          ? (json['videos'] as List)
              .map((v) => VideoModel.fromJson(v))
              .toList()
          : null,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'instructor': instructor,
      'level': level,
      'price': price,
    };
  }
}