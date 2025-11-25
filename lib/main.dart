import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/remote/quiz_history_remote_data_source.dart';
import 'data/repositories/quiz_history_repository.dart';
import 'data/data_sources/remote/progress_remote_data_source.dart';
import 'data/repositories/progress_repository.dart';
import 'data/data_sources/remote/shift_remote_data_source.dart';
import 'data/repositories/shift_repository.dart';
import 'data/data_sources/remote/department_remote_data_source.dart';
import 'data/repositories/department_repository.dart';
import 'data/data_sources/remote/leave_remote_data_source.dart';
import 'data/repositories/leave_repository.dart';
import 'data/data_sources/remote/salary_structure_remote_data_source.dart';
import 'data/repositories/salary_structure_repository.dart';
import 'data/data_sources/remote/formula_remote_data_source.dart';
import 'data/repositories/formula_repository.dart';
import 'presentation/viewmodels/formula_viewmodel.dart';
import 'data/data_sources/remote/payroll_remote_data_source.dart';
import 'data/repositories/payroll_repository.dart';
import 'presentation/viewmodels/payroll_viewmodel.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/category_viewmodel.dart';
import 'presentation/viewmodels/course_viewmodel.dart';
import 'presentation/viewmodels/quiz_history_viewmodel.dart';
import 'presentation/viewmodels/progress_viewmodel.dart';
import 'presentation/viewmodels/shift_viewmodel.dart';
import 'presentation/viewmodels/department_viewmodel.dart';
import 'presentation/viewmodels/leave_viewmodel.dart';
import 'presentation/viewmodels/salary_structure_viewmodel.dart';
import 'presentation/viewmodels/user_viewmodel.dart';
import 'presentation/viewmodels/video_viewmodel.dart';
import 'presentation/views/auth/login_screen.dart';
import 'presentation/views/admin/admin_dashboard_screen.dart';
import 'presentation/views/user/user_dashboard_screen.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/course_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/video_repository.dart';
import 'data/repositories/checkpoint_repository.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/data_sources/remote/category_remote_data_source.dart';
import 'data/data_sources/remote/course_remote_data_source.dart';
import 'data/data_sources/remote/user_remote_data_source.dart';
import 'data/data_sources/remote/video_remote_data_source.dart';
import 'data/data_sources/remote/checkpoint_remote_data_source.dart';
import 'core/network/api_client.dart';
import 'core/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use SharedPrefs to determine initial start screen
  final isLoggedIn = await SharedPrefs.isLoggedIn();

  // If logged in, keep SplashScreen as initial to load user data into AuthViewModel
  final initialHome = isLoggedIn ? const SplashScreen() : const LoginScreen();

  runApp(MyApp(initialHome: initialHome));
}

class MyApp extends StatelessWidget {
  final Widget initialHome;

  const MyApp({super.key, required this.initialHome});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            AuthRepository(AuthRemoteDataSource(apiClient)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(
            UserRepository(UserRemoteDataSource(apiClient)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryViewModel(
            CategoryRepository(CategoryRemoteDataSource(apiClient)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CourseViewModel(
            CourseRepository(CourseRemoteDataSource(apiClient)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoViewModel(
            VideoRepository(VideoRemoteDataSource(apiClient)),
            CheckpointRepository(CheckpointRemoteDataSource(apiClient)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizHistoryViewModel(
            QuizHistoryRepository(
              QuizHistoryRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressViewModel(
            ProgressRepository(
              ProgressRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ShiftViewModel(
            ShiftRepository(
              ShiftRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DepartmentViewModel(
            DepartmentRepository(
              DepartmentRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaveViewModel(
            LeaveRepository(
              LeaveRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SalaryStructureViewModel(
            SalaryStructureRepository(
              SalaryStructureRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FormulaViewModel(
            FormulaRepository(
              FormulaRemoteDataSource(apiClient),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PayrollViewModel(
            PayrollRepository(
              PayrollRemoteDataSource(apiClient),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'LMS App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: initialHome,
      ),
    );
  }
}

// Splash Screen to check login status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds

    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();
    final isLoggedIn = await authViewModel.checkLoginStatus();

    if (isLoggedIn) {
      // Load user data
      await authViewModel.loadUserData();
      
      final roleId = await authViewModel.getUserRole();

      if (mounted) {
        if (roleId == 1) {
          // Admin
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else {
          // User
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'LMS System',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}