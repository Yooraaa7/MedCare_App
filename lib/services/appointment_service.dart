import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/services/user_service.dart';

class AppointmentService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Save new appointment to Firestore ──────────────────────────────────────
  static Future<void> saveAppointment(BaseAppointment appointment) async {
    try {
      final userId = UserService.currentUser?.mrNo ?? 'guest';

      final Map<String, dynamic> data = {
        'id': appointment.id,
        'userId': userId,
        'date': Timestamp.fromDate(appointment.date),
        'timeSlot': appointment.timeSlot,
        'location': appointment.location,
        'contact': appointment.contact,
        'status': appointment.status.name,
        'paymentStatus': appointment.paymentStatus.name,
        'paymentMethod': appointment.paymentMethod.name,
        'fee': appointment.fee,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add type-specific fields
      if (appointment is DoctorAppointment) {
        data['type'] = 'doctor';
        data['doctorName'] = appointment.doctor.nameEng;
        data['doctorSpecialty'] = appointment.doctor.specialty.name;
        data['reasonOfVisit'] = appointment.reasonOfVisit;
      } else if (appointment is VaccineAppointment) {
        data['type'] = 'vaccine';
        data['selectedVaccineNames'] =
            appointment.selectedVaccines.map((v) => v.name).toList();
        data['selectedVaccineIds'] =
            appointment.selectedVaccines.map((v) => v.id).toList();
      } else if (appointment is PackageAppointment) {
        data['type'] = 'package';
        data['packageName'] = appointment.package.name;
        data['selectedSubcategory'] = appointment.selectedSubcategory;
      }

      await _db
          .collection('appointments')
          .doc(appointment.id)
          .set(data);

      debugPrint('✅ Appointment saved to Firestore: ${appointment.id}');
    } catch (e) {
      debugPrint('❌ Failed to save appointment: $e');
    }
  }

  // ── Update appointment status ──────────────────────────────────────────────
  static Future<void> updateStatus(
      String appointmentId, AppointmentStatus status) async {
    try {
      await _db
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': status.name});
      debugPrint(
          '✅ Appointment status updated: $appointmentId → ${status.name}');
    } catch (e) {
      debugPrint('❌ Failed to update status: $e');
    }
  }

  // ── Update payment status ──────────────────────────────────────────────────
  static Future<void> updatePaymentStatus(
      String appointmentId, PaymentStatus status) async {
    try {
      await _db
          .collection('appointments')
          .doc(appointmentId)
          .update({'paymentStatus': status.name});
      debugPrint(
          '✅ Payment status updated: $appointmentId → ${status.name}');
    } catch (e) {
      debugPrint('❌ Failed to update payment status: $e');
    }
  }
}