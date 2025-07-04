import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/features/authentication/presentation/providers/auth_provider.dart';
import 'package:famtask/shared/presentation/widgets/buttons/secondary_button.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SecondaryButton(
          text: 'Đăng nhập với Google',
          icon: const Icon(Icons.g_mobiledata),
          onPressed: () {
            ref.read(authProvider.notifier).signInWithGoogle();
          },
        ),
      ],
    );
  }
}