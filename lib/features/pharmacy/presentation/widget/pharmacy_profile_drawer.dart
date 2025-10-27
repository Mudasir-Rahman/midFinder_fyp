import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/features/auth/presentation/pages/login_page.dart';
import '../bloc/pharmacy_bloc.dart';

import '../../domain/entity/pharmacy_entity.dart';

// Color constants remain the same
const Color kPrimaryDark = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFF3949AB);
const Color kAccentGreen = Color(0xFF00C853);
const Color kBackgroundColor = Color(0xFFF7F9FC); // New light background color

class PharmacyProfileDrawer extends StatelessWidget {
  const PharmacyProfileDrawer({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyBloc, PharmacyState>(
      builder: (context, state) {
        final pharmacy = state is PharmacyProfileLoaded ? state.pharmacy : null;

        return Drawer(
          // Use a very light background for a cleaner look
          backgroundColor: kBackgroundColor,
          // Removed the Column to use CustomScrollView for better scroll and header integration
          child: CustomScrollView(
            slivers: [
              // Header with pharmacy info - using SliverToBoxAdapter for a fixed header
              SliverToBoxAdapter(
                child: _buildDrawerHeader(pharmacy),
              ),

              // Pharmacy Details Section - using SliverList for a scrollable body
              SliverList(
                delegate: SliverChildListDelegate(
                  _buildProfileDetails(pharmacy),
                ),
              ),

              // A small spacer before the logout button
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Logout Button - fixed at the bottom
              SliverToBoxAdapter(
                child: _buildLogoutButton(context),
              ),
              // Add padding to the bottom
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(PharmacyEntity? pharmacy) {
    return Container(
      width: double.infinity,
      // Increased vertical padding slightly
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimaryDark, kPrimaryLight],
        ),
        // Added a subtle shadow effect for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elevated CircleAvatar for a better look
          Material(
            elevation: 4,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(
                Icons.local_pharmacy_rounded,
                size: 40,
                color: kPrimaryDark, // Icon color changed for better contrast
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            pharmacy?.pharmacyName ?? 'Loading...',
            style: const TextStyle(
              fontSize: 24, // Slightly larger font
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Verification status as a chip
          _VerificationChip(
            isVerified: pharmacy?.isVerified == true,
          ),
        ],
      ),
    );
  }

  // Changed to return List<Widget> for use in SliverList
  List<Widget> _buildProfileDetails(PharmacyEntity? pharmacy) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
        child: _buildDetailHeader(
          icon: Icons.business_rounded,
          title: 'General Details',
        ),
      ),
      _DetailCard(
        children: [
          _buildDetailRow(
            icon: Icons.credit_card_rounded,
            label: 'License Number',
            value: pharmacy?.licenseNumber ?? 'N/A',
          ),
          _buildDetailRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: pharmacy?.phone ?? 'N/A',
          ),
          _buildDetailRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: pharmacy?.address ?? 'N/A',
            maxLines: 3,
          ),
        ],
      ),

      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
        child: _buildDetailHeader(
          icon: Icons.access_time_rounded,
          title: 'Operating Hours',
        ),
      ),
      _DetailCard(
        children: [
          _buildDetailRow(
            icon: Icons.schedule_rounded,
            label: 'Opening Time',
            value: pharmacy?.openingTime ?? 'N/A',
          ),
          _buildDetailRow(
            icon: Icons.schedule_rounded,
            label: 'Closing Time',
            value: pharmacy?.closingTime ?? 'N/A',
          ),
          _buildOperatingDays(pharmacy?.operatingDays ?? []),
        ],
      ),

      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
        child: _buildDetailHeader(
          icon: Icons.map_rounded,
          title: 'Location & Status',
        ),
      ),
      _DetailCard(
        children: [
          _buildDetailRow(
            icon: Icons.language_rounded,
            label: 'Coordinates',
            value: '${pharmacy?.latitude?.toStringAsFixed(4) ?? 'N/A'}, ${pharmacy?.longitude?.toStringAsFixed(4) ?? 'N/A'}',
          ),
          _buildDetailRow(
            icon: Icons.info_rounded, // Moved status here for grouping
            label: 'Verification Status',
            value: pharmacy?.isVerified == true ? 'Verified' : 'Pending Verification',
            valueColor: pharmacy?.isVerified == true ? kAccentGreen : Colors.orange,
            // Added a specific icon for verification status
            customIcon: pharmacy?.isVerified == true ? Icons.check_circle_rounded : Icons.pending_rounded,
          ),
        ],
      ),
    ];
  }

  Widget _buildOperatingDays(List<String> operatingDays) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Operating Days',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          operatingDays.isEmpty
              ? Text(
            'Not specified',
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          )
              : Wrap(
            spacing: 8,
            runSpacing: 8, // Increased run spacing for better readability
            children: operatingDays.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: kPrimaryLight.withOpacity(0.15), // Slightly more color
                  borderRadius: BorderRadius.circular(20), // More rounded corners
                  border: Border.all(color: kPrimaryLight.withOpacity(0.3)), // Subtle border
                ),
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding consistency
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.exit_to_app_rounded, size: 20), // Changed icon for a more 'exit' feel
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700), // Larger text
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700, // Darker red for emphasis
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55), // Taller button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // More rounded corners
          ),
          elevation: 4, // Added more elevation
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = kPrimaryDark,
    int maxLines = 1,
    IconData? customIcon, // Optional custom icon for the start of the row
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use the provided icon or a custom one
          Icon(customIcon ?? icon, size: 20, color: kPrimaryLight),
          const SizedBox(width: 16), // Increased spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13, // Slightly larger label
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15, // Slightly larger value
                    color: valueColor,
                    fontWeight: FontWeight.w700, // Bolder value
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: kPrimaryDark),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900, // Bolder header
            color: kPrimaryDark,
          ),
        ),
        const Expanded(child: Divider(thickness: 1.5, indent: 10, color: kPrimaryLight)), // Added a divider line
      ],
    );
  }
}

// --- Helper Widgets for Cleaner UI ---

class _VerificationChip extends StatelessWidget {
  final bool isVerified;
  const _VerificationChip({required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isVerified ? kAccentGreen : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isVerified ? 'VERIFIED' : 'PENDING',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 1, // Subtle lift
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Internal padding adjustment
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}