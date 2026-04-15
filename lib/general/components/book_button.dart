import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:intl/intl.dart';

class BookButton extends StatelessWidget {
  final dynamic subject;

  const BookButton({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<BaseAppointment> upcomingAppointments =
        DataService.getActiveBookings();

    // Find the specific appointment associated with this doctor or package
    final List<dynamic> relatedAppointments = upcomingAppointments.where((a) {
      return (a is DoctorAppointment && a.doctor == subject) ||
          (a is PackageAppointment && a.package == subject);
    }).toList();

    final bool hasAppointment = relatedAppointments.isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 30,
        width: authService.isAuthenticated && hasAppointment ? 150 : 50,
        child: authService.isAuthenticated && hasAppointment
            ? _buildDropdownButton(context, isDark, relatedAppointments)
            : _buildStandardButton(context),
      ),
    );
  }

  void _handleBookMore(BuildContext context) {
    if (subject is Doctor) {
      context.push(
        '/book-doctor',
        extra: {'doctor': subject, 'appointment': null},
      );
    } else {
      context.push(
        '/book-package',
        extra: {'package': subject, 'appointment': null},
      );
    }
  }

  Widget _buildStandardButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
        padding: WidgetStatePropertyAll(const EdgeInsets.all(0)),
      ),
      onPressed: () {
        authService.performProtectedAction(
          context: context,
          onAction: () => _handleBookMore(context),
        );
      },
      child: const Text('Book', style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildDropdownButton(
    BuildContext context,
    bool isDark,
    List<dynamic> appointments,
  ) {
    return PopupMenuButton<dynamic>(
      offset: const Offset(0, 35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        // Map through appointments to create menu items
        ...appointments.map((appt) {
          String dateStr =
              "${DateFormat('dd MMM yyyy, EEEE').format(appt.date)} \n(${appt.timeSlot})";

          return PopupMenuItem(
            value: appt,
            child: ListTile(
              leading: const Icon(Icons.calendar_today, size: 18),
              title: Text(dateStr),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          );
        }),

        const PopupMenuDivider(), // Visual separator

        PopupMenuItem(
          value: 'book_new',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Book Another'),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'book_new') {
          _handleBookMore(context);
        } else {
          // Navigate using the specific appointment object selected
          context.push('/appointments/appointment-details/${value.id}');
        }
      },
      child: AbsorbPointer(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.green.withAlpha(170)
                : AppColors.green,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appointments.length > 1
                    ? 'View (${appointments.length})'
                    : 'View Appointment',
                style: const TextStyle(fontSize: 12),
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
