import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/photo_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget imageCard(String imagePath, BuildContext context) => Material(
  elevation: 4.0,
  shadowColor: AppColors.defaultBlack,
  borderRadius: BorderRadius.circular(8),
  clipBehavior: Clip.antiAlias, // Clips the Container and Image to corners
  child: Container(
    color: Colors.white,
    width: double.infinity,
    child: PhotoDialog(
      imagePath: imagePath,
      imageWidget: Image.asset(
        imagePath,
        fit: BoxFit.contain, // Changed to contain so no text is cut off
      ),
    ),
  ),
);
