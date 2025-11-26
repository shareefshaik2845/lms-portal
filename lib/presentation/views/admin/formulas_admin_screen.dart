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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.functions, color: Colors.amber.shade700),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isNew ? 'Create Formula' : 'Edit Formula',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: codeController,
                        label: 'Component Code',
                        icon: Icons.code,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: nameController,
                        label: 'Component Name',
                        icon: Icons.title,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: exprController,
                        label: 'Formula Expression',
                        icon: Icons.functions,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          value: typeController.text.isEmpty ? 'earning' : typeController.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Formula Type',
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'earning',
                              child: Text('Earning'),
                            ),
                            DropdownMenuItem(
                              value: 'deduction',
                              child: Text('Deduction'),
                            ),
                          ],
                          onChanged: (value) {
                            typeController.text = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: salaryIdController,
                        label: 'Salary Structure ID',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: descController,
                        label: 'Description',
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle, size: 16, color: isActive ? Colors.green : Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  'Active Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: isActive,
                              onChanged: (v) {
                                setState(() {
                                  isActive = v;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red.shade300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isNew ? 'Create' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage ?? 'Operation failed'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Formula Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditDialog(),
        backgroundColor: Colors.amber.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
      body: Consumer<FormulaViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading Formulas...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (vm.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.functions_outlined,
                      size: 64,
                      color: Colors.amber.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No formulas found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new formula to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final f = vm.items[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.functions,
                        color: Colors.amber.shade700,
                        size: 24,
                      ),
                    ),
                  ),
                  title: Text(
                    f.componentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.code, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f.componentCode,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.functions, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f.formulaExpression,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: 'Monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: f.formulaType?.toLowerCase() == 'earning'
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              f.formulaType ?? 'Unknown',
                              style: TextStyle(
                                color: f.formulaType?.toLowerCase() == 'earning'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: f.isActive ?? false
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  f.isActive ?? false ? Icons.check_circle : Icons.cancel,
                                  size: 12,
                                  color: f.isActive ?? false
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  f.isActive ?? false ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: f.isActive ?? false
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Salary ID: ${f.salaryStructureId}',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue.shade600, size: 20),
                          onPressed: () => _openEditDialog(model: f),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.warning_amber_rounded,
                                          size: 32,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Confirm Delete',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Delete formula "${f.componentName}"?',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.grey.shade600,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Cancel'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade600,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Delete'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            if (confirm == true) {
                              final ok = await vm.delete(f.id!);
                              if (!ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(vm.errorMessage ?? 'Delete failed'),
                                    backgroundColor: Colors.red.shade600,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}