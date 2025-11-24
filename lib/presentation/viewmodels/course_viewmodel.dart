import 'package:flutter/material.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/models/course_model.dart';

class CourseViewModel extends ChangeNotifier {
  final CourseRepository _repository;

  CourseViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<CourseModel> _courses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CourseModel> get courses => _courses;

  Future<void> fetchCourses() async {
    print('🔄 CourseViewModel: Starting fetchCourses...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getCourses();
      print('🔄 CourseViewModel: Response received - success: ${response.success}');

      _isLoading = false;

      if (response.success && response.data != null) {
        _courses = response.data!;
        print('✅ CourseViewModel: Loaded ${_courses.length} courses');
      } else {
        _errorMessage = response.message;
        print('❌ CourseViewModel: Error - $_errorMessage');
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ CourseViewModel: Exception - $e');
      print('❌ StackTrace: $stackTrace');
      _isLoading = false;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
    }
  }

  Future<bool> createCourse({
    required String title,
    required String instructor,
    required String level,
    required double price,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final course = CourseModel(
      title: title,
      instructor: instructor,
      level: level,
      price: price,
    );
    final response = await _repository.createCourse(course);

    _isLoading = false;

    if (response.success) {
      await fetchCourses();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCourse(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.deleteCourse(id);

    _isLoading = false;

    if (response.success) {
      await fetchCourses();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }
}