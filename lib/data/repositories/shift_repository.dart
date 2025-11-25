import '../../core/network/api_response.dart';
import '../data_sources/remote/shift_remote_data_source.dart';
import '../models/shift_model.dart';

class ShiftRepository {
  final ShiftRemoteDataSource _remote;

  ShiftRepository(this._remote);

  Future<ApiResponse<List<ShiftModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<ShiftModel>> create(ShiftModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<ShiftModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<ShiftModel>> update(int id, ShiftModel model) async {
    return await _remote.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
