import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget statusBadge({
  required String text,
  required Color color,
  double fontSize = 14,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: color.withValues(alpha: 0.5), // Subtle border
        width: 1,
      ),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: AppColors.defaultWhite,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        letterSpacing: 0.5,
      ),
    ),
  );
}
