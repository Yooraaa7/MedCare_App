import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';

class BookAppointmentsScreen extends StatefulWidget {
  final Doctor doctor;
  final DoctorAppointment? existingAppointment; // For Edit Mode

  const BookAppointmentsScreen({
    super.key,
    required this.doctor,
    this.existingAppointment,
  });

  @override
  State<BookAppointmentsScreen> createState() => _BookAppointmentsScreenState();
}

class _BookAppointmentsScreenState extends State<BookAppointmentsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Local state for doctor-specific fields not covered by the base draft
  String? _reasonOfVisit;

  void _onFormSubmit(BaseAppointmentDraft draft) {
    // 1. Create the specialized DoctorAppointment object
    final appointment = DoctorAppointment.fromDraft(
      draft: draft,
      doctor: widget.doctor,
      reasonOfVisit: _reasonOfVisit!,
    );

    // 2. Add or Update in the DataService
    if (widget.existingAppointment != null) {
      final index = DataService.allAppointments.indexWhere(
        (a) => a.id == draft.id,
      );
      if (index != -1) DataService.allAppointments[index] = appointment;
      showCustomSnackbar(
        context,
        'Appointment updated successfully!',
        type: SnackbarType.success,
      );
    } else {
      DataService.allAppointments.add(appointment);
      showCustomSnackbar(
        context,
        'Appointment booked successfully!',
        type: SnackbarType.success,
      );
    }

    context.go('/appointments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.existingAppointment != null
            ? 'Edit Appointment'
            : 'Book an Appointment',
      ),
      body: BaseBookingForm(
        subject: widget.doctor,
        formKey: _formKey,
        existingAppointment: widget.existingAppointment,
        buttonText: widget.existingAppointment != null
            ? 'Save Changes'
            : 'Book Now!',
        onSubmit: _onFormSubmit,
        afterSections: [
          // Doctor-specific field: Reason of Visit
          Text(
            'Describe Reason of Visit',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CustomTextField(
            label: '',
            hintText: 'Please describe your reason of visit',
            maxLine: 3,
            initialValue: widget.existingAppointment?.reasonOfVisit,
            validator: Validators.required('Reason of Visit'),
            onSaved: (value) => _reasonOfVisit = value,
          ),
          AppSpacing.xlarge,
        ],
      ),
    );
  }
}
