import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/view_all_button.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/home/components/specialty_tile.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the globally loaded data
    final specialties = DataService.allSpecialties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Specialties', style: Theme.of(context).textTheme.titleMedium),
            ViewAllButton(onPressed: () => context.push('/find-a-doctor')),
          ],
        ),
        AppSpacing.small,
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          crossAxisSpacing: 7,
          mainAxisSpacing: 3,
          children: specialties.sublist(0, 9).map((specialty) {
            String encodedSpecialty = Uri.encodeComponent(specialty.name);

            return SpecialtyTile(
              specialty.name,
              specialty.fullImagePath,
              onTap: () =>
                  context.push('/find-a-doctor?specialty=$encodedSpecialty'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
