
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object?> get props => [];
}

// ✅ Get all medicines
class GetAllMedicinesEvent extends MedicineEvent {
  const GetAllMedicinesEvent();
}

// ✅ Search medicine for pharmacy owner (optional patient location can be null)
class SearchMedicineEvent extends MedicineEvent {
  final String query;

  const SearchMedicineEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

// ✅ Search nearby medicines for patients
class SearchNearbyMedicineEvent extends MedicineEvent {
  final String query;
  final double latitude;
  final double longitude;

  const SearchNearbyMedicineEvent({
    required this.query,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [query, latitude, longitude];
}

// ✅ Get medicine detail
class GetMedicineDetailEvent extends MedicineEvent {
  final String medicineId;
  const GetMedicineDetailEvent(this.medicineId);

  @override
  List<Object?> get props => [medicineId];
}

// ✅ Add new medicine
class AddMedicineEvent extends MedicineEvent {
  final MedicineEntity medicine;
  final XFile? imageFile;
  const AddMedicineEvent(this.medicine, {this.imageFile});

  @override
  List<Object?> get props => [medicine];
}

// ✅ Update existing medicine
class UpdateMedicineEvent extends MedicineEvent {
  final MedicineEntity medicine;
  final XFile? imageFile;
  final bool removeExistingImage;
  const UpdateMedicineEvent(
      this.medicine, {
        this.imageFile,
        this.removeExistingImage = false,
      });

  @override
  List<Object?> get props => [medicine];
}

// ✅ Get all medicines of a specific pharmacy
class GetPharmacyMedicineEvent extends MedicineEvent {
  final String pharmacyId;
  const GetPharmacyMedicineEvent(this.pharmacyId);

  @override
  List<Object?> get props => [pharmacyId];
}

// ✅ Get medicines by category
// medicine_event.dart - UPDATE TO NAMED PARAMETER
class GetMedicineByCategoryEvent extends MedicineEvent {
  final String category;

  const GetMedicineByCategoryEvent({required this.category}); // Named parameter

  @override
  List<Object> get props => [category];
}
