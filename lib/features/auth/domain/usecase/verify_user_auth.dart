import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repository/auth_repository.dart';


class VerifyUserAuth {
  final AuthRepository repository;

  VerifyUserAuth(this.repository);

  Future<Either<Failure, String>> call(String userId) async {
    return await repository.verifyUserAuth(userId);
  }
}