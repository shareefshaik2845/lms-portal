import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/checkpoint_model.dart';

class CheckpointRemoteDataSource {
  final ApiClient _apiClient;

  CheckpointRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<CheckpointModel>>> getCheckpoints() async {
    final response = await _apiClient.get(
      ApiConstants.checkpoints,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final checkpoints = data.map((json) => CheckpointModel.fromJson(json)).toList();
      return ApiResponse.success(checkpoints);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch checkpoints');
  }

  Future<ApiResponse<CheckpointModel>> getCheckpointById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.checkpoints}$id',
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(CheckpointModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch checkpoint');
  }

  Future<ApiResponse<CheckpointModel>> createCheckpoint(CheckpointModel checkpoint) async {
    final response = await _apiClient.post(
      ApiConstants.checkpoints,
      body: checkpoint.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(CheckpointModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create checkpoint');
  }

  Future<ApiResponse<CheckpointModel>> updateCheckpoint(int id, CheckpointModel checkpoint) async {
    final response = await _apiClient.put(
      '${ApiConstants.checkpoints}$id',
      body: checkpoint.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(CheckpointModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update checkpoint');
  }

  Future<ApiResponse<bool>> deleteCheckpoint(int id) async {
    return await _apiClient.delete(
      '${ApiConstants.checkpoints}$id',
      requiresAuth: true,
    );
  }
}