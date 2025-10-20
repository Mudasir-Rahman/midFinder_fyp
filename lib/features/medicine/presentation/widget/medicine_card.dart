import 'package:flutter/material.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

class MedicineCard extends StatelessWidget {
  final MedicineEntity medicine;
  final VoidCallback onTap;
  final bool showCategory;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.medication, color: Colors.blue),
        ),
        title: Text(
          medicine.medicineName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generic: ${medicine.genericName}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Manufacturer: ${medicine.manufacturer}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (showCategory) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  medicine.category,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}