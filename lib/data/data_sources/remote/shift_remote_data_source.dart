import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/shift_model.dart';

class ShiftRemoteDataSource {
  final ApiClient _apiClient;

  ShiftRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<ShiftModel>>> getAll() async {
    final response = await _apiClient.get(
      ApiConstants.shifts,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => ShiftModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch shifts');
  }

  Future<ApiResponse<ShiftModel>> create(ShiftModel model) async {
    final response = await _apiClient.post(
      ApiConstants.shifts,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(ShiftModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create shift');
  }

  Future<ApiResponse<ShiftModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.shifts}$id', requiresAuth: true);

    if (response.success) {
      return ApiResponse.success(ShiftModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch shift');
  }

  Future<ApiResponse<ShiftModel>> update(int id, ShiftModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.shifts}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(ShiftModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update shift');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.shifts}$id', requiresAuth: true);
    return response;
  }
}
