import 'package:flutter/material.dart';

class PatientDashboard extends StatelessWidget {
  final String userId;

  const PatientDashboard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedFinder - Patient Dashboard'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Nearby Medicines Section
            _buildNearbyMedicines(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Search medicines
        },
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green[100],
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find your medicines easily',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              icon: Icons.search,
              title: 'Search Medicines',
              subtitle: 'Find specific medicines',
              color: Colors.blue,
              onTap: () {
                _showDummyDialog(context, 'Search Medicines', 'This would open medicine search');
              },
            ),
            _buildActionCard(
              icon: Icons.local_pharmacy,
              title: 'Nearby Pharmacies',
              subtitle: 'Find pharmacies near you',
              color: Colors.orange,
              onTap: () {
                _showDummyDialog(context, 'Nearby Pharmacies', 'This would show nearby pharmacies');
              },
            ),
            _buildActionCard(
              icon: Icons.medical_services,
              title: 'Order History',
              subtitle: 'View your past orders',
              color: Colors.purple,
              onTap: () {
                _showDummyDialog(context, 'Order History', 'This would show your order history');
              },
            ),
            _buildActionCard(
              icon: Icons.favorite,
              title: 'Saved Items',
              subtitle: 'Your favorite medicines',
              color: Colors.red,
              onTap: () {
                _showDummyDialog(context, 'Saved Items', 'This would show your saved medicines');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyMedicines() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Nearby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _MedicineCard(
                  medicineName: 'Paracetamol 500mg',
                  pharmacyName: 'City Pharmacy',
                  distance: '0.8 km',
                  price: 'Rs. 50',
                  isAvailable: true,
                ),
                _MedicineCard(
                  medicineName: 'Amoxicillin 250mg',
                  pharmacyName: 'Health Plus',
                  distance: '1.2 km',
                  price: 'Rs. 120',
                  isAvailable: true,
                ),
                _MedicineCard(
                  medicineName: 'Vitamin C 1000mg',
                  pharmacyName: 'MediCare',
                  distance: '0.5 km',
                  price: 'Rs. 80',
                  isAvailable: false,
                ),
                _MedicineCard(
                  medicineName: 'Ibuprofen 400mg',
                  pharmacyName: 'Quick Meds',
                  distance: '1.5 km',
                  price: 'Rs. 65',
                  isAvailable: true,
                ),
                _MedicineCard(
                  medicineName: 'Cetirizine 10mg',
                  pharmacyName: 'City Pharmacy',
                  distance: '0.8 km',
                  price: 'Rs. 45',
                  isAvailable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDummyDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final String medicineName;
  final String pharmacyName;
  final String distance;
  final String price;
  final bool isAvailable;

  const _MedicineCard({
    required this.medicineName,
    required this.pharmacyName,
    required this.distance,
    required this.price,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pharmacyName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isAvailable ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: isAvailable ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}