import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/shift_viewmodel.dart';
import '../../../data/models/shift_model.dart';

class ShiftsAdminScreen extends StatefulWidget {
  const ShiftsAdminScreen({super.key});

  @override
  State<ShiftsAdminScreen> createState() => _ShiftsAdminScreenState();
}

class _ShiftsAdminScreenState extends State<ShiftsAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShiftViewModel>().fetchAll();
    });
  }

  Future<void> _openEditDialog({ShiftModel? model}) async {
    final nameController = TextEditingController(text: model?.name ?? '');
    final startController = TextEditingController(text: model?.startTime ?? '');
    final endController = TextEditingController(text: model?.endTime ?? '');
    final descController = TextEditingController(text: model?.description ?? '');
    final codeController = TextEditingController(text: model?.shiftCode ?? '');
    final shiftNameController = TextEditingController(text: model?.shiftName ?? '');
    final minutesController = TextEditingController(text: model?.workingMinutes.toString() ?? '0');
    final statusController = TextEditingController(text: model?.status ?? 'active');

    final isNew = model == null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Create Shift' : 'Edit Shift'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: startController, decoration: const InputDecoration(labelText: 'Start Time')),
              TextField(controller: endController, decoration: const InputDecoration(labelText: 'End Time')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Shift Code')),
              TextField(controller: shiftNameController, decoration: const InputDecoration(labelText: 'Shift Name')),
              TextField(controller: minutesController, decoration: const InputDecoration(labelText: 'Working Minutes'), keyboardType: TextInputType.number),
              TextField(controller: statusController, decoration: const InputDecoration(labelText: 'Status')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (result == true) {
      final shift = ShiftModel(
        id: model?.id,
        name: nameController.text,
        startTime: startController.text,
        endTime: endController.text,
        description: descController.text,
        shiftCode: codeController.text,
        shiftName: shiftNameController.text,
        workingMinutes: int.tryParse(minutesController.text) ?? 0,
        status: statusController.text,
      );

      final vm = context.read<ShiftViewModel>();
      bool ok;
      if (isNew) {
        ok = await vm.create(shift);
      } else {
        ok = await vm.update(shift.id!, shift);
      }

      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Operation failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shifts (Admin)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<ShiftViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.items.isEmpty) return const Center(child: Text('No shifts found'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final s = vm.items[index];
              return ListTile(
                title: Text(s.name),
                subtitle: Text('Time: ${s.startTime} - ${s.endTime} • ${s.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _openEditDialog(model: s)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this shift?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final ok = await vm.delete(s.id!);
                          if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Delete failed')));
                        }
                      },
                    ),
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
