import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entity/favorite_entity.dart';
import '../../domain/usecase/favorite_usecases.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase getFavorites;
  final AddFavoriteUseCase addFavorite;
  final RemoveFavoriteUseCase removeFavorite;
  final IsFavoriteUseCase isFavorite;
  final ClearFavoritesUseCase clearFavorites;

  FavoriteBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.isFavorite,
    required this.clearFavorites,
  }) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ClearFavoritesEvent>(_onClearFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    emit(FavoriteLoading());
    final result = await getFavorites(event.patientId);
    result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddFavorite(
      AddFavoriteEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    final favorite = FavoriteEntity(
      id: const Uuid().v4(),
      patientId: event.patientId,
      itemId: event.itemId,
      type: event.type,
      itemName: event.itemName,
      itemImage: event.itemImage,
      itemPrice: event.itemPrice,
      createdAt: DateTime.now(),
    );

    final result = await addFavorite(favorite);
    result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (_) {
        // ✅ IMMEDIATE SUCCESS FEEDBACK
        emit(FavoriteSuccess('${event.itemName} added to favorites!'));
        // Then reload the list
        add(LoadFavoritesEvent(patientId: event.patientId));
      },
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    // Store current state to get the item name for message
    final currentState = state;
    String? itemName;

    if (currentState is FavoritesLoaded) {
      final favorite = currentState.favorites.firstWhere(
            (fav) => fav.id == event.favoriteId,
        orElse: () => FavoriteEntity(
          id: event.favoriteId,
          patientId: event.patientId,
          itemId: '',
          type: FavoriteType.medicine,
          itemName: 'Item',
          itemImage: null,
          itemPrice: null,
          createdAt: DateTime.now(),
        ),
      );
      itemName = favorite.itemName;
    }

    final result = await removeFavorite(event.favoriteId);
    result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (_) {
        // ✅ IMMEDIATE SUCCESS FEEDBACK
        emit(FavoriteSuccess('$itemName removed from favorites!'));
        // Then reload the list
        add(LoadFavoritesEvent(patientId: event.patientId));
      },
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    final isFavResult = await isFavorite(event.patientId, event.itemId, event.type);

    isFavResult.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (isFav) async {
        if (isFav) {
          // Find the favorite ID to remove
          final favoritesResult = await getFavorites(event.patientId);
          favoritesResult.fold(
                (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
                (favorites) {
              final favoriteToRemove = favorites.firstWhere(
                    (fav) => fav.itemId == event.itemId && fav.type == event.type,
              );
              add(RemoveFavoriteEvent(
                patientId: event.patientId,
                favoriteId: favoriteToRemove.id,
              ));
            },
          );
        } else {
          // Add new favorite
          add(AddFavoriteEvent(
            patientId: event.patientId,
            itemId: event.itemId,
            type: event.type,
            itemName: event.itemName,
            itemImage: event.itemImage,
            itemPrice: event.itemPrice,
          ));
        }
      },
    );
  }

  Future<void> _onClearFavorites(
      ClearFavoritesEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    final result = await clearFavorites(event.patientId);
    result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (_) {
        // ✅ USE BOTH SUCCESS STATE AND EMPTY LIST
        emit(FavoriteSuccess('All favorites cleared successfully!'));
        emit(FavoritesLoaded([]));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Local storage error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}