// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../../../../core/constant/app_color.dart';
// import '../../../../medicine/domain/entities/medicine_entity.dart';
// import '../../../../pharmacy/domain/entity/pharmacy_entity.dart';
//
// class MedicineSection extends StatefulWidget {
//   final List<PharmacyEntity> nearbyPharmacies;
//   final Position? currentPosition;
//   final List<MedicineEntity> allMedicines;
//   final Function(String) onSearchRequested;
//
//   const MedicineSection({
//     super.key,
//     required this.nearbyPharmacies,
//     required this.currentPosition,
//     required this.allMedicines,
//     required this.onSearchRequested,
//   });
//
//   @override
//   State<MedicineSection> createState() => _MedicineSectionState();
// }
//
// class _MedicineSectionState extends State<MedicineSection> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   String _sortBy = 'name'; // name, price, distance
//
//   PharmacyEntity? _findPharmacyForMedicine(MedicineEntity medicine) {
//     if (widget.nearbyPharmacies.isEmpty) return null;
//     try {
//       return widget.nearbyPharmacies.firstWhere(
//             (pharmacy) => pharmacy.id == medicine.pharmacyId,
//       );
//     } catch (e) {
//       return null;
//     }
//   }
//
//   List<MedicineEntity> _getSortedMedicines() {
//     List<MedicineEntity> medicines = List.from(widget.allMedicines);
//
//     if (_sortBy == 'price') {
//       medicines.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
//     } else if (_sortBy == 'distance' && widget.currentPosition != null) {
//       medicines.sort((a, b) {
//         final pharmacyA = _findPharmacyForMedicine(a);
//         final pharmacyB = _findPharmacyForMedicine(b);
//
//         if (pharmacyA == null || pharmacyB == null) return 0;
//
//         final distA = Geolocator.distanceBetween(
//           widget.currentPosition!.latitude,
//           widget.currentPosition!.longitude,
//           pharmacyA.latitude ?? 0,
//           pharmacyA.longitude ?? 0,
//         );
//         final distB = Geolocator.distanceBetween(
//           widget.currentPosition!.latitude,
//           widget.currentPosition!.longitude,
//           pharmacyB.latitude ?? 0,
//           pharmacyB.longitude ?? 0,
//         );
//
//         return distA.compareTo(distB);
//       });
//     }
//
//     return medicines;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sortedMedicines = _getSortedMedicines();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section Header
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               _isSearching ? "Search Results" : "Available Medicines",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColor.kPatientPrimary,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             _buildSortButton(),
//           ],
//         ),
//         const SizedBox(height: 16),
//
//         // Search Bar
//         _buildSearchBar(),
//         const SizedBox(height: 16),
//
//         // Results Count
//         if (sortedMedicines.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               '${sortedMedicines.length} medicine${sortedMedicines.length != 1 ? 's' : ''} found',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//
//         // Medicine List
//         if (sortedMedicines.isEmpty)
//           _buildEmptyState()
//         else
//           ...sortedMedicines.take(5).map((medicine) {
//             final pharmacy = _findPharmacyForMedicine(medicine);
//             double? distance;
//
//             if (pharmacy != null &&
//                 widget.currentPosition != null &&
//                 pharmacy.latitude != null &&
//                 pharmacy.longitude != null) {
//               distance = Geolocator.distanceBetween(
//                 widget.currentPosition!.latitude,
//                 widget.currentPosition!.longitude,
//                 pharmacy.latitude!,
//                 pharmacy.longitude!,
//               ) / 1000;
//             }
//
//             return _buildMedicineCard(medicine, pharmacy, distance);
//           }),
//       ],
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         style: const TextStyle(fontSize: 15),
//         decoration: InputDecoration(
//           hintText: 'Search by medicine name...',
//           hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
//           prefixIcon: Icon(
//             Icons.search_rounded,
//             color: AppColor.kPatientPrimary,
//             size: 22,
//           ),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//             icon: Icon(Icons.clear_rounded, color: Colors.grey[400], size: 20),
//             onPressed: () {
//               _searchController.clear();
//               setState(() => _isSearching = false);
//               widget.onSearchRequested('');
//             },
//           )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(
//               color: AppColor.kPatientPrimary,
//               width: 2,
//             ),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//         onChanged: (query) {
//           setState(() => _isSearching = query.isNotEmpty);
//           widget.onSearchRequested(query);
//         },
//       ),
//     );
//   }
//
//   Widget _buildSortButton() {
//     return PopupMenuButton<String>(
//       icon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColor.kPatientPrimary.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(
//           Icons.sort_rounded,
//           color: AppColor.kPatientPrimary,
//           size: 20,
//         ),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       onSelected: (value) {
//         setState(() => _sortBy = value);
//       },
//       itemBuilder: (context) => [
//         _buildSortMenuItem('name', 'Name (A-Z)', Icons.sort_by_alpha),
//         _buildSortMenuItem('price', 'Price (Low to High)', Icons.attach_money),
//         if (widget.currentPosition != null)
//           _buildSortMenuItem('distance', 'Distance (Nearest)', Icons.near_me),
//       ],
//     );
//   }
//
//   PopupMenuItem<String> _buildSortMenuItem(String value, String label, IconData icon) {
//     final isSelected = _sortBy == value;
//     return PopupMenuItem<String>(
//       value: value,
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: isSelected ? AppColor.kPatientPrimary : Colors.grey[600],
//           ),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? AppColor.kPatientPrimary : Colors.black87,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//           if (isSelected) ...[
//             const Spacer(),
//             Icon(Icons.check, size: 18, color: AppColor.kPatientPrimary),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMedicineCard(MedicineEntity medicine, PharmacyEntity? pharmacy, double? distance) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             _showMedicineDetails(medicine, pharmacy, distance);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Medicine Image/Icon
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: AppColor.kPatientPrimary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(14),
//                     image: medicine.imageUrl != null && medicine.imageUrl!.isNotEmpty
//                         ? DecorationImage(
//                       image: NetworkImage(medicine.imageUrl!),
//                       fit: BoxFit.cover,
//                     )
//                         : null,
//                   ),
//                   child: medicine.imageUrl == null || medicine.imageUrl!.isEmpty
//                       ? Icon(
//                     Icons.medication_rounded,
//                     color: AppColor.kPatientPrimary,
//                     size: 30,
//                   )
//                       : null,
//                 ),
//                 const SizedBox(width: 14),
//
//                 // Medicine Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               medicine.medicineName,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           _buildAvailabilityBadge(medicine.isAvailable ?? false),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         medicine.genericName,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Pharmacy & Distance Row
//                       Row(
//                         children: [
//                           Icon(Icons.local_pharmacy, size: 14, color: Colors.grey[500]),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               pharmacy?.pharmacyName ?? medicine.pharmacyName ?? 'Unknown',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           if (distance != null) ...[
//                             const SizedBox(width: 8),
//                             Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
//                             const SizedBox(width: 2),
//                             Text(
//                               '${distance.toStringAsFixed(1)} km',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//
//                       if (medicine.price != null) ...[
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.green[50],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             'Rs ${medicine.price!.toStringAsFixed(0)}',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green[700],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvailabilityBadge(bool isAvailable) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: isAvailable ? Colors.green[50] : Colors.red[50],
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isAvailable ? Icons.check_circle : Icons.cancel,
//             size: 12,
//             color: isAvailable ? Colors.green[700] : Colors.red[700],
//           ),
//           const SizedBox(width: 4),
//           Text(
//             isAvailable ? 'Available' : 'Out',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: isAvailable ? Colors.green[700] : Colors.red[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(
//               _isSearching ? Icons.search_off : Icons.medication_outlined,
//               size: 64,
//               color: Colors.grey[300],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _isSearching ? 'No medicines found' : 'No medicines available',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               _isSearching ? 'Try a different search term' : 'Check back later',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showMedicineDetails(MedicineEntity medicine, PharmacyEntity? pharmacy, double? distance) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               medicine.medicineName,
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Generic: ${medicine.genericName}',
//               style: TextStyle(fontSize: 15, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 16),
//             _buildDetailRow(Icons.local_pharmacy, 'Pharmacy',
//                 pharmacy?.pharmacyName ?? medicine.pharmacyName ?? 'Unknown'),
//             if (medicine.price != null)
//               _buildDetailRow(Icons.attach_money, 'Price',
//                   'Rs ${medicine.price!.toStringAsFixed(0)}'),
//             if (distance != null)
//               _buildDetailRow(Icons.location_on, 'Distance',
//                   '${distance.toStringAsFixed(2)} km away'),
//             _buildDetailRow(Icons.inventory, 'Availability',
//                 medicine.isAvailable == true ? 'In Stock' : 'Out of Stock'),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${medicine.medicineName} added to cart'),
//                       behavior: SnackBarBehavior.floating,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.kPatientPrimary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Add to Cart',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: AppColor.kPatientPrimary),
//           const SizedBox(width: 12),
//           Text(
//             '$label: ',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/constant/app_color.dart';
import '../../../../medicine/domain/entities/medicine_entity.dart';
import '../../../../pharmacy/domain/entity/pharmacy_entity.dart';
// ✅ ADD FAVORITE IMPORTS
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';
import '../../../domain/entity/favorite_entity.dart';

