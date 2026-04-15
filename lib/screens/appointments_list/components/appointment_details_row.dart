import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';

Widget appointmentDetailsRow(BuildContext context, dynamic item) {
  return switch (item) {
    DoctorAppointment doc => _buildRow(
      context: context,
      imagePath: doc.doctor.fullImagePath,
      title: doc.doctor.nameEng,
      subTitle: doc.doctor.nameChinese,
      description: doc.doctor.title,
      timeSlot: doc.timeSlot,
      fee: doc.fee,
    ),

    PackageAppointment pkg => _buildRow(
      context: context,
      imagePath: pkg.package.fullImagePath,
      title: pkg.package.name,
      description: pkg.selectedSubcategory ?? '',
      timeSlot: pkg.timeSlot,
      fee: pkg.fee,
    ),

    VaccineAppointment vac => _buildRow(
      context: context,
      imagePath: vac.vaccineIconPath,
      title: 'Vaccine Appointment',
      description: vac.selectedVaccines.map((v) => v.name).join(', '),
      timeSlot: vac.timeSlot,
      fee: vac.fee,
    ),

    _ => const SizedBox.shrink(), // Default case if something goes wrong
  };
}

Widget _buildRow({
  required BuildContext context,
  required String imagePath,
  required String title,
  String? subTitle,
  required String description,
  required String timeSlot,
  double? fee,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      appointmentImage(imagePath),
      AppSpacing.widthLarge,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            if (subTitle != null && subTitle.isNotEmpty) Text(subTitle),

            AppSpacing.small,

            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),

            AppSpacing.small,

            // Time Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time Slot Section
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    AppSpacing.widthSmall,
                    Text(
                      timeSlot,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            AppSpacing.small,

            // Fee Row
            if (fee != null)
              Text(
                'RM ${fee.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

Widget appointmentImage(String imagePath) => ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.asset(imagePath, width: 60, height: 80, fit: BoxFit.cover),
);
