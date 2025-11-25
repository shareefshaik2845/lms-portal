import '../../core/network/api_response.dart';
import '../data_sources/remote/leave_remote_data_source.dart';
import '../models/leave_model.dart';

class LeaveRepository {
  final LeaveRemoteDataSource _remote;

  LeaveRepository(this._remote);

  Future<ApiResponse<List<LeaveModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<LeaveModel>> create(LeaveModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<LeaveModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<LeaveModel>> update(int id, LeaveModel model) async {
    return await _remote.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
