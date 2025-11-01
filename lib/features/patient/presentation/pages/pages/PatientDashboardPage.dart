
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../../../init_dependence.dart';
import '../../../../medicine/presentation/bloc/medicine_bloc.dart';
import '../../../../medicine/presentation/bloc/medicine_event.dart';
import '../../../../medicine/presentation/bloc/medicine_state.dart';
import '../../../../pharmacy/domain/entity/pharmacy_entity.dart';
import '../../../../pharmacy/domain/usecase/search_nearby_pharmacies.dart';
import '../../../domain/entity/patient_entity.dart';
import '../../bloc/patient_bloc.dart';
import '../../bloc/patient_event.dart';
import '../../bloc/patient_state.dart';
import '../widget/dashboard_app_bar.dart';
import '../widget/loading_states.dart';
import '../widget/location_section.dart';
import '../widget/location_status_card.dart';
import '../widget/medicine_section.dart';
import '../widget/service_cards.dart';
import '../widget/quick_actions.dart'; // ✅ NORMAL IMPORT

// ✅ FAVORITE IMPORTS
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';
import '../../../domain/entity/favorite_entity.dart';
import 'favorites_screen.dart';

class PatientDashboard extends StatefulWidget {
  final String userId;
  final PatientEntity? initialPatient;

  const PatientDashboard({
    super.key,
    required this.userId,
    this.initialPatient,
  });

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isUpdatingLocation = false;
  Position? _currentPosition;
  List<PharmacyEntity> _nearbyPharmacies = [];
  PatientEntity? _currentPatient;
  bool _profileLoaded = false;

  // ✅ ADD MEDICINE CATEGORIES BASED ON YOUR ENTITY
  final List<MedicineCategory> _medicineCategories = [
    MedicineCategory(name: 'All', icon: Icons.medication, category: 'all'),
    MedicineCategory(name: 'Pain Relief', icon: Icons.sick, category: 'Analgesics'),
    MedicineCategory(name: 'Antibiotics', icon: Icons.health_and_safety, category: 'Antibiotics'),
    MedicineCategory(name: 'Vitamins', icon: Icons.eco, category: 'Vitamins'),
    MedicineCategory(name: 'Cold & Flu', icon: Icons.ac_unit, category: 'Cold & Flu'),
    MedicineCategory(name: 'Cardiac', icon: Icons.favorite, category: 'Cardiovascular'),
    MedicineCategory(name: 'Diabetes', icon: Icons.bloodtype, category: 'Diabetes'),
    MedicineCategory(name: 'Other', icon: Icons.medical_services, category: 'Other'),
  ];

  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();

