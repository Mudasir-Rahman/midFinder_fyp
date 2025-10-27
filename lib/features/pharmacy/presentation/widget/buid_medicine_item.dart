
import 'package:flutter/material.dart';

import '../../../medicine/domain/entities/medicine_entity.dart';
import '../../../medicine/presentation/widget/medicine_form.dart';

Widget BuildMedicineItem(MedicineEntity medicine) {
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
