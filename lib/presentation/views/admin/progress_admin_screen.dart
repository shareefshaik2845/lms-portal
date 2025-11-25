import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/progress_viewmodel.dart';

class ProgressAdminScreen extends StatefulWidget {
  const ProgressAdminScreen({super.key});

  @override
  State<ProgressAdminScreen> createState() => _ProgressAdminScreenState();
}

class _ProgressAdminScreenState extends State<ProgressAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressViewModel>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress (Admin)')),
      body: Consumer<ProgressViewModel>(builder: (context, vm, child) {
        if (vm.isLoading) return const Center(child: CircularProgressIndicator());
        if (vm.items.isEmpty) return const Center(child: Text('No progress records'));

        return RefreshIndicator(
          onRefresh: () async => await vm.fetch(),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = vm.items[index];
              return ListTile(
                title: Text('User: ${item.userId} • Course: ${item.courseId}'),
                subtitle: Text('Watched: ${item.watchedMinutes}m • ${item.progressPercentage}%'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text('Delete this progress record?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final ok = await vm.deleteForUser(item.id!, item.userId);
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
      }),
    );
  }
}
