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

  // NEW METHOD: Verify User Authentication
  @override
  Future<Either<Failure, String>> verifyUserAuth(String userId) async {
    try {
      print('🔐 VERIFYING USER AUTH: $userId');

      // Use your existing remote data source to verify the user
      final currentUser = await remoteDataSource.getCurrentUser();

      if (currentUser == null) {
        print('❌ NO CURRENT USER FOUND');
        return Left(ServerFailure('No authenticated user found'));
      }

      if (currentUser.id != userId) {
        print('❌ USER ID MISMATCH: Expected $userId, Got ${currentUser.id}');
        return Left(ServerFailure('User ID mismatch'));
      }

      print('✅ USER AUTH VERIFIED: ${currentUser.email}');
      return Right(userId);

    } on ServerException catch (e) {
      print('❌ AUTH VERIFICATION FAILED: $e');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('❌ AUTH VERIFICATION ERROR: $e');
      return Left(ServerFailure('Authentication verification failed: $e'));
    }
  }
}