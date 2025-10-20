
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/pages/edit_medicine_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
import 'package:rx_locator/features/medicine/presentation/pages/add_medicine_page.dart';
import 'package:rx_locator/features/medicine/presentation/pages/medicine_search_page.dart';
import '../../../medicine/domain/entities/medicine_entity.dart';
import '../../domain/entity/pharmacy_entity.dart';
import '../bloc/pharmacy_bloc.dart';

// 🎨 PREMIUM COLOR PALETTE
const Color kPrimaryDark = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFF3949AB);
const Color kAccentGreen = Color(0xFF00C853);
const Color kAccentOrange = Color(0xFFFF6F00);
const Color kBackgroundGradient1 = Color(0xFFF3E5F5);
const Color kBackgroundGradient2 = Color(0xFFE8EAF6);
const Color kCardBackground = Colors.white;
const double kCardRadius = 20.0;
const double kCardElevation = 8.0;

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
                  Navigator.pushNamed(context, '/pharmacy-profile');
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
              // ✅ FIXED: Use async navigation to refresh data when returning
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMedicinePage(pharmacyId: userId),
                ),
              ).then((_) {
                // ✅ FIXED: Refresh medicines when returning from AddMedicinePage
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
            Text(
              'Oops! Something Went Wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton.icon(
              onPressed: () {
                _checkAuthBeforeNavigation(context, () {
                  context.read<PharmacyBloc>().add(GetPharmacyProfileEvent(userId: userId));
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 22),
              label: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDark,
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
                colors: [kPrimaryLight, kPrimaryDark],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryLight.withOpacity(0.5),
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
              color: kPrimaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Preparing your pharmacy data...',
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
        // ✅ FIXED: Load medicines immediately
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

  // ✅ FIXED: Helper method to refresh medicines
  void _refreshMedicines() {
    context.read<MedicineBloc>().add(GetPharmacyMedicineEvent(widget.userId));
  }

  // ✅ FIXED: Method to handle edit medicine navigation
  void _navigateToEditMedicine(BuildContext context) {
    final medicineState = context.read<MedicineBloc>().state;
    if (medicineState is MedicineLoaded && medicineState.medicines.isNotEmpty) {
      // Navigate to a medicine selection page or show a dialog to select which medicine to edit
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

  // ✅ FIXED: Show dialog to select which medicine to edit
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicineBloc, MedicineState>(
      listener: (context, medicineState) {
        // ✅ FIXED: Listen for medicine addition success
        if (medicineState is MedicineOperationSuccess) {
          // Refresh medicines when operation is successful
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
                  child: _buildWelcomeCard(widget.pharmacy),
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
                  child: _buildStatisticsCards(),
                ),
                const SizedBox(height: 25),
                _buildQuickActionsGrid(context),
                const SizedBox(height: 25),
                _buildRecentMedicinesList(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(PharmacyEntity pharmacy) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryDark,
            kPrimaryLight,
            kPrimaryLight.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: kPrimaryDark.withOpacity(0.5),
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
                  Icons.local_pharmacy_rounded,
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
                      pharmacy.pharmacyName,
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
                        'ID: ${pharmacy.licenseNumber}',
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
                  gradient: LinearGradient(
                    colors: pharmacy.isVerified
                        ? [kAccentGreen, kAccentGreen.withOpacity(0.8)]
                        : [kAccentOrange, kAccentOrange.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (pharmacy.isVerified ? kAccentGreen : kAccentOrange)
                          .withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pharmacy.isVerified
                          ? Icons.verified_rounded
                          : Icons.schedule_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pharmacy.isVerified ? 'VERIFIED' : 'PENDING',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ✅ FIXED: Added refresh button
              IconButton(
                onPressed: _refreshMedicines,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medicineState) {
        // ✅ FIXED: Calculate stats directly from medicine state
        final medicines = medicineState is MedicineLoaded ? medicineState.medicines : [];
        final totalMedicines = medicines.length;
        final lowStockCount = medicines
            .where((m) => (m.stockQuantity ?? 0) < 10 && (m.stockQuantity ?? 0) > 0)
            .length;
        final outOfStockCount = medicines.where((m) => (m.stockQuantity ?? 0) == 0).length;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Items',
                totalMedicines.toString(),
                Icons.inventory_2_rounded,
                [kPrimaryLight, kPrimaryDark],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                'Low Stock',
                lowStockCount.toString(),
                Icons.warning_amber_rounded,
                [Colors.orange[600]!, Colors.orange[800]!],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                'Out of Stock',
                outOfStockCount.toString(),
                Icons.cancel_rounded,
                [Colors.red[600]!, Colors.red[800]!],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(kCardRadius),
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
                    colors: [kPrimaryLight, kPrimaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kPrimaryDark,
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
                Icons.visibility_rounded,
                'View All Medicines',
                [Colors.purple[600]!, Colors.purple[800]!],
                    () => _checkAuthForAction(() {
                  _showAllMedicinesDialog(context);
                }),
              ),
              _buildActionTile(
                Icons.search_rounded,
                'Search',
                [Colors.blue[600]!, Colors.blue[800]!],
                    () => _checkAuthForAction(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MedicineSearchPage()),
                  );
                }),
              ),
              _buildActionTile(
                Icons.add_box_rounded,
                'Add Item',
                [kAccentGreen, kAccentGreen.withOpacity(0.7)],
                    () => _checkAuthForAction(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddMedicinePage(pharmacyId: widget.userId)),
                  ).then((_) {
                    // ✅ FIXED: Refresh when returning from add medicine
                    _refreshMedicines();
                  });
                }),
              ),
              _buildActionTile(
                Icons.edit,
                'Edit Medicine',
                [Colors.blueGrey[600]!, Colors.blueGrey[800]!],
                    () => _checkAuthForAction(() {
                  _navigateToEditMedicine(context);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Show all medicines in a dialog
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentMedicinesList() {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medicineState) {
        // ✅ FIXED: Get medicines directly from state
        final medicines = medicineState is MedicineLoaded ? medicineState.medicines : [];
        final recentMedicines = medicines.take(5).toList();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kCardBackground,
            borderRadius: BorderRadius.circular(kCardRadius),
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
                        colors: [kAccentGreen, kAccentGreen],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.access_time_filled_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recent Medicines',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  // ✅ FIXED: Add refresh button for medicines
                  if (medicineState is MedicineLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      onPressed: _refreshMedicines,
                      icon: Icon(Icons.refresh, color: kPrimaryDark),
                      iconSize: 20,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (recentMedicines.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentMedicines.length,
                  separatorBuilder: (_, __) => const Divider(height: 20, thickness: 1),
                  itemBuilder: (context, index) => _buildMedicineItem(recentMedicines[index]),
                )
              else
                _buildEmptyMedicinesState(medicineState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyMedicinesState(MedicineState state) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inventory_rounded, size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          Text(
            state is MedicineLoading ? 'Loading Medicines...' : 'No Medicines Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state is MedicineLoading
                ? 'Fetching your medicine inventory...'
                : 'Start by adding your first medicine',
            style: TextStyle(color: Colors.grey[500]),
          ),
          if (state is! MedicineLoading) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _checkAuthForAction(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddMedicinePage(pharmacyId: widget.userId)),
                  ).then((_) {
                    _refreshMedicines();
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add First Medicine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicineItem(MedicineEntity medicine) {
    final stock = medicine.stockQuantity ?? 0;
    Color stockColor = stock == 0
        ? Colors.red[700]!
        : stock < 10
        ? Colors.orange[700]!
        : kAccentGreen;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryLight.withOpacity(0.2), kPrimaryDark.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.medication_liquid_rounded, size: 24, color: kPrimaryDark),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine.medicineName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kPrimaryDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                medicine.manufacturer ?? 'No manufacturer',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              medicine.price != null ? '\$${medicine.price!.toStringAsFixed(2)}' : '-',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: kPrimaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: stockColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                stock == 0 ? 'Out' : '$stock',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: stockColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}