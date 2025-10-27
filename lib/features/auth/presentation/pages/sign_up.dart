//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
// import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
// import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
// import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
// import '../../domain/entities/user_entities.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   String _selectedRole = 'patient';
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//
//   void _signUp() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//         SignUpEvent(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//           role: _selectedRole,
//         ),
//       );
//     }
//   }
//
//   void _goToDashboard(UserEntity user) {
//     final role = user.role?.trim().toLowerCase();
//     print('🔄 SignUp - Navigating to dashboard - Role: $role, User ID: ${user.id}');
//
//     if (role == 'patient') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PatientDashboard(userId: user.id, nearbyPharmacies: [], medicines: [],)),
//             (route) => false,
//       );
//     } else if (role == 'pharmacyowner') {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => PharmacyDashboardPage(userId: user.id)),
//             (route) => false,
//       );
//     } else {
//       // ❌ User has no role - THIS SHOULD NOT HAPPEN
//       // Show error and redirect to login
//       print('❌ CRITICAL: User has no role after signup');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Account creation issue. Please login again.'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 5),
//         ),
//       );
//       _navigateToLogin();
//     }
//   }
//
//   void _goToRegistration(UserEntity user) {
//     final role = user.role?.trim().toLowerCase();
//     print('🔄 SignUp - Navigating to registration - Role: $role, User ID: ${user.id}');
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
//       // ❌ User has no role - THIS SHOULD NOT HAPPEN
//       print('❌ CRITICAL: User has no role for registration');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Account creation issue. Please login again.'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 5),
//         ),
//       );
//       _navigateToLogin();
//     }
//   }
//
//   void _navigateToLogin() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       body: BlocListener<AuthBloc, AppAuthState>(
//         listener: (context, state) {
//           // Add debug logging
//           print('=== SIGNUP STATE UPDATE ===');
//           print('State: ${state.runtimeType}');
//           if (state is AuthAuthenticated) {
//             print('✅ User authenticated: ${state.user.email}');
//             print('✅ User role: ${state.user.role}');
//             print('✅ User ID: ${state.user.id}');
//           } else if (state is AuthRegistrationComplete) {
//             print('✅ Registration Complete - User: ${state.user.email}');
//             print('✅ User role: ${state.user.role}');
//           } else if (state is AuthRegistrationIncomplete) {
//             print('🔄 Registration Incomplete - User: ${state.user.email}');
//             print('🔄 User role: ${state.user.role}');
//           }
//           print('==========================');
//
//           if (state is AuthLoading) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Creating account...")),
//             );
//           } else if (state is AuthAuthenticated) {
//             // ✅ FIXED: Handle authenticated state
//             print('✅ User authenticated after signup: ${state.user.email}');
//             _goToDashboard(state.user);
//           } else if (state is AuthRegistrationComplete) {
//             _goToDashboard(state.user);
//           } else if (state is AuthRegistrationIncomplete) {
//             _goToRegistration(state.user);
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderSection(),
//                 _buildSignUpForm(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.35,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.blue.shade700,
//             Colors.blue.shade600,
//           ],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Opacity(
//               opacity: 0.1,
//               child: Icon(
//                 Icons.medical_services,
//                 size: 120,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_ios,
//                       size: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 const Text(
//                   'Join Us Today!',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     height: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Create your account to start your medical journey',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 15,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.person_add_alt_1,
//                       size: 40,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSignUpForm() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Email Field
//             TextFormField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'Email Address',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2),
//                 ),
//                 prefixIcon: const Icon(Icons.email_outlined),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 } else if (!value.contains('@')) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             // Password Field
//             TextFormField(
//               controller: _passwordController,
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2),
//                 ),
//                 prefixIcon: const Icon(Icons.lock_outline),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     color: Colors.grey.shade600,
//                   ),
//                   onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your password';
//                 } else if (value.length < 6) {
//                   return 'Password must be at least 6 characters';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             // Confirm Password Field
//             TextFormField(
//               controller: _confirmPasswordController,
//               obscureText: !_isConfirmPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2),
//                 ),
//                 prefixIcon: const Icon(Icons.lock_outline),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isConfirmPasswordVisible
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     color: Colors.grey.shade600,
//                   ),
//                   onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//               validator: (value) {
//                 if (value != _passwordController.text) {
//                   return 'Passwords do not match';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//
//             // Role Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedRole,
//               decoration: InputDecoration(
//                 labelText: 'Select Role',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2),
//                 ),
//                 prefixIcon: const Icon(Icons.person_outline),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//               items: const [
//                 DropdownMenuItem(
//                   value: 'patient',
//                   child: Text('Patient'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'pharmacyowner',
//                   child: Text('Pharmacy Owner'),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedRole = value!;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),
//
//             // Sign Up Button
//             Container(
//               height: 56,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.shade600, Colors.blue.shade700],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.shade200,
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: _signUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Create Account",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Login Section
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have an account? ",
//                     style: TextStyle(
//                       color: Colors.grey.shade700,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _navigateToLogin,
//                     child: Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.blue.shade700,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
// import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
import '../../../patient/presentation/pages/pages/PatientDashboardPage.dart';
import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
import '../../domain/entities/user_entities.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'patient';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole,
        ),
      );
    }
  }

  void _goToDashboard(UserEntity user) {
    final role = user.role?.trim().toLowerCase();
    print('🔄 SignUp - Navigating to dashboard - Role: $role, User ID: ${user.id}');

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
      print('❌ CRITICAL: User has no role after signup');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account creation issue. Please login again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      _navigateToLogin();
    }
  }

  void _goToRegistration(UserEntity user) {
    final role = user.role?.trim().toLowerCase();
    print('🔄 SignUp - Navigating to registration - Role: $role, User ID: ${user.id}');

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
      print('❌ CRITICAL: User has no role for registration');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account creation issue. Please login again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AppAuthState>(
        listener: (context, state) {
          print('=== SIGNUP STATE UPDATE ===');
          print('State: ${state.runtimeType}');
          if (state is AuthAuthenticated) {
            print('✅ User authenticated: ${state.user.email}');
            print('✅ User role: ${state.user.role}');
            print('✅ User ID: ${state.user.id}');
          } else if (state is AuthRegistrationComplete) {
            print('✅ Registration Complete - User: ${state.user.email}');
            print('✅ User role: ${state.user.role}');
          } else if (state is AuthRegistrationIncomplete) {
            print('🔄 Registration Incomplete - User: ${state.user.email}');
            print('🔄 User role: ${state.user.role}');
          }
          print('==========================');

          if (state is AuthLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Creating account...")),
            );
          } else if (state is AuthAuthenticated) {
            _goToDashboard(state.user);
          } else if (state is AuthRegistrationComplete) {
            _goToDashboard(state.user);
          } else if (state is AuthRegistrationIncomplete) {
            _goToRegistration(state.user);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                _buildSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.medical_services,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Join Us Today!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to start your medical journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your email';
                if (!value.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your password';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Select Role',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: const [
                DropdownMenuItem(value: 'patient', child: Text('Patient')),
                DropdownMenuItem(value: 'pharmacyowner', child: Text('Pharmacy Owner')),
              ],
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 30),

            // Sign Up Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Login Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: _navigateToLogin,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
