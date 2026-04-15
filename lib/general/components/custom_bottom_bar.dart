import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/main.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/appointments');
        break;
      case 2:
        context.go('/payment');
        break;
      case 3:
        context.go('/patient-guide');
        break;
      case 4:
        context.go('/reminders');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: AppColors.defaultGrey,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 1
                ? Icons.calendar_month
                : Icons.calendar_today_outlined,
          ),
          label: 'Appointment',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(currentIndex == 2 ? Icons.payment : Icons.payment_outlined),

              if (authService.isAuthenticated &&
                  SampleData.sampleUser.totalPayable > 0)
                Positioned(
                  right: -8,
                  top: -3,
                  child: Container(
                    height: 13,
                    constraints: BoxConstraints(minWidth: 13),
                    decoration: const BoxDecoration(
                      color: AppColors.strongRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 3 ? Icons.menu_book : Icons.menu_book_outlined,
          ),
          label: 'Guide',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 4
                ? Icons.notifications_active
                : Icons.notifications_active_outlined,
          ),
          label: 'Reminder',
        ),
      ],
    );
  }
}
