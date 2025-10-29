//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../auth/domain/entities/user_entities.dart';
// import '../../../../auth/presentation/pages/login_page.dart';
// import '../../../domain/entity/patient_entity.dart';
// import '../../bloc/patient_bloc.dart';
// import '../../bloc/patient_event.dart';
// import '../../bloc/patient_state.dart';
// import 'PatientDashboardPage.dart';
//
//
// class PatientRegistrationPage extends StatefulWidget {
//   final UserEntity user;
//   const PatientRegistrationPage({super.key, required this.user});
//
//   @override
//   State<PatientRegistrationPage> createState() => _PatientRegistrationPageState();
// }
//
// class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _cnicController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final patient = PatientEntity(
//         userId: widget.user.id,
//         name: _nameController.text.trim(),
//         cnic: _cnicController.text.trim(),
//         phone: _phoneController.text.trim(),
//         address: _addressController.text.trim(),
//         createdAt: DateTime.now(),
//       );
//
//       context.read<PatientBloc>().add(RegisterPatientEvent(patient));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Complete Patient Registration"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Complete Your Profile',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Welcome, ${widget.user.email}',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//
//                 // Name
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Full Name',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     } else if (value.length < 3) {
//                       return 'Name must be at least 3 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // CNIC
//                 TextFormField(
//                   controller: _cnicController,
//                   decoration: const InputDecoration(
//                     labelText: 'CNIC (without dashes)',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.badge),
//                     hintText: '1234567890123',
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your CNIC';
//                     } else if (!RegExp(r'^\d{13}$').hasMatch(value)) {
//                       return 'CNIC must be exactly 13 digits';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Phone
//                 TextFormField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.phone),
//                     hintText: '03001234567',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     } else if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
//                       return 'Please enter a valid Pakistani phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Address
//                 TextFormField(
//                   controller: _addressController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     labelText: 'Complete Address',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.location_on),
//                     hintText: 'House #, Street, Area, City',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your address';
//                     } else if (value.length < 10) {
//                       return 'Please enter a complete address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//
//                 BlocConsumer<PatientBloc, PatientState>(
//                   listener: (context, state) async {
//                     if (state is PatientRegistered) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Registration Successful!'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//
//                       if (!mounted) return;
//
//                       // ✅ FIX: Pass the registered patient data to dashboard
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => PatientDashboard(
//                             userId: state.patient.userId,
//                             initialPatient: state.patient, // Pass the patient data
//                           ),
//                         ),
//                             (route) => false,
//                       );
//                     } else if (state is PatientError) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(state.message),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is PatientLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     return ElevatedButton(
//                       onPressed: _submitForm,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Complete Registration',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _cnicController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/entities/user_entities.dart';
import '../../../../auth/presentation/pages/login_page.dart';
import '../../../domain/entity/patient_entity.dart';
import '../../bloc/patient_bloc.dart';
import '../../bloc/patient_event.dart';
import '../../bloc/patient_state.dart';
import 'PatientDashboardPage.dart';


class PatientRegistrationPage extends StatefulWidget {
  final UserEntity user;
  const PatientRegistrationPage({super.key, required this.user});

  @override
  State<PatientRegistrationPage> createState() => _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _submitForm() {
    print('🎯 SUBMIT FORM CALLED');

    if (_formKey.currentState!.validate()) {
      print('✅ FORM VALIDATION PASSED');

      final patient = PatientEntity(
        userId: widget.user.id,
        name: _nameController.text.trim(),
        cnic: _cnicController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        createdAt: DateTime.now(),
      );

      print('👤 PATIENT ENTITY CREATED:');
      print('   - User ID: ${patient.userId}');
      print('   - Name: ${patient.name}');
      print('   - CNIC: ${patient.cnic}');
      print('   - Phone: ${patient.phone}');
      print('   - Address: ${patient.address}');

      context.read<PatientBloc>().add(RegisterPatientEvent(patient));
    } else {
      print('❌ FORM VALIDATION FAILED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Patient Registration"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Complete Your Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome, ${widget.user.email}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // CNIC
                TextFormField(
                  controller: _cnicController,
                  decoration: const InputDecoration(
                    labelText: 'CNIC (without dashes)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                    hintText: '1234567890123',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your CNIC';
                    } else if (!RegExp(r'^\d{13}$').hasMatch(value)) {
                      return 'CNIC must be exactly 13 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    hintText: '03001234567',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
                      return 'Please enter a valid Pakistani phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Complete Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'House #, Street, Area, City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    } else if (value.length < 10) {
                      return 'Please enter a complete address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                BlocConsumer<PatientBloc, PatientState>(
                  listener: (context, state) async {
                    print('🎯 PATIENT BLOC STATE: ${state.runtimeType}');

                    if (state is PatientRegistered) {
                      print('✅ REGISTRATION SUCCESSFUL');
                      print('   - Patient ID: ${state.patient.userId}');
                      print('   - Patient Name: ${state.patient.name}');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      if (!mounted) return;

                      print('🚀 NAVIGATING TO DASHBOARD...');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PatientDashboard(
                            userId: state.patient.userId,
                            initialPatient: state.patient, // Pass the patient data
                          ),
                        ),
                            (route) => false,
                      );
                    } else if (state is PatientError) {
                      print('❌ REGISTRATION ERROR: ${state.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PatientLoading) {
                      print('⏳ REGISTRATION LOADING...');
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Complete Registration',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}