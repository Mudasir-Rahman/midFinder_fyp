// import 'package:flutter/material.dart';
//
// class PatientDashboard extends StatelessWidget {
//   final String userId;
//
//   const PatientDashboard({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MedFinder - Patient Dashboard'),
//         backgroundColor: Colors.green[700],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               // Navigate to profile
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Navigate to notifications
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Section
//             _buildWelcomeSection(),
//             const SizedBox(height: 24),
//
//             // Quick Actions
//             _buildQuickActions(context),
//             const SizedBox(height: 24),
//
//             // Nearby Medicines Section
//             _buildNearbyMedicines(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Search medicines
//         },
//         backgroundColor: Colors.green[700],
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.search),
//       ),
//     );
//   }
//
//   Widget _buildWelcomeSection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.green[100],
//               child: Icon(
//                 Icons.person,
//                 size: 30,
//                 color: Colors.green[700],
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green[700],
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Find your medicines easily',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
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
//   Widget _buildQuickActions(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.5,
//           children: [
//             _buildActionCard(
//               icon: Icons.search,
//               title: 'Search Medicines',
//               subtitle: 'Find specific medicines',
//               color: Colors.blue,
//               onTap: () {
//                 _showDummyDialog(context, 'Search Medicines', 'This would open medicine search');
//               },
//             ),
//             _buildActionCard(
//               icon: Icons.local_pharmacy,
//               title: 'Nearby Pharmacies',
//               subtitle: 'Find pharmacies near you',
//               color: Colors.orange,
//               onTap: () {
//                 _showDummyDialog(context, 'Nearby Pharmacies', 'This would show nearby pharmacies');
//               },
//             ),
//             _buildActionCard(
//               icon: Icons.medical_services,
//               title: 'Order History',
//               subtitle: 'View your past orders',
//               color: Colors.purple,
//               onTap: () {
//                 _showDummyDialog(context, 'Order History', 'This would show your order history');
//               },
//             ),
//             _buildActionCard(
//               icon: Icons.favorite,
//               title: 'Saved Items',
//               subtitle: 'Your favorite medicines',
//               color: Colors.red,
//               onTap: () {
//                 _showDummyDialog(context, 'Saved Items', 'This would show your saved medicines');
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 28, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNearbyMedicines() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Available Nearby',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               children: const [
//                 _MedicineCard(
//                   medicineName: 'Paracetamol 500mg',
//                   pharmacyName: 'City Pharmacy',
//                   distance: '0.8 km',
//                   price: 'Rs. 50',
//                   isAvailable: true,
//                 ),
//                 _MedicineCard(
//                   medicineName: 'Amoxicillin 250mg',
//                   pharmacyName: 'Health Plus',
//                   distance: '1.2 km',
//                   price: 'Rs. 120',
//                   isAvailable: true,
//                 ),
//                 _MedicineCard(
//                   medicineName: 'Vitamin C 1000mg',
//                   pharmacyName: 'MediCare',
//                   distance: '0.5 km',
//                   price: 'Rs. 80',
//                   isAvailable: false,
//                 ),
//                 _MedicineCard(
//                   medicineName: 'Ibuprofen 400mg',
//                   pharmacyName: 'Quick Meds',
//                   distance: '1.5 km',
//                   price: 'Rs. 65',
//                   isAvailable: true,
//                 ),
//                 _MedicineCard(
//                   medicineName: 'Cetirizine 10mg',
//                   pharmacyName: 'City Pharmacy',
//                   distance: '0.8 km',
//                   price: 'Rs. 45',
//                   isAvailable: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDummyDialog(BuildContext context, String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MedicineCard extends StatelessWidget {
//   final String medicineName;
//   final String pharmacyName;
//   final String distance;
//   final String price;
//   final bool isAvailable;
//
//   const _MedicineCard({
//     required this.medicineName,
//     required this.pharmacyName,
//     required this.distance,
//     required this.price,
//     required this.isAvailable,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.medical_services,
//                 color: Colors.blue[700],
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     medicineName,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     pharmacyName,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, size: 14, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         distance,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                       const Spacer(),
//                       Text(
//                         price,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: isAvailable ? Colors.green[50] : Colors.red[50],
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 isAvailable ? 'In Stock' : 'Out of Stock',
//                 style: TextStyle(
//                   color: isAvailable ? Colors.green[700] : Colors.red[700],
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:rx_locator/features/patient/presentation/bloc/patient_event.dart';
import 'package:rx_locator/features/patient/presentation/bloc/patient_state.dart';
import 'package:rx_locator/features/medicine/presentation/pages/medicine_search_page.dart';

