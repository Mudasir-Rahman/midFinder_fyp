import 'package:equatable/equatable.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineImageUploading extends MedicineState {
  final double progress;
  const MedicineImageUploading({this.progress = 0.0});

  @override
  List<Object> get props => [progress];
}

class MedicineLoaded extends MedicineState {
  final List<MedicineEntity> medicines;
  const MedicineLoaded(this.medicines);

  @override
  List<Object> get props => [medicines];
}

class MedicineDetailLoaded extends MedicineState {
  final MedicineEntity medicine;
  const MedicineDetailLoaded(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class MedicineOperationSuccess extends MedicineState {
  final String message;
  const MedicineOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MedicineError extends MedicineState {
  final String message;
  const MedicineError(this.message);

  @override
  List<Object> get props => [message];
}