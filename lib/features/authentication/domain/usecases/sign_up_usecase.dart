import 'package:famtask/features/authentication/domain/repositories/auth_repository.dart';
import 'package:famtask/features/authentication/domain/entities/auth_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<AuthResult> call(String email, String password) async {
    try {
      await repository.signUp(email, password);
      return AuthResult(user: FirebaseAuth.instance.currentUser);
    } catch (e) {
      return AuthResult(errorMessage: e.toString());
    }
  }
}