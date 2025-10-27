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
import '../widget/quick_actions.dart';

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

    _loadPatientData();
    _controller.forward();
  }

  Future<void> _loadPatientData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAuthError(context));
      return;
    }

    if (!_profileLoaded) {
      context.read<PatientBloc>().add(GetPatientProfileEvent(userId: widget.userId));
    }
    context.read<MedicineBloc>().add(GetAllMedicinesEvent());
  }

  void _showAuthError(BuildContext context) {
    _showSnack('Please log in to continue', isError: true);
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

  void _handleMedicineSearch(String query) {
    if (query.isEmpty) {
      context.read<MedicineBloc>().add(GetAllMedicinesEvent());
    } else {
      context.read<MedicineBloc>().add(SearchMedicineEvent(query: query));
    }
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

                              // Quick Actions
                              QuickActions(onActionSelected: (action) {
                                debugPrint("Action: $action");
                              }),
                              const SizedBox(height: 28),

                              // Location & Pharmacies Section
                              LocationSection(
                                patient: patient,
                                currentPosition: _currentPosition,
                                nearbyPharmacies: _nearbyPharmacies,
                                isUpdating: _isUpdatingLocation,
                                onUpdateLocation: _getCurrentLocation,
                              ),
                              const SizedBox(height: 28),

                              // Medicines Section
                              _buildMedicinesSection(primary),
                              const SizedBox(height: 28),

                              // Services Section
                              ServiceCards(
                                screenWidth: screenWidth,
                                onServiceTap: (service) {
                                  debugPrint("Service tapped: $service");
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

  Widget _buildMedicinesSection(Color primary) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, medState) {
        if (medState is MedicineLoading) {
          return LoadingStates.buildLoadingCard('Loading medicines...');
        }

        if (medState is MedicineLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicineSection(
                nearbyPharmacies: _nearbyPharmacies,
                currentPosition: _currentPosition,
                allMedicines: medState.medicines,
                onSearchRequested: _handleMedicineSearch,
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