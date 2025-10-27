import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String price;
  final String pharmacyName;
  final String distanceKm;

  const MedicineCard({
    Key? key,
    required this.medicineName,
    required this.price,
    required this.pharmacyName,
    required this.distanceKm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Icon
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medication, color: Colors.teal, size: 35),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Pharmacy: $pharmacyName",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    "Distance: $distanceKm km",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Price
            Text(
              "Rs $price",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
