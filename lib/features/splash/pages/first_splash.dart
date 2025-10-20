
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async'; // Import for Future.delayed

import 'package:rx_locator/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rx_locator/features/auth/presentation/bloc/auth_event.dart';
import 'package:rx_locator/features/auth/presentation/bloc/auth_state.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';

import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';

import '../../auth/domain/entities/user_entities.dart';
import '../../patient/presentation/pages/pages/PatientDashboardPage.dart';
import '../../patient/presentation/pages/pages/patient_registration_page.dart';

// Define the minimum duration for the splash screen
const int _kMinimumSplashDurationSeconds = 3;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // A Completer to track when the minimum display time has passed
  final _splashTimerCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    // 1. Start the minimum 3-second timer
    _startSplashTimer();

    // 2. Trigger auth check immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }

  void _startSplashTimer() {
    Future.delayed(
      const Duration(seconds: _kMinimumSplashDurationSeconds),
          () {
        if (!_splashTimerCompleter.isCompleted) {
          _splashTimerCompleter.complete();
        }
      },
    );
  }

  // ✅ ADD THIS METHOD: Handle navigation based on auth state
  void _handleNavigation(BuildContext context, AppAuthState state) async {
    // Wait until the minimum 3 seconds have passed
    await _splashTimerCompleter.future;

    print('=== SPLASH NAVIGATION DEBUG ===');
    print('State: ${state.runtimeType}');
    if (state is AuthRegistrationIncomplete) {
      print('User: ${state.user.email}');
      print('Role: ${state.user.role}');
    } else if (state is AuthRegistrationComplete) {
      print('User: ${state.user.email}');
      print('Role: ${state.user.role}');
    } else if (state is AuthAuthenticated) {
      print('User: ${state.user.email}');
      print('Role: ${state.user.role}');
    }
    print('==============================');

    if (!mounted) return;

    if (state is AuthUnauthenticated) {
      _navigateToLogin(context);
    } else if (state is AuthRegistrationIncomplete) {
      _navigateToRegistration(context, state.user);
    } else if (state is AuthRegistrationComplete || state is AuthAuthenticated) {
      _navigateToDashboard(context, state);
    }
  }

  // ✅ ADD THIS METHOD: Navigate to login
  void _navigateToLogin(BuildContext context) {
    print('🚀 Navigating to Login Page');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  // ✅ ADD THIS METHOD: Navigate to registration based on role
  void _navigateToRegistration(BuildContext context, UserEntity user) {
    final role = user.role?.trim().toLowerCase();
    print('🚀 Navigating to Registration - Role: $role');

    if (role == 'patient') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PatientRegistrationPage(user: user)),
            (route) => false,
      );
    } else if (role == 'pharmacyowner') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PharmacyRegistrationPage(user: user)),
            (route) => false,
      );
    } else {
      // Fallback to login if role is unknown
      print('❌ Unknown role: $role - Falling back to login');
      _navigateToLogin(context);
    }
  }

  // ✅ ADD THIS METHOD: Navigate to dashboard based on role
  void _navigateToDashboard(BuildContext context, AppAuthState state) {
    final user = state is AuthRegistrationComplete
        ? state.user
        : (state as AuthAuthenticated).user;
    final role = user.role?.trim().toLowerCase();

    print('🚀 Navigating to Dashboard - Role: $role');

    if (role == 'patient') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PatientDashboard(userId: user.id)),
            (route) => false,
      );
    } else if (role == 'pharmacyowner') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PharmacyDashboardPage(userId: user.id)),
            (route) => false,
      );
    } else {
      // Fallback to login if role is unknown
      print('❌ Unknown role: $role - Falling back to login');
      _navigateToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AppAuthState>(
      // Listener calls the navigation handler, which now waits for the timer.
      listener: (context, state) {
        print('🔐 Splash Auth State: ${state.runtimeType}');

        // Only attempt navigation on final states, not loading/initial
        if (state is AuthUnauthenticated ||
            state is AuthRegistrationIncomplete ||
            state is AuthRegistrationComplete ||
            state is AuthAuthenticated) {
          _handleNavigation(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue[800], // Slightly deeper color for polish
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enhanced app logo/icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_liquid_outlined, // A different, modern icon
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Rx Locator',
                style: TextStyle(
                  fontSize: 36, // Larger font
                  fontWeight: FontWeight.w900, // Extra bold
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Medicine Finder',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 50),
              CircularProgressIndicator(
                strokeWidth: 4, // Thicker indicator
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}