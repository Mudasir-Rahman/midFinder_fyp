import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class GetAllMedicinesEvent extends MedicineEvent {
  const GetAllMedicinesEvent();
}

class SearchMedicineEvent extends MedicineEvent {
  final String query;
  const SearchMedicineEvent(this.query);

  @override
  List<Object> get props => [query];
}

class GetMedicineDetailEvent extends MedicineEvent {
  final String medicineId;
  const GetMedicineDetailEvent(this.medicineId);

  @override
  List<Object> get props => [medicineId];
}

class AddMedicineEvent extends MedicineEvent {
  final MedicineEntity medicine;
  final XFile? imageFile; // Add image file
  const AddMedicineEvent(this.medicine, {this.imageFile});

  @override
  List<Object> get props => [medicine];
}

class UpdateMedicineEvent extends MedicineEvent {
  final MedicineEntity medicine;
  final XFile? imageFile; // Add image file
  final bool removeExistingImage;
  const UpdateMedicineEvent(
      this.medicine, {
        this.imageFile,
        this.removeExistingImage = false,
      });

  @override
  List<Object> get props => [medicine];
}

class GetPharmacyMedicineEvent extends MedicineEvent {
  final String pharmacyId;
  const GetPharmacyMedicineEvent(this.pharmacyId);

  @override
  List<Object> get props => [pharmacyId];
}

class GetMedicineByCategoryEvent extends MedicineEvent {
  final String category;
  const GetMedicineByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}