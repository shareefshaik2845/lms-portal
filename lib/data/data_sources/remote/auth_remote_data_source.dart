import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required int roleId,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiConstants.register,
      body: {
        'name': name,
        'email': email,
        'role_id': roleId,
        'password': password,
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    return await _apiClient.postFormUrlEncoded(
      ApiConstants.login,
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'scope': '',
        'client_id': 'string',
        'client_secret': 'string',
      },
    );
  }

  // Get current user details after login
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _apiClient.get(
      '${ApiConstants.users}me',
      requiresAuth: true,
    );

    if (response.success) {
      return ApiResponse.success(UserModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch user details');
  }

  // Get user by email (alternative method to get user details)
  Future<ApiResponse<List<UserModel>>> getUserByEmail(String email) async {
    final response = await _apiClient.get(
      ApiConstants.users,
      requiresAuth: true,
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final users = data.map((json) => UserModel.fromJson(json)).toList();
      final user = users.where((u) => u.email == email).toList();
      return ApiResponse.success(user);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch user');
  }
}
