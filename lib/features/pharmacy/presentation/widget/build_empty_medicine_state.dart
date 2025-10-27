import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_state.dart';
import '../../../medicine/presentation/bloc/medicine_bloc.dart';
import '../../../medicine/presentation/bloc/medicine_event.dart';
import '../../../medicine/presentation/pages/add_medicine_page.dart';

// Add these constants if not already defined
const Color kAccentGreen = Color(0xFF00C853);

class EmptyMedicinesWidget extends StatelessWidget {
  final MedicineState state;
  final String userId;
  final VoidCallback onRefreshMedicines;
  final VoidCallback onCheckAuth;

  const EmptyMedicinesWidget({
    Key? key,
    required this.state,
    required this.userId,
    required this.onRefreshMedicines,
    required this.onCheckAuth,
  }) : super(key: key);

  void _addFirstMedicine(BuildContext context) {
    onCheckAuth();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddMedicinePage(pharmacyId: userId)),
    ).then((_) {
      onRefreshMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
                Icons.inventory_rounded,
                size: 60,
                color: Colors.grey[400]
            ),
          ),
          const SizedBox(height: 20),
          Text(
            state is MedicineLoading ? 'Loading Medicines...' : 'No Medicines Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state is MedicineLoading
                ? 'Fetching your medicine inventory...'
                : 'Start by adding your first medicine',
            style: TextStyle(color: Colors.grey[500]),
          ),
          if (state is! MedicineLoading) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _addFirstMedicine(context),
              icon: const Icon(Icons.add),
              label: const Text('Add First Medicine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Alternative version if you want to use it within a BlocConsumer
class EmptyMedicinesStateBuilder extends StatelessWidget {
  final String userId;

  const EmptyMedicinesStateBuilder({
    Key? key,
    required this.userId,
  }) : super(key: key);

  void _checkAuthForAction(BuildContext context, VoidCallback onSuccess) {
    // Implement your auth check logic here
    final user = null; // Replace with your auth check
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login again'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      onSuccess();
    }
  }

  void _refreshMedicines(BuildContext context) {
    context.read<MedicineBloc>().add(GetPharmacyMedicineEvent(userId));
  }

  void _addFirstMedicine(BuildContext context) {
    _checkAuthForAction(context, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddMedicinePage(pharmacyId: userId)),
      ).then((_) {
        _refreshMedicines(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                    Icons.inventory_rounded,
                    size: 60,
                    color: Colors.grey[400]
                ),
              ),
              const SizedBox(height: 20),
              Text(
                state is MedicineLoading ? 'Loading Medicines...' : 'No Medicines Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state is MedicineLoading
                    ? 'Fetching your medicine inventory...'
                    : 'Start by adding your first medicine',
                style: TextStyle(color: Colors.grey[500]),
              ),
              if (state is! MedicineLoading) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _addFirstMedicine(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add First Medicine'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}