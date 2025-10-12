import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/user_entities.dart';
import '../repository/auth_repository.dart';

class UserSignUp implements UseCase<UserEntity, UserSignUpParams> {
  final AuthRepository repository;

  UserSignUp(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserSignUpParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String role;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.role,
  });

}