import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/leave_model.dart';

class LeaveRemoteDataSource {
  final ApiClient _apiClient;

  LeaveRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<LeaveModel>>> getAll() async {
    final response = await _apiClient.get(
      ApiConstants.leaves,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => LeaveModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch leaves');
  }

  Future<ApiResponse<LeaveModel>> create(LeaveModel model) async {
    final response = await _apiClient.post(
      ApiConstants.leaves,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(LeaveModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create leave');
  }

  Future<ApiResponse<LeaveModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.leaves}$id', requiresAuth: true);

    if (response.success) {
      return ApiResponse.success(LeaveModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch leave');
  }

  Future<ApiResponse<LeaveModel>> update(int id, LeaveModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.leaves}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(LeaveModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update leave');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.leaves}$id', requiresAuth: true);
    return response;
  }
}
