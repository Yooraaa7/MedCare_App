import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/services/data_service.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                final unpaidAppointments = DataService.getAppointmentsByStatus(
                  AppointmentStatus.completed,
                ).where((appt) => appt.paymentStatus != PaymentStatus.paid);

                // Update each appointment: mark paid and generate a receipt
                for (var appt in unpaidAppointments) {
                  appt.paymentStatus = PaymentStatus.paid;

                  // TODO: Replace with real receipt generation
                  appt.billing?.add(File('/dummy/receipt.pdf'));
                }

                // Reset user total payable
                SampleData.sampleUser.totalPayable = 0;

                // Notify user
                showCustomSnackbar(
                  context,
                  'Payment processed successfully!',
                  type: SnackbarType.success,
                );

                context.go('/payment');
              },
              child: Image.asset(
                'assets/images/payment/payment_success.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
