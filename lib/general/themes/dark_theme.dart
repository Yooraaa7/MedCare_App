import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/text_styles.dart';
import 'package:medcare_app/general/themes/components/font_size.dart';

class DarkTheme {
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color lightGrey = Color(0xFFB0B0B0);
  static Color secondaryBlue = AppColors.secondary.withValues(alpha: 0.15);
  static const primary = Color(0xff3b82f6);

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: AppColors.defaultWhite,
        secondary: secondaryBlue,
        onSecondary: AppColors.defaultBlack,
        onTertiary: lightGrey,
        surface: darkBackground,
        onSurface: AppColors.defaultWhite,
        error: AppColors.strongRed,
        onError: AppColors.defaultWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        titleTextStyle: TextStyle(
          fontFamily: "Poppins",
          fontSize: FontSize.medium,
          color: AppColors.defaultWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.defaultWhite),
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: secondaryBlue,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        textStyle: AppTextStyles.bodyText.copyWith(
          color: AppColors.defaultWhite,
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTextStyles.bodyText.copyWith(
          color: AppColors.defaultWhite,
        ),
        subtitleTextStyle: AppTextStyles.bodyText.copyWith(
          color: AppColors.defaultWhite,
        ),
      ),
      iconTheme: const IconThemeData(size: 16, color: AppColors.defaultWhite),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),

        hintStyle: TextStyle(
          fontFamily: "Poppins",
          fontSize: FontSize.regular,
          color: lightGrey,
        ),
        prefixIconColor: lightGrey,
        suffixIconColor: lightGrey,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.strongRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.strongRed),
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primary, width: 1),
          ),
          textStyle: TextStyle(
            fontFamily: "Poppins",
            color: primary,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.defaultWhite,
          minimumSize: const Size.fromHeight(45),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: TextStyle(
            fontFamily: "Poppins",
            color: AppColors.defaultWhite,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: AppColors.defaultWhite,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // Thumb color when ON
          }
          return Colors.grey.shade400; // Thumb color when OFF
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary; // When ON
          }
          return Colors.grey.shade200; // Grey track when OFF
        }),
        trackOutlineColor: WidgetStateProperty.all(
          Colors.transparent,
        ), // Cleaner look
        overlayColor: WidgetStateProperty.all(primary.withAlpha(100)),
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.title.copyWith(color: AppColors.defaultWhite),
        titleMedium: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.defaultWhite,
        ),
        bodyMedium: AppTextStyles.bodyText.copyWith(
          color: AppColors.defaultWhite,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.defaultWhite,
        ),
      ),
    );
  }
}
