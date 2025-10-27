import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_state.dart';
import '../widget/buid_medicine_item.dart';
import '../widget/build_empty_medicine_state.dart';

const Color kPrimaryDark = Color(0xFF1A237E);
const Color kAccentGreen = Color(0xFF00C853);
const Color kCardBackground = Colors.white;
const double kCardRadius = 20.0;

class RecentMedicinesWidget extends StatelessWidget {
  final String userId;
  final VoidCallback onRefreshMedicines;

  const RecentMedicinesWidget({
    Key? key,
    required this.userId,
    required this.onRefreshMedicines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medicineState) {
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
                    child: const Icon(
                      Icons.access_time_filled_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
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
                  if (medicineState is MedicineLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      onPressed: onRefreshMedicines,
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
                  itemBuilder: (context, index) => BuildMedicineItem(recentMedicines[index]),
                )
              else
                EmptyMedicinesWidget(
                  state: medicineState,
                  userId: userId,
                  onRefreshMedicines: onRefreshMedicines,
                  onCheckAuth: () {
                    // Implement auth check if needed
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}