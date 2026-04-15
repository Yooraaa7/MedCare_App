import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/components/banner.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Services', style: Theme.of(context).textTheme.titleMedium),
        AppSpacing.medium,
        CustomBanner(
          title: "Find a Doctor",
          imagePath: "assets/images/banners/doctors.jpg",
          onTap: () => context.push('/find-a-doctor'),
        ),
        CustomBanner(
          title: "Packages",
          imagePath: "assets/images/banners/packages.png",
          onTap: () => context.push('/packages'),
        ),
        CustomBanner(
          title: "Vaccination",
          imagePath: "assets/images/banners/vaccines.jpg",
          onTap: () => context.push('/book-vaccine'),
        ),
      ],
    );
  }
}
