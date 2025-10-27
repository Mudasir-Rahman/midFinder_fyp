// import 'package:equatable/equatable.dart';
//
// class MedicineEntity extends Equatable {
//   final String id;
//   final String pharmacyId; // Added this field
//   final String medicineName;
//   final String dosage;
//   final String manufacturer;
//   final String description;
//   final String category;
//   final String genericName;
//   final String? imageUrl;
//   final DateTime createdAt;
//   final double? price; // Added this field
//   final int? stockQuantity; // Added this field
//   final bool? isAvailable; // Added this field
//   final bool? requiresPrescription; // Added this field
//
//   const MedicineEntity({
//     required this.id,
//     required this.pharmacyId,
//     required this.medicineName,
//     required this.dosage,
//     required this.manufacturer,
//     required this.description,
//     required this.category,
//     required this.genericName,
//     this.imageUrl,
//     required this.createdAt,
//     this.price,
//     this.stockQuantity,
//     this.isAvailable,
//     this.requiresPrescription,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     pharmacyId,
//     medicineName,
//     dosage,
//     manufacturer,
//     description,
//     category,
//     genericName,
//     imageUrl,
//     createdAt,
//     price,
//     stockQuantity,
//     isAvailable,
//     requiresPrescription,
//   ];
// }
import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String id;
  final String pharmacyId;
  final String medicineName;
  final String dosage;
  final String manufacturer;
  final String description;
  final String category;
  final String genericName;
  final String? imageUrl;
  final DateTime createdAt;
  final double? price;
  final int? stockQuantity;
  final bool? isAvailable;
  final bool? requiresPrescription;
  final String? pharmacyName; // ✅ Added for display only

  const MedicineEntity({
    required this.id,
    required this.pharmacyId,
    required this.medicineName,
    required this.dosage,
    required this.manufacturer,
    required this.description,
    required this.category,
    required this.genericName,
    this.imageUrl,
    required this.createdAt,
    this.price,
    this.stockQuantity,
    this.isAvailable,
    this.requiresPrescription,
    this.pharmacyName, // ✅ optional display-only field
  });

  @override
  List<Object?> get props => [
    id,
    pharmacyId,
    medicineName,
    dosage,
    manufacturer,
    description,
    category,
    genericName,
    imageUrl,
    createdAt,
    price,
    stockQuantity,
    isAvailable,
    requiresPrescription,
    pharmacyName, // ✅ include in props
  ];
}
