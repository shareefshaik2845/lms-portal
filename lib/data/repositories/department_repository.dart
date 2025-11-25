import '../../core/network/api_response.dart';
import '../data_sources/remote/department_remote_data_source.dart';
import '../models/department_model.dart';

class DepartmentRepository {
  final DepartmentRemoteDataSource _remote;

  DepartmentRepository(this._remote);

  Future<ApiResponse<List<DepartmentModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<DepartmentModel>> create(DepartmentModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<DepartmentModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<DepartmentModel>> update(int id, DepartmentModel model) async {
    return await _remote.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
