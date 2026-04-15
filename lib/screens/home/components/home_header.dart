import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/filter_search_bar.dart';
import 'package:medcare_app/general/components/switch_theme_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const double headerHeight = 150;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/HLWE_2.jpg', fit: BoxFit.cover),
          ),

          // Search bar
          Positioned(
            left: 30,
            right: 30,
            top: 50,
            child: SafeArea(
              top: false,
              child: FilterSearchBar(
                bgColor: Theme.of(context).colorScheme.surface,
                onChanged: (val) {},
                trialing: SwitchThemeButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
