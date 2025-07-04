import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ĐỂ Ý THÊM IMPORT NÀY
import 'package:famtask/features/authentication/presentation/providers/auth_providers.dart';
import 'package:famtask/shared/presentation/widgets/indicators/progress_indicator.dart';
import 'package:famtask/routes/route_names.dart'; // để dùng RouteNames.householdSetup

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // CHUYỂN SANG context.go() thay vì Navigator.pushReplacement
    if (authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.householdSetup);
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: () async {
      await ref.read(authProvider.notifier).signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final updatedAuthState = ref.read(authProvider);
      if (updatedAuthState.user != null) {
        context.go(RouteNames.householdSetup);
      } else if (updatedAuthState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(updatedAuthState.errorMessage!)),
        );
      }
    },
    child: const Text('Sign In'),
  ),
),

              if (authState.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
