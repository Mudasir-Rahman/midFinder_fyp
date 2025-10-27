//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:async';
// import 'package:rx_locator/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:rx_locator/features/auth/presentation/bloc/auth_event.dart';
// import 'package:rx_locator/features/auth/presentation/bloc/auth_state.dart';
// import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
// import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
// import '../../auth/domain/entities/user_entities.dart';
//
// const int _kMinimumSplashDurationSeconds = 3;
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);
//
//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//   final _splashTimerCompleter = Completer<void>();
//   bool _navigated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startSplashTimer();
//
//     // delay slightly to allow session restore before checking
//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (mounted) context.read<AuthBloc>().add(CheckAuthStatusEvent());
//     });
//   }
//
//   void _startSplashTimer() {
//     Future.delayed(
//       const Duration(seconds: _kMinimumSplashDurationSeconds),
//           () => _splashTimerCompleter.complete(),
//     );
//   }
//
//   Future<void> _handleNavigation(BuildContext context, AppAuthState state) async {
//     await _splashTimerCompleter.future;
//     if (!mounted || _navigated) return;
//
//     print('=== SPLASH NAVIGATION DEBUG ===');
//     print('State: ${state.runtimeType}');
//     if (state is AuthRegistrationIncomplete ||
//         state is AuthRegistrationComplete ||
//         state is AuthAuthenticated) {
//       final user = state is AuthRegistrationIncomplete
//           ? state.user
//           : state is AuthRegistrationComplete
//           ? state.user
//           : (state as AuthAuthenticated).user;
//       print('User: ${user.email}');
//       print('Role: ${user.role}');
//     }
//     print('==============================');
//
//     if (state is AuthUnauthenticated) {
//       // debounce unauthenticated to avoid early redirect
//       await Future.delayed(const Duration(seconds: 3));
//       if (mounted && !_navigated) {
//         _navigateToLogin(context);
//       }
//     } else if (state is AuthRegistrationIncomplete) {
//       _navigateToRegistration(context, state.user);
//     } else if (state is AuthRegistrationComplete || state is AuthAuthenticated) {
//       _navigateToDashboard(context, state);
//     }
//   }
//
//   void _navigateToLogin(BuildContext context) {
//     if (_navigated) return;
//     _navigated = true;
//     print('🚀 Navigating to Login Page');
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//           (route) => false,
//     );
//   }
//
//   void _navigateToRegistration(BuildContext context, UserEntity user) {
//     if (_navigated) return;
//     _navigated = true;
//     final role = user.role?.trim().toLowerCase();
//     print('🚀 Navigating to Registration - Role: $role');
//
//     if (role == 'patient') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PatientRegistrationPage(user: user)),
//             (route) => false,
//       );
//     } else if (role == 'pharmacyowner') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PharmacyRegistrationPage(user: user)),
//             (route) => false,
//       );
//     } else {
//       print('❌ Unknown role: $role - Falling back to login');
//       _navigateToLogin(context);
//     }
//   }
//
//   void _navigateToDashboard(BuildContext context, AppAuthState state) {
//     if (_navigated) return;
//     _navigated = true;
//
//     final user = state is AuthRegistrationComplete
//         ? state.user
//         : (state as AuthAuthenticated).user;
//     final role = user.role?.trim().toLowerCase();
//
//     print('🚀 Navigating to Dashboard - Role: $role');
//
//     if (role == 'patient') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PatientDashboard(userId: user.id)),
//             (route) => false,
//       );
//     } else if (role == 'pharmacyowner') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PharmacyDashboardPage(userId: user.id)),
//             (route) => false,
//       );
//     } else {
//       print('❌ Unknown role: $role - Falling back to login');
//       _navigateToLogin(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AppAuthState>(
//       listener: (context, state) {
//         print('🔐 Splash Auth State: ${state.runtimeType}');
//         _handleNavigation(context, state);
//       },
//       child: Scaffold(
//         backgroundColor: Colors.teal.shade700,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.medication_liquid_outlined,
//                   size: 64,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Rx Locator',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.white,
//                   letterSpacing: 2,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Your Medicine Finder',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white70,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//               const SizedBox(height: 50),
//               const CircularProgressIndicator(
//                 strokeWidth: 4,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:rx_locator/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rx_locator/features/auth/presentation/bloc/auth_event.dart';
import 'package:rx_locator/features/auth/presentation/bloc/auth_state.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';

import '../../auth/domain/entities/user_entities.dart';
import '../../patient/presentation/pages/pages/PatientDashboardPage.dart';

const int _kMinimumSplashDurationSeconds = 3;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _splashTimerCompleter = Completer<void>();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();

    // delay slightly to allow session restore before checking
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }

  void _startSplashTimer() {
    Future.delayed(
      const Duration(seconds: _kMinimumSplashDurationSeconds),
          () => _splashTimerCompleter.complete(),
    );
  }

  Future<void> _handleNavigation(BuildContext context, AppAuthState state) async {
    await _splashTimerCompleter.future;
    if (!mounted || _navigated) return;

    print('=== SPLASH NAVIGATION DEBUG ===');
    print('State: ${state.runtimeType}');
    if (state is AuthRegistrationIncomplete ||
        state is AuthRegistrationComplete ||
        state is AuthAuthenticated) {
      final user = state is AuthRegistrationIncomplete
          ? state.user
          : state is AuthRegistrationComplete
          ? state.user
          : (state as AuthAuthenticated).user;
      print('User: ${user.email}');
      print('Role: ${user.role}');
    }
    print('==============================');

    if (state is AuthUnauthenticated) {
      // debounce unauthenticated to avoid early redirect
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && !_navigated) {
        _navigateToLogin(context);
      }
    } else if (state is AuthRegistrationIncomplete) {
      _navigateToRegistration(context, state.user);
    } else if (state is AuthRegistrationComplete || state is AuthAuthenticated) {
      _navigateToDashboard(context, state);
    }
  }

  void _navigateToLogin(BuildContext context) {
    if (_navigated) return;
    _navigated = true;
    print('🚀 Navigating to Login Page');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  void _navigateToRegistration(BuildContext context, UserEntity user) {
    if (_navigated) return;
    _navigated = true;
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
      print('❌ Unknown role: $role - Falling back to login');
      _navigateToLogin(context);
    }
  }

  void _navigateToDashboard(BuildContext context, AppAuthState state) {
    if (_navigated) return;
    _navigated = true;

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
      print('❌ Unknown role: $role - Falling back to login');
      _navigateToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AppAuthState>(
      listener: (context, state) {
        print('🔐 Splash Auth State: ${state.runtimeType}');
        _handleNavigation(context, state);
      },
      child: Scaffold(
        backgroundColor: Colors.teal.shade700,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_liquid_outlined,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Rx Locator',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
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
              const CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}