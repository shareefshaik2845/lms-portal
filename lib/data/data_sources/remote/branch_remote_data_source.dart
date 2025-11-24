import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/branch_model.dart';

class BranchRemoteDataSource {
  final ApiClient _apiClient;

  BranchRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<BranchModel>>> getAllBranches() async {
    final response = await _apiClient.get(
      ApiConstants.branches,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final branches = data.map((json) => BranchModel.fromJson(json)).toList();
      return ApiResponse.success(branches);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch branches');
  }

  Future<ApiResponse<BranchModel>> getBranchById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.branches}$id',
      requiresAuth: false,
    );

    if (response.success) {
      return ApiResponse.success(BranchModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch branch');
  }

  Future<ApiResponse<BranchModel>> createBranch({
    required String name,
    required String address,
    required int organizationId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.branches,
      body: {
        'name': name,
        'address': address,
        'organization_id': organizationId,
      },
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(BranchModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create branch');
  }

  Future<ApiResponse<BranchModel>> updateBranch({
    required int id,
    required String name,
    required String address,
    required int organizationId,
  }) async {
    final response = await _apiClient.put(
      '${ApiConstants.branches}$id',
      body: {
        'name': name,
        'address': address,
        'organization_id': organizationId,
      },
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(BranchModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update branch');
  }

  Future<ApiResponse<bool>> deleteBranch(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.branches}$id',
      requiresAuth: true,
    );

    return response;
  }
}
