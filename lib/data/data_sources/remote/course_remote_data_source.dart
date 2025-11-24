import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/course_model.dart';

class CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<CourseModel>>> getCourses() async {
    final response = await _apiClient.get(
      ApiConstants.courses,
      requiresAuth: false,  // Public endpoint - no auth required
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final courses = data.map((json) => CourseModel.fromJson(json)).toList();
      return ApiResponse.success(courses);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch courses');
  }

  Future<ApiResponse<CourseModel>> getCourseById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.courses}$id',
      requiresAuth: false,  // Public endpoint - no auth required
    );

    if (response.success) {
      return ApiResponse.success(CourseModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch course');
  }

  Future<ApiResponse<CourseModel>> createCourse(CourseModel course) async {
    final response = await _apiClient.post(
      ApiConstants.courses,
      body: course.toJson(),
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      return ApiResponse.success(CourseModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create course');
  }

  Future<ApiResponse<CourseModel>> updateCourse(int id, CourseModel course) async {
    final response = await _apiClient.put(
      '${ApiConstants.courses}$id',
      body: course.toJson(),
      requiresAuth: true,  // ✅ Changed to true - requires token
    );

    if (response.success) {
      return ApiResponse.success(CourseModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update course');
  }

  Future<ApiResponse<bool>> deleteCourse(int id) async {
    return await _apiClient.delete(
      '${ApiConstants.courses}$id',
      requiresAuth: true,  // ✅ Changed to true - requires token
    );
  }
}