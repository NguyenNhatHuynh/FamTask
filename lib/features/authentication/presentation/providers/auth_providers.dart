import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:famtask/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:famtask/features/authentication/presentation/providers/auth_state.dart';
import 'package:famtask/features/authentication/domain/repositories/auth_repository.dart';
import 'package:famtask/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:famtask/features/authentication/data/providers/auth_repository_provider.dart';


final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  final signInUseCase = SignInUseCase(ref.read(authRepositoryProvider));
  final signUpUseCase = SignUpUseCase(ref.read(authRepositoryProvider));
  return AuthProvider(signInUseCase, signUpUseCase);
});

class AuthProvider extends StateNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthProvider(this._signInUseCase, this._signUpUseCase) : super(AuthState.initial());

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    final result = await _signInUseCase(email, password);
    state = result.user != null
        ? AuthState.authenticated(user: result.user!)
        : AuthState.error(errorMessage: result.errorMessage ?? 'Sign-in failed');
  }

  Future<void> signUp(String email, String password) async {
    state = AuthState.loading();
    final result = await _signUpUseCase(email, password);
    state = result.user != null
        ? AuthState.authenticated(user: result.user!)
        : AuthState.error(errorMessage: result.errorMessage ?? 'Sign-up failed');
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    // Implement Google Sign-In logic here
    state = AuthState.error(errorMessage: 'Google sign-in failed'); // Placeholder
  }
}