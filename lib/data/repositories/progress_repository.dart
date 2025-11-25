import '../../core/network/api_response.dart';
import '../data_sources/remote/progress_remote_data_source.dart';
import '../models/progress_model.dart';

class ProgressRepository {
  final ProgressRemoteDataSource _remote;

  ProgressRepository(this._remote);

  Future<ApiResponse<ProgressModel>> watch(int id, {required int watchedMinutes, required int userId}) async {
    return await _remote.watch(id, watchedMinutes: watchedMinutes, userId: userId);
  }

  Future<ApiResponse<List<ProgressModel>>> getProgress({int? userId, int? courseId}) async {
    return await _remote.getProgress(userId: userId, courseId: courseId);
  }

  Future<ApiResponse<bool>> deleteForUser(int id, int userId) async {
    return await _remote.deleteForUser(id, userId);
  }
}
