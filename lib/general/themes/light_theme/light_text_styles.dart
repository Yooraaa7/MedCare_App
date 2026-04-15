import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare_app/general/themes/app_colors.dart';
import 'package:medcare_app/general/themes/font_size.dart';

class AppTextStyles {
  static TextStyle get title => GoogleFonts.poppins(
    fontSize: FontSize.large,
    fontWeight: FontWeight.bold,
    color: AppColors.defaultBlack,
  );

  static TextStyle get bodyText => GoogleFonts.poppins(
    fontSize: FontSize.regular,
    height: 1.5,
    color: AppColors.defaultBlack,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: FontSize.caption,
    color: AppColors.defaultGrey,
  );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: FontSize.medium,
    color: AppColors.defaultBlack,
    fontWeight: FontWeight.w600,
  );
}
