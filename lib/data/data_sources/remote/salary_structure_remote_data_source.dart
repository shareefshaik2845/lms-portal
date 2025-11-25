import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/salary_structure_model.dart';

class SalaryStructureRemoteDataSource {
  final ApiClient _apiClient;

  SalaryStructureRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<SalaryStructureModel>>> getAll() async {
    final response = await _apiClient.get(ApiConstants.salaryStructures, requiresAuth: true);

    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((json) => SalaryStructureModel.fromJson(json)).toList();
      return ApiResponse.success(items);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch salary structures');
  }

  Future<ApiResponse<SalaryStructureModel>> create(SalaryStructureModel model) async {
    final response = await _apiClient.post(
      ApiConstants.salaryStructures,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(SalaryStructureModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create salary structure');
  }

  Future<ApiResponse<SalaryStructureModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.salaryStructures}$id', requiresAuth: true);

    if (response.success) {
      return ApiResponse.success(SalaryStructureModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch salary structure');
  }

  Future<ApiResponse<SalaryStructureModel>> update(int id, SalaryStructureModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.salaryStructures}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(SalaryStructureModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update salary structure');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.salaryStructures}$id', requiresAuth: true);
    return response;
  }
}
