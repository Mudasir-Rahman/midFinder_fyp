import 'package:equatable/equatable.dart';
import '../../domain/entity/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required String id,
    required String patientId,
    required String itemId,
    required FavoriteType type,
    required String itemName,
    String? itemImage,
    double? itemPrice,
    required DateTime createdAt,
  }) : super(
    id: id,
    patientId: patientId,
    itemId: itemId,
    type: type,
    itemName: itemName,
    itemImage: itemImage,
    itemPrice: itemPrice,
    createdAt: createdAt,
  );

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? '',
      patientId: json['patient_id'] ?? '',
      itemId: json['item_id'] ?? '',
      type: _parseFavoriteType(json['type']),
      itemName: json['item_name'] ?? '',
      itemImage: json['item_image'],
      itemPrice: json['item_price']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static FavoriteType _parseFavoriteType(String type) {
    switch (type) {
      case 'medicine':
        return FavoriteType.medicine;
      case 'pharmacy':
        return FavoriteType.pharmacy;
      default:
        return FavoriteType.medicine;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'item_id': itemId,
      'type': type.toString().split('.').last,
      'item_name': itemName,
      'item_image': itemImage,
      'item_price': itemPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }
}