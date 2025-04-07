import 'package:fpdart/fpdart.dart';
import 'package:women/core/error/failures.dart';
import 'package:women/core/usecase/usecase.dart';
import 'package:women/features/auth/domain/entity/user.dart';
import 'package:women/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmialPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
