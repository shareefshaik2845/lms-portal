import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class SharedPrefs {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _roleIdKey = 'role_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Token operations
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // User ID operations
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Role ID operations
  static Future<void> saveRoleId(int roleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_roleIdKey, roleId);
  }

  static Future<int?> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_roleIdKey);
  }

  // User name operations
  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, userName);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // User email operations
  static Future<void> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, userEmail);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Login status operations
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // UserModel operations
  static Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    
    // Also save individual fields for backward compatibility
    await saveUserId(user.id ?? 0);
    await saveRoleId(user.roleId);
    await saveUserName(user.name);
    await saveUserEmail(user.email);
  }

  static Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataStr = prefs.getString(_userDataKey);
    
    if (userDataStr != null) {
      try {
        final userData = jsonDecode(userDataStr);
        return UserModel.fromJson(userData);
      } catch (e) {
        print('❌ Error parsing user data: $e');
        return null;
      }
    }
    
    // Try to construct from individual fields if full model not found
    final id = await getUserId();
    final roleId = await getRoleId();
    final name = await getUserName();
    final email = await getUserEmail();
    
    if (id != null && roleId != null && name != null && email != null) {
      return UserModel(
        id: id,
        roleId: roleId,
        name: name,
        email: email,
      );
    }
    
    return null;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_roleIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_isLoggedInKey);
  }

  // Combined operations
  static Future<void> saveCompleteUserData({
    required UserModel user,
    required String token,
  }) async {
    await saveToken(token);
    await saveUserData(user);
    await saveLoginStatus(true);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final status = await getLoginStatus();
    return token != null && token.isNotEmpty && status;
  }

  // Clear all data
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}