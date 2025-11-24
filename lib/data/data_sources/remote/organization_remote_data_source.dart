import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/organization_model.dart';

class OrganizationRemoteDataSource {
  final ApiClient _apiClient;

  OrganizationRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<OrganizationModel>>> getAllOrganizations() async {
    final response = await _apiClient.get(
      ApiConstants.organizations,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final organizations = data.map((json) => OrganizationModel.fromJson(json)).toList();
      return ApiResponse.success(organizations);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch organizations');
  }

  Future<ApiResponse<OrganizationModel>> getOrganizationById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.organizations}$id',
      requiresAuth: false,
    );

    if (response.success) {
      return ApiResponse.success(OrganizationModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch organization');
  }

  Future<ApiResponse<OrganizationModel>> createOrganization({
    required String name,
    required String description,
    List<int>? branchIds,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.organizations,
      body: {
        'name': name,
        'description': description,
        'branch_ids': branchIds ?? [],
      },
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(OrganizationModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create organization');
  }

  Future<ApiResponse<OrganizationModel>> updateOrganization({
    required int id,
    required String name,
    required String description,
    List<int>? branchIds,
  }) async {
    final response = await _apiClient.put(
      '${ApiConstants.organizations}$id',
      body: {
        'name': name,
        'description': description,
        'branch_ids': branchIds ?? [],
      },
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(OrganizationModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update organization');
  }

  Future<ApiResponse<bool>> deleteOrganization(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.organizations}$id',
      requiresAuth: true,
    );

    return response;
  }
}
