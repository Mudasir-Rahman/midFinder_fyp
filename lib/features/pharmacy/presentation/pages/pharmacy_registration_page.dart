
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';

import '../../../auth/domain/entities/user_entities.dart';
import '../bloc/pharmacy_bloc.dart';
// Assuming these widgets are present and will be styled accordingly if needed
import '../widget/operating_hours_widget.dart';
import '../widget/pharmacy_info_form.dart';

// --- Global Constants for Styling ---
const Color kPrimaryColor = Color(0xFF0056D2); // Deeper Blue
const Color kAccentColor = Color(0xFF42A5F5); // Lighter Blue
const Color kBackgroundColor = Color(0xFFF5F7FA); // Off-White/Light Gray
const double kCardRadius = 20.0;
const double kPadding = 24.0;

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
    _printAuthStatus('INIT');
  }

  void _printAuthStatus(String location) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    print('=== AUTH STATUS [$location] ===');
    print('Widget User ID: ${widget.user.id}');
    print('Current Auth User: ${currentUser?.id}');
    print('Email: ${currentUser?.email}');
    print('Match: ${currentUser?.id == widget.user.id}');
    print('Authenticated: ${currentUser != null}');
    print('============================');
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
    _printAuthStatus('REGISTRATION_START');

    if (_formKey.currentState!.validate()) {
      // Validate that location is set
      if (_latitude == 0.0 && _longitude == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('📍 Please set your pharmacy location using the map or address lookup.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.deepOrange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      // Verify authentication before proceeding
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        _handleAuthFailure('User not authenticated during registration');
        return;
      }

      if (currentUser.id != widget.user.id) {
        _handleAuthFailure('User ID mismatch during registration');
        return;
      }

      // Format time to ensure 2-digit minutes
      final openingTime = '${_openingTime.hour.toString().padLeft(2, '0')}:${_openingTime.minute.toString().padLeft(2, '0')}';
      final closingTime = '${_closingTime.hour.toString().padLeft(2, '0')}:${_closingTime.minute.toString().padLeft(2, '0')}';

      print('✅ AUTH VERIFIED - Dispatching registration event');

      // Assuming RegisterPharmacyEvent is defined elsewhere
      context.read<PharmacyBloc>().add(RegisterPharmacyEvent(
        userId: currentUser.id, // Use current user ID for safety
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
    } else {
      print('❌ FORM VALIDATION FAILED');
    }
  }

  void _handleAuthFailure(String message) {
    print('❌ AUTH FAILURE: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authentication error. Please login again.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  Future<void> _handleRegistrationSuccess() async {
    _printAuthStatus('REGISTRATION_SUCCESS');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '🎉 Pharmacy registered successfully!',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(kPadding),
      ),
    );

    // Wait for state to settle and verify auth
    await Future.delayed(const Duration(milliseconds: 800));

    final currentUser = Supabase.instance.client.auth.currentUser;
    _printAuthStatus('NAVIGATION_CHECK');

    if (currentUser != null) {
      print('✅ NAVIGATING TO DASHBOARD WITH USER: ${currentUser.id}');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => PharmacyDashboardPage(userId: currentUser.id),
        ),
            (route) => false,
      );
    } else {
      _handleAuthFailure('User authentication lost after registration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Pharmacy Registration',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // More subtle shape for a modern look
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: BlocConsumer<PharmacyBloc, PharmacyState>(
        listener: (context, state) async {
          if (state is PharmacyRegistrationSuccess) {
            await _handleRegistrationSuccess();
          } else if (state is PharmacyError) {
            print('❌ REGISTRATION ERROR: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message, style: const TextStyle(fontWeight: FontWeight.w600))),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.all(kPadding),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Use a consistent background
              Container(color: kBackgroundColor),

              SingleChildScrollView(
                padding: const EdgeInsets.all(kPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      const SizedBox(height: 32),

                      // Pharmacy Information Form
                      _buildSectionTitle('🏥 Pharmacy Information'),
                      const SizedBox(height: 16),
                      _buildCardWrapper(
                        child: PharmacyInfoForm(
                          pharmacyNameController: _pharmacyNameController,
                          licenseNumberController: _licenseNumberController,
                          addressController: _addressController,
                          phoneController: _phoneController,
                          onLocationSelected: _onLocationSelected,
                          // Note: Ensure PharmacyInfoForm uses a modern look (e.g., filled text fields)
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Location Status
                      if (_latitude != 0.0 || _longitude != 0.0)
                        _buildLocationStatusCard(),

                      const SizedBox(height: 32),

                      // Operating Hours Section
                      _buildSectionTitle('🕒 Operating Hours'),
                      const SizedBox(height: 16),
                      _buildCardWrapper(
                        child: OperatingHoursWidget(
                          operatingDays: _operatingDays,
                          openingTime: _openingTime,
                          closingTime: _closingTime,
                          onOperatingDaysChanged: _onOperatingDaysChanged,
                          onOpeningTimeChanged: _onOpeningTimeChanged,
                          onClosingTimeChanged: _onClosingTimeChanged,
                          // Note: Ensure OperatingHoursWidget is styled beautifully
                        ),
                      ),

                      const SizedBox(height: 32),

                      // License Information Section
                      _buildLicenseInfoCard(),

                      const SizedBox(height: 40),

                      // Register Button
                      _buildRegisterButton(state),
                      const SizedBox(height: 20), // Extra space at bottom
                    ],
                  ),
                ),
              ),

              // Loading Overlay
              if (state is PharmacyLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kCardRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            strokeWidth: 4,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Setting up your pharmacy...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Please wait while we create your account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // --- New Helper Widgets for Enhanced Aesthetics ---

  Widget _buildCardWrapper({required Widget child}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      margin: EdgeInsets.zero, // Remove default card margin
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: kAccentColor.withOpacity(0.1), // Light accent background
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: kAccentColor.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.local_pharmacy_rounded,
                size: 38,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome, Pharmacy Partner!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900, // Extra bold
                      color: kPrimaryColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join the RxLocator network by completing your profile details below.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Decorative Divider
        Container(
          height: 5,
          width: 80,
          decoration: BoxDecoration(
            color: kAccentColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: Colors.grey[850], // Darker for contrast
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildLocationStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        side: BorderSide(color: Colors.green.shade100, width: 2), // Subtle border
      ),
      margin: EdgeInsets.zero,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_sharp,
                color: Colors.green.shade800,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location Set Successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${_latitude.toStringAsFixed(6)} | Lng: ${_longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.05), // Very light primary background
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: kPrimaryColor,
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'License Verification',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your license number is recorded. You will manage and upload verification documents from your dedicated **Pharmacy Dashboard** after this initial registration.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Chip(
                  avatar: const Icon(Icons.security, size: 16, color: Colors.white),
                  label: const Text('Secure Process', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  backgroundColor: kAccentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(PharmacyState state) {
    final bool isLoading = state is PharmacyLoading;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : _registerPharmacy,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: kPrimaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // Slightly more rounded
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800, // Bolder text
          ),
        ),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Setting Up Your Pharmacy...'),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.rocket_launch, size: 24), // More exciting icon
            SizedBox(width: 10),
            Text('Launch My Pharmacy'),
          ],
        ),
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