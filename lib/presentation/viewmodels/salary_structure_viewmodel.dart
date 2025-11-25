import 'package:flutter/material.dart';
import '../../data/repositories/salary_structure_repository.dart';
import '../../data/models/salary_structure_model.dart';

class SalaryStructureViewModel extends ChangeNotifier {
  final SalaryStructureRepository _repository;

  SalaryStructureViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<SalaryStructureModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<SalaryStructureModel> get items => _items;

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

  Future<bool> create(SalaryStructureModel model) async {
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

  Future<bool> update(int id, SalaryStructureModel model) async {
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
