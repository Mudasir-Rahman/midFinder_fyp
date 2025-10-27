import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/pages/edit_medicine_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
import 'package:rx_locator/features/medicine/presentation/pages/add_medicine_page.dart';

import '../../../medicine/domain/entities/medicine_entity.dart';
import '../../domain/entity/pharmacy_entity.dart';
import '../bloc/pharmacy_bloc.dart';

import '../widget/welcome_card_widget.dart';
import '../widget/statistics_cards_widget.dart';
import '../widget/quick_actions_widget.dart';
import '../widget/recent_medicines_widget.dart';
import '../widget/error_state_widget.dart';
import '../widget/loading_state_widget.dart';
import '../widget/pharmacy_profile_drawer.dart'; // ✅ ADDED IMPORT

// 🎨 PREMIUM COLOR PALETTE
const Color kPrimaryDark = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFF3949AB);
const Color kAccentGreen = Color(0xFF00C853);
const Color kBackgroundGradient1 = Color(0xFFF3E5F5);
const Color kBackgroundGradient2 = Color(0xFFE8EAF6);

class PharmacyDashboardPage extends StatelessWidget {
  final String userId;

  const PharmacyDashboardPage({Key? key, required this.userId}) : super(key: key);

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
        context.read<PharmacyBloc>().add(GetPharmacyProfileEvent(userId: userId));
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pharmacy Dashboard',
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
                kPrimaryDark,
                kPrimaryLight,
                kPrimaryLight.withOpacity(0.8),
              ],
            ),
          ),
        ),
        // ✅ REMOVED: Person icon from actions
      ),
      drawer: const PharmacyProfileDrawer(), // ✅ ADDED: Drawer
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kBackgroundGradient1,
              kBackgroundGradient2,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: BlocBuilder<PharmacyBloc, PharmacyState>(
          builder: (context, state) {
            if (state is PharmacyProfileLoaded) {
              return _PharmacyDashboardContent(pharmacy: state.pharmacy, userId: userId);
            } else if (state is PharmacyError) {
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
            colors: [kAccentGreen, kAccentGreen],
          ),
          boxShadow: [
            BoxShadow(
              color: kAccentGreen.withOpacity(0.5),
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
                MaterialPageRoute(
                  builder: (context) => AddMedicinePage(pharmacyId: userId),
                ),
              ).then((_) {
                context.read<MedicineBloc>().add(GetPharmacyMedicineEvent(userId));
              });
            });
          },
          label: const Text(
            'Add Medicine',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          icon: const Icon(Icons.add_circle_rounded, size: 26),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PharmacyError state) {
    return ErrorStateWidget(
      state: state,
      onRetry: () {
        _checkAuthBeforeNavigation(context, () {
          context.read<PharmacyBloc>().add(GetPharmacyProfileEvent(userId: userId));
        });
      },
    );
  }

  Widget _buildLoadingState() {
    return const LoadingStateWidget();
  }
}

class _PharmacyDashboardContent extends StatefulWidget {
  final PharmacyEntity pharmacy;
  final String userId;

  const _PharmacyDashboardContent({
    Key? key,
    required this.pharmacy,
    required this.userId,
  }) : super(key: key);

  @override
  State<_PharmacyDashboardContent> createState() => _PharmacyDashboardContentState();
}

class _PharmacyDashboardContentState extends State<_PharmacyDashboardContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        context.read<MedicineBloc>().add(GetPharmacyMedicineEvent(widget.userId));
      }
    });
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

  void _refreshMedicines() {
    context.read<MedicineBloc>().add(GetPharmacyMedicineEvent(widget.userId));
  }

  void _navigateToEditMedicine(BuildContext context) {
    final medicineState = context.read<MedicineBloc>().state;
    if (medicineState is MedicineLoaded && medicineState.medicines.isNotEmpty) {
      _showMedicineSelectionDialog(context, medicineState.medicines);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No medicines available to edit'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMedicineSelectionDialog(BuildContext context, List<MedicineEntity> medicines) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Medicine to Edit'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return ListTile(
                leading: const Icon(Icons.medication),
                title: Text(medicine.medicineName),
                subtitle: Text('Stock: ${medicine.stockQuantity ?? 0}'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditMedicinePage(medicine: medicine),
                    ),
                  ).then((_) {
                    _refreshMedicines();
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAllMedicinesDialog(BuildContext context) {
    final medicineState = context.read<MedicineBloc>().state;
    if (medicineState is MedicineLoaded) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('All Medicines'),
          content: SizedBox(
            width: double.maxFinite,
            child: medicineState.medicines.isEmpty
                ? const Center(child: Text('No medicines available'))
                : ListView.builder(
              shrinkWrap: true,
              itemCount: medicineState.medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicineState.medicines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.medication, color: kPrimaryDark),
                    title: Text(
                      medicine.medicineName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Stock: ${medicine.stockQuantity ?? 0}'),
                    trailing: Text(
                      '\$${medicine.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicineBloc, MedicineState>(
      listener: (context, medicineState) {
        if (medicineState is MedicineOperationSuccess) {
          _refreshMedicines();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Medicine added successfully!'),
              backgroundColor: kAccentGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeTransition(
                  opacity: _animationController,
                  child: WelcomeCardWidget(
                    pharmacy: widget.pharmacy,
                    onRefreshMedicines: _refreshMedicines,
                  ),
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
                  child: const StatisticsCardsWidget(),
                ),
                const SizedBox(height: 25),
                QuickActionsWidget(
                  userId: widget.userId,
                  onCheckAuth: () => _checkAuthForAction(() {}),
                  onRefreshMedicines: _refreshMedicines,
                  onNavigateToEditMedicine: () => _navigateToEditMedicine(context),
                  onShowAllMedicinesDialog: () => _showAllMedicinesDialog(context),
                ),
                const SizedBox(height: 25),
                RecentMedicinesWidget(
                  userId: widget.userId,
                  onRefreshMedicines: _refreshMedicines,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}