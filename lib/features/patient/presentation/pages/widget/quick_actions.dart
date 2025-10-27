import 'package:flutter/material.dart';
import '../../../../../core/constant/app_color.dart';

class QuickActions extends StatelessWidget {
  final Function(String action) onActionSelected;

  const QuickActions({super.key, required this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.local_hospital, 'label': 'Nearby Pharmacies'},
      {'icon': Icons.medication, 'label': 'My Medicines'},
      {'icon': Icons.history, 'label': 'Orders'},
      {'icon': Icons.favorite, 'label': 'Favorites'},
      {'icon': Icons.settings, 'label': 'Settings'},
      {'icon': Icons.help, 'label': 'Help'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow in Column
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kPatientPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            // ✅ Responsive layout
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onActionSelected(action['label'] as String),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ Added to prevent overflow
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          action['icon'] as IconData,
                          size: 32,
                          color: AppColor.kPatientPrimary,
                        ),
                        const SizedBox(height: 8),
                        Flexible( // ✅ Helps handle text wrapping
                          child: Text(
                            action['label'] as String,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
