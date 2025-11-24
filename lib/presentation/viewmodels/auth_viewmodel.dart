import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/shared_prefs.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // Check if user is already logged in
  Future<bool> checkLoginStatus() async {
    return await SharedPrefs.isLoggedIn();
  }

  // Get stored user role
  Future<int?> getUserRole() async {
    return await SharedPrefs.getRoleId();
  }

  // Get stored user details
  Future<void> loadUserData() async {
    final userId = await SharedPrefs.getUserId();
    final roleId = await SharedPrefs.getRoleId();
    final userName = await SharedPrefs.getUserName();
    final userEmail = await SharedPrefs.getUserEmail();

    if (userId != null && roleId != null && userName != null && userEmail != null) {
      _currentUser = UserModel(
        id: userId,
        name: userName,
        email: userEmail,
        roleId: roleId,
      );
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required int roleId,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.register(
      name: name,
      email: email,
      roleId: roleId,
      password: password,
    );

    _isLoading = false;

    if (response.success) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.login(
      username: username,
      password: password,
    );

    if (response.success && response.data != null) {
      final token = response.data!['access_token'];
      
      // Save token first
      await SharedPrefs.saveToken(token);

      // Get user details from login response (no need for separate API call)
      final userData = response.data!['user'];
      
      _isLoading = false;

      if (userData != null) {
        final user = UserModel.fromJson(userData);
        _currentUser = user;

        // Save all user data to SharedPreferences
        await SharedPrefs.saveUserData(user);
        // Mark login status so SharedPrefs.isLoggedIn() returns true
        await SharedPrefs.saveLoginStatus(true);

        notifyListeners();
        
        return {
          'success': true,
          'roleId': user.roleId,
          'user': user,
        };
      } else {
        _errorMessage = 'Failed to fetch user details from login response';
        notifyListeners();
        return null;
      }
    } else {
      _isLoading = false;
      _errorMessage = response.message ?? 'Login failed';
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    // Clear stored authentication so isLoggedIn() becomes false and cached user data is removed
    await SharedPrefs.clearToken();
    await SharedPrefs.clearUserData();
    // Ensure login status is false (clearUserData removes the flag, but keep explicit call for clarity)
    await SharedPrefs.saveLoginStatus(false);

    _currentUser = null;
    notifyListeners();
  }

  // Get current user info
  String getUserName() {
    return _currentUser?.name ?? 'User';
  }

  String getUserEmail() {
    return _currentUser?.email ?? '';
  }

  int? getUserRoleId() {
    return _currentUser?.roleId;
  }

  bool isAdmin() {
    return _currentUser?.roleId == 1;
  }

  bool isUser() {
    return _currentUser?.roleId == 2;
  }
}