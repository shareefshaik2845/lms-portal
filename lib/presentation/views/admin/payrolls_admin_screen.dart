import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/payroll_viewmodel.dart';
import '../../../data/models/payroll_model.dart';

class PayrollsAdminScreen extends StatefulWidget {
  const PayrollsAdminScreen({super.key});

  @override
  State<PayrollsAdminScreen> createState() => _PayrollsAdminScreenState();
}

class _PayrollsAdminScreenState extends State<PayrollsAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PayrollViewModel>().fetchAll();
    });
  }

  Future<void> _openCreateDialog() async {
    final userIdCtrl = TextEditingController(text: '0');
    final salaryIdCtrl = TextEditingController(text: '0');
    final monthCtrl = TextEditingController(text: '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Payroll'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: userIdCtrl, decoration: const InputDecoration(labelText: 'User ID'), keyboardType: TextInputType.number),
              TextField(controller: salaryIdCtrl, decoration: const InputDecoration(labelText: 'Salary Structure ID'), keyboardType: TextInputType.number),
              TextField(controller: monthCtrl, decoration: const InputDecoration(labelText: 'Month (YYYY-MM)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
        ],
      ),
    );

    if (result == true) {
      final model = PayrollModel(
        userId: int.tryParse(userIdCtrl.text) ?? 0,
        salaryStructureId: int.tryParse(salaryIdCtrl.text) ?? 0,
        month: monthCtrl.text,
        basicSalary: 0,
        allowances: 0,
        deductions: 0,
        bonus: 0,
        grossSalary: 0,
        netSalary: 0,
      );

      final vm = context.read<PayrollViewModel>();
      final ok = await vm.create(model);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Create failed')));
    }
  }

  Future<void> _openEditDialog(PayrollModel p) async {
    final statusCtrl = TextEditingController(text: p.status ?? 'pending');
    bool recalc = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Payroll Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: statusCtrl, decoration: const InputDecoration(labelText: 'Status')),
            Row(children: [const Text('Recalculate'), Switch(value: recalc, onChanged: (v) { setState(() { recalc = v; }); })]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (result == true) {
      final vm = context.read<PayrollViewModel>();
      final ok = await vm.updateStatus(p.id!, statusCtrl.text, recalculate: recalc);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Update failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payrolls (Admin)')),
      floatingActionButton: FloatingActionButton(onPressed: _openCreateDialog, child: const Icon(Icons.add)),
      body: Consumer<PayrollViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.items.isEmpty) return const Center(child: Text('No payrolls found'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final p = vm.items[index];
              return ListTile(
                title: Text('${p.userName ?? 'User ${p.userId}'} — ${p.month}'),
                subtitle: Text('Net: ${p.netSalary} • Status: ${p.status ?? '-'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _openEditDialog(p)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Delete this payroll?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final ok = await vm.delete(p.id!);
                        if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Delete failed')));
                      }
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
