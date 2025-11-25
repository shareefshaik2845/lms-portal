import 'package:flutter/material.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/models/shift_model.dart';

class ShiftViewModel extends ChangeNotifier {
  final ShiftRepository _repository;

  ShiftViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<ShiftModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ShiftModel> get items => _items;

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

  Future<bool> create(ShiftModel model) async {
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

  Future<bool> update(int id, ShiftModel model) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.update(id, model);

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
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    }

    _errorMessage = response.message;
    notifyListeners();
    return false;
  }
}
