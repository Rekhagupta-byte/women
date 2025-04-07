import 'package:fpdart/fpdart.dart';
import 'package:women/core/error/exceptions.dart';
import 'package:women/core/error/failures.dart';
import 'package:women/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:women/features/auth/domain/entity/user.dart';
import 'package:women/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmialPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmialPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
