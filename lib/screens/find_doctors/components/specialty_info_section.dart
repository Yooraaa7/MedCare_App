import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/view_all_button.dart';
import 'package:medcare_app/models/specialty.dart';

class SpecialtyInfoSection extends StatelessWidget {
  final Specialty specialty;

  const SpecialtyInfoSection({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        child: Stack(
          children: [
            // The Background Image (Positioned Right)
            Positioned(
              right: -20, // Slightly off-screen for a stylized look
              top: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.2, // Light overlay effect
                child: Image.asset(
                  specialty.fullImagePath,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 2. The Gradient Overlay
            // Ensures the left side (text area) is always clear
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface.withAlpha(100),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // 3. The Content Layer
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        specialty.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ViewAllButton(
                      text: 'View More',
                      onPressed: () => context.push(
                        '/find-a-doctor/specialty-details',
                        extra: specialty,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.7, // Keep text on the left
                  child: Text(
                    specialty.intro,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
