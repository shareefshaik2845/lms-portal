import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository;

  UserViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<UserModel> _users = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UserModel> get users => _users;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getUsers();

    _isLoading = false;

    if (response.success && response.data != null) {
      _users = response.data!;
    } else {
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required int roleId,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = UserModel(name: name, email: email, roleId: roleId);
    final response = await _repository.createUser(user, password);

    _isLoading = false;

    if (response.success) {
      await fetchUsers();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.deleteUser(id);

    _isLoading = false;

    if (response.success) {
      await fetchUsers();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }
}