import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_action_row.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_info._block.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_profile.dart';
import 'package:medcare_app/screens/appointments_list/components/appointment_section_box.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final BaseAppointment appointment;
  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color payButtonColor = isDark
        ? AppColors.green.withAlpha(170)
        : AppColors.green;

    return Scaffold(
      appBar: const CustomAppbar(title: 'Appointment Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment Profile Block
            AppointmentProfile(
              appointment: widget.appointment,
              onStatusChanged: () => setState(() {}),
            ),

            const SizedBox(height: 30),

            // Appointment Info
            AppointmentInfoBlock(appointment: widget.appointment),

            // Guarantee Letter section
            AppointmentSectionBox(
              title: 'Corporate / Guarantee Letter',
              data: widget.appointment.guaranteeLetter,
            ),

            // Payment section
            if (widget.appointment.fee != null)
              AppointmentSectionBox(
                title: widget.appointment.paymentStatus == PaymentStatus.paid
                    ? 'Payment Details'
                    : 'Billing Details',
                trialing: NumberFormat(
                  'RM #,##0.00',
                ).format(widget.appointment.fee),
                data: widget.appointment.billing,
              ),

            // Pay-to-access sections
            _lockOverlay(
              child: _buildReportContent(widget.appointment),
              payButtonColor: payButtonColor,
              locked: widget.appointment.paymentStatus == PaymentStatus.unpaid,
            ),

            AppSpacing.large,

            // Action buttons
            AppointmentActionRow(appointment: widget.appointment),
          ],
        ),
      ),
    );
  }

  // Blurry lock overlay if the user has not paid
  Widget _lockOverlay({
    required Widget child,
    required bool locked,
    required Color payButtonColor,
  }) {
    if (!locked) return child;

    return Stack(
      children: [
        // Disable interaction under the blur
        AbsorbPointer(
          absorbing: true, // prevents taps, scrolling, etc.
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: child,
          ),
        ),

        Positioned.fill(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Settle your bill to view details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Pay Now Button
                      SizedBox(
                        width: 140,
                        height: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF36D1DC), // light cyan
                                Color(0xFF5B86E5), // soft blue
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              context.go('/payment');
                            },
                            child: const Text("Pay Now"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Pay-to-access contents
  Widget _buildReportContent(BaseAppointment appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lab reports etc.
        AppointmentSectionBox(title: 'Reports', data: appointment.reports),

        // Doctor comments and prescriptions are displayed for doctor consultations
        if (appointment is DoctorAppointment) ...[
          AppointmentSectionBox(
            title: "Doctor's Comment",
            data: appointment.doctorComments,
          ),
          AppointmentSectionBox(
            title: "Prescription",
            data: appointment.prescriptions,
          ),
        ],
      ],
    );
  }
}
