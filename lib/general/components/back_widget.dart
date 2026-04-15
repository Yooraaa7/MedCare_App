import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget backWidget(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconButton(
        onPressed: () => context.pop(),
        color: isDark ? AppColors.defaultWhite : AppColors.defaultBlack,
        alignment: Alignment.topLeft,
        icon: const Icon(Icons.arrow_back, size: 24),
      ),
    ],
  );
}
