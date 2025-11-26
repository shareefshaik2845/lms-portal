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

  void _showProfileDialog(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_circle, size: 40, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ProfileInfoRow(
                icon: Icons.person,
                label: 'Name',
                value: authViewModel.getUserName(),
              ),
              const SizedBox(height: 16),
              _ProfileInfoRow(
                icon: Icons.email,
                label: 'Email',
                value: authViewModel.getUserEmail(),
              ),
              const SizedBox(height: 16),
              _ProfileInfoRow(
                icon: Icons.admin_panel_settings,
                label: 'Role',
                value: authViewModel.isAdmin() ? 'Admin' : 'User',
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Welcome, ${authViewModel.getUserName()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () => _showProfileDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Management Modules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage all aspects of your application',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _DashboardCard(
                    title: 'User Management',
                    icon: Icons.people_alt_rounded,
                    color: Colors.blue,
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[600]!],
                    ),
                    onTap: () => _navigateTo(context, const UserManagementScreen()),
                  ),
                  _DashboardCard(
                    title: 'Categories',
                    icon: Icons.category_rounded,
                    color: Colors.green,
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                    ),
                    onTap: () => _navigateTo(context, const CategoryManagementScreen()),
                  ),
                  _DashboardCard(
                    title: 'Courses',
                    icon: Icons.menu_book_rounded,
                    color: Colors.orange,
                    gradient: LinearGradient(
                      colors: [Colors.orange[400]!, Colors.orange[600]!],
                    ),
                    onTap: () => _navigateTo(context, const CourseManagementScreen()),
                  ),
                  _DashboardCard(
                    title: 'Videos',
                    icon: Icons.video_library_rounded,
                    color: Colors.purple,
                    gradient: LinearGradient(
                      colors: [Colors.purple[400]!, Colors.purple[600]!],
                    ),
                    onTap: () => _navigateTo(context, const VideoManagementScreen()),
                  ),
                  _DashboardCard(
                    title: 'Quiz History',
                    icon: Icons.quiz_rounded,
                    color: Colors.teal,
                    gradient: LinearGradient(
                      colors: [Colors.teal[400]!, Colors.teal[600]!],
                    ),
                    onTap: () => _navigateTo(context, const QuizHistoryAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Progress',
                    icon: Icons.analytics_rounded,
                    color: Colors.indigo,
                    gradient: LinearGradient(
                      colors: [Colors.indigo[400]!, Colors.indigo[600]!],
                    ),
                    onTap: () => _navigateTo(context, const ProgressAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Shifts',
                    icon: Icons.schedule_rounded,
                    color: Colors.brown,
                    gradient: LinearGradient(
                      colors: [Colors.brown[400]!, Colors.brown[600]!],
                    ),
                    onTap: () => _navigateTo(context, const ShiftsAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Departments',
                    icon: Icons.business_rounded,
                    color: Colors.cyan,
                    gradient: LinearGradient(
                      colors: [Colors.cyan[500]!, Colors.cyan[700]!],
                    ),
                    onTap: () => _navigateTo(context, const DepartmentsAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Leaves',
                    icon: Icons.beach_access_rounded,
                    color: Colors.lightGreen,
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen[400]!, Colors.lightGreen[600]!],
                    ),
                    onTap: () => _navigateTo(context, const LeavesAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Salary Structures',
                    icon: Icons.attach_money_rounded,
                    color: Colors.tealAccent,
                    gradient: LinearGradient(
                      colors: [Colors.teal[300]!, Colors.teal[500]!],
                    ),
                    onTap: () => _navigateTo(context, const SalaryStructuresAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Formulas',
                    icon: Icons.functions_rounded,
                    color: Colors.deepPurple,
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
                    ),
                    onTap: () => _navigateTo(context, const FormulasAdminScreen()),
                  ),
                  _DashboardCard(
                    title: 'Payrolls',
                    icon: Icons.payments_rounded,
                    color: Colors.greenAccent,
                    gradient: LinearGradient(
                      colors: [Colors.green[500]!, Colors.green[700]!],
                    ),
                    onTap: () => _navigateTo(context, const PayrollsAdminScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: gradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}