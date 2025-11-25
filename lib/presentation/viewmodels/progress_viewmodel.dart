import 'package:flutter/material.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/models/progress_model.dart';
import '../../core/utils/shared_prefs.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository _repository;

  ProgressViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<ProgressModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProgressModel> get items => _items;

  Future<void> watch(int id, {required int watchedMinutes, required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.watch(id, watchedMinutes: watchedMinutes, userId: userId);

    _isLoading = false;
    if (response.success && response.data != null) {
      // refresh list for current user
      await fetchForCurrentUser();
    } else {
      _errorMessage = response.message;
    }
    notifyListeners();
  }

  Future<void> fetch({int? userId, int? courseId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getProgress(userId: userId, courseId: courseId);

    _isLoading = false;
    if (response.success && response.data != null) {
      _items = response.data!;
    } else {
      _errorMessage = response.message;
    }
    notifyListeners();
  }

  Future<void> fetchForCurrentUser() async {
    final userId = await SharedPrefs.getUserId();
    if (userId == null) {
      _errorMessage = 'No logged in user';
      notifyListeners();
      return;
    }
    await fetch(userId: userId);
  }

  Future<bool> deleteForUser(int id, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.deleteForUser(id, userId);

    _isLoading = false;
    if (response.success) {
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    }

    _errorMessage = response.message;
    notifyListeners();
    return false;
  }
}
