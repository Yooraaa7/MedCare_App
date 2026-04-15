import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/packages/dna_decode_data.dart';
import 'package:medcare_app/data/packages/packages_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:intl/intl.dart';

class DnaReportScreen extends StatelessWidget {
  final String type; // fit, heritage, prevent

  const DnaReportScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Determine which package to show
    final DnaPackage package;
    switch (type.toLowerCase()) {
      case 'heritage':
        package = DnaPackage.dnaHeritage;
        break;
      case 'prevent':
        package = DnaPackage.dnaPrevent;
        break;
      default:
        package = DnaPackage.dnaFit;
    }

    return Scaffold(
      appBar: const CustomAppbar(title: 'Report Details'),
      body: Column(
        children: [
          // 1. Scrollable List Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                // Dynamic Orange Title
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      const TextSpan(text: "DNA Decode "),
                      TextSpan(
                        text: type.toUpperCase(),
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reports List
                ...package.categories.map((cat) => _ReportTile(category: cat)),
                AppSpacing.large,
              ],
            ),
          ),

          // 2. Fixed Bottom Section
          const CustomDivider(),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              30,
              20,
              30,
              40,
            ), // Matches ListView padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${NumberFormat('#,###').format(package.totalReports)} Reports",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "+ Consultation with a \nHealth Screening Doctor",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      authService.performProtectedAction(
                        context: context,
                        onAction: () => context.push(
                          '/book-package?type=$type',
                          extra: {
                            'package': ourPackages.first,
                            'appointment': null,
                          },
                        ),
                      );
                    },
                    child: const Text("Book an Appointment"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Report Tile
class _ReportTile extends StatelessWidget {
  final DnaCategory category;
  const _ReportTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Aligns text with the title above
      visualDensity: VisualDensity.compact,
      title: SizedBox(
        width: 100, // Fixed width for the title
        child: Text(category.name, maxLines: 2),
      ),
      trailing: Text(
        category.isApprox
            ? "${category.reportCount} reports (approx)"
            : "${category.reportCount} reports",
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }
}
