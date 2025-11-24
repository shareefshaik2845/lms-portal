import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/enrollment_model.dart';

class EnrollmentRemoteDataSource {
  final ApiClient _apiClient;

  EnrollmentRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<EnrollmentModel>>> getAllEnrollments() async {
    final response = await _apiClient.get(
      ApiConstants.enrollments,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final enrollments = data.map((json) => EnrollmentModel.fromJson(json)).toList();
      return ApiResponse.success(enrollments);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch enrollments');
  }

  Future<ApiResponse<EnrollmentModel>> createEnrollment({
    required int userId,
    required int courseId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.enrollments,
      body: {
        'user_id': userId,
        'course_id': courseId,
      },
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(EnrollmentModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create enrollment');
  }

  Future<ApiResponse<List<EnrollmentModel>>> getUserEnrollments(int userId) async {
    final response = await _apiClient.get(
      '${ApiConstants.enrollments}user/$userId',
      requiresAuth: false,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final enrollments = data.map((json) => EnrollmentModel.fromJson(json)).toList();
      return ApiResponse.success(enrollments);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch user enrollments');
  }

  Future<ApiResponse<List<EnrollmentModel>>> getCourseEnrollments(int courseId) async {
    final response = await _apiClient.get(
      '${ApiConstants.enrollments}course/$courseId',
      requiresAuth: false,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final enrollments = data.map((json) => EnrollmentModel.fromJson(json)).toList();
      return ApiResponse.success(enrollments);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch course enrollments');
  }

  Future<ApiResponse<bool>> deleteEnrollment(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.enrollments}$id',
      requiresAuth: true,
    );

    return response;
  }
}
