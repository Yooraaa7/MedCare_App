import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget trailing;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing = const Icon(Icons.chevron_right, size: 20,)
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onTertiary),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium,),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: onTap,
    );
  }
}