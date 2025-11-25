import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/progress_viewmodel.dart';

class ProgressUserScreen extends StatefulWidget {
  const ProgressUserScreen({super.key});

  @override
  State<ProgressUserScreen> createState() => _ProgressUserScreenState();
}

class _ProgressUserScreenState extends State<ProgressUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressViewModel>().fetchForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: Consumer<ProgressViewModel>(builder: (context, vm, child) {
        if (vm.isLoading) return const Center(child: CircularProgressIndicator());
        if (vm.items.isEmpty) return const Center(child: Text('No progress yet'));

        return RefreshIndicator(
          onRefresh: () async => await vm.fetchForCurrentUser(),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = vm.items[index];
              return ListTile(
                title: Text('Course: ${item.courseId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Watched minutes: ${item.watchedMinutes}'),
                    Text('Progress: ${item.progressPercentage}%'),
                    Text('Updated: ${item.updatedAt ?? item.createdAt ?? '-'}'),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
