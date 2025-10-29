import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../pharmacy/domain/entity/pharmacy_entity.dart';
import '../../../domain/entity/patient_entity.dart';
import '../../../../../core/constant/app_color.dart';
// ✅ ADD FAVORITE IMPORTS
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_state.dart';
import '../../../domain/entity/favorite_entity.dart';

class LocationSection extends StatelessWidget {
  final PatientEntity patient;
  final Position? currentPosition;
  final List<PharmacyEntity> nearbyPharmacies;
  final bool isUpdating;
  final VoidCallback onUpdateLocation;
  // ✅ ADD FAVORITE CALLBACK
  final Function(String, String)? onTogglePharmacyFavorite;

  const LocationSection({
    super.key,
    required this.patient,
    required this.currentPosition,
    required this.nearbyPharmacies,
    required this.isUpdating,
    required this.onUpdateLocation,
    required this.onTogglePharmacyFavorite,
  });

  // ✅ CHECK IF PHARMACY IS FAVORITE
  bool _isPharmacyFavorite(String pharmacyId, FavoriteState state) {
    if (state is FavoritesLoaded) {
      return state.favorites.any((fav) =>
      fav.itemId == pharmacyId && fav.type == FavoriteType.pharmacy);
    }
    return false;
  }

  // ✅ CHECK IF PHARMACY IS CURRENTLY OPEN
  bool _isPharmacyOpen(PharmacyEntity pharmacy) {
    try {
      final now = DateTime.now();
      final currentTime = TimeOfDay.fromDateTime(now);
      final currentDay = _getWeekdayString(now.weekday);

      // Check if pharmacy operates today
      if (!pharmacy.operatingDays.contains(currentDay)) {
        return false;
      }

      // Parse opening and closing times
      final openingTime = _parseTime(pharmacy.openingTime);
      final closingTime = _parseTime(pharmacy.closingTime);

      return currentTime.hour > openingTime.hour ||
          (currentTime.hour == openingTime.hour && currentTime.minute >= openingTime.minute) &&
              (currentTime.hour < closingTime.hour ||
                  (currentTime.hour == closingTime.hour && currentTime.minute <= closingTime.minute));
    } catch (e) {
      return false; // Return false if time parsing fails
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Card
        Card(
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
        ),

        const SizedBox(height: 16),

        // Nearby Pharmacies List
        if (nearbyPharmacies.isNotEmpty) ...[
          const Text(
            "Nearby Pharmacies",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kPatientPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...nearbyPharmacies.take(3).map((pharmacy) => _buildPharmacyCard(pharmacy)),

          if (nearbyPharmacies.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "+ ${nearbyPharmacies.length - 3} more pharmacies nearby",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ] else if (currentPosition != null) ...[
          const Text(
            "Nearby Pharmacies",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kPatientPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildNoPharmaciesCard(),
        ],
      ],
    );
  }

  Widget _buildPharmacyCard(PharmacyEntity pharmacy) {
    final isOpen = _isPharmacyOpen(pharmacy);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Pharmacy Icon with Verification Badge
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor.kPatientPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_pharmacy,
                    color: AppColor.kPatientPrimary,
                    size: 28,
                  ),
                ),
                if (pharmacy.isVerified)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Pharmacy Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pharmacy.pharmacyName, // ✅ CORRECT: using pharmacyName
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // ✅ ADD FAVORITE BUTTON
                      BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                          final isFavorite = _isPharmacyFavorite(pharmacy.id, state);
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey[400],
                              size: 22,
                            ),
                            onPressed: () {
                              onTogglePharmacyFavorite?.call(pharmacy.id, pharmacy.pharmacyName); // ✅ CORRECT: using pharmacyName
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pharmacy.address, // ✅ CORRECT: using address
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pharmacy.phone, // ✅ CORRECT: using phone
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      if (pharmacy.distanceFromPatient != null) ...[
                        Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${pharmacy.distanceFromPatient!.toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // ✅ OPEN/CLOSED STATUS WITH OPERATING HOURS
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOpen ? Icons.check_circle : Icons.cancel,
                          size: 12,
                          color: isOpen ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOpen ? 'Open Now' : 'Closed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isOpen ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${pharmacy.openingTime} - ${pharmacy.closingTime}', // ✅ CORRECT: using openingTime and closingTime
                          style: TextStyle(
                            fontSize: 11,
                            color: isOpen ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ OPERATING DAYS
                  if (pharmacy.operatingDays.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: pharmacy.operatingDays.map((day) { // ✅ CORRECT: using operatingDays
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            day.substring(0, 3),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPharmaciesCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.local_pharmacy_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            const Text(
              'No nearby pharmacies found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try updating your location or increasing search radius',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}