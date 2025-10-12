// import 'package:flutter/material.dart';
// import 'package:rx_locator/core/constant/app_color.dart';
// import 'package:rx_locator/core/constant/app_style.dart';
//
// class RoleSelectionCard extends StatefulWidget {
//   final String title;
//   final String description;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const RoleSelectionCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   State<RoleSelectionCard> createState() => _RoleSelectionCardState();
// }
//
// class _RoleSelectionCardState extends State<RoleSelectionCard> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _shadowAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: AppStyle.animationDuration,
//     );
//
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     if (widget.isSelected) {
//       _animationController.forward();
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant RoleSelectionCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isSelected != oldWidget.isSelected) {
//       if (widget.isSelected) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown(TapDownDetails details) {
//     _animationController.forward();
//   }
//
//   void _onTapUp(TapUpDetails details) {
//     if (!widget.isSelected) {
//       _animationController.reverse();
//     }
//     widget.onTap();
//   }
//
//   void _onTapCancel() {
//     if (!widget.isSelected) {
//       _animationController.reverse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTapDown: _onTapDown,
//         onTapUp: _onTapUp,
//         onTapCancel: _onTapCancel,
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColor.surfaceColor,
//             borderRadius: BorderRadius.circular(AppStyle.borderRadius),
//             border: Border.all(
//               color: widget.isSelected ? AppColor.primaryColor : AppColor.borderColor,
//               width: widget.isSelected ? 2 : 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColor.primaryColor.withOpacity(0.1 * _shadowAnimation.value),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               // Selection highlight
//               if (widget.isSelected)
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: AppColor.primaryColor,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: AppColor.whiteColor,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Icon
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         gradient: widget.isSelected
//                             ? AppColor.accentGradient
//                             : LinearGradient(
//                           colors: [
//                             AppColor.lightGreyColor,
//                             AppColor.borderColor,
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Icon(
//                         widget.icon,
//                         color: widget.isSelected ? AppColor.whiteColor : AppColor.greyColor,
//                         size: 28,
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Title
//                     Text(
//                       widget.title,
//                       style: AppStyle.heading3.copyWith(
//                         color: widget.isSelected ? AppColor.primaryColor : AppColor.headingColor,
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     // Description
//                     Text(
//                       widget.description,
//                       style: AppStyle.bodySmall.copyWith(
//                         color: widget.isSelected ? AppColor.primaryColor : AppColor.captionColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }