import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';

class DoctorAppointment extends BaseAppointment {
  final Doctor doctor;
  String reasonOfVisit;
  final List<String>? doctorComments;
  final List<Reminder>? prescriptions;

  DoctorAppointment({
    required super.id,
    required super.date,
    required super.timeSlot,
    required super.location,
    required super.contact,
    required super.paymentMethod,
    super.paymentStatus,
    super.status,
    super.billing,
    super.fee,
    super.guaranteeLetter,
    super.insurance,
    super.reports,

    required this.doctor,
    required this.reasonOfVisit,
    this.doctorComments,
    this.prescriptions,
  });

  DoctorAppointment.fromDraft({
    required BaseAppointmentDraft draft,
    required this.doctor,
    required this.reasonOfVisit,
    this.doctorComments,
    this.prescriptions,
  }) : super(
         id: draft.id!,
         date: draft.date,
         timeSlot: draft.timeSlot!,
         location: draft.location ?? doctor.location,
         contact: draft.contact ?? doctor.contact,
         paymentMethod: draft.paymentMethod,
         guaranteeLetter: draft.guaranteeLetter,
         insurance: draft.insurance,
       );
}
