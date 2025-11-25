import '../../core/network/api_response.dart';
import '../data_sources/remote/quiz_history_remote_data_source.dart';
import '../models/quiz_history_model.dart';

class QuizHistoryRepository {
  final QuizHistoryRemoteDataSource _remoteDataSource;

  QuizHistoryRepository(this._remoteDataSource);

  Future<ApiResponse<List<QuizHistoryModel>>> getAll() async {
    return await _remoteDataSource.getAll();
  }

  Future<ApiResponse<QuizHistoryModel>> create(QuizHistoryModel model) async {
    return await _remoteDataSource.create(model);
  }

  Future<ApiResponse<List<QuizHistoryModel>>> getByUser(int userId) async {
    return await _remoteDataSource.getByUser(userId);
  }

  Future<ApiResponse<QuizHistoryModel>> getById(int id) async {
    return await _remoteDataSource.getById(id);
  }

  Future<ApiResponse<QuizHistoryModel>> update(int id, QuizHistoryModel model) async {
    return await _remoteDataSource.update(id, model);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    return await _remoteDataSource.delete(id);
  }
}
