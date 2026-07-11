import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/appointment_service.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';
import 'package:medcare_app/screens/book_appointments/components/package_type_picker.dart';

class BookPackageScreen extends StatefulWidget {
  final Package package;
  final String? selectedType;
  final PackageAppointment? existingAppointment;

  const BookPackageScreen({
    super.key,
    required this.package,
    this.selectedType,
    this.existingAppointment,
  });

  @override
  State<BookPackageScreen> createState() => _BookPackageScreenState();
}

class _BookPackageScreenState extends State<BookPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    final subCats = widget.package.subCategories;

    if (subCats != null && subCats.isNotEmpty) {
      if (widget.selectedType != null && widget.selectedType!.isNotEmpty) {
        _selectedType = subCats.firstWhere(
          (s) => s.toLowerCase().contains(widget.selectedType ?? ''),
          orElse: () => subCats.first,
        );
      } else if (widget.existingAppointment?.selectedSubcategory != null) {
        _selectedType = widget.existingAppointment!.selectedSubcategory;
      } else {
        _selectedType = subCats.first;
      }
    } else {
      _selectedType = null;
    }
  }

  Future<void> _onFormSubmit(BaseAppointmentDraft draft) async {
    if (widget.package.subCategories != null &&
        widget.package.subCategories!.isNotEmpty &&
        _selectedType == null) {
      showCustomSnackbar(
        context,
        'Please select a package type.',
        type: SnackbarType.error,
      );
      return;
    }

    final appointment = PackageAppointment.fromDraft(
      draft: draft,
      package: widget.package,
      selectedSubcategory: _selectedType,
    );

    if (widget.existingAppointment != null) {
      // Update existing — local only for now
      final index = DataService.allAppointments.indexWhere(
        (a) => a.id == draft.id,
      );
      if (index != -1) DataService.allAppointments[index] = appointment;
      if (mounted) {
        showCustomSnackbar(
          context,
          'Appointment updated successfully!',
          type: SnackbarType.success,
        );
      }
    } else {
      // New appointment — add locally AND save to Firestore
      final error = await AppointmentService.saveAppointment(appointment);
      if (error != null) {
        if (mounted) showCustomSnackbar(context, error, type: SnackbarType.error);
        return;
      }
      DataService.allAppointments.add(appointment);
      if (mounted) {
        showCustomSnackbar(
          context,
          'Appointment booked successfully!',
          type: SnackbarType.success,
        );
      }
    }

    if (mounted) context.go('/appointments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.existingAppointment != null
            ? 'Edit Package'
            : 'Book Package',
      ),
      body: BaseBookingForm(
        formKey: _formKey,
        subject: widget.package,
        existingAppointment: widget.existingAppointment,
        buttonText: widget.existingAppointment != null
            ? 'Save Changes'
            : 'Book Now!',
        onSubmit: _onFormSubmit,
        beforeSections: [
          if (widget.package.subCategories != null &&
              widget.package.subCategories!.isNotEmpty) ...[
            PackageTypePicker(
              packageTypes: widget.package.subCategories!,
              selected: _selectedType ?? '',
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            AppSpacing.xlarge,
          ],
        ],
      ),
    );
  }
}