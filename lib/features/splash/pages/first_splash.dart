import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
import '../../auth/domain/entities/user_entities.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_event.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../../auth/presentation/pages/login_page.dart';
import '../../patient/presentation/pages/pages/PatientDashboardPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // User not logged in → Navigate to Login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Remove all previous routes
          );
        } else if (state is AuthRegistrationComplete) {
          // User logged in AND registration complete → Go to Dashboard
          _navigateToDashboard(state.user);
        } else if (state is AuthRegistrationIncomplete) {
          // User logged in BUT registration incomplete → Go to Registration
          _navigateToRegistration(state.user);
        } else if (state is AuthError) {
          // Error occurred → Show error and go to login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue[700],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'MedFinder',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find Your Medicine Easily',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDashboard(UserEntity user) {
    final role = user.role?.trim().toLowerCase();

    if (role == 'patient') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PatientDashboard(userId: user.id)),
            (route) => false,
      );
    } else if (role == 'pharmacyowner') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PharmacyDashboardPage(userId: user.id)),
            (route) => false,
      );
    } else {
      // Fallback to login if role is unknown
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }

  void _navigateToRegistration(UserEntity user) {
    final role = user.role?.trim().toLowerCase();

    if (role == 'patient') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PatientRegistrationPage(user: user)),
            (route) => false,
      );
    } else if (role == 'pharmacyowner') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PharmacyRegistrationPage(user: user.id)),
            (route) => false,
      );
    } else {
      // Fallback to login if role is unknown
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }
}