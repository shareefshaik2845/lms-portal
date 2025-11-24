import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/video_model.dart';

class VideoRemoteDataSource {
  final ApiClient _apiClient;

  VideoRemoteDataSource(this._apiClient);

  Future<ApiResponse<List<VideoModel>>> getVideos() async {
    final response = await _apiClient.get(
      ApiConstants.videos,
      requiresAuth: true,  // ✅ Changed to true - requires token
    );

    if (response.success) {
      final List<dynamic> data = response.data;
      final videos = data.map((json) => VideoModel.fromJson(json)).toList();
      return ApiResponse.success(videos);
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch videos');
  }

  Future<ApiResponse<VideoModel>> getVideoById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.videos}$id',
      requiresAuth: true,  // ✅ Changed to true - requires token
    );

    if (response.success) {
      return ApiResponse.success(VideoModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to fetch video');
  }

  Future<ApiResponse<VideoModel>> createVideo(VideoModel video) async {
    final response = await _apiClient.post(
      ApiConstants.videos,
      body: video.toJson(),
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      return ApiResponse.success(VideoModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to create video');
  }

  Future<ApiResponse<VideoModel>> updateVideo(int id, VideoModel video) async {
    final response = await _apiClient.put(
      '${ApiConstants.videos}$id',
      body: video.toJson(),
      requiresAuth: true,  // ✅ Already true
    );

    if (response.success) {
      return ApiResponse.success(VideoModel.fromJson(response.data));
    }

    return ApiResponse.error(response.message ?? 'Failed to update video');
  }

  Future<ApiResponse<bool>> deleteVideo(int id) async {
    return await _apiClient.delete(
      '${ApiConstants.videos}$id',
      requiresAuth: true,  // ✅ Already true
    );
  }
}