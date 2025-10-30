// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
//
// import 'package:rx_locator/core/error/failures.dart';
// import 'package:rx_locator/core/services/image_upload_service.dart';
// import 'package:rx_locator/core/usecase/usecase.dart';
// import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
// import 'package:rx_locator/features/medicine/domain/usecase/add_medicine.dart';
// import 'package:rx_locator/features/medicine/domain/usecase/get_medicine_by_category.dart';
// import 'package:rx_locator/features/medicine/domain/usecase/get_medicine_detail.dart';
// import 'package:rx_locator/features/medicine/domain/usecase/search_medicine.dart';
// import 'package:rx_locator/features/medicine/domain/usecase/update_medicine.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
//
// import '../../data/model/medicine_model.dart';
// import '../../domain/usecase/get_all_medicine.dart';
// import '../../domain/usecase/get_pharmacy_medicine.dart';
//
// class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
//   final SearchMedicine searchMedicine;
//   final GetMedicineDetail getMedicineDetail;
//   final AddMedicine addMedicine;
//   final UpdateMedicine updateMedicine;
//   final GetMedicinePharmacy getPharmacyMedicine;
//   final GetMedicineByCategory getMedicineByCategory;
//   final GetAllMedicines getAllMedicines;
//   final ImageUploadService imageUploadService;
//
//   MedicineBloc({
//     required this.searchMedicine,
//     required this.getMedicineDetail,
//     required this.addMedicine,
//     required this.updateMedicine,
//     required this.getPharmacyMedicine,
//     required this.getMedicineByCategory,
//     required this.getAllMedicines,
//     required this.imageUploadService,
//   }) : super(MedicineInitial()) {
//     on<GetAllMedicinesEvent>(_onGetAllMedicines);
//     on<SearchMedicineEvent>(_onSearchMedicine);
//     on<GetMedicineDetailEvent>(_onGetMedicineDetail);
//     on<AddMedicineEvent>(_onAddMedicine);
//     on<UpdateMedicineEvent>(_onUpdateMedicine);
//     on<GetPharmacyMedicineEvent>(_onGetPharmacyMedicine);
//     on<GetMedicineByCategoryEvent>(_onGetMedicineByCategory);
//   }
//
//   Future<void> _onGetAllMedicines(
//       GetAllMedicinesEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//     final result = await getAllMedicines(NoParams());
//     _handleMedicineListResult(result, emit);
//   }
//
//   Future<void> _onSearchMedicine(
//       SearchMedicineEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//     final result = await searchMedicine(SearchMedicineParams(query: event.query));
//     _handleMedicineListResult(result, emit);
//   }
//
//   Future<void> _onGetMedicineDetail(
//       GetMedicineDetailEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//     final result = await getMedicineDetail(event.medicineId);
//     _handleMedicineDetailResult(result, emit);
//   }
//
//   Future<void> _onAddMedicine(
//       AddMedicineEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//
//     try {
//       MedicineEntity medicineToAdd = event.medicine;
//
//       // Upload image first if provided
//       if (event.imageFile != null) {
//         emit(const MedicineImageUploading());
//
//         final imageUrl = await imageUploadService.uploadMedicineImage(
//           event.imageFile!,
//           event.medicine.id.isEmpty
//               ? 'temp_${DateTime.now().millisecondsSinceEpoch}'
//               : event.medicine.id,
//         );
//
//         // Update medicine with image URL
//         medicineToAdd = _createMedicineWithImage(medicineToAdd, imageUrl);
//       }
//
//       // Add medicine to database
//       final result = await addMedicine(AddMedicineParams(medicine: medicineToAdd));
//       _handleOperationResult(result, emit, 'Medicine added successfully');
//
//     } catch (e) {
//       emit(MedicineError('Failed to add medicine: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onUpdateMedicine(
//       UpdateMedicineEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//
//     try {
//       MedicineEntity medicineToUpdate = event.medicine;
//
//       // Handle image operations
//       if (event.removeExistingImage) {
//         // Remove existing image
//         if (medicineToUpdate.imageUrl != null) {
//           await imageUploadService.deleteMedicineImage(medicineToUpdate.imageUrl!);
//         }
//         medicineToUpdate = _createMedicineWithImage(medicineToUpdate, null);
//       }
//       else if (event.imageFile != null) {
//         // Upload new image
//         emit(const MedicineImageUploading());
//
//         final imageUrl = await imageUploadService.uploadMedicineImage(
//           event.imageFile!,
//           event.medicine.id,
//         );
//
//         // Delete old image if exists
//         if (medicineToUpdate.imageUrl != null) {
//           await imageUploadService.deleteMedicineImage(medicineToUpdate.imageUrl!);
//         }
//
//         medicineToUpdate = _createMedicineWithImage(medicineToUpdate, imageUrl);
//       }
//
//       // Update medicine in database
//       final result = await updateMedicine(UpdateMedicineParams(medicine: medicineToUpdate));
//       _handleOperationResult(result, emit, 'Medicine updated successfully');
//
//     } catch (e) {
//       emit(MedicineError('Failed to update medicine: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onGetPharmacyMedicine(
//       GetPharmacyMedicineEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//     final result = await getPharmacyMedicine(event.pharmacyId);
//     _handleMedicineListResult(result, emit);
//   }
//
//   Future<void> _onGetMedicineByCategory(
//       GetMedicineByCategoryEvent event,
//       Emitter<MedicineState> emit,
//       ) async {
//     emit(MedicineLoading());
//     final result = await getMedicineByCategory(event.category);
//     _handleMedicineListResult(result, emit);
//   }
//
//   // Helper method to create medicine with image
//   MedicineEntity _createMedicineWithImage(MedicineEntity medicine, String? imageUrl) {
//     // Assuming MedicineModel has a copyWith method or create a new instance
//     // Replace this with your actual implementation
//     return MedicineModel(
//       id: medicine.id,
//       pharmacyId: medicine.pharmacyId,
//       medicineName: medicine.medicineName,
//       genericName: medicine.genericName,
//       dosage: medicine.dosage,
//       manufacturer: medicine.manufacturer,
//       description: medicine.description,
//       category: medicine.category,
//       imageUrl: imageUrl,
//       price: medicine.price,
//       stockQuantity: medicine.stockQuantity,
//       isAvailable: medicine.isAvailable,
//       requiresPrescription: medicine.requiresPrescription,
//       createdAt: medicine.createdAt,
//
//     );
//   }
//
//   void _handleMedicineListResult(
//       Either<Failure, List<MedicineEntity>> result,
//       Emitter<MedicineState> emit,
//       ) {
//     result.fold(
//           (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
//           (medicines) => emit(MedicineLoaded(medicines)),
//     );
//   }
//
//   void _handleMedicineDetailResult(
//       Either<Failure, MedicineEntity> result,
//       Emitter<MedicineState> emit,
//       ) {
//     result.fold(
//           (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
//           (medicine) => emit(MedicineDetailLoaded(medicine)),
//     );
//   }
//
//   void _handleOperationResult(
//       Either<Failure, void> result,
//       Emitter<MedicineState> emit,
//       String successMessage,
//       ) {
//     result.fold(
//           (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
//           (_) => emit(MedicineOperationSuccess(successMessage)),
//     );
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server error: ${(failure as ServerFailure).message}';
//       case NetworkFailure:
//         return 'Network error: Please check your internet connection';
//       default:
//         return 'Unexpected error occurred';
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/core/services/image_upload_service.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/domain/usecase/add_medicine.dart';
import 'package:rx_locator/features/medicine/domain/usecase/get_medicine_by_category.dart';
import 'package:rx_locator/features/medicine/domain/usecase/get_medicine_detail.dart';
import 'package:rx_locator/features/medicine/domain/usecase/search_medicine.dart';
import 'package:rx_locator/features/medicine/domain/usecase/update_medicine.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
import '../../domain/usecase/get_all_medicine.dart';
import '../../domain/usecase/get_pharmacy_medicine.dart';
import '../../domain/usecase/search_nearby_medicine.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final SearchMedicine searchMedicine;
  final SearchNearbyMedicine searchNearbyMedicine;
  final GetMedicineDetail getMedicineDetail;
  final AddMedicine addMedicine;
  final UpdateMedicine updateMedicine;
  final GetMedicinePharmacy getPharmacyMedicine;
  final GetMedicineByCategory getMedicineByCategory;
  final GetAllMedicines getAllMedicines;
  final ImageUploadService imageUploadService;

  MedicineBloc({
    required this.searchMedicine,
    required this.searchNearbyMedicine,
    required this.getMedicineDetail,
    required this.addMedicine,
    required this.updateMedicine,
    required this.getPharmacyMedicine,
    required this.getMedicineByCategory,
    required this.getAllMedicines,
    required this.imageUploadService,
  }) : super(MedicineInitial()) {
    on<GetAllMedicinesEvent>(_onGetAllMedicines);
    on<SearchMedicineEvent>(_onSearchMedicine);
    on<SearchNearbyMedicineEvent>(_onSearchNearbyMedicine);
    on<GetMedicineDetailEvent>(_onGetMedicineDetail);
    on<AddMedicineEvent>(_onAddMedicine);
    on<UpdateMedicineEvent>(_onUpdateMedicine);
    on<GetPharmacyMedicineEvent>(_onGetPharmacyMedicine);
    on<GetMedicineByCategoryEvent>(_onGetMedicineByCategory);
  }

  Future<void> _onGetAllMedicines(
      GetAllMedicinesEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    final result = await getAllMedicines(NoParams());
    _handleMedicineListResult(result, emit);
  }

  Future<void> _onSearchMedicine(
      SearchMedicineEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    final result = await searchMedicine(SearchMedicineParams(query: event.query));
    _handleMedicineListResult(result, emit);
  }

  Future<void> _onSearchNearbyMedicine(
      SearchNearbyMedicineEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    final result = await searchNearbyMedicine(SearchNearbyMedicineParams(
      query: event.query,
      latitude: event.latitude,
      longitude: event.longitude,
    ));
    _handleMedicineListResult(result, emit);
  }

  Future<void> _onGetMedicineDetail(
      GetMedicineDetailEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    // FIXED: Pass medicineId directly as String
    final result = await getMedicineDetail(event.medicineId);
    _handleMedicineDetailResult(result, emit);
  }

  Future<void> _onAddMedicine(
      AddMedicineEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());

    try {
      MedicineEntity medicineToAdd = event.medicine;

      // Upload image first if provided
      if (event.imageFile != null) {
        emit(const MedicineImageUploading());

        final imageUrl = await imageUploadService.uploadMedicineImage(
          event.imageFile!,
          event.medicine.id.isEmpty
              ? 'temp_${DateTime.now().millisecondsSinceEpoch}'
              : event.medicine.id,
        );

        // Create updated medicine with image URL
        medicineToAdd = _createMedicineWithImage(medicineToAdd, imageUrl);
      }

      // Add medicine to database
      final result = await addMedicine(AddMedicineParams(medicine: medicineToAdd));
      _handleOperationResult(result, emit, 'Medicine added successfully');

    } catch (e) {
      emit(MedicineError('Failed to add medicine: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMedicine(
      UpdateMedicineEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());

    try {
      MedicineEntity medicineToUpdate = event.medicine;

      // Handle image operations
      if (event.removeExistingImage) {
        // Remove existing image
        if (medicineToUpdate.imageUrl != null) {
          await imageUploadService.deleteMedicineImage(medicineToUpdate.imageUrl!);
        }
        medicineToUpdate = _createMedicineWithImage(medicineToUpdate, null);
      }
      else if (event.imageFile != null) {
        // Upload new image
        emit(const MedicineImageUploading());

        final imageUrl = await imageUploadService.uploadMedicineImage(
          event.imageFile!,
          event.medicine.id,
        );

        // Delete old image if exists
        if (medicineToUpdate.imageUrl != null) {
          await imageUploadService.deleteMedicineImage(medicineToUpdate.imageUrl!);
        }

        medicineToUpdate = _createMedicineWithImage(medicineToUpdate, imageUrl);
      }

      // Update medicine in database
      final result = await updateMedicine(UpdateMedicineParams(medicine: medicineToUpdate));
      _handleOperationResult(result, emit, 'Medicine updated successfully');

    } catch (e) {
      emit(MedicineError('Failed to update medicine: ${e.toString()}'));
    }
  }

  Future<void> _onGetPharmacyMedicine(
      GetPharmacyMedicineEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    // FIXED: Check what GetMedicinePharmacy expects - it might also take String directly
    // If it takes String directly, use: await getPharmacyMedicine(event.pharmacyId)
    // If it uses params, use: await getPharmacyMedicine(GetPharmacyMedicineParams(pharmacyId: event.pharmacyId))
    final result = await getPharmacyMedicine(event.pharmacyId); // Try this first
    _handleMedicineListResult(result, emit);
  }

  Future<void> _onGetMedicineByCategory(
      GetMedicineByCategoryEvent event,
      Emitter<MedicineState> emit,
      ) async {
    emit(MedicineLoading());
    final result = await getMedicineByCategory(GetMedicineByCategoryParams(category: event.category));
    _handleMedicineListResult(result, emit);
  }

  // Helper method to create medicine with image
  MedicineEntity _createMedicineWithImage(MedicineEntity medicine, String? imageUrl) {
    return MedicineEntity(
      id: medicine.id,
      pharmacyId: medicine.pharmacyId,
      medicineName: medicine.medicineName,
      genericName: medicine.genericName,
      dosage: medicine.dosage,
      manufacturer: medicine.manufacturer,
      description: medicine.description,
      category: medicine.category,
      imageUrl: imageUrl,
      price: medicine.price,
      stockQuantity: medicine.stockQuantity,
      isAvailable: medicine.isAvailable,
      requiresPrescription: medicine.requiresPrescription,
      createdAt: medicine.createdAt,
      pharmacyName: medicine.pharmacyName,
    );
  }

  void _handleMedicineListResult(
      Either<Failure, List<MedicineEntity>> result,
      Emitter<MedicineState> emit,
      ) {
    result.fold(
          (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
          (medicines) => emit(MedicineLoaded(medicines)),
    );
  }

  void _handleMedicineDetailResult(
      Either<Failure, MedicineEntity> result,
      Emitter<MedicineState> emit,
      ) {
    result.fold(
          (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
          (medicine) => emit(MedicineDetailLoaded(medicine)),
    );
  }

  void _handleOperationResult(
      Either<Failure, void> result,
      Emitter<MedicineState> emit,
      String successMessage,
      ) {
    result.fold(
          (failure) => emit(MedicineError(_mapFailureToMessage(failure))),
          (_) => emit(MedicineOperationSuccess(successMessage)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${(failure as ServerFailure).message}';
      case NetworkFailure:
        return 'Network error: Please check your internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }
}