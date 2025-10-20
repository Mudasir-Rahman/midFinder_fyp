// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/features/auth/presentation/pages/sign_up.dart';
// import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
//
// // Assuming these are your custom imports
// import '../../../../core/utils/Validators.dart';
// import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
// import '../../domain/entities/user_entities.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/auth_fields.dart';
// import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
//
// // --- Constants for a Professional Look ---
// const Color kPrimaryColor = Color(0xFF004D99); // Darker, Corporate Blue
// const Color kAccentColor = Color(0xFF4DB6AC); // Calming Medical Teal Accent
// const Color kBackgroundColor = Color(0xFFFAFAFA); // Off-white/Light Gray Background
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
//       MaterialPageRoute(builder: (context) => const SignUpPage()),
//           (route) => false,
//     );
//   }
//
//   void _goToDashboard(UserEntity user) {
//     final role = user.role?.trim().toLowerCase();
//     if (role == 'patient') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PatientDashboard(userId: user.id)),
//             (route) => false,
//       );
//     } else if (role == 'pharmacyowner') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (_) => PharmacyDashboardPage(userId: user.id)),
//             (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         _buildCustomSnackBar(
//             content: "Unknown role detected",
//             color: Colors.orange,
//             icon: Icons.warning_amber),
//       );
//     }
//   }
//
//   void _goToRegistration(UserEntity user) {
//     final role = user.role?.trim().toLowerCase();
//     if (role == 'patient') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PatientRegistrationPage(user: user)),
//             (route) => false,
//       );
//     } else if (role == 'pharmacyowner') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (_) => PharmacyRegistrationPage(user: user)),
//             (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         _buildCustomSnackBar(
//             content: "Unknown role detected",
//             color: Colors.orange,
//             icon: Icons.warning_amber),
//       );
//     }
//   }
//
//   // --- Utility SnackBar Widget for feedback ---
//   SnackBar _buildCustomSnackBar(
//       {required String content, required Color color, required IconData icon}) {
//     return SnackBar(
//       content: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 20),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(content,
//                   style: const TextStyle(fontWeight: FontWeight.w600))),
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
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthLoading) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             _buildCustomSnackBar(
//                 content: 'Signing in...',
//                 color: kAccentColor,
//                 icon: Icons.login),
//           );
//         } else if (state is AuthRegistrationComplete) {
//           _goToDashboard(state.user);
//         } else if (state is AuthRegistrationIncomplete) {
//           _goToRegistration(state.user);
//         } else if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             _buildCustomSnackBar(
//                 content: state.message,
//                 color: const Color(0xFFD32F2F), // Danger Red
//                 icon: Icons.error_outline),
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
//   // --- Final Polish Header Section ---
//   Widget _buildHeaderSection() {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.35,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             kPrimaryColor,
//             kAccentColor.withOpacity(0.9), // Blend primary and accent
//           ],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(55), // Large, smooth curve
//           bottomRight: Radius.circular(55), // Large, smooth curve
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: kPrimaryColor.withOpacity(0.5),
//             blurRadius: 30, // Stronger shadow
//             offset: const Offset(0, 15),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Background stylized medical cross pattern
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Opacity(
//               opacity: 0.1,
//               child: Icon(
//                 Icons.add_box_rounded, // Subtle, abstract background element
//                 size: 200,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//                 top: 24, left: 24, right: 24, bottom: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button (If it exists)
//                 if (Navigator.canPop(context))
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back_ios_new_rounded,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )
//                 else
//                   const SizedBox(height: 16), // Top spacing if no back button
//
//                 const Spacer(flex: 2), // Pushes the text down slightly
//                 const Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 42, // Maximum size for impact
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Sign in to continue your medical journey',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white.withOpacity(0.9),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Spacer(flex: 1), // Keeps text high
//               ],
//             ),
//           ),
//           // Floating Icon Card - Perfectly centered on the curve
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
//                       color: Colors.black.withOpacity(0.25),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.local_hospital_rounded,
//                   size: 40,
//                   color: kPrimaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- Final Polish Login Form Section ---
//   Widget _buildLoginForm() {
//     return Padding(
//       // Adjusted top padding to visually integrate with the floating icon
//       padding: const EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 32.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Email Field
//             AuthTextField(
//               controller: _emailController,
//               labelText: 'Email Address',
//               prefixIcon: Icons.alternate_email_rounded,
//               validator: Validators.validateEmail,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 24),
//
//             // Password Field
//             AuthTextField(
//               controller: _passwordController,
//               labelText: 'Password',
//               prefixIcon: Icons.lock_outline_rounded,
//               isObscureText: _obscurePassword,
//               validator: Validators.validatePassword,
//               suffixWidget: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//                 icon: Icon(
//                   _obscurePassword
//                       ? Icons.visibility_rounded
//                       : Icons.visibility_off_rounded,
//                   color: kPrimaryColor.withOpacity(0.7),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Forgot Password Link
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   // TODO: Implement Forgot Password Logic
//                 },
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   minimumSize: const Size(50, 30),
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//                 child: const Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     color: kPrimaryColor,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Sign In Button (Primary Action)
//             BlocBuilder<AuthBloc, AuthState>(
//               builder: (context, state) {
//                 return AuthButton(
//                   onPressed: state is AuthLoading ? null : _login,
//                   text: 'Sign In',
//                   isLoading: state is AuthLoading,
//                   // Assuming AuthButton uses the kPrimaryColor gradient
//                 );
//               },
//             ),
//             const SizedBox(height: 40),
//
//             // Divider
//             Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     color: Colors.grey.shade400,
//                     thickness: 1,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     'Or connect using',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Divider(
//                     color: Colors.grey.shade400,
//                     thickness: 1,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Social Buttons (Secondary Action - Outlined Style)
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildSocialButton(
//                     icon: Icons.g_mobiledata_rounded,
//                     label: 'Google',
//                     onPressed: () {},
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildSocialButton(
//                     icon: Icons.facebook,
//                     label: 'Facebook',
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//
//             // Sign Up Link
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account? ",
//                     style: TextStyle(
//                       color: Colors.grey.shade700,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _navigateToSignUp,
//                     child: const Text(
//                       'Sign Up',
//                       style: TextStyle(
//                         color: kPrimaryColor,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                         decoration: TextDecoration.underline,
//                         decorationColor: kPrimaryColor,
//                         decorationThickness: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- Outlined Social Button Style ---
//   Widget _buildSocialButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       style: OutlinedButton.styleFrom(
//         foregroundColor: kPrimaryColor,
//         side: BorderSide(color: Colors.grey.shade400, width: 1.5),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(kBorderRadius),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       icon: Icon(
//         icon,
//         color: kPrimaryColor,
//         size: 24,
//       ),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: Colors.grey.shade800,
//           fontWeight: FontWeight.w600,
//           fontSize: 15,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/auth/presentation/pages/sign_up.dart';
import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';

// Assuming these are your custom imports
import '../../../../core/utils/Validators.dart';
import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
import '../../domain/entities/user_entities.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_fields.dart';
import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';

// --- Constants for a Professional Look ---
const Color kPrimaryColor = Color(0xFF004D99); // Darker, Corporate Blue
const Color kAccentColor = Color(0xFF4DB6AC); // Calming Medical Teal Accent
const Color kBackgroundColor = Color(0xFFFAFAFA); // Off-white/Light Gray Background
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
      MaterialPageRoute(builder: (context) => const SignUpPage()),
          (route) => false,
    );
  }

  void _goToDashboard(UserEntity user) {
    final role = user.role?.trim().toLowerCase();
    print('🔄 Navigating to dashboard - Role: $role, User ID: ${user.id}');

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
      // ✅ FIXED: If user has no role, send them to pharmacy dashboard as default
      print('⚠️ User has no role, navigating to pharmacy dashboard as default');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PharmacyDashboardPage(userId: user.id)),
            (route) => false,
      );
    }
  }

  void _goToRegistration(UserEntity user) {
    final role = user.role?.trim().toLowerCase();
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
            content: "Unknown role detected",
            color: Colors.orange,
            icon: Icons.warning_amber),
      );
    }
  }

  // --- Debug method to see auth state ---
  void _debugAuthState(AppAuthState state) {
    print('=== AUTH STATE UPDATE ===');
    print('State: ${state.runtimeType}');
    if (state is AuthAuthenticated) {
      print('User: ${state.user.email}');
      print('Role: ${state.user.role}');
      print('ID: ${state.user.id}');
    } else if (state is AuthRegistrationComplete) {
      print('Registration Complete - User: ${state.user.email}');
    } else if (state is AuthRegistrationIncomplete) {
      print('Registration Incomplete - User: ${state.user.email}');
    } else if (state is AuthError) {
      print('Error: ${state.message}');
    }
    print('========================');
  }

  // --- Utility SnackBar Widget for feedback ---
  SnackBar _buildCustomSnackBar(
      {required String content, required Color color, required IconData icon}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(content,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
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
        _debugAuthState(state); // Debug logging

        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildCustomSnackBar(
                content: 'Signing in...',
                color: kAccentColor,
                icon: Icons.login),
          );
        } else if (state is AuthAuthenticated) {
          // ✅ FIXED: Handle authenticated state (user exists but no role/registration check)
          print('✅ User authenticated: ${state.user.email}');
          _goToDashboard(state.user);
        } else if (state is AuthRegistrationComplete) {
          _goToDashboard(state.user);
        } else if (state is AuthRegistrationIncomplete) {
          _goToRegistration(state.user);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildCustomSnackBar(
                content: state.message,
                color: const Color(0xFFD32F2F), // Danger Red
                icon: Icons.error_outline),
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

  // --- Final Polish Header Section ---
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor,
            kAccentColor.withOpacity(0.9), // Blend primary and accent
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(55), // Large, smooth curve
          bottomRight: Radius.circular(55), // Large, smooth curve
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.5),
            blurRadius: 30, // Stronger shadow
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background stylized medical cross pattern
          Positioned(
            top: 20,
            right: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.add_box_rounded, // Subtle, abstract background element
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 24, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button (If it exists)
                if (Navigator.canPop(context))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 16), // Top spacing if no back button

                const Spacer(flex: 2), // Pushes the text down slightly
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 42, // Maximum size for impact
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue your medical journey',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 1), // Keeps text high
              ],
            ),
          ),
          // Floating Icon Card - Perfectly centered on the curve
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
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Final Polish Login Form Section ---
  Widget _buildLoginForm() {
    return Padding(
      // Adjusted top padding to visually integrate with the floating icon
      padding: const EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 32.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Field
            AuthTextField(
              controller: _emailController,
              labelText: 'Email Address',
              prefixIcon: Icons.alternate_email_rounded,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Password Field
            AuthTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              isObscureText: _obscurePassword,
              validator: Validators.validatePassword,
              suffixWidget: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: kPrimaryColor.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement Forgot Password Logic
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Sign In Button (Primary Action)
            BlocBuilder<AuthBloc, AppAuthState>(
              builder: (context, state) {
                return AuthButton(
                  onPressed: state is AuthLoading ? null : _login,
                  text: 'Sign In',
                  isLoading: state is AuthLoading,
                  // Assuming AuthButton uses the kPrimaryColor gradient
                );
              },
            ),
            const SizedBox(height: 40),

            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or connect using',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Social Buttons (Secondary Action - Outlined Style)
            Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Google',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.facebook,
                    label: 'Facebook',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Sign Up Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: kPrimaryColor,
                        decorationThickness: 2,
                      ),
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

  // --- Outlined Social Button Style ---
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      icon: Icon(
        icon,
        color: kPrimaryColor,
        size: 24,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}