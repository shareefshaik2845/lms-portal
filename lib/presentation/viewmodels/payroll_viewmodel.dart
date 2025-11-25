import 'package:flutter/material.dart';
import '../../data/repositories/payroll_repository.dart';
import '../../data/models/payroll_model.dart';

class PayrollViewModel extends ChangeNotifier {
  final PayrollRepository _repository;

  PayrollViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<PayrollModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PayrollModel> get items => _items;

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

  Future<bool> create(PayrollModel model) async {
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

  Future<bool> updateStatus(int id, String status, {bool recalculate = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final body = {'status': status, 'recalculate': recalculate};
    final response = await _repository.update(id, body);

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
