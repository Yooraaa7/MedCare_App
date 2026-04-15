import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/app_colors.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final double size;

  const NotificationBadge({super.key, required this.count, this.size = 18});

  @override
  Widget build(BuildContext context) {
    // The notification badge will be invisible if none is provided
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      // Create a nice circle
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: size,
      constraints: BoxConstraints(minWidth: size),
      decoration: const BoxDecoration(
        color: AppColors.strongRed,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        // If the count exceeds 99 stop displaying the actual number
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: AppColors.defaultWhite,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
