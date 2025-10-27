
import 'package:flutter/material.dart';
import 'package:rx_locator/features/medicine/presentation/pages/add_medicine_page.dart';
import 'package:rx_locator/features/medicine/presentation/pages/medicine_search_page.dart';

const Color kPrimaryDark = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFF3949AB);
const Color kAccentGreen = Color(0xFF00C853);
const Color kCardBackground = Colors.white;
const double kCardRadius = 20.0;

class QuickActionsWidget extends StatelessWidget {
  final String userId;
  final VoidCallback onCheckAuth;
  final VoidCallback onRefreshMedicines;
  final VoidCallback onNavigateToEditMedicine;
  final VoidCallback onShowAllMedicinesDialog;

  const QuickActionsWidget({
    Key? key,
    required this.userId,
    required this.onCheckAuth,
    required this.onRefreshMedicines,
    required this.onNavigateToEditMedicine,
    required this.onShowAllMedicinesDialog,
  }) : super(key: key);

  void _handleViewAllMedicines() {
    onCheckAuth();
    onShowAllMedicinesDialog();
  }

  void _handleSearch(BuildContext context) {
    onCheckAuth();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MedicineSearchPage()),
    );
  }

  void _handleAddMedicine(BuildContext context) {
    onCheckAuth();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddMedicinePage(pharmacyId: userId)),
    ).then((_) {
      onRefreshMedicines();
    });
  }

  void _handleEditMedicine() {
    onCheckAuth();
    onNavigateToEditMedicine();
  }

  @override
  Widget build(BuildContext context) {
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
              // View All Medicines
              ActionTileWidget(
                icon: Icons.visibility_rounded,
                title: 'View All Medicines',
                gradient: [Colors.purple[600]!, Colors.purple[800]!],
                onTap: () => _handleViewAllMedicines(),
              ),
              // Search Medicines
              ActionTileWidget(
                icon: Icons.search_rounded,
                title: 'Search',
                gradient: [Colors.blue[600]!, Colors.blue[800]!],
                onTap: () => _handleSearch(context),
              ),
              // Add Medicine
              ActionTileWidget(
                icon: Icons.add_box_rounded,
                title: 'Add Medicine',
                gradient: [kAccentGreen, kAccentGreen.withOpacity(0.7)],
                onTap: () => _handleAddMedicine(context),
              ),
              // Edit Medicine
              ActionTileWidget(
                icon: Icons.edit_rounded,
                title: 'Edit Medicine',
                gradient: [Colors.orange[600]!, Colors.orange[800]!],
                onTap: () => _handleEditMedicine(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradient;
  final VoidCallback onTap;

  const ActionTileWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}