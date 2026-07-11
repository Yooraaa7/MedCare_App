import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
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
  State<RegisterSlider> createState() =>
      _RegisterSliderState();
}

class _RegisterSliderState
    extends State<RegisterSlider> {
  late bool isRegistered;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    isRegistered =
        widget.appointment.status !=
            AppointmentStatus.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color primary =
        Theme.of(context).colorScheme.primary;

    final Color outerColor =
        isRegistered && isDark
            ? AppColors.green.withAlpha(170)
            : isRegistered
                ? AppColors.green
                : primary;

    return SizedBox(
      width: 220,
      height: 30,
      child: SlideAction(
        text: isRegistered
            ? 'Registered'
            : 'Slide to register',
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
              color: AppColors.defaultWhite,
              fontWeight: FontWeight.w600,
            ),
        outerColor: outerColor,
        innerColor: AppColors.defaultWhite,
        elevation: 0,
        alignment: Alignment.centerLeft,
        submittedIcon: const Icon(
          Icons.check,
          color: AppColors.defaultWhite,
        ),
        enabled:
            !isRegistered && !_isSubmitting,
        sliderButtonIcon: isRegistered
            ? Icon(
                Icons.check,
                color: outerColor,
              )
            : Icon(
                Icons.arrow_forward,
                color: primary,
              ),
        sliderRotate: false,
        sliderButtonIconSize: 15,
        sliderButtonIconPadding: 3,
        onSubmit: _registerAppointment,
      ),
    );
  }

  Future<void> _registerAppointment() async {
    if (_isSubmitting || isRegistered) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      isRegistered = true;

      widget.appointment.status =
          AppointmentStatus.registered;
    });

    try {
      await _displayNotifications();

      widget.onUpdate();
    } catch (error) {
      debugPrint(
        'Unable to schedule appointment '
        'notifications: $error',
      );

      widget.onUpdate();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _displayNotifications() async {
    final DateTime queueTime =
        DateTime.now().add(
      const Duration(seconds: 5),
    );

    final DateTime paymentTime =
        DateTime.now().add(
      const Duration(seconds: 10),
    );

    final String doctorName =
        _getDoctorName();

    final String clinicLocation =
        _getClinicLocation();

    final String appointmentTime =
        widget.appointment.timeSlot.trim();

    final String queueBody =
        _buildQueueNotificationBody(
      doctorName: doctorName,
      clinicLocation: clinicLocation,
      appointmentTime: appointmentTime,
    );

    await NotificationService
        .scheduleNotification(
      id: _notificationId(1),
      title: 'Queue Reminder',
      body: queueBody,
      scheduledTime: queueTime,
    );

    final String paymentPayload =
        jsonEncode({
      'screen': 'payment',
      'appointmentId':
          widget.appointment.id,
    });

    final String paymentBody =
        _buildPaymentNotificationBody(
      doctorName: doctorName,
      clinicLocation: clinicLocation,
    );

    await NotificationService
        .scheduleNotification(
      id: _notificationId(2),
      title: 'Payment Reminder',
      body: paymentBody,
      payload: paymentPayload,
      scheduledTime: paymentTime,
    );
  }

  String _getDoctorName() {
    final BaseAppointment appointment =
        widget.appointment;

    if (appointment is DoctorAppointment) {
      final String name =
          appointment.doctor.nameEng.trim();

      if (name.isNotEmpty) {
        return name;
      }
    }

    return 'your doctor';
  }

  String _getClinicLocation() {
    final BaseAppointment appointment =
        widget.appointment;

    if (appointment is DoctorAppointment) {
      final String doctorLocation =
          appointment.doctor.location.trim();

      if (doctorLocation.isNotEmpty) {
        return doctorLocation;
      }
    }

    final String appointmentLocation =
        appointment.location.trim();

    if (appointmentLocation.isNotEmpty) {
      return appointmentLocation;
    }

    return 'the assigned clinic';
  }

  String _buildQueueNotificationBody({
    required String doctorName,
    required String clinicLocation,
    required String appointmentTime,
  }) {
    final String timeText =
        appointmentTime.isEmpty
            ? ''
            : ' Your appointment time is '
                '$appointmentTime.';

    return 'You are next in line for your '
        'appointment with $doctorName. '
        'Please proceed to $clinicLocation.'
        '$timeText Kindly be prepared as '
        'your turn is approaching.';
  }

  String _buildPaymentNotificationBody({
    required String doctorName,
    required String clinicLocation,
  }) {
    return 'Your consultation with '
        '$doctorName at $clinicLocation '
        'is complete. Please proceed to '
        'the payment counter to settle '
        'your bill.';
  }

  int _notificationId(int type) {
    final int appointmentHash =
        widget.appointment.id.hashCode.abs();

    return (appointmentHash % 100000) * 10 +
        type;
  }
}