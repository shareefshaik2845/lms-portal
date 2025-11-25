import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/quiz_history_viewmodel.dart';
import '../../../data/models/quiz_history_model.dart';

class QuizHistoryAdminScreen extends StatefulWidget {
  const QuizHistoryAdminScreen({super.key});

  @override
  State<QuizHistoryAdminScreen> createState() => _QuizHistoryAdminScreenState();
}

class _QuizHistoryAdminScreenState extends State<QuizHistoryAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizHistoryViewModel>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History (Admin)'),
      ),
      body: Consumer<QuizHistoryViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          if (vm.items.isEmpty) {
            return const Center(child: Text('No quiz history available'));
          }

          return RefreshIndicator(
            onRefresh: () async => await vm.fetchAll(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: vm.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final QuizHistoryModel item = vm.items[index];
                return ListTile(
                  title: Text(item.question),
                  subtitle: Text('User: ${item.userId} • Course: ${item.courseId} • Result: ${item.result}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Delete this quiz history record?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final ok = await vm.delete(item.id!);
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Delete failed')));
                        }
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
