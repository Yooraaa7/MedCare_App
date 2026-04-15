import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_bottom_bar.dart';

class MainLayoutShell extends StatelessWidget {
  final Widget child;
  const MainLayoutShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    // Logic to highlight the correct icon based on the path
    if (location == '/home') return 0;
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/payment')) return 2;
    if (location.startsWith('/patient-guide')) return 3;
    if (location == '/reminders') return 4;
    return 0;
  }
}
