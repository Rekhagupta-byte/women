import 'package:fpdart/fpdart.dart';
import 'package:women/core/error/failures.dart';
import 'package:women/core/usecase/usecase.dart';
import 'package:women/features/auth/domain/entity/user.dart';
import 'package:women/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmialPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String name;
  final String password;

  UserSignUpParams(
      {required this.email, required this.name, required this.password});
}
