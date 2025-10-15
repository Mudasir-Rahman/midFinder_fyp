import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'medicine_event.dart';
part 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  MedicineBloc() : super(MedicineInitial()) {
    on<MedicineEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
