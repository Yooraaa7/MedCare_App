import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/services/notification_service.dart';
import 'package:slide_to_act/slide_to_act.dart';

class RegisterSlider extends StatefulWidget {
  final BaseAppointment appointment;
  final VoidCallback onUpdate;

  const RegisterSlider({
    super.key,
    required this.appointment,
    required this.onUpdate,
  });

  @override
  State<RegisterSlider> createState() => _RegisterSliderState();
}

class _RegisterSliderState extends State<RegisterSlider> {
  late bool isRegistered;

  @override
  void initState() {
    super.initState();
    // Initialize based on the passed status
    isRegistered = widget.appointment.status != AppointmentStatus.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primary = Theme.of(context).colorScheme.primary;
    Color outerColor = isRegistered && isDark
        ? AppColors.green.withAlpha(170)
        : isRegistered
        ? AppColors.green
        : primary;

    return SizedBox(
      width: 220,
      height: 30,
      child: SlideAction(
        text: isRegistered ? "Registered" : "Slide to register",
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.defaultWhite,
          fontWeight: FontWeight.w600,
        ),
        outerColor: outerColor,
        innerColor: AppColors.defaultWhite,
        elevation: 0,
        alignment: Alignment.centerLeft,
        submittedIcon: const Icon(Icons.check, color: AppColors.defaultWhite),
        enabled: !isRegistered,
        sliderButtonIcon: isRegistered
            ? Icon(Icons.check, color: outerColor)
            : Icon(Icons.arrow_forward, color: primary),
        sliderRotate: false,
        sliderButtonIconSize: 15,
        sliderButtonIconPadding: 3,
        onSubmit: () async {
          setState(() {
            isRegistered = true;
            widget.appointment.status = AppointmentStatus.registered;
          });
          displayNotification();
          widget.onUpdate();
        },
      ),
    );
  }

  // TODO: Replace with real status updates
  void displayNotification() {
    final queueTime = DateTime.now().add(const Duration(seconds: 5));
    final payTime = DateTime.now().add(const Duration(seconds: 10));

    NotificationService.scheduleNotification(
      id: 1,
      title: 'Queue Reminder',
      body:
          'You are next in line for your appointment. '
          'Please proceed to Clinic 117 (1st Floor). '
          'Kindly be prepared as your turn is approaching.',
      scheduledTime: queueTime,
    );

    String paymentPayload = jsonEncode({'screen': 'payment'});

    NotificationService.scheduleNotification(
      id: 2,
      title: 'Payment Reminder',
      body:
          'Your consultation is complete. Please proceed to the payment counter '
          'to settle your bill. Thank you for visiting Clinic 117.',
      payload: paymentPayload,
      scheduledTime: payTime,
    );
  }
}
