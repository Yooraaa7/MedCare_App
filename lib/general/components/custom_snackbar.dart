import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

enum SnackbarType { success, error, info }

void showCustomSnackbar(
  BuildContext context,
  String message, {
  SnackbarType type = SnackbarType.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  // Map enum to color & icon
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = AppColors.green;
      icon = Icons.check_circle_outline;
      break;
    case SnackbarType.error:
      backgroundColor = AppColors.strongRed;
      icon = Icons.cancel_outlined;
      break;
    case SnackbarType.info:
      backgroundColor = Theme.of(context).colorScheme.primary;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: Colors.white,
            )
          : null,
    ),
  );
}
