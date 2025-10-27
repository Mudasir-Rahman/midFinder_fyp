import 'package:flutter/material.dart';
import '../../../../../core/constant/app_color.dart';

class ServiceCards extends StatelessWidget {
  final double screenWidth;
  final void Function(String service) onServiceTap;

  const ServiceCards({
    super.key,
    required this.screenWidth,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Find Medicine',
        'icon': Icons.search_rounded,
        'description': 'Search medicines',
        'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
      },
      {
        'title': 'Upload Prescription',
        'icon': Icons.upload_file_rounded,
        'description': 'Quick order',
        'gradient': [Color(0xFFf093fb), Color(0xFff5576c)],
      },
      {
        'title': 'Nearby Pharmacies',
        'icon': Icons.local_pharmacy_rounded,
        'description': 'Find locations',
        'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
      },
      {
        'title': 'Health Tips',
        'icon': Icons.health_and_safety_rounded,
        'description': 'Stay informed',
        'gradient': [Color(0xFF43e97b), Color(0xFF38f9d7)],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Services",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.kPatientPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _ServiceCard(
              title: service['title'] as String,
              icon: service['icon'] as IconData,
              description: service['description'] as String,
              gradient: service['gradient'] as List<Color>,
              onTap: () => onServiceTap(service['title'] as String),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient[0].withOpacity(_isPressed ? 0.3 : 0.4),
                blurRadius: _isPressed ? 8 : 15,
                offset: Offset(0, _isPressed ? 2 : 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    widget.icon,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // Text Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}