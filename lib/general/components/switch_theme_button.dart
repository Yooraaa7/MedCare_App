import 'package:flutter/material.dart';
import 'package:medcare_app/main.dart';

class SwitchThemeButton extends StatefulWidget {
  const SwitchThemeButton({super.key});

  @override
  State<SwitchThemeButton> createState() => _SwitchThemeButtonState();
}

class _SwitchThemeButtonState extends State<SwitchThemeButton> {
  @override
  Widget build(BuildContext context) {
    // Wrap the ListTile in a ValueListenableBuilder so it
    // updates specifically when the theme changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;

        return IconButton(
          // Dynamic Icon
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 20,
          ),
          onPressed: () => _toggleTheme(!isDark),
        );
      },
    );
  }

  // Logic to update the global theme state
  void _toggleTheme(bool dark) {
    themeNotifier.value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}
