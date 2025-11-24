import 'package:lms_portal/data/models/course_model.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;
  final List<CourseModel>? courses;

  CategoryModel({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.courses,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      courses: json['courses'] != null
          ? (json['courses'] as List)
              .map((c) => CourseModel.fromJson(c))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
    };
  }
}