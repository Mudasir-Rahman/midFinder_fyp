import 'package:flutter/material.dart';

class PharmacyInfoForm extends StatelessWidget {
  final TextEditingController pharmacyNameController;
  final TextEditingController licenseNumberController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final Function(double, double) onLocationSelected;

  const PharmacyInfoForm({
    Key? key,
    required this.pharmacyNameController,
    required this.licenseNumberController,
    required this.addressController,
    required this.phoneController,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pharmacy Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Pharmacy Name
            TextFormField(
              controller: pharmacyNameController,
              decoration: const InputDecoration(
                labelText: 'Pharmacy Name',
                prefixIcon: Icon(Icons.local_pharmacy),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pharmacy name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // License Number
            TextFormField(
              controller: licenseNumberController,
              decoration: const InputDecoration(
                labelText: 'License Number',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter license number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (!RegExp(r'^[0-9+-\s]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Location Selector
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _openMapForLocationSelection(context);
                },
                icon: const Icon(Icons.map),
                label: const Text('Select Location on Map'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMapForLocationSelection(BuildContext context) {
    // TODO: Implement map integration
    // For now, show a dialog or navigate to map page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Selection'),
        content: const Text('Map integration will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Set default coordinates for demo
              onLocationSelected(33.6844, 73.0479);
            },
            child: const Text('Use Current Location'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}