import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_card.dart';
import 'package:medcare_app/general/components/number_badge.dart';
import 'package:medcare_app/general/components/view_all_button.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class AppointmentsSection extends StatelessWidget {
  const AppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final activeBookings = DataService.getActiveBookings();

    // Check if user is a guest
    final bool isGuest = authService.isGuest;

    // HIDE EVERYTHING if guest or no appointments
    if (isGuest || activeBookings.isEmpty) {
      return const CustomDivider();
    }

    // Otherwise display the first appointment
    final activeAppointment = activeBookings.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppointmentsSectionTitle(count: activeBookings.length),
        AppSpacing.small,
        AppointmentCard(
          appointments: [activeAppointment],
          date: activeAppointment.date,
        ),
      ],
    );
  }
}

class AppointmentsSectionTitle extends StatelessWidget {
  final int count;
  const AppointmentsSectionTitle({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Upcoming Appointments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                NumberBadge(count: count),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        ViewAllButton(onPressed: () => context.go('/appointments')),
      ],
    );
  }
}
