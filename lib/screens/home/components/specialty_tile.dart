import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class SpecialtyTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const SpecialtyTile(this.title, this.imagePath, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              AppSpacing.small,
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
