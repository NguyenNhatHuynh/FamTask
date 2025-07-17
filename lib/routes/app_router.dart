import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:famtask/features/authentication/presentation/providers/auth_providers.dart';
import 'package:famtask/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:famtask/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:famtask/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:famtask/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:famtask/routes/route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.signIn,
    routes: [
      GoRoute(
        path: RouteNames.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => DashboardScreen(location: state.uri.toString()),
      ),
      GoRoute(
        path: RouteNames.addTask,
        builder: (context, state) => const AddTaskScreen(),
      ),
    ],
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.user != null;

      if (!isAuthenticated && state.uri.toString() != RouteNames.signIn && state.uri.toString() != RouteNames.signUp) {
        return RouteNames.signIn;
      }
      return null;
    },
  );
});