// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../auth/domain/entities/user_entities.dart';
// import '../../../domain/entity/patient_entity.dart';
// import '../../bloc/patient_bloc.dart';
// import '../../bloc/patient_event.dart';
// import '../../bloc/patient_state.dart';
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
//   final _latitudeController = TextEditingController();
//   final _longitudeController = TextEditingController();
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
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header
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
//                 // Name Field
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
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // CNIC Field
//                 TextFormField(
//                   controller: _cnicController,
//                   decoration: const InputDecoration(
//                     labelText: 'CNIC',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.badge),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your CNIC';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Phone Field
//                 TextFormField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Address Field
//                 TextFormField(
//                   controller: _addressController,
//                   maxLines: 2,
//                   decoration: const InputDecoration(
//                     labelText: 'Address',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Location Fields (could be filled automatically via GPS)
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _latitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           labelText: 'Latitude',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _longitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           labelText: 'Longitude',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//
//                 // Register Button
//                 BlocConsumer<PatientBloc, PatientState>(
//                   listener: (context, state) {
//                     if (state is PatientRegistered) {
//                       // Navigate to dashboard on success
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Registration Successful!')),
//                       );
//                       // Navigate to patient dashboard
//                       // Navigator.pushReplacement(...);
//                     } else if (state is PatientError) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(state.message)),
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
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         backgroundColor: Colors.blue,
//                       ),
//                       child: const Text(
//                         'Complete Registration',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Create patient entity with name
//       final patient = PatientEntity(
//         userId: widget.user.id,
//         name: _nameController.text.trim(), // ← Name collected here
//         cnic: _cnicController.text.trim(),
//         phone: _phoneController.text.trim(),
//         address: _addressController.text.trim(),
//         latitude: double.tryParse(_latitudeController.text),
//         longitude: double.tryParse(_longitudeController.text),
//         createdAt: DateTime.now(),
//       );
//
//       // Trigger registration
//       context.read<PatientBloc>().add(RegisterPatientEvent(patient));
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _cnicController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'; // Add this package

import '../../../../auth/domain/entities/user_entities.dart';
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
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required for better service')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
      // Set default coordinates (Islamabad)
      _latitudeController.text = '33.6844';
      _longitudeController.text = '73.0479';
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
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

                // Name Field
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

                // CNIC Field
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

                // Phone Field
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
                      return 'Please enter a valid Pakistani phone number\nFormat: 03001234567';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Field
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
                const SizedBox(height: 16),

                // Location Section
                const Text(
                  'Location Coordinates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We automatically detected your location. You can manually adjust if needed.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.explore),
                        ),
                        readOnly: true, // Make read-only since we auto-detect
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.explore),
                        ),
                        readOnly: true, // Make read-only since we auto-detect
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 56, // Match the TextField height
                      child: IconButton(
                        icon: _isGettingLocation
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.my_location),
                        onPressed: _isGettingLocation ? null : _getCurrentLocation,
                        tooltip: 'Refresh location',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue.shade200),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Register Button
                BlocConsumer<PatientBloc, PatientState>(
                  listener: (context, state) {
                    if (state is PatientRegistered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Navigate to patient dashboard
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PatientDashboard(userId: widget.user.id),
                        ),
                            (route) => false,
                      );
                    } else if (state is PatientError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PatientLoading) {
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final patient = PatientEntity(
        userId: widget.user.id,
        name: _nameController.text.trim(),
        cnic: _cnicController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        createdAt: DateTime.now(),
      );

      context.read<PatientBloc>().add(RegisterPatientEvent(patient));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}