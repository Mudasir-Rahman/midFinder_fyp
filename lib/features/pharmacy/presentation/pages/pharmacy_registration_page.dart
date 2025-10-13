// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../auth/domain/entities/user_entities.dart';
// import '../bloc/pharmacy_bloc.dart';
// import '../widget/license_upload_widget.dart';
// import '../widget/operating_hours_widget.dart';
// import '../widget/pharmacy_info_form.dart';
//
//
// class PharmacyRegistrationPage extends StatefulWidget {
//   final UserEntity user;
//
//   const PharmacyRegistrationPage({Key? key, required this.user}) : super(key: key);
//
//   @override
//   State<PharmacyRegistrationPage> createState() => _PharmacyRegistrationPageState();
// }
//
// class _PharmacyRegistrationPageState extends State<PharmacyRegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Form controllers
//   final _pharmacyNameController = TextEditingController();
//   final _licenseNumberController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   // Location
//   double _latitude = 0.0;
//   double _longitude = 0.0;
//
//   // Operating hours
//   List<String> _operatingDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
//   TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _closingTime = const TimeOfDay(hour: 18, minute: 0);
//
//   // License image
//   String? _licenseImagePath;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   void _getCurrentLocation() {
//     // TODO: Implement location service
//     // For now, set default coordinates
//     _latitude = 33.6844;
//     _longitude = 73.0479;
//   }
//
//   void _onLicenseImageSelected(String imagePath) {
//     setState(() {
//       _licenseImagePath = imagePath;
//     });
//   }
//
//   void _onOperatingDaysChanged(List<String> days) {
//     setState(() {
//       _operatingDays = days;
//     });
//   }
//
//   void _onOpeningTimeChanged(TimeOfDay time) {
//     setState(() {
//       _openingTime = time;
//     });
//   }
//
//   void _onClosingTimeChanged(TimeOfDay time) {
//     setState(() {
//       _closingTime = time;
//     });
//   }
//
//   void _onLocationSelected(double lat, double lng) {
//     setState(() {
//       _latitude = lat;
//       _longitude = lng;
//     });
//   }
//
//   void _registerPharmacy() {
//     if (_formKey.currentState!.validate()) {
//       context.read<PharmacyBloc>().add(RegisterPharmacyEvent(
//         userId: widget.user.id,
//         pharmacyName: _pharmacyNameController.text.trim(),
//         licenseNumber: _licenseNumberController.text.trim(),
//         address: _addressController.text.trim(),
//         phone: _phoneController.text.trim(),
//         latitude: _latitude,
//         longitude: _longitude,
//         operatingDays: _operatingDays,
//         openingTime: '${_openingTime.hour}:${_openingTime.minute}',
//         closingTime: '${_closingTime.hour}:${_closingTime.minute}',
//         licenseImagePath: _licenseImagePath,
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pharmacy Registration'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//       ),
//       body: BlocConsumer<PharmacyBloc, PharmacyState>(
//         listener: (context, state) {
//           if (state is PharmacyRegistrationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Pharmacy registered successfully!')),
//             );
//             Navigator.pushReplacementNamed(context, '/pharmacy-dashboard');
//           } else if (state is PharmacyError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is LicenseImageUploadSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('License image uploaded successfully!')),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Pharmacy Information Form
//                       PharmacyInfoForm(
//                         pharmacyNameController: _pharmacyNameController,
//                         licenseNumberController: _licenseNumberController,
//                         addressController: _addressController,
//                         phoneController: _phoneController,
//                         onLocationSelected: _onLocationSelected,
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // Operating Hours
//                       OperatingHoursWidget(
//                         operatingDays: _operatingDays,
//                         openingTime: _openingTime,
//                         closingTime: _closingTime,
//                         onOperatingDaysChanged: _onOperatingDaysChanged,
//                         onOpeningTimeChanged: _onOpeningTimeChanged,
//                         onClosingTimeChanged: _onClosingTimeChanged,
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // License Upload
//                       LicenseUploadWidget(
//                         onImageSelected: _onLicenseImageSelected,
//                         imagePath: _licenseImagePath,
//                       ),
//
//                       const SizedBox(height: 32),
//
//                       // Register Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: state is PharmacyLoading ? null : _registerPharmacy,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue[700],
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: state is PharmacyLoading
//                               ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                               : const Text(
//                             'Register Pharmacy',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Loading Overlay
//               if (state is PharmacyLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.3),
//                   child: const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pharmacyNameController.dispose();
//     _licenseNumberController.dispose();
//     _addressController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';

