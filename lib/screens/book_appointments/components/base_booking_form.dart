import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:intl/intl.dart';

import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/date_picker.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/screens/book_appointments/components/payment_picker.dart';
import 'package:medcare_app/screens/book_appointments/components/time_slot_picker.dart';
import 'package:uuid/uuid.dart';

// Common submission data for base appointments
class BaseAppointmentDraft {
  String? id;
  DateTime date = DateTime.now().add(const Duration(days: 1));
  String? timeSlot;
  String? location;
  String? contact;
  File? guaranteeLetter;
  InsuranceDetails? insurance;

  PaymentMethod paymentMethod = PaymentMethod.selfPay;

  // Simplifies pre-filling during Edit Mode
  BaseAppointmentDraft.fromAppointment(BaseAppointment? appt) {
    date = appt?.date ?? date; // Set a default date regardless

    if (appt == null) return;
    id = appt.id;
    timeSlot = appt.timeSlot;
    paymentMethod = appt.paymentMethod;
    guaranteeLetter = appt.guaranteeLetter;
    insurance = appt.insurance;
  }
}

class BaseBookingForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  // Subject (Package, Vaccine, Doctor, etc.)
  final dynamic subject;

  // Optional appointment to indicate whether its for booking for updating
  final BaseAppointment? existingAppointment;

  // Optional injection points / validation points
  final List<Widget>? beforeSections;
  final List<Widget>? afterSections;
  final bool Function()? prevalidation;

  // Runs ONLY if validation + clash check passes
  final void Function(BaseAppointmentDraft draft) onSubmit;

  final String buttonText;

  const BaseBookingForm({
    super.key,
    required this.subject,
    required this.formKey,
    required this.onSubmit,
    this.existingAppointment,
    this.beforeSections,
    this.afterSections,
    this.prevalidation,
    this.buttonText = 'Book Now!',
  });

  @override
  State<BaseBookingForm> createState() => _BaseBookingFormState();
}

class _BaseBookingFormState extends State<BaseBookingForm> {
  // Initialize draft immediately using the factory
  late final _draft = BaseAppointmentDraft.fromAppointment(
    widget.existingAppointment,
  );
  late final TextEditingController _dateController;

  bool _validateTimeSlot = false;
  bool _validateInsurance = false;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _validateTimeSlot = true;
      _validateInsurance = true;
    });

    // Validation check
    if (!(widget.formKey.currentState?.validate() ?? false) ||
        widget.prevalidation?.call() == false ||
        _draft.timeSlot == null ||
        (_draft.paymentMethod == PaymentMethod.insurance &&
            _draft.insurance == null)) {
      showCustomSnackbar(
        context,
        'Please complete all required sections before proceeding.',
        type: SnackbarType.error,
      );
      return;
    }

    widget.formKey.currentState?.save();

    // Clash check (Only if date/time changed)
    final isNewTime =
        widget.existingAppointment?.date != _draft.date ||
        widget.existingAppointment?.timeSlot != _draft.timeSlot;

    if (isNewTime &&
        DataService.isSlotClashing(_draft.date, _draft.timeSlot!)) {
      final dateStr = DateFormat('dd MMM yyyy, EEEE').format(_draft.date);
      showCustomSnackbar(
        context,
        'You already have an appointment on $dateStr at ${_draft.timeSlot}.',
        type: SnackbarType.error,
      );
      return;
    }

    // Subject Mapping to assign the new data
    final metadata = switch (widget.subject) {
      Doctor d => (loc: d.location, con: d.contact),
      Package p => (loc: p.location, con: p.contact),
      Vaccine v => (loc: v.location, con: v.contact),
      _ => (loc: null, con: null),
    };

    _draft.location = metadata.loc;
    _draft.contact = metadata.con;
    _draft.id ??= const Uuid().v4(); // Assign ID only if it doesn't exist

    FocusScope.of(context).unfocus(); // Close keyboard

    widget.onSubmit(_draft);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          ...?widget.beforeSections,
          DatePicker(
            controller: _dateController,
            initialDate: _draft.date,
            onDateSelected: (date) => _draft.date = date,
          ),
          AppSpacing.xlarge,

          TimeSlotPicker(
            initialSlot: _draft.timeSlot,
            timeSlots: [
              '09:00 AM - 10:00 AM',
              '10:00 AM - 11:00 AM',
              '11:00 AM - 12:00 PM',
              '13:00 PM - 14:00 PM',
            ],
            hasError: _validateTimeSlot && _draft.timeSlot == null,
            onSelected: (slot) => setState(() {
              _draft.timeSlot = slot;
              _validateTimeSlot = false;
            }),
          ),
          AppSpacing.xlarge,

          PaymentMethodSection(
            initialMethod: _draft.paymentMethod,
            initialGuaranteeLetter: _draft.guaranteeLetter,
            initialInsurance: _draft.insurance,
            onDataChanged: (data) {
              setState(() {
                _draft.paymentMethod = data.$1;
                _draft.guaranteeLetter = data.$2;
                _draft.insurance = data.$3;
              });
            },
            hasError:
                _validateInsurance &&
                (_draft.paymentMethod == PaymentMethod.insurance &&
                    _draft.insurance == null),
          ),
          AppSpacing.xlarge,

          ...?widget.afterSections,

          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
