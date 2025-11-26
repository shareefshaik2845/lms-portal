import 'package:flutter/material.dart';
import '../../data/repositories/quiz_history_repository.dart';
import '../../data/models/quiz_history_model.dart';
import '../../core/utils/shared_prefs.dart';

class QuizHistoryViewModel extends ChangeNotifier {
  final QuizHistoryRepository _repository;

  QuizHistoryViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<QuizHistoryModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<QuizHistoryModel> get items => _items;

  Future<void> fetchAll() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getAll();

    _isLoading = false;
    if (response.success && response.data != null) {
      _items = response.data!;
    } else {
      _errorMessage = response.message;
    }
    notifyListeners();
  }

  Future<void> fetchForCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final userId = await SharedPrefs.getUserId();
    if (userId == null) {
      _isLoading = false;
      _errorMessage = 'No logged in user found';
      notifyListeners();
      return;
    }

    final response = await _repository.getByUser(userId);

    _isLoading = false;
    if (response.success && response.data != null) {
      _items = response.data!;
    } else {
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<bool> create(QuizHistoryModel model) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.create(model);

    _isLoading = false;
    if (response.success) {
      await fetchAll();
      return true;
    }

    _errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<bool> delete(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.delete(id);

    _isLoading = false;
    if (response.success) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
      return true;
    }

    _errorMessage = response.message;
    notifyListeners();
    return false;
  }
}
