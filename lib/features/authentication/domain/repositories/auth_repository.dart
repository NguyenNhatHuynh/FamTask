import 'package:famtask/features/authentication/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> signIn(String email, String password);
  Future<AuthResult> signUp(String email, String password);
  Future<AuthResult> signInWithGoogle();
}