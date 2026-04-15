import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/book_button.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            context.push('/find-a-doctor/doctor-details', extra: doctor);
          },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Tells children to fill vertical space
              children: [
                // Doctor Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 80,
                    child: Image.asset(doctor.fullImagePath, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize
                        .min, // Use min so it only takes needed space
                    children: [
                      Text(
                        doctor.nameEng,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(doctor.nameChinese),
                      AppSpacing.small,
                      Text(
                        doctor.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      AppSpacing.medium,

                      // This Spacer will push the button to the absolute bottom
                      // of whatever height the image/column combo ends up being
                      const Spacer(),

                      if (doctor.isBookable)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: BookButton(subject: doctor),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
