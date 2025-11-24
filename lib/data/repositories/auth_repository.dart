import '../../core/network/api_response.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required int roleId,
    required String password,
  }) async {
    return await _remoteDataSource.register(
      name: name,
      email: email,
      roleId: roleId,
      password: password,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    return await _remoteDataSource.login(
      username: username,
      password: password,
    );
  }

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  Future<ApiResponse<List<UserModel>>> getUserByEmail(String email) async {
    return await _remoteDataSource.getUserByEmail(email);
  }
}