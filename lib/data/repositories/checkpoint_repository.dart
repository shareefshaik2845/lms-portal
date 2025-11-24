import '../../core/network/api_response.dart';
import '../data_sources/remote/checkpoint_remote_data_source.dart';
import '../models/checkpoint_model.dart';

class CheckpointRepository {
  final CheckpointRemoteDataSource _remoteDataSource;

  CheckpointRepository(this._remoteDataSource);

  Future<ApiResponse<List<CheckpointModel>>> getCheckpoints() async {
    return await _remoteDataSource.getCheckpoints();
  }

  Future<ApiResponse<CheckpointModel>> getCheckpointById(int id) async {
    return await _remoteDataSource.getCheckpointById(id);
  }

  Future<ApiResponse<CheckpointModel>> createCheckpoint(CheckpointModel checkpoint) async {
    return await _remoteDataSource.createCheckpoint(checkpoint);
  }

  Future<ApiResponse<CheckpointModel>> updateCheckpoint(int id, CheckpointModel checkpoint) async {
    return await _remoteDataSource.updateCheckpoint(id, checkpoint);
  }

  Future<ApiResponse<bool>> deleteCheckpoint(int id) async {
    return await _remoteDataSource.deleteCheckpoint(id);
  }
}