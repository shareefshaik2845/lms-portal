import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/payroll_model.dart';

class PayrollRemoteDataSource {
  final ApiClient _apiClient;

  PayrollRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<PayrollModel>>> getAll() async {
    final response = await _apiClient.get(ApiConstants.payrolls, requiresAuth: true);
    if (response.success) {
      final List<dynamic> data = response.data;
      final items = data.map((j) => PayrollModel.fromJson(j)).toList();
      return ApiResponse.success(items);
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch payrolls');
  }

  Future<ApiResponse<PayrollModel>> create(PayrollModel model) async {
    final response = await _apiClient.post(
      ApiConstants.payrolls,
      body: model.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(PayrollModel.fromJson(response.data));
    }
    return ApiResponse.error(response.message ?? 'Failed to create payroll');
  }

  Future<ApiResponse<PayrollModel>> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.payrolls}$id', requiresAuth: true);
    if (response.success) {
      return ApiResponse.success(PayrollModel.fromJson(response.data));
    }
    return ApiResponse.error(response.message ?? 'Failed to fetch payroll');
  }

  Future<ApiResponse<PayrollModel>> update(int id, Map<String, dynamic> body) async {
    final response = await _apiClient.put(
      '${ApiConstants.payrolls}$id',
      body: body,
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(PayrollModel.fromJson(response.data));
    }
    return ApiResponse.error(response.message ?? 'Failed to update payroll');
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final response = await _apiClient.delete('${ApiConstants.payrolls}$id', requiresAuth: true);
    return response;
  }
}
