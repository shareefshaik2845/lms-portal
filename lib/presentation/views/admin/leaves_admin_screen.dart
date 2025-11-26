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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.beach_access, color: Colors.teal.shade700),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isNew ? 'Create Leave' : 'Edit Leave',
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
                        controller: nameController,
                        label: 'Leave Name',
                        icon: Icons.badge,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: descController,
                        label: 'Description',
                        icon: Icons.description,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: dateController,
                        label: 'Leave Date (YYYY-MM-DD)',
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: userController,
                        label: 'User ID',
                        icon: Icons.person,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: yearController,
                        label: 'Year',
                        icon: Icons.date_range,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: allocatedController,
                              label: 'Allocated Days',
                              icon: Icons.add_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              controller: usedController,
                              label: 'Used Days',
                              icon: Icons.remove_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: balanceController,
                        label: 'Balance Days',
                        icon: Icons.account_balance_wallet,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchRow(
                        value: status,
                        onChanged: (v) => setState(() => status = v),
                        label: 'Active Status',
                        icon: Icons.toggle_on,
                      ),
                      const SizedBox(height: 8),
                      _buildSwitchRow(
                        value: carry,
                        onChanged: (v) => setState(() => carry = v),
                        label: 'Carry Forward',
                        icon: Icons.forward,
                      ),
                      const SizedBox(height: 8),
                      _buildSwitchRow(
                        value: holiday,
                        onChanged: (v) => setState(() => holiday = v),
                        label: 'Holiday',
                        icon: Icons.celebration,
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
                      backgroundColor: Colors.teal.shade600,
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
      if (isNew) {
        ok = await vm.create(leave);
      } else {
        ok = await vm.update(leave.id!, leave);
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

  Widget _buildSwitchRow({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
    required IconData icon,
  }) {
    return Container(
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
              Icon(icon, size: 20, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal,
            inactiveThumbColor: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Leave Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
      body: Consumer<LeaveViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading Leaves...',
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
                      color: Colors.teal.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.beach_access_outlined,
                      size: 64,
                      color: Colors.teal.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No leave records found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new leave record to get started',
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
              final l = vm.items[index];
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        l.holiday ? Icons.celebration : Icons.beach_access,
                        color: Colors.teal.shade700,
                        size: 24,
                      ),
                    ),
                  ),
                  title: Text(
                    l.name,
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
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              l.leaveDate,
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
                          Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'User ID: ${l.userId}',
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
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildStatusChip(
                            label: 'Balance: ${l.balance}',
                            color: l.balance > 0 ? Colors.green : Colors.red,
                          ),
                          _buildStatusChip(
                            label: l.status ? 'Active' : 'Inactive',
                            color: l.status ? Colors.green : Colors.red,
                          ),
                          if (l.carryForward)
                            _buildStatusChip(
                              label: 'Carry Forward',
                              color: Colors.orange,
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
                          onPressed: () => _openDialog(model: l),
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
                                        'Delete leave record "${l.name}"?',
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
                              final ok = await vm.delete(l.id!);
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

  Widget _buildStatusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}