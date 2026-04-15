import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/font_size.dart';

class AppTextStyles {
  static TextStyle get title => TextStyle(
    fontFamily: "Poppins",
    fontSize: FontSize.large,
    fontWeight: FontWeight.bold,
    color: AppColors.defaultBlack,
  );

  static TextStyle get bodyText => TextStyle(
    fontFamily: "Poppins",
    fontSize: FontSize.regular,
    height: 1.7,
    color: AppColors.defaultBlack,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: "Poppins",
    fontSize: FontSize.caption,
    color: AppColors.defaultGrey,
  );

  static TextStyle get sectionTitle => TextStyle(
    fontFamily: "Poppins",
    fontSize: FontSize.medium,
    color: AppColors.defaultBlack,
    fontWeight: FontWeight.w600,
  );
}
