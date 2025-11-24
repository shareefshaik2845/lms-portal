import '../../core/network/api_response.dart';
import '../data_sources/remote/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepository(this._remoteDataSource);

  Future<ApiResponse<List<UserModel>>> getUsers() async {
    return await _remoteDataSource.getUsers();
  }

  Future<ApiResponse<UserModel>> getUserById(int id) async {
    return await _remoteDataSource.getUserById(id);
  }

  Future<ApiResponse<UserModel>> createUser(UserModel user, String password) async {
    return await _remoteDataSource.createUser(user, password);
  }

  Future<ApiResponse<UserModel>> updateUser(int id, UserModel user) async {
    return await _remoteDataSource.updateUser(id, user);
  }

  Future<ApiResponse<bool>> deleteUser(int id) async {
    return await _remoteDataSource.deleteUser(id);
  }
}