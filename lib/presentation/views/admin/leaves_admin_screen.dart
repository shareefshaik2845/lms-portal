import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/leave_viewmodel.dart';
import '../../../data/models/leave_model.dart';

class LeavesAdminScreen extends StatefulWidget {
  const LeavesAdminScreen({super.key});

  @override
  State<LeavesAdminScreen> createState() => _LeavesAdminScreenState();
}

class _LeavesAdminScreenState extends State<LeavesAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveViewModel>().fetchAll();
    });
  }

  Future<void> _openDialog({LeaveModel? model}) async {
    final nameController = TextEditingController(text: model?.name ?? '');
    final descController = TextEditingController(text: model?.description ?? '');
    final dateController = TextEditingController(text: model?.leaveDate ?? '');
    final userController = TextEditingController(text: model?.userId.toString() ?? '0');
    final yearController = TextEditingController(text: model?.year.toString() ?? '0');
    final allocatedController = TextEditingController(text: model?.allocated.toString() ?? '0');
    final usedController = TextEditingController(text: model?.used.toString() ?? '0');
    final balanceController = TextEditingController(text: model?.balance.toString() ?? '0');
    bool status = model?.status ?? true;
    bool carry = model?.carryForward ?? false;
    bool holiday = model?.holiday ?? false;

    final isNew = model == null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Create Leave' : 'Edit Leave'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Leave Date (YYYY-MM-DD)')),
              TextField(controller: userController, decoration: const InputDecoration(labelText: 'User ID'), keyboardType: TextInputType.number),
              TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Year'), keyboardType: TextInputType.number),
              TextField(controller: allocatedController, decoration: const InputDecoration(labelText: 'Allocated'), keyboardType: TextInputType.number),
              TextField(controller: usedController, decoration: const InputDecoration(labelText: 'Used'), keyboardType: TextInputType.number),
              TextField(controller: balanceController, decoration: const InputDecoration(labelText: 'Balance'), keyboardType: TextInputType.number),
              Row(children: [const Text('Active'), Switch(value: status, onChanged: (v) { status = v; })]),
              Row(children: [const Text('Carry Forward'), Switch(value: carry, onChanged: (v) { carry = v; })]),
              Row(children: [const Text('Holiday'), Switch(value: holiday, onChanged: (v) { holiday = v; })]),
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
      final leave = LeaveModel(
        id: model?.id,
        name: nameController.text,
        description: descController.text,
        status: status,
        leaveDate: dateController.text,
        userId: int.tryParse(userController.text) ?? 0,
        year: int.tryParse(yearController.text) ?? 0,
        allocated: int.tryParse(allocatedController.text) ?? 0,
        used: int.tryParse(usedController.text) ?? 0,
        balance: int.tryParse(balanceController.text) ?? 0,
        carryForward: carry,
        holiday: holiday,
      );

      final vm = context.read<LeaveViewModel>();
      bool ok;
      if (isNew) ok = await vm.create(leave);
      else ok = await vm.update(leave.id!, leave);

      if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Operation failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaves (Admin)')),
      floatingActionButton: FloatingActionButton(onPressed: () => _openDialog(), child: const Icon(Icons.add)),
      body: Consumer<LeaveViewModel>(builder: (context, vm, child) {
        if (vm.isLoading) return const Center(child: CircularProgressIndicator());
        if (vm.items.isEmpty) return const Center(child: Text('No leaves'));

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: vm.items.length,
          itemBuilder: (context, index) {
            final l = vm.items[index];
            return ListTile(
              title: Text(l.name),
              subtitle: Text('Date: ${l.leaveDate} • User: ${l.userId} • Balance: ${l.balance}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => _openDialog(model: l)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text('Delete this leave record?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final ok = await vm.delete(l.id!);
                      if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Delete failed')));
                    }
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
