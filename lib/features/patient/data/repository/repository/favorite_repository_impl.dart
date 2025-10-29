import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/local_database_service.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entity/favorite_entity.dart';
import '../../../domain/repository/favorite_repository.dart';
import '../../patient_model/favorite_model.dart';


class FavoriteRepositoryImpl implements FavoriteRepository {
  final LocalDatabaseService localDatabaseService;

  FavoriteRepositoryImpl({required this.localDatabaseService});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites(String patientId) async {
    try {
      // ✅ Use instance, not static
      final Database db = await localDatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'patient_id = ?',
        whereArgs: [patientId],
        orderBy: 'created_at DESC',
      );

      final favorites = maps.map((map) => FavoriteModel.fromJson(map)).toList();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteEntity favorite) async {
    try {
      // ✅ Use instance, not static
      final Database db = await localDatabaseService.database;
      final favoriteModel = FavoriteModel(
        id: favorite.id,
        patientId: favorite.patientId,
        itemId: favorite.itemId,
        type: favorite.type,
        itemName: favorite.itemName,
        itemImage: favorite.itemImage,
        itemPrice: favorite.itemPrice,
        createdAt: favorite.createdAt,
      );

      await db.insert(
        'favorites',
        favoriteModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String favoriteId) async {
    try {
      // ✅ Use instance, not static
      final Database db = await localDatabaseService.database;
      await db.delete(
        'favorites',
        where: 'id = ?',
        whereArgs: [favoriteId],
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String patientId, String itemId, FavoriteType type) async {
    try {
      // ✅ Use instance, not static
      final Database db = await localDatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'patient_id = ? AND item_id = ? AND type = ?',
        whereArgs: [patientId, itemId, type.toString().split('.').last],
      );
      return Right(maps.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure('Failed to check favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites(String patientId) async {
    try {
      // ✅ Use instance, not static
      final Database db = await localDatabaseService.database;
      await db.delete(
        'favorites',
        where: 'patient_id = ?',
        whereArgs: [patientId],
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear favorites: $e'));
    }
  }
}