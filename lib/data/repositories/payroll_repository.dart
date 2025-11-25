import '../../core/network/api_response.dart';
import '../data_sources/remote/payroll_remote_data_source.dart';
import '../models/payroll_model.dart';

class PayrollRepository {
  final PayrollRemoteDataSource _remote;

  PayrollRepository(this._remote);

  Future<ApiResponse<List<PayrollModel>>> getAll() async {
    return await _remote.getAll();
  }

  Future<ApiResponse<PayrollModel>> create(PayrollModel model) async {
    return await _remote.create(model);
  }

  Future<ApiResponse<PayrollModel>> getById(int id) async {
    return await _remote.getById(id);
  }

  Future<ApiResponse<PayrollModel>> update(int id, Map<String, dynamic> body) async {
    return await _remote.update(id, body);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remote.delete(id);
  }
}
