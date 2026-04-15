import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';

class VaccineAppointment extends BaseAppointment {
  List<Vaccine> selectedVaccines;

  String get vaccineIconPath => 'assets/images/vaccine_icon.jpg';

  VaccineAppointment({
    required super.id,
    required super.date,
    required super.timeSlot,
    required super.paymentMethod,
    required super.location,
    required super.contact,
    super.paymentStatus,
    super.status,
    super.billing,
    super.fee,
    super.guaranteeLetter,
    super.insurance,
    super.reports,
    required this.selectedVaccines,
  });

  VaccineAppointment.fromDraft({
    required BaseAppointmentDraft draft,
    required this.selectedVaccines,
  }) : super(
         id: draft.id!,
         date: draft.date,
         timeSlot: draft.timeSlot!,
         location: draft.location ?? selectedVaccines.first.location,
         contact: draft.contact ?? selectedVaccines.first.contact,
         paymentMethod: draft.paymentMethod,
         guaranteeLetter: draft.guaranteeLetter,
         insurance: draft.insurance,
       );
}
