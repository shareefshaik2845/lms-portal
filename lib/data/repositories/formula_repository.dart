import '../../core/network/api_response.dart';
import '../data_sources/remote/formula_remote_data_source.dart';
import '../models/formula_model.dart';

class FormulaRepository {
  final FormulaRemoteDataSource _remote;

  FormulaRepository(this._remote);

  Future<ApiResponse<List<FormulaModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<FormulaModel>> create(FormulaModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<FormulaModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<FormulaModel>> update(int id, FormulaModel model) async {
    return await _remote.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
