import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/department_model.dart';

class DepartmentRemoteDataSource {
  final ApiClient _apiClient;

  DepartmentRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<DepartmentModel>>> getAll() async {
    final response = await _apiClient.get(
      ApiConstants.departments,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => DepartmentModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch departments');
  }

  Future<ApiResponse<DepartmentModel>> create(DepartmentModel model) async {
    final response = await _apiClient.post(
      ApiConstants.departments,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(DepartmentModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create department');
  }

  Future<ApiResponse<DepartmentModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.departments}$id', requiresAuth: true);

    if (response.success) {
      return ApiResponse.success(DepartmentModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch department');
  }

  Future<ApiResponse<DepartmentModel>> update(int id, DepartmentModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.departments}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(DepartmentModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update department');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.departments}$id', requiresAuth: true);
    return response;
  }
}
