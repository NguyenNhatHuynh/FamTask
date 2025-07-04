import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/core/theme/app_text_styles.dart';
import 'package:famtask/shared/presentation/widgets/inputs/custom_text_field.dart';
import 'package:famtask/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:famtask/core/utils/validation_utils.dart';

class AuthForm extends ConsumerStatefulWidget {
  final bool isSignUp;
  final Function(String email, String password, String? displayName) onSubmit;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.onSubmit,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _emailController.text,
        _passwordController.text,
        widget.isSignUp ? _displayNameController.text : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (widget.isSignUp)
            CustomTextField(
              controller: _displayNameController,
              label: 'Tên hiển thị',
              validator: ValidationUtils.validateName,
            ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            label: 'Mật khẩu',
            obscureText: true,
            validator: ValidationUtils.validatePassword,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: widget.isSignUp ? 'Đăng ký' : 'Đăng nhập',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}