import '../data_sources/remote/organization_remote_data_source.dart';
import '../models/organization_model.dart';
import '../../core/network/api_response.dart';

class OrganizationRepository {
  final OrganizationRemoteDataSource _remoteDataSource;

  OrganizationRepository(this._remoteDataSource);

  Future<ApiResponse<List<OrganizationModel>>> getAllOrganizations() {
    return _remoteDataSource.getAllOrganizations();
  }

  Future<ApiResponse<OrganizationModel>> getOrganizationById(int id) {
    return _remoteDataSource.getOrganizationById(id);
  }

  Future<ApiResponse<OrganizationModel>> createOrganization({
    required String name,
    required String description,
    List<int>? branchIds,
  }) {
    return _remoteDataSource.createOrganization(
      name: name,
      description: description,
      branchIds: branchIds,
    );
  }

  Future<ApiResponse<OrganizationModel>> updateOrganization({
    required int id,
    required String name,
    required String description,
    List<int>? branchIds,
  }) {
    return _remoteDataSource.updateOrganization(
      id: id,
      name: name,
      description: description,
      branchIds: branchIds,
    );
  }

  Future<ApiResponse<bool>> deleteOrganization(int id) {
    return _remoteDataSource.deleteOrganization(id);
  }
}
