import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/switch_theme_button.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool implyLeading;
  final VoidCallback? onBackPressed;

  const CustomAppbar({
    super.key,
    required this.title,
    this.implyLeading = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: implyLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: onBackPressed ?? () => context.pop(),
            )
          : null,
      actions: [const SwitchThemeButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
