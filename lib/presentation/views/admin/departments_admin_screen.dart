import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/department_viewmodel.dart';
import '../../../data/models/department_model.dart';

class DepartmentsAdminScreen extends StatefulWidget {
  const DepartmentsAdminScreen({super.key});

  @override
  State<DepartmentsAdminScreen> createState() => _DepartmentsAdminScreenState();
}

class _DepartmentsAdminScreenState extends State<DepartmentsAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentViewModel>().fetchAll();
    });
  }

  Future<void> _openDialog({DepartmentModel? model}) async {
    final nameController = TextEditingController(text: model?.name ?? '');
    final codeController = TextEditingController(text: model?.code ?? '');
    final descController = TextEditingController(text: model?.description ?? '');
    bool status = model?.status ?? true;

    final isNew = model == null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Create Department' : 'Edit Department'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Code')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              Row(
                children: [
                  const Text('Active'),
                  Switch(value: status, onChanged: (v) { status = v; }),
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
      final dept = DepartmentModel(
        id: model?.id,
        name: nameController.text,
        code: codeController.text,
        description: descController.text,
        status: status,
      );

      final vm = context.read<DepartmentViewModel>();
      bool ok;
      if (isNew) ok = await vm.create(dept);
      else ok = await vm.update(dept.id!, dept);

      if (!ok) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Operation failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments (Admin)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<DepartmentViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.items.isEmpty) return const Center(child: Text('No departments'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final d = vm.items[index];
              return ListTile(
                title: Text(d.name),
                subtitle: Text('${d.code} • ${d.description}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _openDialog(model: d)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Delete this department?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final ok = await vm.delete(d.id!);
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
