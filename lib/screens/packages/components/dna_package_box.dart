import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/packages/dna_decode_data.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:intl/intl.dart';

class DnaPackageBox extends StatelessWidget {
  final DnaPackage dnaPackage;

  const DnaPackageBox({super.key, required this.dnaPackage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final dnaType = dnaPackage.title.split(' ').last;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: "DNA DECODE "),
                  TextSpan(
                    text: dnaType,
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            AppSpacing.medium,

            // Description
            Text(dnaPackage.description),
            AppSpacing.small,

            // Price label
            Text(
              dnaPackage.priceRange,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiary,
              ),
            ),
            AppSpacing.medium,

            // View reports button
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () => context.push(
                  '/packages/dna-decode/report-details?type=${dnaType.toLowerCase()}',
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View ${NumberFormat('#,###').format(dnaPackage.totalReports)} reports included",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
