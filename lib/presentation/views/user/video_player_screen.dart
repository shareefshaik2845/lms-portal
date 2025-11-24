import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../viewmodels/video_viewmodel.dart';
import '../../../data/models/checkpoint_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const VideoPlayerScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  int _currentVideoIndex = 0;
  CheckpointModel? _currentCheckpoint;
  bool _isCheckpointActive = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<VideoViewModel>();
      viewModel.fetchVideosByCourse(widget.courseId);
      viewModel.fetchCheckpoints();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(_onPlayerStateChanged);
    }
  }

  void _onPlayerStateChanged() {
    if (_controller == null || _isCheckpointActive) return;

    final position = _controller!.value.position.inSeconds;
    final viewModel = context.read<VideoViewModel>();
    final videos = viewModel.videos;

    if (_currentVideoIndex < videos.length) {
      final currentVideo = videos[_currentVideoIndex];
      final checkpoints = viewModel.getCheckpointsForVideo(currentVideo.id!);

      for (final checkpoint in checkpoints) {
        if (position >= checkpoint.timestamp &&
            position < checkpoint.timestamp + 2) {
          _showCheckpoint(checkpoint);
          break;
        }
      }
    }
  }

  void _showCheckpoint(CheckpointModel checkpoint) {
    setState(() {
      _isCheckpointActive = true;
      _currentCheckpoint = checkpoint;
      _selectedAnswer = null;
    });
    _controller?.pause();
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }

    final isCorrect = _selectedAnswer == _currentCheckpoint!.correctAnswer;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
        content: Text(
          isCorrect
              ? 'Great job! Continue watching.'
              : 'The correct answer is: ${_currentCheckpoint!.correctAnswer}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isCheckpointActive = false;
                _currentCheckpoint = null;
              });
              _controller?.play();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
      ),
      body: Consumer<VideoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = viewModel.videos;
          if (videos.isEmpty) {
            return const Center(child: Text('No videos available'));
          }

          if (_controller == null) {
            final currentVideo = videos[_currentVideoIndex];
            _initializePlayer(currentVideo.youtubeUrl);
          }

          return Column(
            children: [
              if (_controller != null)
                YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                ),
              if (_isCheckpointActive && _currentCheckpoint != null)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Checkpoint Question',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentCheckpoint!.question,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 24),
                        ...(_currentCheckpoint!.getChoicesList().map(
                          (choice) => RadioListTile<String>(
                            title: Text(choice),
                            value: choice,
                            groupValue: _selectedAnswer,
                            onChanged: (value) {
                              setState(() {
                                _selectedAnswer = value;
                              });
                            },
                          ),
                        )),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitAnswer,
                          child: const Text('Submit Answer'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  }