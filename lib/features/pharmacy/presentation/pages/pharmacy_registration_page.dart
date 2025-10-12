import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pharmacy_bloc.dart';
import '../widget/license_upload_widget.dart';
import '../widget/operating_hours_widget.dart';
import '../widget/pharmacy_info_form.dart';


class PharmacyRegistrationPage extends StatefulWidget {
  final String user;

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

  // Location
  double _latitude = 0.0;
  double _longitude = 0.0;

  // Operating hours
  List<String> _operatingDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 18, minute: 0);

  // License image
  String? _licenseImagePath;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    // TODO: Implement location service
    // For now, set default coordinates
    _latitude = 33.6844;
    _longitude = 73.0479;
  }

  void _onLicenseImageSelected(String imagePath) {
    setState(() {
      _licenseImagePath = imagePath;
    });
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
      context.read<PharmacyBloc>().add(RegisterPharmacyEvent(
        userId: widget.user,
        pharmacyName: _pharmacyNameController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        operatingDays: _operatingDays,
        openingTime: '${_openingTime.hour}:${_openingTime.minute}',
        closingTime: '${_closingTime.hour}:${_closingTime.minute}',
        licenseImagePath: _licenseImagePath,
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
              const SnackBar(content: Text('Pharmacy registered successfully!')),
            );
            Navigator.pushReplacementNamed(context, '/pharmacy-dashboard');
          } else if (state is PharmacyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LicenseImageUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('License image uploaded successfully!')),
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
                      // Pharmacy Information Form
                      PharmacyInfoForm(
                        pharmacyNameController: _pharmacyNameController,
                        licenseNumberController: _licenseNumberController,
                        addressController: _addressController,
                        phoneController: _phoneController,
                        onLocationSelected: _onLocationSelected,
                      ),

                      const SizedBox(height: 24),

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

                      // License Upload
                      LicenseUploadWidget(
                        onImageSelected: _onLicenseImageSelected,
                        imagePath: _licenseImagePath,
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