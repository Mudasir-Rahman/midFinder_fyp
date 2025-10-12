// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/core/constant/app_color.dart';
//
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import 'core/keys/app_secret.dart';
// import 'features/auth/presentation/bloc/auth_bloc.dart';
// import 'features/splash/pages/first_splash.dart';
// import 'init_dependence.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Supabase first
//   await _initializeSupabase();
//
//   // Then initialize dependencies
//   await _initializeDependencies();
//
//   runApp(const MyApp());
// }
//
// Future<void> _initializeSupabase() async {
//   try {
//     await Supabase.initialize(
//       url: SupabaseKeys.url,
//       anonKey: SupabaseKeys.anonKey,
//       debug: false, // Set to true for development
//     );
//   } catch (e) {
//     throw Exception('Failed to initialize Supabase: $e');
//   }
// }
//
// Future<void> _initializeDependencies() async {
//   try {
//     await initDependencies();
//   } catch (e) {
//     throw Exception('Failed to initialize dependencies: $e');
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => sl<AuthBloc>(),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Rx Locator',
//         theme: ThemeData(
//           primaryColor: AppColor.primaryColor,
//           scaffoldBackgroundColor: AppColor.backgroundColor,
//           appBarTheme: const AppBarTheme(
//             backgroundColor: AppColor.primaryColor,
//             elevation: 0,
//             centerTitle: true,
//             iconTheme: IconThemeData(color: AppColor.whiteColor),
//           ),
//           inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//             fillColor: AppColor.backgroundColor,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColor.lightGreyColor),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColor.lightGreyColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 color: AppColor.primaryColor,
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//         home: const SplashPage(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/core/constant/app_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/keys/app_secret.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/patient/presentation/bloc/patient_bloc.dart';
import 'features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
import 'features/splash/pages/first_splash.dart';
import 'init_dependence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase first
  await _initializeSupabase();

  // Then initialize dependencies
  await _initializeDependencies();

  runApp(const MyApp());
}

Future<void> _initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: SupabaseKeys.url,
      anonKey: SupabaseKeys.anonKey,
      debug: false, // Set to true for development
    );
  } catch (e) {
    throw Exception('Failed to initialize Supabase: $e');
  }
}

Future<void> _initializeDependencies() async {
  try {
    await initDependencies();
  } catch (e) {
    throw Exception('Failed to initialize dependencies: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<PatientBloc>(
          create: (context) => sl<PatientBloc>(),
        ),
        BlocProvider<PharmacyBloc>(
          create: (context) => sl<PharmacyBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Rx Locator',
        theme: ThemeData(
          primaryColor: AppColor.primaryColor,
          scaffoldBackgroundColor: AppColor.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColor.whiteColor),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColor.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.lightGreyColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.lightGreyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}