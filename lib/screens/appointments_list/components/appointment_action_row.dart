import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';

class AppointmentActionRow extends StatelessWidget {
  final BaseAppointment appointment;

  const AppointmentActionRow({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    String path = switch (appointment) {
      DoctorAppointment _ => '/book-doctor',
      VaccineAppointment _ => '/book-vaccine',
      PackageAppointment _ => '/book-package',
      _ => '/',
    };

    // 1. Prepare the "Subject" (Doctor or Package)
    final dynamic subject = switch (appointment) {
      DoctorAppointment docAppt => docAppt.doctor,
      PackageAppointment pkgAppt => pkgAppt.package,
      _ => null, // Vaccine doesn't need a subject passed in the map
    };

    // 2. Prepare the extras for Modify (Edit mode)
    // Vaccine is special: it just takes the appointment itself as extra
    final dynamic modifyExtra = appointment is VaccineAppointment
        ? appointment
        : {
            'doctor': appointment is DoctorAppointment ? subject : null,
            'package': appointment is PackageAppointment ? subject : null,
            'appointment': appointment,
          };

    // 3. Prepare the extras for Rebook (Fresh mode)
    final dynamic rebookExtra = appointment is VaccineAppointment
        ? null
        : {
            'doctor': appointment is DoctorAppointment ? subject : null,
            'package': appointment is PackageAppointment ? subject : null,
            'appointment': null, // Null indicates a fresh booking
          };

    final List<Widget> buttons = switch (appointment.status) {
      AppointmentStatus.upcoming => [
        _buildModify(context, path, modifyExtra),
        _buildCancel(context),
      ],
      AppointmentStatus.registered || AppointmentStatus.ongoing => [],
      AppointmentStatus.completed ||
      AppointmentStatus.cancelled => [_buildRebook(context, path, rebookExtra)],
    };

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: buttons
            .map(
              (button) => Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SizedBox(width: 110, height: 40, child: button),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- Button Builders remain clean ---
  Widget _buildModify(BuildContext context, String path, dynamic extra) {
    return TextButton(
      onPressed: () => context.push(path, extra: extra),
      child: const Text("Modify"),
    );
  }

  Widget _buildRebook(BuildContext context, String path, dynamic extra) {
    return ElevatedButton(
      onPressed: () => context.push(path, extra: extra),
      child: const Text("Rebook"),
    );
  }

  Widget _buildCancel(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.strongRed),
      onPressed: () => _confirmCancel(context),
      child: const Text("Cancel"),
    );
  }

  void _confirmCancel(BuildContext context) {
    showWarningDialog(
      context,
      title: 'Cancel Appointment',
      content: 'Are you sure you want to cancel your appointment?',
      actionColor: AppColors.strongRed,
      onTapAction: () {
        final index = DataService.allAppointments.indexWhere(
          (a) => a.id == appointment.id,
        );

        if (index != -1) {
          DataService.allAppointments[index].status =
              AppointmentStatus.cancelled;
        }

        showCustomSnackbar(
          context,
          'Appointment successfully cancelled!',
          type: SnackbarType.success,
        );
        context.go('/appointments');
      },
      onTapBack: () => context.pop(),
    );
  }
}
