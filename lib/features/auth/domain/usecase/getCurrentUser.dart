
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entities.dart';
import '../repository/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
