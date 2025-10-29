import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites(String patientId);
  Future<Either<Failure, void>> addFavorite(FavoriteEntity favorite);
  Future<Either<Failure, void>> removeFavorite(String favoriteId);
  Future<Either<Failure, bool>> isFavorite(String patientId, String itemId, FavoriteType type);
  Future<Either<Failure, void>> clearFavorites(String patientId);
}