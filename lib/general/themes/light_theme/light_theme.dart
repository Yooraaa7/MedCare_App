import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare_app/general/themes/app_colors.dart';
import 'package:medcare_app/general/themes/light_theme/light_text_styles.dart';
import 'package:medcare_app/general/themes/font_size.dart';

class LightTheme {
  static ThemeData getLightTheme() {
    final primary = const Color(0xff2563EB);

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: AppColors.defaultWhite,
        secondary: AppColors.secondary,
        onSecondary: AppColors.defaultBlack,
        onTertiary: AppColors.defaultGrey,
        error: AppColors.strongRed,
        onError: AppColors.defaultWhite,
        surface: AppColors.defaultWhite,
        onSurface: AppColors.defaultBlack,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.poppins(
          fontSize: FontSize.medium,
          color: AppColors.defaultBlack,
        ),
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.secondary,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: IconThemeData(size: 16, color: AppColors.defaultGrey),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),

        hintStyle: GoogleFonts.poppins(
          fontSize: FontSize.regular,
          color: AppColors.defaultGrey,
        ),

        prefixIconColor: AppColors.defaultGrey,
        suffixIconColor: AppColors.defaultGrey,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.defaultGrey),
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

        filled: false,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primary, width: 1),
          ),
          textStyle: GoogleFonts.poppins(
            color: primary,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(45), // default height
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
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
          AppColors.defaultGrey.withAlpha(100),
        ), // Cleaner look
        overlayColor: WidgetStateProperty.all(primary.withAlpha(100)),
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.sectionTitle,
        bodyMedium: AppTextStyles.bodyText,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
