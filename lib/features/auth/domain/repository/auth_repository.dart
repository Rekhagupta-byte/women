import 'package:fpdart/fpdart.dart';
import 'package:women/core/error/failures.dart';
import 'package:women/features/auth/domain/entity/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmialPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmialPassword({
    required String email,
    required String password,
  });
}
