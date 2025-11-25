import 'package:flutter/material.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/repositories/checkpoint_repository.dart';
import '../../data/models/video_model.dart';
import '../../data/models/checkpoint_model.dart';

class VideoViewModel extends ChangeNotifier {
  final VideoRepository _videoRepository;
  final CheckpointRepository _checkpointRepository;

  VideoViewModel(this._videoRepository, this._checkpointRepository);

  bool _isLoading = false;
  String? _errorMessage;
  List<VideoModel> _videos = [];
  List<CheckpointModel> _checkpoints = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<VideoModel> get videos => _videos;
  List<CheckpointModel> get checkpoints => _checkpoints;

  Future<void> fetchVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _videoRepository.getVideos();

    _isLoading = false;

    // If the API returned 401, treat it as a session expiry so the UI can prompt re-login
    if (response.statusCode == 401) {
      _errorMessage = 'Session expired. Please log in again.';
    } else if (response.success && response.data != null) {
      _videos = response.data!;
    } else {
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<void> fetchVideosByCourse(int courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _videoRepository.getVideos();

    _isLoading = false;

    if (response.success && response.data != null) {
      // Filter videos by courseId
      _videos = response.data!.where((video) => video.courseId == courseId).toList();
    } else {
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<void> fetchCheckpoints() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _checkpointRepository.getCheckpoints();

    _isLoading = false;

    // Map 401 responses to a unified session-expired message
    if (response.statusCode == 401) {
      _errorMessage = 'Session expired. Please log in again.';
    } else if (response.success && response.data != null) {
      _checkpoints = response.data!;
    } else {
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  List<CheckpointModel> getCheckpointsForVideo(int videoId) {
    return _checkpoints.where((cp) => cp.videoId == videoId).toList();
  }

  Future<bool> createVideo({
    required String title,
    required String youtubeUrl,
    required int duration,
    required int courseId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final video = VideoModel(
      title: title,
      youtubeUrl: youtubeUrl,
      duration: duration,
      courseId: courseId,
    );
    final response = await _videoRepository.createVideo(video);

    _isLoading = false;

    if (response.success) {
      await fetchVideos();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createCheckpoint({
    required int videoId,
    required int timestamp,
    required String question,
    required String choices,
    required String correctAnswer,
    bool required = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final checkpoint = CheckpointModel(
      videoId: videoId,
      timestamp: timestamp,
      question: question,
      // Normalize choices: accept semicolons or commas, normalize to comma-separated
      choices: choices.replaceAll(';', ',').split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).join(', '),
      correctAnswer: correctAnswer,
      required: required,
    );
    final response = await _checkpointRepository.createCheckpoint(checkpoint);

    // Helpful debug prints for failing requests (will appear in console)
    print('🧾 CreateCheckpoint payload: ${checkpoint.toJson()}');
    print('🧾 CreateCheckpoint response: success=${response.success}, status=${response.statusCode}, message=${response.message}');

    _isLoading = false;

    // If token is invalid/expired, normalize message so UI can handle session expiry
    if (response.statusCode == 401) {
      _errorMessage = 'Session expired. Please log in again.';
      notifyListeners();
      return false;
    }

    if (response.success) {
      await fetchCheckpoints();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }
}