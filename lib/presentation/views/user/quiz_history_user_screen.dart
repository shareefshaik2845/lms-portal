import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/quiz_history_viewmodel.dart';

class QuizHistoryUserScreen extends StatefulWidget {
  const QuizHistoryUserScreen({super.key});

  @override
  State<QuizHistoryUserScreen> createState() => _QuizHistoryUserScreenState();
}

class _QuizHistoryUserScreenState extends State<QuizHistoryUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizHistoryViewModel>().fetchForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quiz History'),
      ),
      body: Consumer<QuizHistoryViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          if (vm.items.isEmpty) return const Center(child: Text('You have no quiz history yet'));

          return RefreshIndicator(
            onRefresh: () async => await vm.fetchForCurrentUser(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.items.length,
              itemBuilder: (context, index) {
                final item = vm.items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.question),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Answer: ${item.answer}'),
                        Text('Result: ${item.result}'),
                        Text('Completed: ${item.completedAt ?? '-'}'),
                      ],
                    ),
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
