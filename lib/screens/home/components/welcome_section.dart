import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/number_badge.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/user_service.dart';

class WelcomeSection extends StatefulWidget {
  const WelcomeSection({super.key});

  @override
  State<WelcomeSection> createState() =>
      _WelcomeSectionState();
}

class _WelcomeSectionState
    extends State<WelcomeSection> {
  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final String displayName =
        _getDisplayName();

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $displayName',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
              AppSpacing.small,
              Text(
                "We're here whenever you need us.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (authService.isAuthenticated)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _notificationButton(
                isDark,
                context,
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(
                  Icons.person_outline,
                ),
                style: welcomeIcons(
                  isDark,
                  context,
                ),
                tooltip: 'Profile',
                onPressed: () {
                  context.push('/profile');
                },
              ),
            ],
          )
        else
          SizedBox(
            width: 70,
            child: ElevatedButton(
              onPressed: () async {
                await authService.logout();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getDisplayName() {
    if (!authService.isAuthenticated) {
      return 'Guest';
    }

    final String? savedName =
        UserService.currentUser?.name.trim();

    if (savedName == null ||
        savedName.isEmpty) {
      return 'Patient';
    }

    return savedName;
  }

  Widget _notificationButton(
    bool isDark,
    BuildContext context,
  ) {
    final bool isDemoUser =
        UserService.isDemoUser;

    final int unreadCount = isDemoUser
        ? SampleData.sampleNotifications
            .where(
              (notification) =>
                  !notification.isRead,
            )
            .length
        : 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
          ),
          style: welcomeIcons(
            isDark,
            context,
          ),
          tooltip: 'Notifications',
          onPressed: () async {
            final bool? updated =
                await context.push<bool>(
              '/notifications',
            );

            if (updated == true &&
                mounted) {
              setState(() {});
            }
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 1,
            top: 1,
            child: NumberBadge(
              count: unreadCount,
            ),
          ),
      ],
    );
  }
}

ButtonStyle welcomeIcons(
  bool isDark,
  BuildContext context,
) {
  final ColorScheme colorScheme =
      Theme.of(context).colorScheme;

  return IconButton.styleFrom(
    backgroundColor: isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.white,
    foregroundColor: isDark
        ? colorScheme.onSurface
        : Colors.black,
    disabledBackgroundColor: isDark
        ? colorScheme.surfaceContainerHighest
            .withAlpha(120)
        : Colors.white.withAlpha(120),
    disabledForegroundColor: isDark
        ? colorScheme.onSurface.withAlpha(100)
        : Colors.black.withAlpha(100),
    shape: const CircleBorder(),
    iconSize: 20,
    elevation: 4,
    shadowColor: Colors.black26,
  );
}