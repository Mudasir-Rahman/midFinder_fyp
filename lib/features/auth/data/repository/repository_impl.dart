import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entities.dart';

import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,

  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      print('Login failed: $e');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('Login failed: $e');
      return Left(ServerFailure('Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        email: email,
        password: password,
        role: role,
      );
      return Right(user);
    } on ServerException catch (e) {
      print('Sign up failed: $e');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('Sign up failed: $e');
      return Left(ServerFailure('Sign up failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      print('Logout failed: $e');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('Logout failed: $e');
      return Left(ServerFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      print('Get current user failed: $e');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('Get current user failed: $e');
      return Left(ServerFailure('Get current user failed: $e'));
    }
  }
}