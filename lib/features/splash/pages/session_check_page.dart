// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
//
// import 'first_splash.dart';
//
// class SessionCheckPage extends StatefulWidget {
//   const SessionCheckPage({super.key});
//
//   @override
//   State<SessionCheckPage> createState() => _SessionCheckPageState();
// }
//
// class _SessionCheckPageState extends State<SessionCheckPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkSession();
//   }
//
//   Future<void> _checkSession() async {
//     final supabase = Supabase.instance.client;
//
//     // Wait briefly to show splash effect
//     await Future.delayed(const Duration(seconds: 2));
//
//     final user = supabase.auth.currentUser;
//
//     if (!mounted) return;
//
//     if (user != null) {
//       // ✅ User already logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const ()),
//       );
//     } else {
//       // 🚪 No active session
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const SplashPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
