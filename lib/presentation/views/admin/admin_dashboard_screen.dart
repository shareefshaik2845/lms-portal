import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';
import 'category_management_screen.dart';
import 'course_management_screen.dart';
import 'quiz_history_admin_screen.dart';
import 'progress_admin_screen.dart';
import 'shifts_admin_screen.dart';
import 'departments_admin_screen.dart';
import 'leaves_admin_screen.dart';
import 'salary_structures_admin_screen.dart';
import 'formulas_admin_screen.dart';
import 'payrolls_admin_screen.dart';
import 'user_management_screen.dart';
import 'video_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().loadUserData();
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<AuthViewModel>().logout();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Admin Dashboard'),
                Text(
                  authViewModel.getUserName(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              final authViewModel = context.read<AuthViewModel>();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Profile'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${authViewModel.getUserName()}'),
                      const SizedBox(height: 8),
                      Text('Email: ${authViewModel.getUserEmail()}'),
                      const SizedBox(height: 8),
                      Text('Role: ${authViewModel.isAdmin() ? 'Admin' : 'User'}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              title: 'User Management',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UserManagementScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Categories',
              icon: Icons.category,
              color: Colors.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CategoryManagementScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Courses',
              icon: Icons.book,
              color: Colors.orange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CourseManagementScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Videos',
              icon: Icons.video_library,
              color: Colors.purple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const VideoManagementScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Quiz History',
              icon: Icons.history_edu,
              color: Colors.teal,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const QuizHistoryAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Progress',
              icon: Icons.show_chart,
              color: Colors.indigo,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProgressAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Shifts',
              icon: Icons.schedule,
              color: Colors.brown,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ShiftsAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Departments',
              icon: Icons.apartment,
              color: Colors.cyan,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DepartmentsAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Leaves',
              icon: Icons.beach_access,
              color: Colors.lightGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LeavesAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Salary Structures',
              icon: Icons.attach_money,
              color: Colors.tealAccent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SalaryStructuresAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Formulas',
              icon: Icons.functions,
              color: Colors.deepPurple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FormulasAdminScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              title: 'Payrolls',
              icon: Icons.payments,
              color: Colors.greenAccent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PayrollsAdminScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}