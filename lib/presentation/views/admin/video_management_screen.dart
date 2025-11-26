import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/video_viewmodel.dart';
import '../../viewmodels/course_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';

class VideoManagementScreen extends StatefulWidget {
  const VideoManagementScreen({super.key});

  @override
  State<VideoManagementScreen> createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final videoViewModel = context.read<VideoViewModel>();
    final courseViewModel = context.read<CourseViewModel>();
    
    await Future.wait([
      videoViewModel.fetchVideos(),
      courseViewModel.fetchCourses(),
    ]);

  // Check for session expiration by inspecting error messages
  if (mounted &&
    ((videoViewModel.errorMessage == 'Session expired. Please log in again.') ||
      (courseViewModel.errorMessage == 'Session expired. Please log in again.'))) {
    _handleSessionExpired();
  }
  }

  void _handleSessionExpired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text('Your session has expired. Please login again.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showAddVideoDialog() {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final durationController = TextEditingController();
    int? selectedCourseId;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Video'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Video Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'YouTube URL',
                    hintText: 'https://www.youtube.com/watch?v=...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (seconds)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Consumer<CourseViewModel>(
                  builder: (context, courseViewModel, child) {
                    if (courseViewModel.courses.isEmpty) {
                      return const Text(
                        'No courses available. Please create a course first.',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    return DropdownButtonFormField<int>(
                      value: selectedCourseId,
                      decoration: const InputDecoration(
                        labelText: 'Select Course',
                        border: OutlineInputBorder(),
                      ),
                      items: courseViewModel.courses
                          .map((course) => DropdownMenuItem(
                                value: course.id,
                                child: Text(
                                  course.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourseId = value;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    urlController.text.isEmpty ||
                    durationController.text.isEmpty ||
                    selectedCourseId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final success = await context.read<VideoViewModel>().createVideo(
                      title: titleController.text,
                      youtubeUrl: urlController.text,
                      duration: int.tryParse(durationController.text) ?? 0,
                      courseId: selectedCourseId!,
                    );

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Video added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    final viewModel = context.read<VideoViewModel>();
                    if (viewModel.errorMessage == 'Session expired. Please log in again.') {
                      _handleSessionExpired();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.errorMessage ?? 'Failed to add video'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCheckpointDialog(int videoId, String videoTitle) {
    final questionController = TextEditingController();
    final choicesController = TextEditingController();
    final correctAnswerController = TextEditingController();
    final timestampController = TextEditingController();
    bool isRequired = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.quiz, color: Colors.orange.shade700),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add Checkpoint for "$videoTitle"',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Video ID: $videoId',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: timestampController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Timestamp (seconds)',
                        hintText: 'e.g., 150 for 2 minutes 30 seconds',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        labelText: 'Question',
                        hintText: 'e.g., Dart is developed by which company?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.question_answer),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: choicesController,
                      decoration: const InputDecoration(
                        labelText: 'Choices (semicolon or comma separated)',
                        hintText: 'e.g., Facebook; Microsoft; Google; Oracle',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.list),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: correctAnswerController,
                      decoration: const InputDecoration(
                        labelText: 'Correct Answer',
                        hintText: 'Must exactly match one of the choices',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.check_circle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: CheckboxListTile(
                      title: const Text('Required'),
                      subtitle: const Text('User must answer to continue'),
                      value: isRequired,
                      onChanged: (value) {
                        setState(() {
                          isRequired = value ?? true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (questionController.text.isEmpty ||
                              choicesController.text.isEmpty ||
                              correctAnswerController.text.isEmpty ||
                              timestampController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final success = await context.read<VideoViewModel>().createCheckpoint(
                            videoId: videoId,
                            timestamp: int.tryParse(timestampController.text) ?? 0,
                            question: questionController.text,
                            choices: choicesController.text,
                            correctAnswer: correctAnswerController.text,
                            required: isRequired,
                          );

                          if (dialogContext.mounted) {
                            if (success) {
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Checkpoint added successfully'),
                                  backgroundColor: Colors.green.shade600,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            } else {
                              final viewModel = context.read<VideoViewModel>();
                              if (viewModel.errorMessage == 'Session expired. Please log in again.') {
                                Navigator.of(dialogContext).pop();
                                _handleSessionExpired();
                              } else {
                                // Show error but keep dialog open so user can fix
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.errorMessage ?? 'Failed to add checkpoint'),
                                    backgroundColor: Colors.red.shade600,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add Checkpoint'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Management'),
        actions: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    authViewModel.getUserName(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVideoDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Video'),
      ),
      body: Consumer<VideoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading videos...'),
                ],
              ),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No videos found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add a video',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.videos.length,
            itemBuilder: (context, index) {
              final video = viewModel.videos[index];
              final checkpoints = viewModel.getCheckpointsForVideo(video.id!);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_circle_outline,
                      size: 32,
                      color: Colors.purple,
                    ),
                  ),
                  title: Text(
                    video.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${video.duration} seconds'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${checkpoints.length} checkpoints'),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'add_checkpoint',
                        child: const Row(
                          children: [
                            Icon(Icons.add_task, size: 20),
                            SizedBox(width: 8),
                            Text('Add Checkpoint'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Video', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'add_checkpoint') {
                        _showAddCheckpointDialog(video.id!, video.title);
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text('Delete video "${video.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && mounted) {
                          // Implement delete functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Delete functionality coming soon'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  children: [
                    if (checkpoints.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No checkpoints for this video',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...checkpoints.map((checkpoint) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child: Text(
                              '${checkpoint.timestamp}s',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          title: Text(checkpoint.question),
                          subtitle: Text(
                            'Answer: ${checkpoint.correctAnswer}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Icon(
                            checkpoint.required
                                ? Icons.lock
                                : Icons.lock_open,
                            color: checkpoint.required
                                ? Colors.red
                                : Colors.green,
                            size: 20,
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}