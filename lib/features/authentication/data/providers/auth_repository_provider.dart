import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/features/authentication/domain/repositories/auth_repository.dart';
import 'package:famtask/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:famtask/features/authentication/data/datasources/auth_remote_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
 return AuthRepositoryImpl(AuthRemoteDataSourceImpl());

});
