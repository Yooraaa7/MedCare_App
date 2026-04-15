import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/components/status_badge.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_details_row.dart';
import 'package:medcare_app/screens/appointments_list/components/file_tile.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final List<BaseAppointment> appointments;
  final DateTime date;

  const AppointmentCard({
    super.key,
    required this.appointments,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the first appointment of the group as representative
            // If rendered separately, then no issue
            dateTimeRow(
              date,
              appointments.first.paymentStatus,
              appointments.first.status,
              isDark,
            ),
            AppSpacing.small,
            const CustomDivider(),
            AppSpacing.medium,

            // --- Dynamic List of Appointments ---
            for (int i = 0; i < appointments.length; i++) ...[
              InkWell(
                onTap: () {
                  // Navigate to specific appointment details
                  context.push(
                    '/appointments/appointment-details/${appointments[i].id}',
                  );
                },
                child: appointmentDetailsRow(context, appointments[i]),
              ),

              // If the appointment is completed, pass in the details
              if (appointments[i].status == AppointmentStatus.completed) ...[
                AppSpacing.medium,
                const CustomDivider(),
                AppSpacing.small,
                paymentDetailsRow(
                  billingFiles: appointments[i].billing,
                  status: appointments[i].paymentStatus,
                  context: context,
                ),
              ],

              // Add a small divider between items, but not after the last one
              if (i < appointments.length - 1)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: CustomDivider(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget dateTimeRow(
  DateTime date,
  PaymentStatus paymentStatus,
  AppointmentStatus status,
  bool isDark,
) {
  final String formattedDate = DateFormat('dd MMM yyyy, EEEE').format(date);
  Color billColor;

  switch (paymentStatus) {
    case PaymentStatus.paid:
      billColor = isDark ? AppColors.green.withAlpha(170) : AppColors.green;
      break;
    case PaymentStatus.pending:
      billColor = Colors.orange;
      break;
    case PaymentStatus.unpaid:
      billColor = AppColors.strongRed;
      break;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 16),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
      if (status == AppointmentStatus.cancelled)
        statusBadge(text: 'Cancel', color: AppColors.defaultGrey),
      if (status == AppointmentStatus.completed)
        statusBadge(text: paymentStatus.name.toUpperCase(), color: billColor),
    ],
  );
}

Widget paymentDetailsRow({
  List<File>? billingFiles,
  required BuildContext context,
  required PaymentStatus status,
}) {
  final bool isPaid = status == PaymentStatus.paid;
  final String sectionLabel = isPaid ? "Payment Details" : "Bill Details";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 5,
    children: [
      Text(
        sectionLabel,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 2),

      if (billingFiles != null && billingFiles.isNotEmpty)
        ...billingFiles.map((file) {
          return buildFileTile(context, file);
        })
      else
        Text(
          isPaid ? "No receipt available" : "No bill issued yet",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
        ),
    ],
  );
}
