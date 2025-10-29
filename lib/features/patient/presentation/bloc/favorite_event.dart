import 'package:equatable/equatable.dart';

import '../../domain/entity/favorite_entity.dart';


abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  final String patientId;

  const LoadFavoritesEvent({required this.patientId});

  @override
  List<Object> get props => [patientId];
}

class AddFavoriteEvent extends FavoriteEvent {
  final String patientId;
  final String itemId;
  final FavoriteType type;
  final String itemName;
  final String? itemImage;
  final double? itemPrice;

  const AddFavoriteEvent({
    required this.patientId,
    required this.itemId,
    required this.type,
    required this.itemName,
    this.itemImage,
    this.itemPrice,
  });

  @override
  List<Object> get props => [patientId, itemId, type, itemName];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String patientId;
  final String favoriteId;

  const RemoveFavoriteEvent({
    required this.patientId,
    required this.favoriteId,
  });

  @override
  List<Object> get props => [patientId, favoriteId];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String patientId;
  final String itemId;
  final FavoriteType type;
  final String itemName;
  final String? itemImage;
  final double? itemPrice;

  const ToggleFavoriteEvent({
    required this.patientId,
    required this.itemId,
    required this.type,
    required this.itemName,
    this.itemImage,
    this.itemPrice,
  });

  @override
  List<Object> get props => [patientId, itemId, type, itemName];
}

class ClearFavoritesEvent extends FavoriteEvent {
  final String patientId;

  const ClearFavoritesEvent({required this.patientId});

  @override
  List<Object> get props => [patientId];
}