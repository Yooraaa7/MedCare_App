import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/packages/dna_decode_data.dart';
import 'package:medcare_app/data/packages/packages_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/components/build_list.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/screens/packages/components/dna_package_box.dart';

class DnaDecodeDetailsScreen extends StatelessWidget {
  const DnaDecodeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Package Details'),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text(
            "DNA Decode Genetic Screening",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSpacing.large,
          const Text(
            "Genetic testing examines your genes to identify inherited conditions, disease risks, and carrier status. "
            "This information helps to work out necessary lifestyle adjustments and preventive care based on your genetic profile.",
          ),

          AppSpacing.large,
          const CustomDivider(),
          AppSpacing.large,

          // Package cards
          Text('Packages', style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.large,

          DnaPackageBox(dnaPackage: DnaPackage.dnaFit),
          DnaPackageBox(dnaPackage: DnaPackage.dnaHeritage),
          DnaPackageBox(dnaPackage: DnaPackage.dnaPrevent),

          const SizedBox(height: 16),

          // Decode CTA centered + bold
          Center(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  const TextSpan(text: "Decode Your "),
                  const TextSpan(
                    text: "DNA ",
                    style: TextStyle(color: AppColors.strongRed),
                  ),
                  const TextSpan(text: "Now"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Book button
          ElevatedButton(
            onPressed: () {
              authService.performProtectedAction(
                context: context,
                onAction: () => context.push(
                  '/book-package',
                  extra: {'package': ourPackages.first, 'appointment': null},
                ),
              );
            },
            child: const Text("Book an Appointment"),
          ),

          AppSpacing.large,
          const CustomDivider(),
          AppSpacing.large,

          /// Terms
          Text(
            'Terms and Conditions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppSpacing.medium,
          buildList([
            "Each package includes a report review session with a Health Screening doctor, either in person or via tele-health.",
            "Children under 18 must be accompanied by a parent or legal guardian.",
            "Additional fees apply for individuals requiring a buccal swab.",
            "Genetic counselling is available for an additional charge.",
            "Your report will be ready within 30 working days. The hospital will schedule an appointment for you to review your report.",
          ], false),
        ],
      ),
    );
  }
}
