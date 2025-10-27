import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_state.dart';
import '../../../medicine/domain/entities/medicine_entity.dart';

const Color kPrimaryLight = Color(0xFF3949AB);
const Color kPrimaryDark = Color(0xFF1A237E);

class StatisticsCardsWidget extends StatelessWidget {
  const StatisticsCardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medicineState) {
        final medicines = medicineState is MedicineLoaded ? medicineState.medicines : [];
        final totalMedicines = medicines.length;
        final lowStockCount = medicines
            .where((m) => (m.stockQuantity ?? 0) < 10 && (m.stockQuantity ?? 0) > 0)
            .length;
        final outOfStockCount = medicines.where((m) => (m.stockQuantity ?? 0) == 0).length;

        return Row(
          children: [
            Expanded(
              child: StatCardWidget(
                title: 'Total Items',
                value: totalMedicines.toString(),
                icon: Icons.inventory_2_rounded,
                gradient: [kPrimaryLight, kPrimaryDark],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: StatCardWidget(
                title: 'Low Stock',
                value: lowStockCount.toString(),
                icon: Icons.warning_amber_rounded,
                gradient: [Colors.orange[600]!, Colors.orange[800]!],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: StatCardWidget(
                title: 'Out of Stock',
                value: outOfStockCount.toString(),
                icon: Icons.cancel_rounded,
                gradient: [Colors.red[600]!, Colors.red[800]!],
              ),
            ),
          ],
        );
      },
    );
  }
}

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const StatCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}