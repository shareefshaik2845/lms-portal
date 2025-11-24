import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/course_viewmodel.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseViewModel>().fetchCourses();
    });
  }

  void _showAddCourseDialog() {
    final titleController = TextEditingController();
    final instructorController = TextEditingController();
    final priceController = TextEditingController();
    String selectedLevel = 'beginner';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Course Title'),
                ),
                TextField(
                  controller: instructorController,
                  decoration: const InputDecoration(labelText: 'Instructor'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: const InputDecoration(labelText: 'Level'),
                  items: const [
                    DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                    DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                    DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await context.read<CourseViewModel>().createCourse(
                      title: titleController.text,
                      instructor: instructorController.text,
                      level: selectedLevel,
                      price: double.tryParse(priceController.text) ?? 0,
                    );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Course created successfully')),
                    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add),
      ),
      body: Consumer<CourseViewModel>(
        builder: (context, viewModel, child) {
          print('🔍 Debug - isLoading: ${viewModel.isLoading}');
          print('🔍 Debug - courses count: ${viewModel.courses.length}');
          print('🔍 Debug - errorMessage: ${viewModel.errorMessage}');
          
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if there is one
          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<CourseViewModel>().fetchCourses(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No courses found'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<CourseViewModel>().fetchCourses(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.courses.length,
            itemBuilder: (context, index) {
              final course = viewModel.courses[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.book),
                  ),
                  title: Text(course.title),
                  subtitle: Text(
                    '${course.instructor} • ${course.level} • \${course.price}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (course.id != null) {
                        await context
                            .read<CourseViewModel>()
                            .deleteCourse(course.id!);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}