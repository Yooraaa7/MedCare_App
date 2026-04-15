import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/book_button.dart';
import 'package:medcare_app/general/components/photo_dialog.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/package.dart';

class PackageCard extends StatelessWidget {
  final Package package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (package.name.toLowerCase() == "dna decode genetic screening") {
          // Go to the special DNA Details page
          context.push('/packages/dna-decode');
        } else {
          // Go to the standard details screen for other packages
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PhotoDialog(
                imagePath: package.fullImagePath,
                imageWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    package.fullImagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(child: detailsColumn(context, package)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget detailsColumn(BuildContext context, Package package) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      package.name,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    ),

    AppSpacing.medium,

    BookButton(subject: package),
  ],
);
