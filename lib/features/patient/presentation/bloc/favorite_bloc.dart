// import 'package:bloc/bloc.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../domain/entity/favorite_entity.dart';
// import '../../domain/usecase/favorite_usecases.dart';
// import 'favorite_event.dart';
// import 'favorite_state.dart';
//
// class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
//   final GetFavoritesUseCase getFavorites;
//   final AddFavoriteUseCase addFavorite;
//   final RemoveFavoriteUseCase removeFavorite;
//   final IsFavoriteUseCase isFavorite;
//   final ClearFavoritesUseCase clearFavorites;
//
//   FavoriteBloc({
//     required this.getFavorites,
//     required this.addFavorite,
//     required this.removeFavorite,
//     required this.isFavorite,
//     required this.clearFavorites,
//   }) : super(FavoriteInitial()) {
//     on<LoadFavoritesEvent>(_onLoadFavorites);
//     on<AddFavoriteEvent>(_onAddFavorite);
//     on<RemoveFavoriteEvent>(_onRemoveFavorite);
//     on<ToggleFavoriteEvent>(_onToggleFavorite);
//     on<ClearFavoritesEvent>(_onClearFavorites);
//   }
//
//   Future<void> _onLoadFavorites(
//       LoadFavoritesEvent event,
//       Emitter<FavoriteState> emit,
//       ) async {
//     emit(FavoriteLoading());
//     final result = await getFavorites(event.patientId);
//     result.fold(
//           (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//           (favorites) => emit(FavoritesLoaded(favorites)),
//     );
//   }
//
//   Future<void> _onAddFavorite(
//       AddFavoriteEvent event,
//       Emitter<FavoriteState> emit,
//       ) async {
//     final favorite = FavoriteEntity(
//       id: const Uuid().v4(),
//       patientId: event.patientId,
//       itemId: event.itemId,
//       type: event.type,
//       itemName: event.itemName,
//       itemImage: event.itemImage,
//       itemPrice: event.itemPrice,
//       createdAt: DateTime.now(),
//     );
//
//     final result = await addFavorite(favorite);
//     result.fold(
//           (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//           (_) {
//         // ✅ IMMEDIATE SUCCESS FEEDBACK
//         emit(FavoriteSuccess('${event.itemName} added to favorites!'));
//         // Then reload the list
//         add(LoadFavoritesEvent(patientId: event.patientId));
//       },
//     );
//   }
//
//   Future<void> _onRemoveFavorite(
//       RemoveFavoriteEvent event,
//       Emitter<FavoriteState> emit,
//       ) async {
//     // Store current state to get the item name for message
//     final currentState = state;
//     String? itemName;
//
//     if (currentState is FavoritesLoaded) {
//       final favorite = currentState.favorites.firstWhere(
//             (fav) => fav.id == event.favoriteId,
//         orElse: () => FavoriteEntity(
//           id: event.favoriteId,
//           patientId: event.patientId,
//           itemId: '',
//           type: FavoriteType.medicine,
//           itemName: 'Item',
//           itemImage: null,
//           itemPrice: null,
//           createdAt: DateTime.now(),
//         ),
//       );
//       itemName = favorite.itemName;
//     }
//
//     final result = await removeFavorite(event.favoriteId);
//     result.fold(
//           (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//           (_) {
//         // ✅ IMMEDIATE SUCCESS FEEDBACK
//         emit(FavoriteSuccess('$itemName removed from favorites!'));
//         // Then reload the list
//         add(LoadFavoritesEvent(patientId: event.patientId));
//       },
//     );
//   }
//
//   Future<void> _onToggleFavorite(
//       ToggleFavoriteEvent event,
//       Emitter<FavoriteState> emit,
//       ) async {
//     final isFavResult = await isFavorite(event.patientId, event.itemId, event.type);
//
//     isFavResult.fold(
//           (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//           (isFav) async {
//         if (isFav) {
//           // Find the favorite ID to remove
//           final favoritesResult = await getFavorites(event.patientId);
//           favoritesResult.fold(
//                 (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//                 (favorites) {
//               final favoriteToRemove = favorites.firstWhere(
//                     (fav) => fav.itemId == event.itemId && fav.type == event.type,
//               );
//               add(RemoveFavoriteEvent(
//                 patientId: event.patientId,
//                 favoriteId: favoriteToRemove.id,
//               ));
//             },
//           );
//         } else {
//           // Add new favorite
//           add(AddFavoriteEvent(
//             patientId: event.patientId,
//             itemId: event.itemId,
//             type: event.type,
//             itemName: event.itemName,
//             itemImage: event.itemImage,
//             itemPrice: event.itemPrice,
//           ));
//         }
//       },
//     );
//   }
//
//   Future<void> _onClearFavorites(
//       ClearFavoritesEvent event,
//       Emitter<FavoriteState> emit,
//       ) async {
//     final result = await clearFavorites(event.patientId);
//     result.fold(
//           (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
//           (_) {
//         // ✅ USE BOTH SUCCESS STATE AND EMPTY LIST
//         emit(FavoriteSuccess('All favorites cleared successfully!'));
//         emit(FavoritesLoaded([]));
//       },
//     );
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case CacheFailure:
//         return 'Local storage error: ${failure.message}';
//       default:
//         return 'Unexpected error: ${failure.message}';
//     }
//   }
// }
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
    // If we're already in FavoritesLoaded state, keep the current favorites temporarily
    final currentFavorites = state is FavoritesLoaded
        ? (state as FavoritesLoaded).favorites
        : [];

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
        // ✅ FIXED: Emit success and reload without immediate state conflict
        add(LoadFavoritesEvent(patientId: event.patientId));
        // Success message will be handled by the listener in UI
      },
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    // Store current state to get the item name for potential error message
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
        // ✅ FIXED: Just reload the list, success will be shown via the loaded state
        add(LoadFavoritesEvent(patientId: event.patientId));
      },
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    try {
      final isFavResult = await isFavorite(event.patientId, event.itemId, event.type);

      await isFavResult.fold(
            (failure) async {
          emit(FavoriteError(_mapFailureToMessage(failure)));
        },
            (isFav) async {
          if (isFav) {
            // Find the favorite ID to remove
            final favoritesResult = await getFavorites(event.patientId);
            await favoritesResult.fold(
                  (failure) async {
                emit(FavoriteError(_mapFailureToMessage(failure)));
              },
                  (favorites) async {
                final favoriteToRemove = favorites.firstWhere(
                      (fav) => fav.itemId == event.itemId && fav.type == event.type,
                );

                final removeResult = await removeFavorite(favoriteToRemove.id);
                removeResult.fold(
                      (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
                      (_) => add(LoadFavoritesEvent(patientId: event.patientId)),
                );
              },
            );
          } else {
            // Add new favorite
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

            final addResult = await addFavorite(favorite);
            addResult.fold(
                  (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
                  (_) => add(LoadFavoritesEvent(patientId: event.patientId)),
            );
          }
        },
      );
    } catch (e) {
      emit(FavoriteError('Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<void> _onClearFavorites(
      ClearFavoritesEvent event,
      Emitter<FavoriteState> emit,
      ) async {
    final result = await clearFavorites(event.patientId);
    result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (_) {
        // ✅ FIXED: Just emit empty favorites, no success state conflict
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