// import 'package:flutter/material.dart';
// import 'package:rx_locator/features/patient/presentation/pages/pages/patient_registration_page.dart';
// import 'package:rx_locator/features/pharmacy/presentation/pages/pharmacy_registration_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../domain/entities/user_entities.dart';
//
// class RoleSelectionPage extends StatelessWidget {
//   final UserEntity user;
//
//   const RoleSelectionPage({super.key, required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Your Role'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 40),
//             // Header
//             const Text(
//               'How will you use MedFinder?',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Choose your role to continue',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 60),
//
//             // Role Selection Cards
//             Expanded(
//               child: Column(
//                 children: [
//                   // Patient Card
//                   _RoleCard(
//                     icon: Icons.personal_injury,
//                     title: 'Patient',
//                     subtitle: 'Find medicines and pharmacies near you',
//                     color: Colors.green[700]!,
//                     onTap: () {
// Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientRegistrationPage(user:user)));
//                     },
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Pharmacist Card
//                   _RoleCard(
//                     icon: Icons.local_pharmacy,
//                     title: 'Pharmacist',
//                     subtitle: 'Register your pharmacy and manage medicines',
//                     color: Colors.orange[700]!,
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>PharmacyRegistrationPage(userId: user.id))
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _RoleCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _RoleCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 32, color: color),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }