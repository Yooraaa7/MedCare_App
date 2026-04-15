import 'dart:io';

import 'package:medcare_app/models/payment_methods/insurance_details.dart';

enum PaymentMethod { selfPay, insurance, corporate }

enum PaymentStatus { pending, paid, unpaid }

enum AppointmentStatus { upcoming, registered, ongoing, completed, cancelled }

abstract class BaseAppointment {
  final String id;
  final DateTime date;
  final String timeSlot;
  final String location;
  final String contact;
  final PaymentMethod paymentMethod;
  final double? fee;
  File? guaranteeLetter;
  final InsuranceDetails? insurance;
  List<File>? billing;
  PaymentStatus paymentStatus;
  AppointmentStatus status;
  List<File>? reports;

  BaseAppointment({
    required this.id,
    required this.date,
    required this.timeSlot,
    required this.location,
    required this.contact,
    required this.paymentMethod,
    this.insurance,
    this.fee,
    this.guaranteeLetter,
    this.billing,
    this.paymentStatus = PaymentStatus.unpaid,
    this.status = AppointmentStatus.upcoming,
    this.reports,
  });
}
