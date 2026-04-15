import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

Widget sectionBox({
  required BuildContext context,
  required String title,
  required List<Widget> children,
  bool centerContent = false,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 20),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: centerContent
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          AppSpacing.medium,
          ...children,
        ],
      ),
    ),
  );
}
