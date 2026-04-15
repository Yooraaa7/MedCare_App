import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/specialty.dart';

class SpecialtyScreen extends StatelessWidget {
  final Specialty specialty;
  const SpecialtyScreen({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Specialty Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with dynamic background image + intro
            Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: -20,
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset(
                      specialty.fullImagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Specialty Title and Content
                    Text(
                      specialty.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    AppSpacing.large,
                    Text(specialty.intro),
                  ],
                ),
              ],
            ),

            // 3. Dynamic Sections (Symptoms, Diseases, etc.)
            ...specialty.sections.expand(
              (section) => [
                AppSpacing.medium,
                const CustomDivider(),
                AppSpacing.medium,

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    MarkdownBody(data: section.content),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
