import '../../core/network/api_response.dart';
import '../data_sources/remote/salary_structure_remote_data_source.dart';
import '../models/salary_structure_model.dart';

class SalaryStructureRepository {
  final SalaryStructureRemoteDataSource _remote;

  SalaryStructureRepository(this._remote);

  Future<ApiResponse<List<SalaryStructureModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<SalaryStructureModel>> create(SalaryStructureModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<SalaryStructureModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<SalaryStructureModel>> update(int id, SalaryStructureModel model) async {
    return await _remote.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
