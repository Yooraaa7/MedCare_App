import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

class CustomBanner extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CustomBanner({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent, // Allows the background image to show
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary.withAlpha(100),
            onTap: onTap,
            child: Ink(
              // Use Ink to decorate when using InkWell
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  // Ensure the text does not stick to the right edge
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.defaultBlack,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.defaultBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
