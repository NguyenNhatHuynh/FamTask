import 'package:famtask/core/errors/exceptions.dart';
import 'package:famtask/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:famtask/features/authentication/domain/entities/auth_result.dart';
import 'package:famtask/features/authentication/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<AuthResult> signIn(String email, String password) async {
    try {
      await dataSource.signIn(email, password);
      return AuthResult(user: FirebaseAuth.instance.currentUser);
    } on AuthException catch (e) {
      return AuthResult(errorMessage: e.message);
    }
  }

  @override
  Future<AuthResult> signUp(String email, String password) async {
    try {
      await dataSource.signUp(email, password);
      return AuthResult(user: FirebaseAuth.instance.currentUser);
    } on AuthException catch (e) {
      return AuthResult(errorMessage: e.message);
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      await dataSource.signInWithGoogle();
      return AuthResult(user: FirebaseAuth.instance.currentUser);
    } on AuthException catch (e) {
      return AuthResult(errorMessage: e.message);
    }
  }
}