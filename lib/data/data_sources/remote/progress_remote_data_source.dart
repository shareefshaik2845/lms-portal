import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/progress_model.dart';

class ProgressRemoteDataSource {
  final ApiClient _apiClient;

  ProgressRemoteDataSource(this._apiClient);

  Future<ApiResponse<ProgressModel>> watch(int id, {required int watchedMinutes, required int userId}) async {
    final response = await _apiClient.post(
      '${ApiConstants.progress}$id/watch?watched_minutes=$watchedMinutes&user_id=$userId',
      body: {},
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(ProgressModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update progress');
  }

  Future<ApiResponse<List<ProgressModel>>> getProgress({int? userId, int? courseId}) async {
    final query = <String>[];
    if (userId != null) query.add('user_id=$userId');
    if (courseId != null) query.add('course_id=$courseId');
    final q = query.isNotEmpty ? '?${query.join('&')}' : '';

    final response = await _apiClient.get(
      '${ApiConstants.progress}$q',
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => ProgressModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch progress');
  }

  Future<ApiResponse<bool>> deleteForUser(int id, int userId) async {
    final response = await _apiClient.delete(
      '${ApiConstants.progress}$id/user/$userId',
      requiresAuth: true,
    );

    return response;
  }
}
