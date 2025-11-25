import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/formula_viewmodel.dart';
import '../../../data/models/formula_model.dart';

class FormulasAdminScreen extends StatefulWidget {
  const FormulasAdminScreen({super.key});

  @override
  State<FormulasAdminScreen> createState() => _FormulasAdminScreenState();
}

class _FormulasAdminScreenState extends State<FormulasAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FormulaViewModel>().fetchAll();
    });
  }

  Future<void> _openEditDialog({FormulaModel? model}) async {
    final codeController = TextEditingController(text: model?.componentCode ?? '');
    final nameController = TextEditingController(text: model?.componentName ?? '');
    final exprController = TextEditingController(text: model?.formulaExpression ?? '');
    final typeController = TextEditingController(text: model?.formulaType ?? 'earning');
    final descController = TextEditingController(text: model?.description ?? '');
    final salaryIdController = TextEditingController(text: model?.salaryStructureId.toString() ?? '0');
    bool isActive = model?.isActive ?? true;
    final isNew = model == null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Create Formula' : 'Edit Formula'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Component Code')),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Component Name')),
              TextField(controller: exprController, decoration: const InputDecoration(labelText: 'Expression')),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Type (earning/deduction)')),
              TextField(controller: salaryIdController, decoration: const InputDecoration(labelText: 'Salary Structure ID'), keyboardType: TextInputType.number),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              Row(children: [const Text('Active'), Switch(value: isActive, onChanged: (v) { setState(() { isActive = v; }); })]),
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
      final modelToSave = FormulaModel(
        id: model?.id,
        componentCode: codeController.text,
        componentName: nameController.text,
        formulaExpression: exprController.text,
        formulaType: typeController.text,
        isActive: isActive,
        description: descController.text,
        salaryStructureId: int.tryParse(salaryIdController.text) ?? 0,
      );

      final vm = context.read<FormulaViewModel>();
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
      appBar: AppBar(title: const Text('Formulas (Admin)')),
      floatingActionButton: FloatingActionButton(onPressed: () => _openEditDialog(), child: const Icon(Icons.add)),
      body: Consumer<FormulaViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.items.isEmpty) return const Center(child: Text('No formulas found'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final f = vm.items[index];
              return ListTile(
                title: Text('${f.componentName} (${f.componentCode})'),
                subtitle: Text('Type: ${f.formulaType} • SalaryStructure: ${f.salaryStructureId}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _openEditDialog(model: f)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Delete this formula?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final ok = await vm.delete(f.id!);
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