import '../../../auth/domain/entities/user_entities.dart';
import '../bloc/pharmacy_bloc.dart';
import '../widget/operating_hours_widget.dart';
import '../widget/pharmacy_info_form.dart';

class PharmacyRegistrationPage extends StatefulWidget {
  final UserEntity user;

  const PharmacyRegistrationPage({Key? key, required this.user}) : super(key: key);

  @override
  State<PharmacyRegistrationPage> createState() => _PharmacyRegistrationPageState();
}

class _PharmacyRegistrationPageState extends State<PharmacyRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _pharmacyNameController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // Location (will be entered manually or via address lookup)
  double _latitude = 0.0;
  double _longitude = 0.0;

  // Operating hours
  List<String> _operatingDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    // No auto-location for pharmacies
  }

  void _onOperatingDaysChanged(List<String> days) {
    setState(() {
      _operatingDays = days;
    });
  }

  void _onOpeningTimeChanged(TimeOfDay time) {
    setState(() {
      _openingTime = time;
    });
  }

  void _onClosingTimeChanged(TimeOfDay time) {
    setState(() {
      _closingTime = time;
    });
  }

  void _onLocationSelected(double lat, double lng) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
    });
  }

  void _registerPharmacy() {
    if (_formKey.currentState!.validate()) {
      // Validate that location is set
      if (_latitude == 0.0 && _longitude == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please set your pharmacy location using the map'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Format time to ensure 2-digit minutes
      final openingTime = '${_openingTime.hour.toString().padLeft(2, '0')}:${_openingTime.minute.toString().padLeft(2, '0')}';
      final closingTime = '${_closingTime.hour.toString().padLeft(2, '0')}:${_closingTime.minute.toString().padLeft(2, '0')}';

      context.read<PharmacyBloc>().add(RegisterPharmacyEvent(
        userId: widget.user.id,
        pharmacyName: _pharmacyNameController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        operatingDays: _operatingDays,
        openingTime: openingTime,
        closingTime: closingTime,
        licenseImagePath: null, // No license image needed
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Registration'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<PharmacyBloc, PharmacyState>(
        listener: (context, state) {
          if (state is PharmacyRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pharmacy registered successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to pharmacy dashboard
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => PharmacyDashboardPage(userId: widget.user.id),
              ),
                  (route) => false,
            );
          } else if (state is PharmacyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const SizedBox(height: 10),
                      const Text(
                        'Register Your Pharmacy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Enter your pharmacy details to start serving patients',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Pharmacy Information Form
                      PharmacyInfoForm(
                        pharmacyNameController: _pharmacyNameController,
                        licenseNumberController: _licenseNumberController,
                        addressController: _addressController,
                        phoneController: _phoneController,
                        onLocationSelected: _onLocationSelected,
                      ),

                      const SizedBox(height: 24),

                      // Location Status
                      if (_latitude != 0.0 || _longitude != 0.0)
                        Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.green),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Location Set',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lat: ${_latitude.toStringAsFixed(6)}, Lng: ${_longitude.toStringAsFixed(6)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Operating Hours
                      OperatingHoursWidget(
                        operatingDays: _operatingDays,
                        openingTime: _openingTime,
                        closingTime: _closingTime,
                        onOperatingDaysChanged: _onOperatingDaysChanged,
                        onOpeningTimeChanged: _onOpeningTimeChanged,
                        onClosingTimeChanged: _onClosingTimeChanged,
                      ),

                      const SizedBox(height: 24),

                      // Simple License Note
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.verified, color: Colors.blue[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'License Verification',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your pharmacy license will be verified by our admin team. '
                                    'You can provide license documents later if required.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is PharmacyLoading ? null : _registerPharmacy,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is PharmacyLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Register Pharmacy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Loading Overlay
              if (state is PharmacyLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pharmacyNameController.dispose();
    _licenseNumberController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}