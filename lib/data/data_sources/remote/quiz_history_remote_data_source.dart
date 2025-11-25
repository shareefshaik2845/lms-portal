import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/quiz_history_model.dart';

class QuizHistoryRemoteDataSource {
  final ApiClient _apiClient;

  QuizHistoryRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<QuizHistoryModel>>> getAll() async {
    final response = await _apiClient.get(
      ApiConstants.quizHistory,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => QuizHistoryModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch quiz history');
  }

  Future<ApiResponse<QuizHistoryModel>> create(QuizHistoryModel model) async {
    final response = await _apiClient.post(
      ApiConstants.quizHistory,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(QuizHistoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create quiz history');
  }

  Future<ApiResponse<List<QuizHistoryModel>>> getByUser(int userId) async {
    final response = await _apiClient.get(
      '${ApiConstants.quizHistory}user/$userId',
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => QuizHistoryModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch user quiz history');
  }

  Future<ApiResponse<QuizHistoryModel>> getById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.quizHistory}$id',
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(QuizHistoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch quiz history');
  }

  Future<ApiResponse<QuizHistoryModel>> update(int id, QuizHistoryModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.quizHistory}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(QuizHistoryModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update quiz history');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.quizHistory}$id',
      requiresAuth: true,
    );

    return response;
  }
}
