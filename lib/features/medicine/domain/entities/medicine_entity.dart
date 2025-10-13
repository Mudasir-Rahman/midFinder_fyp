import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String id;
  final String medicineName;
  final String dosage;
  final String manufacturer;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final String genericName;
  final String category;

  const MedicineEntity({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.manufacturer,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    required this.genericName,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    medicineName,
    dosage,
    manufacturer,
    description,
    imageUrl,
    createdAt,
    genericName,
    category,
  ];
}