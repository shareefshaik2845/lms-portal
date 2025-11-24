import '../data_sources/remote/branch_remote_data_source.dart';
import '../models/branch_model.dart';
import '../../core/network/api_response.dart';

class BranchRepository {
  final BranchRemoteDataSource _remoteDataSource;

  BranchRepository(this._remoteDataSource);

  Future<ApiResponse<List<BranchModel>>> getAllBranches() {
    return _remoteDataSource.getAllBranches();
  }

  Future<ApiResponse<BranchModel>> getBranchById(int id) {
    return _remoteDataSource.getBranchById(id);
  }

  Future<ApiResponse<BranchModel>> createBranch({
    required String name,
    required String address,
    required int organizationId,
  }) {
    return _remoteDataSource.createBranch(
      name: name,
      address: address,
      organizationId: organizationId,
    );
  }

  Future<ApiResponse<BranchModel>> updateBranch({
    required int id,
    required String name,
    required String address,
    required int organizationId,
  }) {
    return _remoteDataSource.updateBranch(
      id: id,
      name: name,
      address: address,
      organizationId: organizationId,
    );
  }

  Future<ApiResponse<bool>> deleteBranch(int id) {
    return _remoteDataSource.deleteBranch(id);
  }
}
