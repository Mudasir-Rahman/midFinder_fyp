//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
// import '../widget/medicine_form.dart';
//
// // --- CONSTANTS FROM DASHBOARD (Simulated global access) ---
// const Color kPrimaryColor = Color(0xFF004D99); // Deep Sapphire Blue
// const Color kAccentColor = Color(0xFF388E3C); // Vibrant Medical Green
// const double kCardRadius = 18.0;
// const Color kBackgroundColor = Color(0xFFF5F7FA);
//
// class AddMedicinePage extends StatefulWidget {
//   final String pharmacyId;
//
//   const AddMedicinePage({super.key, required this.pharmacyId});
//
//   @override
//   State<AddMedicinePage> createState() => _AddMedicinePageState();
// }
//
// class _AddMedicinePageState extends State<AddMedicinePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Helper widget for a visually strong header
//   Widget _buildPageHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Product Registration',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.w900,
//             color: kPrimaryColor,
//             letterSpacing: -0.8,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Enter detailed information to add a new medicine to your inventory.',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           'Add New Medicine',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             letterSpacing: -0.5,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: kPrimaryColor,
//         elevation: 10,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(kCardRadius),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: TextButton.icon(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                 }
//               },
//               icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
//               label: const Text(
//                 'Save',
//                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               style: TextButton.styleFrom(
//                 backgroundColor: kAccentColor.withOpacity(0.8),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: BlocListener<MedicineBloc, MedicineState>(
//         listener: (context, state) {
//           if (state is MedicineOperationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message ?? 'Medicine added successfully!'),
//                 backgroundColor: kAccentColor,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//             Navigator.of(context).pop();
//           } else if (state is MedicineError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red[700],
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Step 1: Visually appealing Header
//               _buildPageHeader(),
//               const SizedBox(height: 25),
//
//               // Step 2: Form enclosed in an elevated Card for focus
//               Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(kCardRadius),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: MedicineForm(
//                     formKey: _formKey,
//                     pharmacyId: widget.pharmacyId,
//                     onSubmit: (medicine, {XFile? imageFile}) {
//                       // FIXED: Pass both medicine and optional image file to BLoC
//                       context.read<MedicineBloc>().add(
//                         AddMedicineEvent(
//                           medicine,
//                           imageFile: imageFile,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // Ensure space at the bottom if needed
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
import '../../domain/entities/medicine_entity.dart';
import '../widget/medicine_form.dart';

// --- CONSTANTS FROM DASHBOARD (Simulated global access) ---
const Color kPrimaryColor = Color(0xFF004D99); // Deep Sapphire Blue
const Color kAccentColor = Color(0xFF388E3C); // Vibrant Medical Green
const double kCardRadius = 18.0;
const Color kBackgroundColor = Color(0xFFF5F7FA);

class AddMedicinePage extends StatefulWidget {
  final String pharmacyId;

  const AddMedicinePage({super.key, required this.pharmacyId});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ ADDED: Authentication check before submitting
  void _checkAuthAndSubmit(MedicineEntity medicine, {XFile? imageFile}) {
    final user = Supabase.instance.client.auth.currentUser;
    print('=== ADD MEDICINE AUTH CHECK ===');
    print('User: ${user?.email}');
    print('User ID: ${user?.id}');
    print('Authenticated: ${user != null}');
    print('===============================');

    if (user == null) {
      print('❌ USER NOT AUTHENTICATED - Redirecting to login');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session expired. Please login again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
      );
    } else {
      print('✅ User authenticated - Proceeding with medicine submission');
      // Proceed with adding medicine
      context.read<MedicineBloc>().add(
        AddMedicineEvent(
          medicine,
          imageFile: imageFile,
        ),
      );
    }
  }

  // Helper widget for a visually strong header
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Registration',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter detailed information to add a new medicine to your inventory.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add New Medicine',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 10,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(kCardRadius),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: kAccentColor.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<MedicineBloc, MedicineState>(
        listener: (context, state) {
          if (state is MedicineOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Medicine added successfully!'),
                backgroundColor: kAccentColor,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is MedicineError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[700],
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: Visually appealing Header
              _buildPageHeader(),
              const SizedBox(height: 25),

              // Step 2: Form enclosed in an elevated Card for focus
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: MedicineForm(
                    formKey: _formKey,
                    pharmacyId: widget.pharmacyId,
                    onSubmit: (medicine, {XFile? imageFile}) {
                      // ✅ FIXED: Added authentication check before submission
                      _checkAuthAndSubmit(medicine, imageFile: imageFile);
                    },
                  ),
                ),
              ),

              // Ensure space at the bottom if needed
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}