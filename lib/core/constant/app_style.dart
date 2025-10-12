import 'package:flutter/material.dart';
import 'app_color.dart';

class AppStyle {
  // ============ SPACING & DIMENSIONS ============
  static const double borderRadius = 16.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderWidth = 1.5;
  static const double borderWidthThick = 2.0;
  static const double cardElevation = 8.0;
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 32.0;

  // ============ ANIMATION ============
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveBounce = Curves.elasticOut;
  static const Curve animationCurveSnappy = Curves.fastOutSlowIn;

  // ============ SHADOWS ============
  static final BoxShadow cardShadow = BoxShadow(
    color: AppColor.primaryColor.withOpacity(0.1),
    blurRadius: 20,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  );

  static final BoxShadow buttonShadow = BoxShadow(
    color: AppColor.primaryColor.withOpacity(0.3),
    blurRadius: 15,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  );

  static final BoxShadow floatingShadow = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 25,
    offset: const Offset(0, 10),
    spreadRadius: 0,
  );

  // ============ GRADIENTS ============
  static const Gradient primaryGradient = LinearGradient(
    colors: [AppColor.primaryColor, Color(0xFF2E4E8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [AppColor.accentColor, Color(0xFF4AB8E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [AppColor.successColor, Color(0xFF6BCF59)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient backgroundGradient = LinearGradient(
    colors: [AppColor.backgroundColor, Color(0xFFF0F4F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============ HEADINGS ============
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColor.bodyTextColor,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColor.bodyTextColor,
    letterSpacing: -0.6,
    height: 1.25,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColor.bodyTextColor,
    letterSpacing: -0.4,
    height: 1.3,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColor.bodyTextColor,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle heading5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColor.bodyTextColor,
    letterSpacing: -0.1,
    height: 1.4,
  );

  // ============ BODY TEXT ============
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyTextColor,
    height: 1.6,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyTextColor,
    height: 1.5,
    letterSpacing: 0.05,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyTextColor,
    height: 1.4,
    letterSpacing: 0.03,
  );

  static const TextStyle bodyText1 = bodyLarge;
  static const TextStyle bodyText2 = bodyMedium;

  // ============ CAPTION & LABEL ============
  static const TextStyle captionLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColor.greyColor,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.greyColor,
    height: 1.3,
    letterSpacing: 0.1,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColor.greyColor,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.bodyTextColor,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.bodyTextColor,
    height: 1.4,
    letterSpacing: 0.05,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.greyColor,
    height: 1.3,
    letterSpacing: 0.05,
  );

  // ============ BUTTON TEXT ============
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.whiteColor,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.whiteColor,
    letterSpacing: 0.1,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.whiteColor,
    letterSpacing: 0.05,
    height: 1.2,
  );

  static const TextStyle buttonText = buttonMedium;

  // ============ INPUT FIELD STYLES ============
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColor.backgroundColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: AppColor.lightGreyColor, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: AppColor.lightGreyColor, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: AppColor.primaryColor, width: borderWidth),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: AppColor.errorColor, width: borderWidth),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: AppColor.errorColor, width: borderWidthThick),
    ),
    labelStyle: labelMedium,
    hintStyle: TextStyle(
      color: AppColor.greyColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    errorStyle: TextStyle(
      color: AppColor.errorColor,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );

  // ============ BUTTON STYLES ============
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColor.primaryColor,
    foregroundColor: AppColor.whiteColor,
    elevation: 0,
    shadowColor: Colors.transparent,
    minimumSize: const Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: buttonMedium,
  );

  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColor.primaryColor,
    side: const BorderSide(color: AppColor.primaryColor, width: borderWidth),
    minimumSize: const Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: buttonMedium.copyWith(color: AppColor.primaryColor),
  );

  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColor.primaryColor,
    minimumSize: const Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: buttonMedium.copyWith(color: AppColor.primaryColor),
  );

  // ============ CARD STYLES ============
  static final CardTheme cardTheme = CardTheme(
    elevation: cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    shadowColor: AppColor.primaryColor.withOpacity(0.1),
    margin: EdgeInsets.zero,
  );

  // ============ APP BAR STYLES ============
  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColor.primaryColor,
    foregroundColor: AppColor.whiteColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: heading3.copyWith(color: AppColor.whiteColor),
    iconTheme: const IconThemeData(color: AppColor.whiteColor, size: iconSize),
  );

  // ============ BOTTOM NAVIGATION BAR STYLES ============
  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
  BottomNavigationBarThemeData(
    backgroundColor: AppColor.whiteColor,
    selectedItemColor: AppColor.primaryColor,
    unselectedItemColor: AppColor.greyColor,
    selectedLabelStyle: caption,
    unselectedLabelStyle: caption,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // ============ DIALOG STYLES ============
  static final DialogTheme dialogTheme = DialogTheme(
    backgroundColor: AppColor.whiteColor,
    elevation: cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusLarge),
    ),
    titleTextStyle: heading3,
    contentTextStyle: bodyMedium,
  );

  // ============ SNACKBAR STYLES ============
  static final SnackBarThemeData snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColor.bodyTextColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    contentTextStyle: bodyMedium.copyWith(color: AppColor.whiteColor),
    actionTextColor: AppColor.accentColor,
  );

  // ============ CHIP STYLES ============
  static final ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: AppColor.backgroundColor,
    selectedColor: AppColor.primaryColor.withOpacity(0.1),
    secondarySelectedColor: AppColor.primaryColor,
    labelStyle: captionLarge.copyWith(color: AppColor.bodyTextColor),
    secondaryLabelStyle: captionLarge.copyWith(color: AppColor.whiteColor),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: const BorderSide(color: AppColor.lightGreyColor),
    ),
  );

  // ============ DIVIDER STYLES ============
  static const DividerThemeData dividerTheme = DividerThemeData(
    color: AppColor.lightGreyColor,
    thickness: 1,
    space: 1,
  );

  // ============ HELPER METHODS ============
  static TextStyle getTextFieldLabelStyle(bool isFocused) {
    return labelMedium.copyWith(
      color: isFocused ? AppColor.primaryColor : AppColor.greyColor,
    );
  }

  static TextStyle getButtonTextStyle(bool isSecondary) {
    return isSecondary
        ? buttonMedium.copyWith(color: AppColor.primaryColor)
        : buttonMedium;
  }

  static BoxDecoration getCardDecoration() {
    return BoxDecoration(
      color: AppColor.whiteColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [cardShadow],
    );
  }

  static BoxDecoration getGradientCardDecoration() {
    return BoxDecoration(
      gradient: primaryGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [cardShadow],
    );
  }

  static BoxDecoration getGlassmorphismDecoration() {
    return BoxDecoration(
      color: AppColor.whiteColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColor.whiteColor.withOpacity(0.2),
        width: 1,
      ),
    );
  }
}