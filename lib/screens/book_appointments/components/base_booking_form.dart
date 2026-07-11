import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/date_picker.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:medcare_app/screens/book_appointments/components/payment_picker.dart';
import 'package:medcare_app/screens/book_appointments/components/time_slot_picker.dart';
import 'package:medcare_app/services/appointment_service.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:uuid/uuid.dart';

class BaseAppointmentDraft {
  String? id;
  DateTime date =
      DateTime.now().add(const Duration(days: 1));
  String? timeSlot;
  String? location;
  String? contact;
  File? guaranteeLetter;
  InsuranceDetails? insurance;

  PaymentMethod paymentMethod =
      PaymentMethod.selfPay;

  BaseAppointmentDraft.fromAppointment(
    BaseAppointment? appointment,
  ) {
    date = appointment?.date ?? date;

    if (appointment == null) {
      return;
    }

    id = appointment.id;
    timeSlot = appointment.timeSlot;
    paymentMethod =
        appointment.paymentMethod;
    guaranteeLetter =
        appointment.guaranteeLetter;
    insurance = appointment.insurance;
  }
}

class BaseBookingForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final dynamic subject;
  final BaseAppointment? existingAppointment;
  final List<Widget>? beforeSections;
  final List<Widget>? afterSections;
  final bool Function()? prevalidation;
  final void Function(
    BaseAppointmentDraft draft,
  ) onSubmit;
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
  State<BaseBookingForm> createState() =>
      _BaseBookingFormState();
}

class _BaseBookingFormState
    extends State<BaseBookingForm> {
  late final BaseAppointmentDraft _draft =
      BaseAppointmentDraft.fromAppointment(
    widget.existingAppointment,
  );

  late final TextEditingController
      _dateController;

  bool _validateTimeSlot = false;
  bool _validateInsurance = false;

  static const List<String> _timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '13:00 PM - 14:00 PM',
  ];

  @override
  void initState() {
    super.initState();

    _dateController =
        TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String? get _doctorId {
    if (widget.subject is! Doctor) {
      return null;
    }

    final Doctor doctor =
        widget.subject as Doctor;

    if (doctor.id.trim().isEmpty) {
      return null;
    }

    return doctor.id;
  }

  void _handleSubmit() {
    setState(() {
      _validateTimeSlot = true;
      _validateInsurance = true;
    });

    final bool formIsValid =
        widget.formKey.currentState
                ?.validate() ??
            false;

    final bool prevalidationPassed =
        widget.prevalidation?.call() ??
            true;

    final bool insuranceIsValid =
        _draft.paymentMethod !=
                PaymentMethod.insurance ||
            _draft.insurance != null;

    if (!formIsValid ||
        !prevalidationPassed ||
        _draft.timeSlot == null ||
        !insuranceIsValid) {
      showCustomSnackbar(
        context,
        'Please complete all required '
        'sections before proceeding.',
        type: SnackbarType.error,
      );

      return;
    }

    widget.formKey.currentState?.save();

    final bool isNewTime =
        widget.existingAppointment?.date !=
                _draft.date ||
            widget.existingAppointment
                    ?.timeSlot !=
                _draft.timeSlot;

    if (isNewTime &&
        DataService.isSlotClashing(
          _draft.date,
          _draft.timeSlot!,
        )) {
      final String formattedDate =
          DateFormat(
        'dd MMM yyyy, EEEE',
      ).format(_draft.date);

      showCustomSnackbar(
        context,
        'You already have an appointment '
        'on $formattedDate at '
        '${_draft.timeSlot}.',
        type: SnackbarType.error,
      );

      return;
    }

    final metadata =
        switch (widget.subject) {
      Doctor doctor => (
          location: doctor.location,
          contact: doctor.contact,
        ),
      Package package => (
          location: package.location,
          contact: package.contact,
        ),
      Vaccine vaccine => (
          location: vaccine.location,
          contact: vaccine.contact,
        ),
      _ => (
          location: null,
          contact: null,
        ),
    };

    _draft.location = metadata.location;
    _draft.contact = metadata.contact;
    _draft.id ??= const Uuid().v4();

    FocusScope.of(context).unfocus();

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
            onDateSelected: (
              DateTime selectedDate,
            ) {
              setState(() {
                _draft.date = selectedDate;
                _draft.timeSlot = null;
                _validateTimeSlot = false;
              });
            },
          ),

          AppSpacing.xlarge,

          _buildTimeSlotSection(),

          AppSpacing.xlarge,

          PaymentMethodSection(
            initialMethod:
                _draft.paymentMethod,
            initialGuaranteeLetter:
                _draft.guaranteeLetter,
            initialInsurance:
                _draft.insurance,
            onDataChanged: (data) {
              setState(() {
                _draft.paymentMethod =
                    data.$1;

                _draft.guaranteeLetter =
                    data.$2;

                _draft.insurance =
                    data.$3;
              });
            },
            hasError:
                _validateInsurance &&
                    _draft.paymentMethod ==
                        PaymentMethod
                            .insurance &&
                    _draft.insurance ==
                        null,
          ),

          AppSpacing.xlarge,

          ...?widget.afterSections,

          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text(
              widget.buttonText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    final String? doctorId =
        _doctorId;

    if (doctorId == null) {
      return TimeSlotPicker(
        key: ValueKey(
          'general-${_draft.date.toIso8601String()}',
        ),
        initialSlot:
            _draft.timeSlot,
        timeSlots: _timeSlots,
        fullyBookedSlots:
            const <String>{},
        hasError:
            _validateTimeSlot &&
                _draft.timeSlot == null,
        onSelected: _selectTimeSlot,
      );
    }

    return StreamBuilder<Set<String>>(
      stream: AppointmentService
          .watchBookedDoctorSlots(
        doctorId: doctorId,
        date: _draft.date,
      ),
      initialData: const <String>{},
      builder: (
        BuildContext context,
        AsyncSnapshot<Set<String>>
            snapshot,
      ) {
        if (snapshot.hasError) {
          debugPrint(
            'Booked-slot stream error: '
            '${snapshot.error}',
          );
        }

        if (snapshot.connectionState ==
                ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        final Set<String> bookedSlots =
            snapshot.data ??
                const <String>{};

        debugPrint(
          'Live booked slots for '
          '$doctorId on ${_draft.date}: '
          '$bookedSlots',
        );

        // If another user books the slot
        // currently selected on this screen,
        // clear the selection.
        if (_draft.timeSlot != null &&
            bookedSlots.contains(
              _draft.timeSlot,
            )) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _draft.timeSlot = null;
            });
          });
        }

        return TimeSlotPicker(
          // The key forces Flutter to rebuild
          // the picker whenever the booked
          // slot collection changes.
          key: ValueKey(
            '$doctorId-'
            '${_draft.date.toIso8601String()}-'
            '${bookedSlots.join("|")}',
          ),
          initialSlot:
              _draft.timeSlot,
          timeSlots: _timeSlots,
          fullyBookedSlots:
              bookedSlots,
          hasError:
              _validateTimeSlot &&
                  _draft.timeSlot ==
                      null,
          onSelected:
              _selectTimeSlot,
        );
      },
    );
  }

  void _selectTimeSlot(
    String slot,
  ) {
    setState(() {
      _draft.timeSlot = slot;
      _validateTimeSlot = false;
    });
  }
}