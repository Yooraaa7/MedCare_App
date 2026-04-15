import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/number_badge.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';

class WelcomeSection extends StatefulWidget {
  const WelcomeSection({super.key});

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${authService.isAuthenticated ? SampleData.sampleUser.name : 'Guest'}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AppSpacing.small,
              Text(
                "We're here whenever you need us.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        if (authService.isAuthenticated)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _notificationButton(isDark, context),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.person),
                style: welcomeIcons(isDark, context),
                onPressed: () => context.push('/profile'),
              ),
            ],
          )
        else
          SizedBox(
            width: 70,
            child: ElevatedButton(
              onPressed: () => authService.logout(),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _notificationButton(bool isDark, BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      IconButton(
        icon: const Icon(Icons.notifications_none),
        style: welcomeIcons(isDark, context),
        onPressed: () async {
          final bool? updated = await context.push<bool>('/notifications');

          if (updated == true && mounted) {
            setState(() {}); // Refresh badge count
          }
        },
      ),

      // Number badge
      Positioned(
        right: 1,
        top: 1,
        child: NumberBadge(
          count: SampleData.sampleNotifications.where((n) => !n.isRead).length,
        ),
      ),
    ],
  );
}

// Icon styling
ButtonStyle welcomeIcons(bool isDark, BuildContext context) => ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(
    isDark ? Theme.of(context).colorScheme.secondary : AppColors.secondary,
  ),
  foregroundColor: WidgetStatePropertyAll(
    isDark ? AppColors.defaultWhite : AppColors.defaultBlack,
  ),
  shape: const WidgetStatePropertyAll(CircleBorder()),
  iconSize: const WidgetStatePropertyAll(20),
  elevation: const WidgetStatePropertyAll(4.0),
  shadowColor: const WidgetStatePropertyAll(AppColors.defaultBlack),
  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
);
