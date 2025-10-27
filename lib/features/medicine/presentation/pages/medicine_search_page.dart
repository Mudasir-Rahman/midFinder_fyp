// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
// import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';
//
// import '../widget/medicine_card.dart';
// import '../widget/medicine_search_bar.dart';
// import 'medicine_detail_page.dart';
//
// // --- Global Constants for Styling ---
// const Color kPrimaryColor = Color(0xFF0056D2); // Deep Blue
// const Color kAccentColor = Color(0xFF42A5F5); // Bright Sky Blue
// const Color kBackgroundColor = Color(0xFFF5F7FA); // Light Gray/Off-White
// const double kPadding = 20.0;
// const double kRadius = 16.0;
//
// class MedicineSearchPage extends StatefulWidget {
//   const MedicineSearchPage({super.key});
//
//   @override
//   State<MedicineSearchPage> createState() => _MedicineSearchPageState();
// }
//
// class _MedicineSearchPageState extends State<MedicineSearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final _debouncer = _Debouncer(milliseconds: 500);
//
//   @override
//   void initState() {
//     super.initState();
//     // Load all medicines initially
//     context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         // Added Back Button logic
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Medicine Catalog',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w800,
//             fontSize: 22,
//             letterSpacing: -0.5,
//           ),
//         ),
//         backgroundColor: kPrimaryColor,
//         elevation: 0, // Removed shadow for modern look
//         centerTitle: true,
//         // Enhanced App Bar shape
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(kRadius * 2), // 32.0 radius
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
//         child: Column(
//           children: [
//             // Medicine Search Bar - Elevated and Stylized
//             _buildSearchBar(),
//             const SizedBox(height: 16),
//             // Results/Status display area
//             Expanded(
//               child: BlocConsumer<MedicineBloc, MedicineState>(
//                 listener: (context, state) {
//                   if (state is MedicineError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Error: ${state.message}'),
//                         backgroundColor: Colors.red.shade600,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is MedicineLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: kPrimaryColor),
//                     );
//                   } else if (state is MedicineLoaded) {
//                     if (state.medicines.isEmpty) {
//                       return _buildEmptyState();
//                     }
//                     return _buildMedicineList(state);
//                   } else if (state is MedicineError) {
//                     return _buildErrorState(state.message);
//                   }
//                   // Initial state text
//                   return const Center(
//                     child: Text(
//                       'Search for specific medicines or view the full catalog below.',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                       textAlign: TextAlign.center,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- Helper Widgets for UI Beauty ---
//
//   Widget _buildSearchBar() {
//     return MedicineSearchBar(
//       controller: _searchController,
//       onSearch: (query) {
//         _debouncer.run(() {
//           if (query.isEmpty) {
//             context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
//           } else {
//             // Trim query to handle accidental spaces
//             context.read<MedicineBloc>().add(SearchMedicineEvent(query.trim()));
//           }
//         });
//       },
//       // Assuming MedicineSearchBar has its own stylish design
//     );
//   }
//
//   Widget _buildMedicineList(MedicineLoaded state) {
//     return ListView.builder(
//       // Padding only on the bottom to account for the overall page padding
//       padding: const EdgeInsets.only(bottom: kPadding),
//       itemCount: state.medicines.length,
//       itemBuilder: (context, index) {
//         final medicine = state.medicines[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12.0),
//           child: MedicineCard(
//             medicine: medicine,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MedicineDetailPage(medicineId: medicine.id),
//                 ),
//               );
//             },
//             // Assuming MedicineCard has a modern elevated look
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.medication_liquid_outlined, size: 80, color: kAccentColor),
//           const SizedBox(height: 20),
//           const Text(
//             'Couldn\'t find that medicine!',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try checking your spelling or searching for a different drug name.',
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () {
//               // Clear search and reload all
//               _searchController.clear();
//               context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
//             },
//             icon: const Icon(Icons.refresh_rounded),
//             label: const Text('View All Medicines'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kAccentColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
//           const SizedBox(height: 16),
//           const Text(
//             'Connection Error',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Failed to load medicines: $message',
//             style: const TextStyle(fontSize: 15, color: Colors.redAccent),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kPrimaryColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
//             ),
//             child: const Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debouncer.dispose();
//     super.dispose();
//   }
// }
//
// // Debouncer Class (Remains the same, but included for completeness)
// class _Debouncer {
//   final int milliseconds;
//   Timer? _timer;
//
//   _Debouncer({required this.milliseconds});
//
//   void run(VoidCallback action) {
//     _timer?.cancel();
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
//
//   void dispose() {
//     _timer?.cancel();
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_event.dart';
import 'package:rx_locator/features/medicine/presentation/bloc/medicine_state.dart';

import '../widget/medicine_card.dart';
import '../widget/medicine_search_bar.dart';
import 'medicine_detail_page.dart';

const Color kPrimaryColor = Color(0xFF0056D2);
const Color kAccentColor = Color(0xFF42A5F5);
const Color kBackgroundColor = Color(0xFFF5F7FA);
const double kPadding = 20.0;
const double kRadius = 16.0;

class MedicineSearchPage extends StatefulWidget {
  final double? patientLatitude;
  final double? patientLongitude;
  final bool isPatient; // <-- Flag to differentiate patient vs pharmacy owner

  const MedicineSearchPage({
    super.key,
    this.patientLatitude,
    this.patientLongitude,
    this.isPatient = false,
  });

  @override
  State<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = _Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    // Load all medicines initially
    context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Medicine Catalog',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(kRadius * 2)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<MedicineBloc, MedicineState>(
                listener: (context, state) {
                  if (state is MedicineError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.message}'),
                        backgroundColor: Colors.red.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MedicineLoading) {
                    return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
                  } else if (state is MedicineLoaded) {
                    if (state.medicines.isEmpty) return _buildEmptyState();
                    return _buildMedicineList(state);
                  } else if (state is MedicineError) {
                    return _buildErrorState(state.message);
                  }
                  return const Center(
                    child: Text(
                      'Search for medicines or view the full catalog below.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return MedicineSearchBar(
      controller: _searchController,
      onSearch: (query) {
        _debouncer.run(() {
          if (query.isEmpty) {
            context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
          } else {
            if (widget.isPatient && widget.patientLatitude != null && widget.patientLongitude != null) {
              // Patient nearby search
              context.read<MedicineBloc>().add(SearchNearbyMedicineEvent(
                query: query.trim(),
                latitude: widget.patientLatitude!,
                longitude: widget.patientLongitude!,
              ));
            } else {
              // Pharmacy owner search
              context.read<MedicineBloc>().add(SearchMedicineEvent(query: query.trim()));
            }
          }
        });
      },
    );
  }

  Widget _buildMedicineList(MedicineLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: kPadding),
      itemCount: state.medicines.length,
      itemBuilder: (context, index) {
        final medicine = state.medicines[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: MedicineCard(
            medicine: medicine,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicineDetailPage(medicineId: medicine.id)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medication_liquid_outlined, size: 80, color: kAccentColor),
          const SizedBox(height: 20),
          const Text(
            'Couldn\'t find that medicine!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Try checking your spelling or searching for a different drug name.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              context.read<MedicineBloc>().add(const GetAllMedicinesEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('View All Medicines'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'Connection Error',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load medicines: $message',
            style: const TextStyle(fontSize: 15, color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<MedicineBloc>().add(const GetAllMedicinesEvent()),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }
}

class _Debouncer {
  final int milliseconds;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer?.cancel();
}
