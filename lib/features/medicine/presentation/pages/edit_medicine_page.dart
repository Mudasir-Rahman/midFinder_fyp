// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
//
// import '../bloc/medicine_event.dart';
// import '../bloc/medicine_state.dart';
// import '../widget/medicine_form.dart';
//
//
// class EditMedicinePage extends StatefulWidget {
//   final MedicineEntity medicine;
//
//   const EditMedicinePage({super.key, required this.medicine});
//
//   @override
//   State<EditMedicinePage> createState() => _EditMedicinePageState();
// }
//
// class _EditMedicinePageState extends State<EditMedicinePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Medicine'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//               }
//             },
//           ),
//         ],
//       ),
//       body: BlocListener<MedicineBloc, MedicineState>(
//         listener: (context, state) {
//           if (state is MedicineOperationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.of(context).pop();
//           } else if (state is MedicineError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: MedicineForm(
//             formKey: _formKey,
//             medicine: widget.medicine,
//             pharmacyId: widget.medicine.pharmacyId, // Added required parameter
//             onSubmit: (medicine) {
//               context.read<MedicineBloc>().add(UpdateMedicineEvent(medicine));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';

import '../bloc/medicine_event.dart';
import '../bloc/medicine_state.dart';
import '../widget/medicine_form.dart';

class EditMedicinePage extends StatefulWidget {
  final MedicineEntity medicine;

  const EditMedicinePage({super.key, required this.medicine});

  @override
  State<EditMedicinePage> createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medicine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
            },
          ),
        ],
      ),
      body: BlocListener<MedicineBloc, MedicineState>(
        listener: (context, state) {
          if (state is MedicineOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is MedicineError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MedicineForm(
            formKey: _formKey,
            medicine: widget.medicine,
            pharmacyId: widget.medicine.pharmacyId,
            onSubmit: (medicine, {XFile? imageFile}) {
              // Pass both medicine and optional image file to BLoC
              context.read<MedicineBloc>().add(
                UpdateMedicineEvent(
                  medicine,
                  imageFile: imageFile,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}