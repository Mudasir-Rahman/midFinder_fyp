import 'package:flutter/material.dart';
import 'package:rx_locator/core/constant/app_color.dart';
import 'package:rx_locator/core/constant/app_style.dart';

class RoleSelectorWidget extends StatelessWidget {
  final Function(String role) onRoleSelected;

  const RoleSelectorWidget({super.key, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor.withOpacity(0.05),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Select Your Role',
                style: AppStyle.heading1.copyWith(color: AppColor.primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This choice determines the features available to you.',
                style: AppStyle.bodyText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildRoleCard(context, icon: Icons.person_outline, title: 'Patient', subtitle: 'Find medicines and nearby pharmacies.', role: 'patient'),
              const SizedBox(height: 20),
              _buildRoleCard(context, icon: Icons.local_pharmacy_outlined, title: 'Pharmacy Owner', subtitle: 'Manage inventory and receive location requests.', role: 'pharmacy_owner'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required String role}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onRoleSelected(role),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: AppColor.accentColor),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyle.heading2.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppStyle.bodyText2),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColor.greyColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
