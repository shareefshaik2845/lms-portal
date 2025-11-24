import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';
import '../../core/utils/shared_prefs.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isSessionExpired = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get isSessionExpired => _isSessionExpired;

  void resetSessionExpired() {
    _isSessionExpired = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    _isSessionExpired = false;
    notifyListeners();

    // Check if token exists
    final token = await SharedPrefs.getToken();
    if (token == null || token.isEmpty) {
      _isLoading = false;
      _errorMessage = 'Please login again';
      _isSessionExpired = true;
      notifyListeners();
      return;
    }

    final response = await _repository.getCategories();

    _isLoading = false;

    if (response.success && response.data != null) {
      _categories = response.data!;
    } else {
      _errorMessage = response.message;
      
      // Check for session expiration (401 error)
      if (response.statusCode == 401) {
        _isSessionExpired = true;
        // clear stored token to force re-login since SharedPrefs.clearAuthData() doesn't exist
        await SharedPrefs.saveToken('');
      }
    }

    notifyListeners();
  }

  Future<void> fetchCategoryById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _isSessionExpired = false;
    notifyListeners();

    final response = await _repository.getCategoryById(id);

    _isLoading = false;

    if (response.success && response.data != null) {
      _selectedCategory = response.data;
    } else {
      _errorMessage = response.message;
      
      if (response.statusCode == 401) {
        _isSessionExpired = true;
        await SharedPrefs.saveToken('');
      }
    }

    notifyListeners();
  }

  Future<bool> createCategory({
    required String name,
    required String description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSessionExpired = false;
    notifyListeners();

    final category = CategoryModel(name: name, description: description);
    final response = await _repository.createCategory(category);

    _isLoading = false;

    if (response.success) {
      await fetchCategories();
      return true;
    } else {
      _errorMessage = response.message;
      
      if (response.statusCode == 401) {
        _isSessionExpired = true;
        // clear stored token to force re-login
        await SharedPrefs.saveToken('');
      }
      
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSessionExpired = false;
    notifyListeners();

    final category = CategoryModel(id: id, name: name, description: description);
    final response = await _repository.updateCategory(id, category);

    _isLoading = false;

    if (response.success) {
      await fetchCategories();
      return true;
    } else {
      _errorMessage = response.message;
      
      if (response.statusCode == 401) {
        _isSessionExpired = true;
        // clear stored token to force re-login
        await SharedPrefs.saveToken('');
      }
      
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _isSessionExpired = false;
    notifyListeners();

    final response = await _repository.deleteCategory(id);

    _isLoading = false;

    if (response.success) {
      await fetchCategories();
      return true;
    } else {
      _errorMessage = response.message;
      
      if (response.statusCode == 401) {
        _isSessionExpired = true;
        // clear stored token to force re-login
        await SharedPrefs.saveToken('');
      }
      
      notifyListeners();
      return false;
    }
  }
}