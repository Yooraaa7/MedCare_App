import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/vaccine.dart';

void showVaccineInfoDialog(BuildContext context, Vaccine vaccine) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with title and close icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vaccine.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  AppSpacing.widthSmall,
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Divider
              const CustomDivider(),
              const SizedBox(height: 12),

              // Vaccine description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(vaccine.details),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
