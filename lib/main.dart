import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constant/app_color.dart';
import 'core/keys/app_secret.dart';
import 'core/services/image_upload_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/medicine/presentation/bloc/medicine_bloc.dart';
import 'features/patient/presentation/bloc/patient_bloc.dart';
import 'features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
import 'features/splash/pages/first_splash.dart';
import 'init_dependence.dart';

// ✅ ADD FAVORITE BLOC IMPORT
import 'features/patient/presentation/bloc/favorite_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔵 Starting app initialization...');

  await _initializeSupabase();
  await _initializeDependencies();

  runApp(const MyApp());
}

/// =======================================================
/// SUPABASE INITIALIZATION (CORRECT VERSION)
/// =======================================================
Future<void> _initializeSupabase() async {
  try {
    print('🔵 Initializing Supabase...');
    await Supabase.initialize(
      url: SupabaseKeys.url,
      anonKey: SupabaseKeys.anonKey,
      debug: true, // Keep true for debugging auth issues
    );
    print('✅ Supabase initialized successfully');

    // ✅ Check current session on startup
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;
    print('🔐 Startup Auth Check:');
    print('   Session: ${session != null}');
    print('   User: ${user?.email}');
    print('   User ID: ${user?.id}');

  } catch (e, st) {
    print('❌ Failed to initialize Supabase: $e');
    print(st);
    rethrow;
  }
}

/// =======================================================
/// DEPENDENCY INJECTION INITIALIZATION
/// =======================================================
Future<void> _initializeDependencies() async {
  try {
    print('🔵 Initializing dependencies...');
    await init(); // ✅ Changed from initDependencies() to init()
    print('✅ Dependencies initialized successfully');

    // Optional: Verify registrations (safe debug checks)
    try {
      sl<ImageUploadService>();
      print('✅ ImageUploadService registered correctly.');
    } catch (e) {
      print('❌ ImageUploadService registration failed: $e');
    }

    try {
      sl<MedicineBloc>();
      print('✅ MedicineBloc created successfully.');
    } catch (e) {
      print('❌ MedicineBloc creation failed: $e');
    }

    // ✅ ADD FAVORITE BLOC VERIFICATION
    try {
      sl<FavoriteBloc>();
      print('✅ FavoriteBloc created successfully.');
    } catch (e) {
      print('❌ FavoriteBloc creation failed: $e');
    }
  } catch (e, st) {
    print('❌ Dependency initialization failed: $e');
    print(st);
    rethrow;
  }
}

/// =======================================================
/// ROOT APP WIDGET WITH AUTH STATE MANAGEMENT
/// =======================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
    _setupAuthListener();
  }

  // ✅ Initialize auth state and check current user
  void _initializeAuth() {
    final user = _supabase.auth.currentUser;
    setState(() {
      _currentUser = user;
    });

    print('🔐 App Startup - User: ${user?.email}');

    // If user exists, we'll handle auth status in the SplashPage
    if (user != null) {
      print('✅ User found on startup: ${user.email}');
    }
  }

  // ✅ Listen for auth state changes
  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      final User? user = data.session?.user;

      print('🔐 Auth State Changed: $event');
      print('   User: ${user?.email}');
      print('   Session: ${session != null}');

      setState(() {
        _currentUser = user;
      });

      // Handle auth events
      if (event == AuthChangeEvent.signedIn && user != null) {
        print('✅ User signed in: ${user.email}');
      } else if (event == AuthChangeEvent.signedOut) {
        print('🚪 User signed out');
        setState(() {
          _currentUser = null;
        });
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        print('🔄 Token refreshed for: ${user?.email}');
      } else if (event == AuthChangeEvent.userUpdated) {
        print('👤 User updated: ${user?.email}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<PatientBloc>()),
        BlocProvider(create: (_) => sl<PharmacyBloc>()),
        BlocProvider(create: (_) => sl<MedicineBloc>()),
        // ✅ ADD FAVORITE BLOC PROVIDER
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
      ],
      child: MaterialApp(
        title: 'Rx Locator',
        debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}