    if (widget.initialPatient != null) {
      _currentPatient = widget.initialPatient;
      _profileLoaded = true;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatientData();
    });

    _controller.forward();
  }

  Future<void> _loadPatientData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showAuthError();
      return;
    }

    if (!_profileLoaded) {
      context.read<PatientBloc>().add(GetPatientProfileEvent(userId: widget.userId));
    }
    context.read<MedicineBloc>().add(GetAllMedicinesEvent());

    // ✅ LOAD PATIENT'S FAVORITES
    context.read<FavoriteBloc>().add(LoadFavoritesEvent(patientId: widget.userId));
  }

  void _showAuthError() {
    if (mounted) {
      _showSnack('Please log in to continue', isError: true);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isUpdatingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permission is required to find nearby pharmacies', isError: true);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnack('Please enable location permissions in settings', isError: true);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      context.read<PatientBloc>().add(UpdatePatientLocationEvent(
        userId: widget.userId,
        latitude: position.latitude,
        longitude: position.longitude,
      ));

      await _getNearbyPharmacies(position.latitude, position.longitude);
      _showSnack("Location updated successfully!");
    } catch (e) {
      _showSnack('Unable to get location. Please try again.', isError: true);
    } finally {
      setState(() => _isUpdatingLocation = false);
    }
  }

  Future<void> _getNearbyPharmacies(double latitude, double longitude) async {
    try {
      final searchNearbyPharmacies = sl<SearchNearbyPharmacies>();
      final result = await searchNearbyPharmacies(SearchNearbyPharmaciesParams(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: 10,
      ));

      result.fold(
            (failure) => _showSnack('Unable to load nearby pharmacies', isError: true),
            (pharmacies) => setState(() => _nearbyPharmacies = pharmacies),
      );
    } catch (e) {
      _showSnack('Error loading pharmacies', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  // ✅ ADD CATEGORY SELECTION METHOD
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == 'all') {
      context.read<MedicineBloc>().add(GetAllMedicinesEvent());
    } else {
      context.read<MedicineBloc>().add(GetMedicineByCategoryEvent(category: category));
    }
  }

  void _handleMedicineSearch(String query) {
    if (query.isEmpty) {
      if (_selectedCategory == 'all') {
        context.read<MedicineBloc>().add(GetAllMedicinesEvent());
      } else {
        context.read<MedicineBloc>().add(GetMedicineByCategoryEvent(category: _selectedCategory));
      }
    } else {
      context.read<MedicineBloc>().add(SearchMedicineEvent(query: query));
    }
  }

  // ✅ ADD FAVORITE FUNCTIONALITY
  void _toggleMedicineFavorite(String medicineId, String medicineName, String? imageUrl, double? price) {
    context.read<FavoriteBloc>().add(ToggleFavoriteEvent(
      patientId: widget.userId,
      itemId: medicineId,
      type: FavoriteType.medicine,
      itemName: medicineName,
      itemImage: imageUrl,
      itemPrice: price,
    ));
  }

  void _togglePharmacyFavorite(String pharmacyId, String pharmacyName) {
    context.read<FavoriteBloc>().add(ToggleFavoriteEvent(
      patientId: widget.userId,
      itemId: pharmacyId,
      type: FavoriteType.pharmacy,
      itemName: pharmacyName,
      itemImage: null,
      itemPrice: null,
    ));
  }

  // ✅ UPDATED FAVORITES SCREEN NAVIGATION WITH DEBUG PRINTS
  void _navigateToFavorites() {
    print('❤️ Navigating to Favorites screen for patient: ${widget.userId}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientFavoritesScreen(patientId: widget.userId),
      ),
    ).then((_) {
      print('🔙 Returned from Favorites screen');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Color primary = AppColor.kPatientPrimary;
    final Color bgColor = AppColor.kPatientBackground2;

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFavorites,
        backgroundColor: primary,
        child: const Icon(Icons.favorite, color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocListener<PatientBloc, PatientState>(
            listener: (context, state) {
              if (state is PatientProfileLoaded) {
                setState(() {
                  _currentPatient = state.patient;
                  _profileLoaded = true;
                });
              }
              if (state is PatientError) {
                _showSnack('Error: ${state.message}', isError: true);
              }
            },
            child: BlocBuilder<PatientBloc, PatientState>(
              builder: (context, state) {
                if (state is PatientLoading && !_profileLoaded) {
                  return LoadingStates.buildLoadingState(primary);
                }

                final patient = _currentPatient;
                if (patient != null) {
                  return CustomScrollView(
                    slivers: [
                      DashboardAppBar.buildAppBar(primary, patient),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),

                              // Location Status Card
                              LocationStatusCard.build(
                                primary: primary,
                                currentPosition: _currentPosition,
                                nearbyPharmacies: _nearbyPharmacies,
                                isUpdating: _isUpdatingLocation,
                                onUpdateLocation: _getCurrentLocation,
                              ),
                              const SizedBox(height: 24),

                              // ✅ FIXED: Quick Actions with correct Favorites handling
                              QuickActions( // ✅ USE NORMAL IMPORT
                                onActionSelected: (action) {
                                  print('🎯 Quick Action Selected: $action');

                                  if (action == 'Favorites') { // ✅ FIXED: Capital F
                                    print('❤️ Navigating to Favorites screen...');
                                    _navigateToFavorites();
                                  } else {
                                    debugPrint("Action: $action");
                                    // Handle other actions
                                    switch (action) {
                                      case 'Nearby Pharmacies':
                                      // Navigate to pharmacies
                                        break;
                                      case 'My Medicines':
                                      // Navigate to medicines
                                        break;
                                      case 'Orders':
                                      // Navigate to orders
                                        break;
                                      case 'Settings':
                                      // Navigate to settings
                                        break;
                                      case 'Help':
                                      // Navigate to help
                                        break;
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 28),

                              // Location & Pharmacies Section
                              LocationSection(
                                patient: patient,
                                currentPosition: _currentPosition,
                                nearbyPharmacies: _nearbyPharmacies,
                                isUpdating: _isUpdatingLocation,
                                onUpdateLocation: _getCurrentLocation,
                                onTogglePharmacyFavorite: _togglePharmacyFavorite,
                              ),
                              const SizedBox(height: 28),

                              // ✅ ADD MEDICINE CATEGORIES SECTION
                              _buildMedicineCategoriesSection(primary),
                              const SizedBox(height: 20),

                              // Medicines Section
                              _buildMedicinesSection(primary),
                              const SizedBox(height: 28),

                              // Services Section - ADD FAVORITES SERVICE
                              ServiceCards(
                                screenWidth: screenWidth,
                                onServiceTap: (service) {
                                  if (service == 'favorites') {
                                    _navigateToFavorites();
                                  } else {
                                    debugPrint("Service tapped: $service");
                                  }
                                },
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return LoadingStates.buildLoadingState(primary);
              },
            ),
          ),
        ),
      ),
    );
  }

  // ✅ ADD MEDICINE CATEGORIES WIDGET
  Widget _buildMedicineCategoriesSection(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Medicine Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _medicineCategories.length,
            itemBuilder: (context, index) {
              final category = _medicineCategories[index];
              final isSelected = _selectedCategory == category.category;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _onCategorySelected(category.category),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isSelected ? primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: isSelected
                              ? Border.all(color: primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              color: isSelected ? Colors.white : primary,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 70,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? primary : Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesSection(Color primary) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medState) {
        if (medState is MedicineLoading) {
          return LoadingStates.buildLoadingCard('Loading medicines...');
        }

        if (medState is MedicineLoaded) {
          // ✅ FILTER MEDICINES BY AVAILABILITY
          final availableMedicines = medState.medicines.where((medicine) =>
          medicine.isAvailable == true
          ).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'all'
                          ? 'All Medicines'
                          : '$_selectedCategory Medicines',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    if (availableMedicines.isNotEmpty)
                      Text(
                        '${availableMedicines.length} available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              MedicineSection(
                nearbyPharmacies: _nearbyPharmacies,
                currentPosition: _currentPosition,
                allMedicines: availableMedicines, // ✅ Only show available medicines
                onSearchRequested: _handleMedicineSearch,
                onToggleMedicineFavorite: _toggleMedicineFavorite,
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to full medicine list
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(Icons.medication_rounded, color: primary, size: 20),
                  label: Text(
                    "View All Medicines",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (medState is MedicineError) {
          return LoadingStates.buildErrorCard(
            'Unable to load medicines',
            medState.message,
            Icons.medical_services_outlined,
          );
        }

        return LoadingStates.buildEmptyCard(
          'No medicines available',
          Icons.medication_outlined,
        );
      },
    );
  }
}

// ✅ ADD MEDICINE CATEGORY MODEL
class MedicineCategory {
  final String name;
  final IconData icon;
  final String category;

  MedicineCategory({
    required this.name,
    required this.icon,
    required this.category,
  });
}
