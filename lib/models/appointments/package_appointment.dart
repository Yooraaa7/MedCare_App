import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';

class PackageAppointment extends BaseAppointment {
  // Class-specific field
  final Package package;
  String? selectedSubcategory;

  PackageAppointment({
    // Shared fields passed to super constructor
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
    // Package specific
    required this.package,
    this.selectedSubcategory,
  });

  PackageAppointment.fromDraft({
    required BaseAppointmentDraft draft,
    required this.package,
    this.selectedSubcategory,
  }) : super(
         id: draft.id!,
         date: draft.date,
         timeSlot: draft.timeSlot!,
         location: draft.location ?? package.location,
         contact: draft.contact ?? package.contact,
         paymentMethod: draft.paymentMethod,
         guaranteeLetter: draft.guaranteeLetter,
         insurance: draft.insurance,
       );
}
