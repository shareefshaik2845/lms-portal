import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/salary_structure_viewmodel.dart';
import '../../../data/models/salary_structure_model.dart';

class SalaryStructuresAdminScreen extends StatefulWidget {
  const SalaryStructuresAdminScreen({super.key});

  @override
  State<SalaryStructuresAdminScreen> createState() => _SalaryStructuresAdminScreenState();
}

class _SalaryStructuresAdminScreenState extends State<SalaryStructuresAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalaryStructureViewModel>().fetchAll();
    });
  }

  Future<void> _openEditDialog({SalaryStructureModel? model}) async {
    final userIdController = TextEditingController(text: model?.userId.toString() ?? '0');
    final basicController = TextEditingController(text: model?.basicSalaryAnnual.toString() ?? '0');
    final allowancesController = TextEditingController(text: model?.allowancesAnnual.toString() ?? '0');
    final deductionsController = TextEditingController(text: model?.deductionsAnnual.toString() ?? '0');
    final bonusController = TextEditingController(text: model?.bonusAnnual.toString() ?? '0');
    final fromController = TextEditingController(text: model?.effectiveFrom ?? '');
    final toController = TextEditingController(text: model?.effectiveTo ?? '');
    bool isActive = model?.isActive ?? true;

    final isNew = model == null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Create Salary Structure' : 'Edit Salary Structure'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: userIdController, decoration: const InputDecoration(labelText: 'User ID'), keyboardType: TextInputType.number),
              TextField(controller: basicController, decoration: const InputDecoration(labelText: 'Basic Salary (annual)'), keyboardType: TextInputType.number),
              TextField(controller: allowancesController, decoration: const InputDecoration(labelText: 'Allowances (annual)'), keyboardType: TextInputType.number),
              TextField(controller: deductionsController, decoration: const InputDecoration(labelText: 'Deductions (annual)'), keyboardType: TextInputType.number),
              TextField(controller: bonusController, decoration: const InputDecoration(labelText: 'Bonus (annual)'), keyboardType: TextInputType.number),
              TextField(controller: fromController, decoration: const InputDecoration(labelText: 'Effective From (YYYY-MM-DD)')),
              TextField(controller: toController, decoration: const InputDecoration(labelText: 'Effective To (YYYY-MM-DD)')),
              Row(
                children: [
                  const Text('Active'),
                  Switch(value: isActive, onChanged: (v) { setState(() { isActive = v; }); }),
                ],
              ),
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
      final modelToSave = SalaryStructureModel(
        id: model?.id,
        userId: int.tryParse(userIdController.text) ?? 0,
        basicSalaryAnnual: num.tryParse(basicController.text) ?? 0,
        allowancesAnnual: num.tryParse(allowancesController.text) ?? 0,
        deductionsAnnual: num.tryParse(deductionsController.text) ?? 0,
        bonusAnnual: num.tryParse(bonusController.text) ?? 0,
        effectiveFrom: fromController.text,
        effectiveTo: toController.text,
        isActive: isActive,
        totalAnnual: (num.tryParse(basicController.text) ?? 0) + (num.tryParse(allowancesController.text) ?? 0) - (num.tryParse(deductionsController.text) ?? 0) + (num.tryParse(bonusController.text) ?? 0),
      );

      final vm = context.read<SalaryStructureViewModel>();
      bool ok;
      if (isNew) {
        ok = await vm.create(modelToSave);
      } else {
        ok = await vm.update(modelToSave.id!, modelToSave);
      }

      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Operation failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Structures (Admin)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<SalaryStructureViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.items.isEmpty) return const Center(child: Text('No salary structures found'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final s = vm.items[index];
              return ListTile(
                title: Text('User: ${s.userId} — Total: ${s.totalAnnual}'),
                subtitle: Text('From: ${s.effectiveFrom} To: ${s.effectiveTo} • Active: ${s.isActive}'),
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
                            content: const Text('Delete this salary structure?'),
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
