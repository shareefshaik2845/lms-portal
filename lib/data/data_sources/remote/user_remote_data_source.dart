import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<UserModel>>> getUsers() async {
    final response = await _apiClient.get(
      ApiConstants.users,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final users = data.map((json) => UserModel.fromJson(json)).toList();
      return ApiResponse.success(users);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch users');
  }

  Future<ApiResponse<UserModel>> getUserById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.users}$id',
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(UserModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch user');
  }

  Future<ApiResponse<UserModel>> createUser(UserModel user, String password) async {
    final body = user.toJson();
    body['password'] = password;

    final response = await _apiClient.post(
      ApiConstants.users,
      body: body,
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(UserModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create user');
  }

  Future<ApiResponse<UserModel>> updateUser(int id, UserModel user) async {
    final response = await _apiClient.put(
      '${ApiConstants.users}$id',
      body: user.toJson(),
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(UserModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update user');
  }

  Future<ApiResponse<bool>> deleteUser(int id) async {
    return await _apiClient.delete(
      '${ApiConstants.users}$id',
      requiresAuth: true,
    );
  }
}