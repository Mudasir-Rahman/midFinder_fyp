//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/features/auth/presentation/pages/sign_up.dart';
// import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
// import '../../../../core/utils/Validators.dart';
// import '../../domain/entities/user_entities.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/auth_fields.dart';
// import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
//
// // --- Constants ---
// const Color kPrimaryColor = Color(0xFF004D99);
// const Color kAccentColor = Color(0xFF4DB6AC);
// const Color kBackgroundColor = Color(0xFFFAFAFA);
// const double kBorderRadius = 16.0;
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _hasNavigated = false; // Prevents double navigation
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//         LoginEvent(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         ),
//       );
//     }
//   }
//
//   void _navigateToSignUp() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const SignUpPage()),
//           (route) => false,
//     );
//   }
//
//   void _goToDashboard(UserEntity user) {
//     if (_hasNavigated) return; // Stop multiple redirects
//     _hasNavigated = true;
//
//     final role = user.role?.trim().toLowerCase();
//     debugPrint('🚀 Navigating to Dashboard | Role: $role | ID: ${user.id}');
//
//     Future.microtask(() {
//       if (role == 'patient') {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PatientDashboard(userId: user.id),
//           ),
//               (route) => false,
//         );
//       } else if (role == 'pharmacyowner') {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PharmacyDashboardPage(userId: user.id),
//           ),
//               (route) => false,
//         );
//       } else {
//         debugPrint('⚠️ Unknown role detected. Defaulting to Pharmacy Dashboard.');
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PharmacyDashboardPage(userId: user.id),
//           ),
//               (route) => false,
//         );
//       }
//     });
//   }
//
//   void _goToRegistration(UserEntity user) {
//     if (_hasNavigated) return;
//     _hasNavigated = true;
//
//     final role = user.role?.trim().toLowerCase();
//     Future.microtask(() {
//       if (role == 'patient') {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => PatientRegistrationPage(user: user)),
//               (route) => false,
//         );
//       } else if (role == 'pharmacyowner') {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => PharmacyRegistrationPage(user: user)),
//               (route) => false,
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           _buildCustomSnackBar(
//             content: 'Unknown role detected',
//             color: Colors.orange,
//             icon: Icons.warning_amber,
//           ),
//         );
//       }
//     });
//   }
//
//   SnackBar _buildCustomSnackBar({
//     required String content,
//     required Color color,
//     required IconData icon,
//   }) {
//     return SnackBar(
//       content: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 20),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(
//                 content,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               )),
//         ],
//       ),
//       backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(15),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AppAuthState>(
//       listener: (context, state) {
//         if (state is AuthAuthenticated) {
//           debugPrint('✅ Authenticated: ${state.user.email}');
//           _goToDashboard(state.user);
//         } else if (state is AuthRegistrationComplete) {
//           _goToDashboard(state.user);
//         } else if (state is AuthRegistrationIncomplete) {
//           _goToRegistration(state.user);
//         } else if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             _buildCustomSnackBar(
//               content: state.message,
//               color: Colors.red,
//               icon: Icons.error_outline,
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: kBackgroundColor,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderSection(),
//                 _buildLoginForm(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Header UI ---
//   Widget _buildHeaderSection() {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.35,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [kPrimaryColor, kAccentColor.withOpacity(0.9)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(55),
//           bottomRight: Radius.circular(55),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: kPrimaryColor.withOpacity(0.4),
//             blurRadius: 25,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Opacity(
//               opacity: 0.1,
//               child: Icon(Icons.add_box_rounded, size: 200, color: Colors.white),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Spacer(),
//                 const Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Sign in to continue your medical journey',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: -35,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(kBorderRadius),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 15,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.local_hospital_rounded, size: 40, color: kPrimaryColor),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- Login Form UI ---
//   Widget _buildLoginForm() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             AuthTextField(
//               controller: _emailController,
//               labelText: 'Email Address',
//               prefixIcon: Icons.alternate_email_rounded,
//               validator: Validators.validateEmail,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 24),
//             AuthTextField(
//               controller: _passwordController,
//               labelText: 'Password',
//               prefixIcon: Icons.lock_outline_rounded,
//               isObscureText: _obscurePassword,
//               validator: Validators.validatePassword,
//               suffixWidget: IconButton(
//                 onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                   color: kPrimaryColor.withOpacity(0.7),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: const Text('Forgot Password?', style: TextStyle(color: kPrimaryColor)),
//               ),
//             ),
//             const SizedBox(height: 32),
//             BlocBuilder<AuthBloc, AppAuthState>(
//               builder: (context, state) {
//                 return AuthButton(
//                   onPressed: state is AuthLoading ? null : _login,
//                   text: 'Sign In',
//                   isLoading: state is AuthLoading,
//                 );
//               },
//             ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account? "),
//                 GestureDetector(
//                   onTap: _navigateToSignUp,
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       color: kPrimaryColor,
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // --- Simple PatientDashboard Example ---
// class PatientDashboard extends StatelessWidget {
//   final String userId;
//
//   const PatientDashboard({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Patient Dashboard")),
//       body: Center(child: Text("Welcome, $userId")),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/auth/presentation/pages/sign_up.dart';
import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';

import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
import '../../../../core/utils/Validators.dart';
import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
import '../../domain/entities/user_entities.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_fields.dart';
import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';

// --- Constants ---
const Color kPrimaryColor = Color(0xFF004D99);
const Color kAccentColor = Color(0xFF4DB6AC);
const Color kBackgroundColor = Color(0xFFFAFAFA);
const double kBorderRadius = 16.0;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _hasNavigated = false; // Prevents double navigation

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
          (route) => false,
    );
  }

  void _goToDashboard(UserEntity user) {
    if (_hasNavigated) return; // Stop multiple redirects
    _hasNavigated = true;

    final role = user.role?.trim().toLowerCase();
    debugPrint('🚀 Navigating to Dashboard | Role: $role | ID: ${user.id}');

    Future.microtask(() {
      if (role == 'patient') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PatientDashboard(userId: user.id), // ✅ USES ACTUAL DASHBOARD
          ),
              (route) => false,
        );
      } else if (role == 'pharmacyowner') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PharmacyDashboardPage(userId: user.id),
          ),
              (route) => false,
        );
      } else {
        debugPrint('⚠️ Unknown role detected. Defaulting to Pharmacy Dashboard.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PharmacyDashboardPage(userId: user.id),
          ),
              (route) => false,
        );
      }
    });
  }

  void _goToRegistration(UserEntity user) {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final role = user.role?.trim().toLowerCase();
    Future.microtask(() {
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
        ScaffoldMessenger.of(context).showSnackBar(
          _buildCustomSnackBar(
            content: 'Unknown role detected',
            color: Colors.orange,
            icon: Icons.warning_amber,
          ),
        );
      }
    });
  }

  SnackBar _buildCustomSnackBar({
    required String content,
    required Color color,
    required IconData icon,
  }) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
                content,
                style: const TextStyle(fontWeight: FontWeight.w600),
              )),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          debugPrint('✅ Authenticated: ${state.user.email}');
          _goToDashboard(state.user);
        } else if (state is AuthRegistrationComplete) {
          _goToDashboard(state.user);
        } else if (state is AuthRegistrationIncomplete) {
          _goToRegistration(state.user);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildCustomSnackBar(
              content: state.message,
              color: Colors.red,
              icon: Icons.error_outline,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header UI ---
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kAccentColor.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(55),
          bottomRight: Radius.circular(55),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.add_box_rounded, size: 200, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue your medical journey',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            bottom: -35,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.local_hospital_rounded, size: 40, color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Login Form UI ---
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _emailController,
              labelText: 'Email Address',
              prefixIcon: Icons.alternate_email_rounded,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            AuthTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              isObscureText: _obscurePassword,
              validator: Validators.validatePassword,
              suffixWidget: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: kPrimaryColor.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?', style: TextStyle(color: kPrimaryColor)),
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AppAuthState>(
              builder: (context, state) {
                return AuthButton(
                  onPressed: state is AuthLoading ? null : _login,
                  text: 'Sign In',
                  isLoading: state is AuthLoading,
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: _navigateToSignUp,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ REMOVE THIS LOCAL WIDGET - IT'S CAUSING THE CONFLICT
// class PatientDashboard extends StatelessWidget {
//   final String userId;
//
//   const PatientDashboard({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Patient Dashboard")),
//       body: Center(child: Text("Welcome, $userId")),
//     );
//   }
// }