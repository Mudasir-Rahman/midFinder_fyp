import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/favorite_entity.dart';
import '../repository/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase({required this.repository});

  Future<Either<Failure, List<FavoriteEntity>>> call(String patientId) {
    return repository.getFavorites(patientId);
  }
}

class AddFavoriteUseCase {
  final FavoriteRepository repository;

  AddFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(FavoriteEntity favorite) {
    return repository.addFavorite(favorite);
  }
}

class RemoveFavoriteUseCase {
  final FavoriteRepository repository;

  RemoveFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(String favoriteId) {
    return repository.removeFavorite(favoriteId);
  }
}

class IsFavoriteUseCase {
  final FavoriteRepository repository;

  IsFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String patientId, String itemId, FavoriteType type) {
    return repository.isFavorite(patientId, itemId, type);
  }
}

class ClearFavoritesUseCase {
  final FavoriteRepository repository;

  ClearFavoritesUseCase({required this.repository});

  Future<Either<Failure, void>> call(String patientId) {
    return repository.clearFavorites(patientId);
  }
}