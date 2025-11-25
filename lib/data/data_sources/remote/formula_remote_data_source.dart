import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/formula_model.dart';

class FormulaRemoteDataSource {
  final ApiClient _apiClient;

  FormulaRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<FormulaModel>>> getAll() async {
    final response = await _apiClient.get(ApiConstants.formulas, requiresAuth: true);
    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((j) => FormulaModel.fromJson(j)).toList();
      return ApiResponse.success(items);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch formulas');
  }

  Future<ApiResponse<FormulaModel>> create(FormulaModel model) async {
    final response = await _apiClient.post(
      ApiConstants.formulas,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(FormulaModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create formula');
  }

  Future<ApiResponse<FormulaModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.formulas}$id', requiresAuth: true);
    if (response.success) {
      return ApiResponse.success(FormulaModel.fromJson(response.data));
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch formula');
  }

  Future<ApiResponse<FormulaModel>> update(int id, FormulaModel model) async {
    final response = await _apiClient.put(
      '${ApiConstants.formulas}$id',
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(FormulaModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update formula');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.formulas}$id', requiresAuth: true);
    return response;
  }
}
