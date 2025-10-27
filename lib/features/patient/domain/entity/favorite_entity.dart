import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String patientId;
  final String itemId;
  final FavoriteType type;
  final String itemName;
  final String? itemImage;
  final double? itemPrice;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.patientId,
    required this.itemId,
    required this.type,
    required this.itemName,
    this.itemImage,
    this.itemPrice,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, patientId, itemId, type, itemName];
}

enum FavoriteType {
  medicine,
  pharmacy,
}