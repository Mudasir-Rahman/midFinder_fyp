// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/user_entities.dart';
//
//
// abstract class AuthRepository {
//   Future<Either<Failure, UserEntity>> signUp({
//     required String email,
//     required String password,
//     required String role,
//   });
//
//   Future<Either<Failure, UserEntity>> login({
//     required String email,
//     required String password,
//   });
//
//   Future<Either<Failure, void>> logout();
//   Future<Either<Failure, UserEntity?>> getCurrentUser();
//   // Add this method to your AuthRepository
//   Future<Either<Failure, void>> resendVerificationEmail(String email);
// }
// features/auth/domain/repositories/auth_repository.dart
// features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, String>> verifyUserAuth(String userId);

}