import '../../../domain/entity/patient_entity.dart';

// 🎨 PATIENT COLOR PALETTE
const Color kPatientPrimary = Color(0xFF2196F3); // Blue
const Color kPatientSecondary = Color(0xFF03A9F4); // Light Blue
const Color kPatientAccent = Color(0xFF00BCD4); // Cyan
const Color kPatientBackground1 = Color(0xFFE3F2FD); // Light Blue Background
const Color kPatientBackground2 = Color(0xFFF3E5F5); // Light Purple
const Color kPatientCard = Colors.white;
const double kPatientCardRadius = 20.0;

class PatientDashboard extends StatelessWidget {
  final String userId;

  const PatientDashboard({super.key, required this.userId});

  void _checkAuthBeforeNavigation(BuildContext context, VoidCallback onSuccess) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showAuthError(context);
    } else {
      onSuccess();
    }
  }

  void _showAuthError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session expired. Please login again.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _showAuthError(context);
      } else {
        context.read<PatientBloc>().add(GetPatientProfileEvent(userId: userId));
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MedFinder - Patient Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPatientPrimary,
                kPatientSecondary,
                kPatientSecondary.withOpacity(0.8),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.person_rounded, size: 22, color: Colors.white),
              ),
              onPressed: () {
                _checkAuthBeforeNavigation(context, () {
                  Navigator.pushNamed(context, '/patient-profile');
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.notifications_rounded, size: 22, color: Colors.white),
              ),
              onPressed: () {
                _checkAuthBeforeNavigation(context, () {
                  Navigator.pushNamed(context, '/notifications');
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPatientBackground1,
              kPatientBackground2,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            if (state is PatientProfileLoaded) {
              return _PatientDashboardContent(patient: state.patient, userId: userId);
            } else if (state is PatientError) {
              return _buildErrorState(context, state);
            } else {
              return _buildLoadingState();
            }
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [kPatientAccent, kPatientSecondary],
          ),
          boxShadow: [
            BoxShadow(
              color: kPatientAccent.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            _checkAuthBeforeNavigation(context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedicineSearchPage()),
              );
            });
          },
          label: const Text(
            'Search Medicines',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          icon: const Icon(Icons.search_rounded, size: 26),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PatientError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Oops! Something Went Wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton.icon(
              onPressed: () {
                _checkAuthBeforeNavigation(context, () {
                  context.read<PatientBloc>().add(GetPatientProfileEvent(userId: userId));
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 22),
              label: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPatientPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPatientSecondary, kPatientPrimary],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPatientSecondary.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Loading Your Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kPatientPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Preparing your patient dashboard...',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientDashboardContent extends StatefulWidget {
  final PatientEntity patient;
  final String userId;

  const _PatientDashboardContent({
    Key? key,
    required this.patient,
    required this.userId,
  }) : super(key: key);

  @override
  State<_PatientDashboardContent> createState() => _PatientDashboardContentState();
}

class _PatientDashboardContentState extends State<_PatientDashboardContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAuthForAction(VoidCallback onSuccess) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login again'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    } else {
      onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FadeTransition(
                opacity: _animationController,
                child: _buildWelcomeCard(widget.patient),
              ),
              const SizedBox(height: 25),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOut,
                )),
                child: _buildQuickActionsGrid(context),
              ),
              const SizedBox(height: 25),
              _buildNearbyMedicines(),
              const SizedBox(height: 25),
              _buildHealthTips(),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(PatientEntity patient) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPatientPrimary,
            kPatientSecondary,
            kPatientSecondary.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(kPatientCardRadius),
        boxShadow: [
          BoxShadow(
            color: kPatientPrimary.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${patient.name}!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Patient ID: ${patient.userId.substring(0, 8)}...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CNIC: ${patient.cnic}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.phone_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPatientCard,
        borderRadius: BorderRadius.circular(kPatientCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPatientSecondary, kPatientPrimary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kPatientPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              _buildActionTile(
                Icons.search_rounded,
                'Search Medicines',
                [Colors.blue[600]!, Colors.blue[800]!],
                    () => _checkAuthForAction(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MedicineSearchPage()),
                  );
                }),
              ),
              _buildActionTile(
                Icons.local_pharmacy_rounded,
                'Find Pharmacies',
                [Colors.purple[600]!, Colors.purple[800]!],
                    () => _checkAuthForAction(() {
                  _showDummyDialog(context, 'Nearby Pharmacies', 'This would show nearby pharmacies');
                }),
              ),
              _buildActionTile(
                Icons.history_rounded,
                'Order History',
                [Colors.orange[600]!, Colors.orange[800]!],
                    () => _checkAuthForAction(() {
                  _showDummyDialog(context, 'Order History', 'This would show your order history');
                }),
              ),
              _buildActionTile(
                Icons.favorite_rounded,
                'Saved Items',
                [Colors.red[600]!, Colors.red[800]!],
                    () => _checkAuthForAction(() {
                  _showDummyDialog(context, 'Saved Items', 'This would show your saved medicines');
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, List<Color> gradient, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyMedicines() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPatientCard,
        borderRadius: BorderRadius.circular(kPatientCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.greenAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Available Nearby',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kPatientPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: const [
              _MedicineCard(
                medicineName: 'Paracetamol 500mg',
                pharmacyName: 'City Pharmacy',
                distance: '0.8 km',
                price: 'Rs. 50',
                isAvailable: true,
              ),
              _MedicineCard(
                medicineName: 'Amoxicillin 250mg',
                pharmacyName: 'Health Plus',
                distance: '1.2 km',
                price: 'Rs. 120',
                isAvailable: true,
              ),
              _MedicineCard(
                medicineName: 'Vitamin C 1000mg',
                pharmacyName: 'MediCare',
                distance: '0.5 km',
                price: 'Rs. 80',
                isAvailable: false,
              ),
              _MedicineCard(
                medicineName: 'Ibuprofen 400mg',
                pharmacyName: 'Quick Meds',
                distance: '1.5 km',
                price: 'Rs. 65',
                isAvailable: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPatientCard,
        borderRadius: BorderRadius.circular(kPatientCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPatientAccent, kPatientSecondary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Health Tips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kPatientPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildHealthTipItem(
            'Stay Hydrated',
            'Drink at least 8 glasses of water daily for better health',
            Icons.water_drop_rounded,
            Colors.blue,
          ),
          _buildHealthTipItem(
            'Regular Exercise',
            '30 minutes of daily exercise improves overall wellbeing',
            Icons.directions_run_rounded,
            Colors.green,
          ),
          _buildHealthTipItem(
            'Balanced Diet',
            'Eat a variety of fruits and vegetables for proper nutrition',
            Icons.restaurant_rounded,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTipItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDummyDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final String medicineName;
  final String pharmacyName;
  final String distance;
  final String price;
  final bool isAvailable;

  const _MedicineCard({
    required this.medicineName,
    required this.pharmacyName,
    required this.distance,
    required this.price,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kPatientPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medical_services_rounded,
              color: kPatientPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: kPatientPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pharmacyName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAvailable ? Colors.green[200]! : Colors.red[200]!,
              ),
            ),
            child: Text(
              isAvailable ? 'In Stock' : 'Out of Stock',
              style: TextStyle(
                color: isAvailable ? Colors.green[700] : Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}