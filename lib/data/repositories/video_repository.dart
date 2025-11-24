import '../../core/network/api_response.dart';
import '../data_sources/remote/video_remote_data_source.dart';
import '../models/video_model.dart';

class VideoRepository {
  final VideoRemoteDataSource _remoteDataSource;

  VideoRepository(this._remoteDataSource);

  Future<ApiResponse<List<VideoModel>>> getVideos() async {
    return await _remoteDataSource.getVideos();
  }

  Future<ApiResponse<VideoModel>> getVideoById(int id) async {
    return await _remoteDataSource.getVideoById(id);
  }

  Future<ApiResponse<VideoModel>> createVideo(VideoModel video) async {
    return await _remoteDataSource.createVideo(video);
  }

  Future<ApiResponse<VideoModel>> updateVideo(int id, VideoModel video) async {
    return await _remoteDataSource.updateVideo(id, video);
  }

  Future<ApiResponse<bool>> deleteVideo(int id) async {
    return await _remoteDataSource.deleteVideo(id);
  }
}