class MedicineSection extends StatefulWidget {
  final List<PharmacyEntity> nearbyPharmacies;
  final Position? currentPosition;
  final List<MedicineEntity> allMedicines;
  final Function(String) onSearchRequested;
  // ✅ ADD FAVORITE CALLBACK
  final Function(String, String, String?, double?)? onToggleMedicineFavorite;

  const MedicineSection({
    super.key,
    required this.nearbyPharmacies,
    required this.currentPosition,
    required this.allMedicines,
    required this.onSearchRequested,
    this.onToggleMedicineFavorite, // ✅ NEW PARAMETER
  });

  @override
  State<MedicineSection> createState() => _MedicineSectionState();
}

class _MedicineSectionState extends State<MedicineSection> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _sortBy = 'name'; // name, price, distance

  PharmacyEntity? _findPharmacyForMedicine(MedicineEntity medicine) {
    if (widget.nearbyPharmacies.isEmpty) return null;
    try {
      return widget.nearbyPharmacies.firstWhere(
            (pharmacy) => pharmacy.id == medicine.pharmacyId,
      );
    } catch (e) {
      return null;
    }
  }

  List<MedicineEntity> _getSortedMedicines() {
    List<MedicineEntity> medicines = List.from(widget.allMedicines);

    if (_sortBy == 'price') {
      medicines.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (_sortBy == 'distance' && widget.currentPosition != null) {
      medicines.sort((a, b) {
        final pharmacyA = _findPharmacyForMedicine(a);
        final pharmacyB = _findPharmacyForMedicine(b);

        if (pharmacyA == null || pharmacyB == null) return 0;

        final distA = Geolocator.distanceBetween(
          widget.currentPosition!.latitude,
          widget.currentPosition!.longitude,
          pharmacyA.latitude ?? 0,
          pharmacyA.longitude ?? 0,
        );
        final distB = Geolocator.distanceBetween(
          widget.currentPosition!.latitude,
          widget.currentPosition!.longitude,
          pharmacyB.latitude ?? 0,
          pharmacyB.longitude ?? 0,
        );

        return distA.compareTo(distB);
      });
    }

    return medicines;
  }

  // ✅ CHECK IF MEDICINE IS FAVORITE
  bool _isMedicineFavorite(String medicineId, FavoriteState state) {
    if (state is FavoritesLoaded) {
      return state.favorites.any((fav) =>
      fav.itemId == medicineId && fav.type == FavoriteType.medicine);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final sortedMedicines = _getSortedMedicines();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isSearching ? "Search Results" : "Available Medicines",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.kPatientPrimary,
                letterSpacing: 0.3,
              ),
            ),
            _buildSortButton(),
          ],
        ),
        const SizedBox(height: 16),

        // Search Bar
        _buildSearchBar(),
        const SizedBox(height: 16),

        // Results Count
        if (sortedMedicines.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${sortedMedicines.length} medicine${sortedMedicines.length != 1 ? 's' : ''} found',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Medicine List
        if (sortedMedicines.isEmpty)
          _buildEmptyState()
        else
          ...sortedMedicines.take(5).map((medicine) {
            final pharmacy = _findPharmacyForMedicine(medicine);
            double? distance;

            if (pharmacy != null &&
                widget.currentPosition != null &&
                pharmacy.latitude != null &&
                pharmacy.longitude != null) {
              distance = Geolocator.distanceBetween(
                widget.currentPosition!.latitude,
                widget.currentPosition!.longitude,
                pharmacy.latitude!,
                pharmacy.longitude!,
              ) / 1000;
            }

            return _buildMedicineCard(medicine, pharmacy, distance);
          }),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search by medicine name...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColor.kPatientPrimary,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear_rounded, color: Colors.grey[400], size: 20),
            onPressed: () {
              _searchController.clear();
              setState(() => _isSearching = false);
              widget.onSearchRequested('');
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColor.kPatientPrimary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (query) {
          setState(() => _isSearching = query.isNotEmpty);
          widget.onSearchRequested(query);
        },
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.kPatientPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.sort_rounded,
          color: AppColor.kPatientPrimary,
          size: 20,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        setState(() => _sortBy = value);
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('name', 'Name (A-Z)', Icons.sort_by_alpha),
        _buildSortMenuItem('price', 'Price (Low to High)', Icons.attach_money),
        if (widget.currentPosition != null)
          _buildSortMenuItem('distance', 'Distance (Nearest)', Icons.near_me),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value, String label, IconData icon) {
    final isSelected = _sortBy == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColor.kPatientPrimary : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColor.kPatientPrimary : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: AppColor.kPatientPrimary),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicineCard(MedicineEntity medicine, PharmacyEntity? pharmacy, double? distance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showMedicineDetails(medicine, pharmacy, distance);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medicine Image/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColor.kPatientPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    image: medicine.imageUrl != null && medicine.imageUrl!.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(medicine.imageUrl!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: medicine.imageUrl == null || medicine.imageUrl!.isEmpty
                      ? Icon(
                    Icons.medication_rounded,
                    color: AppColor.kPatientPrimary,
                    size: 30,
                  )
                      : null,
                ),
                const SizedBox(width: 14),

                // Medicine Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medicine.medicineName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // ✅ ADD FAVORITE BUTTON
                          BlocBuilder<FavoriteBloc, FavoriteState>(
                            builder: (context, state) {
                              final isFavorite = _isMedicineFavorite(medicine.id, state);
                              return IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey[400],
                                  size: 22,
                                ),
                                onPressed: () {
                                  widget.onToggleMedicineFavorite?.call(
                                    medicine.id,
                                    medicine.medicineName,
                                    medicine.imageUrl,
                                    medicine.price,
                                  );
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
                      const SizedBox(height: 6),
                      Text(
                        medicine.genericName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Pharmacy & Distance Row
                      Row(
                        children: [
                          Icon(Icons.local_pharmacy, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pharmacy?.pharmacyName ?? medicine.pharmacyName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (distance != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 2),
                            Text(
                              '${distance.toStringAsFixed(1)} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (medicine.price != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Rs ${medicine.price!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isAvailable ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'Available' : 'Out',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isAvailable ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              _isSearching ? Icons.search_off : Icons.medication_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching ? 'No medicines found' : 'No medicines available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isSearching ? 'Try a different search term' : 'Check back later',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicineDetails(MedicineEntity medicine, PharmacyEntity? pharmacy, double? distance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ✅ ADD FAVORITE BUTTON TO DETAILS VIEW
            Row(
              children: [
                Expanded(
                  child: Text(
                    medicine.medicineName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    final isFavorite = _isMedicineFavorite(medicine.id, state);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        widget.onToggleMedicineFavorite?.call(
                          medicine.id,
                          medicine.medicineName,
                          medicine.imageUrl,
                          medicine.price,
                        );
                        Navigator.pop(context); // Close details after toggling
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Generic: ${medicine.genericName}',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.local_pharmacy, 'Pharmacy',
                pharmacy?.pharmacyName ?? medicine.pharmacyName ?? 'Unknown'),
            if (medicine.price != null)
              _buildDetailRow(Icons.attach_money, 'Price',
                  'Rs ${medicine.price!.toStringAsFixed(0)}'),
            if (distance != null)
              _buildDetailRow(Icons.location_on, 'Distance',
                  '${distance.toStringAsFixed(2)} km away'),
            _buildDetailRow(Icons.inventory, 'Availability',
                medicine.isAvailable == true ? 'In Stock' : 'Out of Stock'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${medicine.medicineName} added to cart'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kPatientPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColor.kPatientPrimary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}