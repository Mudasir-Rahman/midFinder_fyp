import 'package:flutter/material.dart';

class AppColor {
  // ============ PRIMARY COLORS ============
  static const Color primaryColor = Color(0xFF1E3E72);
  static const Color primaryDark = Color(0xFF0D2B5C);
  static const Color primaryLight = Color(0xFF2E4E8F);
  static const Color primaryContainer = Color(0xFFE8EDF7);

  // ============ ACCENT COLORS ============
  static const Color accentColor = Color(0xFF63C8F2);
  static const Color accentDark = Color(0xFF4AB8E2);
  static const Color accentLight = Color(0xFF7CD8FF);
  static const Color accentContainer = Color(0xFFE8F7FD);

  // ============ SUCCESS COLORS ============
  static const Color successColor = Color(0xFF5ABA4A);
  static const Color successDark = Color(0xFF4AA83A);
  static const Color successLight = Color(0xFF6BCF59);
  static const Color successContainer = Color(0xFFE8F5E8);

  // ============ WARNING COLORS ============
  static const Color warningColor = Color(0xFFF7CC3B);
  static const Color warningDark = Color(0xFFE5BA29);
  static const Color warningLight = Color(0xFFFFDD55);
  static const Color warningContainer = Color(0xFFFFFBEB);

  // ============ ERROR COLORS ============
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFC21818);
  static const Color errorLight = Color(0xFFE53935);
  static const Color errorContainer = Color(0xFFFCE7E7);

  // ============ NEUTRAL COLORS ============
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // ============ TEXT COLORS ============
  static const Color bodyTextColor = Color(0xFF334155);
  static const Color headingColor = Color(0xFF1E293B);
  static const Color captionColor = Color(0xFF64748B);

  // ============ GREY COLORS ============
  static const Color greyColor = Color(0xFF6A737D);
  static const Color lightGreyColor = Color(0xFFE2E8F0);
  static const Color darkGreyColor = Color(0xFF475569);
  static const Color borderColor = Color(0xFFCBD5E1);

  // ============ SEMANTIC COLORS ============
  static const Color infoColor = Color(0xFF2196F3);
  static const Color highlightColor = Color(0xFFD88DBC);
  static const Color disabledColor = Color(0xFF94A3B8);
  static const Color splashColor = Color(0x66C8C8C8);

  // ============ GRADIENTS ============
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [accentColor, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [successColor, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient warningGradient = LinearGradient(
    colors: [warningColor, warningDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient errorGradient = LinearGradient(
    colors: [errorColor, errorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ BACKGROUND GRADIENTS ============
  static const Gradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFFF0F4F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const String defaultImageUrl =
      'https://via.placeholder.com/150?text=No+Image';
  static const Gradient glassGradient = LinearGradient(
    colors: [Colors.white54, Colors.white10],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ PATIENT THEME COLORS ============
  static const Color kPatientPrimary = Color(0xFF1E3E72);
  static const Color kPatientBackground1 = Color(0xFFB3C7F9);
  static const Color kPatientBackground2 = Color(0xFFDFE8FB);

  // ============ SHIMMER GRADIENT ============
  static const Gradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
