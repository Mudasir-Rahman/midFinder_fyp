import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../pharmacy/domain/entity/pharmacy_entity.dart';
import '../../../domain/entity/patient_entity.dart';
import '../../../../../core/constant/app_color.dart';

class LocationSection extends StatelessWidget {
  final PatientEntity patient;
  final Position? currentPosition;
  final List<PharmacyEntity> nearbyPharmacies;
  final bool isUpdating;
  final VoidCallback onUpdateLocation;

  const LocationSection({
    super.key,
    required this.patient,
    required this.currentPosition,
    required this.nearbyPharmacies,
    required this.isUpdating,
    required this.onUpdateLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.kPatientPrimary,
                  ),
                ),
                IconButton(
                  icon: isUpdating
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.refresh),
                  onPressed: isUpdating ? null : onUpdateLocation,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              patient.address.isNotEmpty
                  ? patient.address
                  : "Location not available",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            if (nearbyPharmacies.isNotEmpty)
              Text(
                "Nearby Pharmacies: ${nearbyPharmacies.length}",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
