// import 'package:equatable/equatable.dart';
//
// import '../../domain/entity/favorite_entity.dart';
//
// abstract class FavoriteState extends Equatable {
//   const FavoriteState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class FavoriteInitial extends FavoriteState {}
//
// class FavoriteLoading extends FavoriteState {}
//
// class FavoritesLoaded extends FavoriteState {
//   final List<FavoriteEntity> favorites;
//   final String? message; // ✅ ADDED OPTIONAL MESSAGE
//
//   const FavoritesLoaded(this.favorites, {this.message});
//
//   @override
//   List<Object> get props => [favorites, if (message != null) message!];
// }
//
// class FavoriteError extends FavoriteState {
//   final String message;
//
//   const FavoriteError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// // ✅ ADDED SUCCESS STATE FOR SPECIFIC ACTIONS
// class FavoriteSuccess extends FavoriteState {
//   final String message;
//
//   const FavoriteSuccess(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
import 'package:equatable/equatable.dart';

import '../../domain/entity/favorite_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<FavoriteEntity> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteSuccess extends FavoriteState {
  final String message;

  const FavoriteSuccess(this.message);

  @override
  List<Object> get props => [message];
}