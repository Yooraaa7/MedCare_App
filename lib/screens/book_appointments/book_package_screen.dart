import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      // Try to find the "Real String" from the list if a type was passed
      if (widget.selectedType != null && widget.selectedType!.isNotEmpty) {
        _selectedType = subCats.firstWhere(
          (realString) =>
              realString.toLowerCase().contains(widget.selectedType ?? ''),
          orElse: () => subCats.first, // Fallback if no match found
        );
      }
      // Use the existing appointment value
      else if (widget.existingAppointment?.selectedSubcategory != null) {
        _selectedType = widget.existingAppointment!.selectedSubcategory;
      }
      // Final default to the first in the list
      else {
        _selectedType = subCats.first;
      }
    } else {
      _selectedType = null;
    }
  }

  void _onFormSubmit(BaseAppointmentDraft draft) {
    // Check if subcategories exist and one is selected
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

    // Instantiate a package appointment
    final appointment = PackageAppointment.fromDraft(
      draft: draft,
      package: widget.package,
      selectedSubcategory: _selectedType,
    );

    // Logic for saving/updating
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
          // Package Type Selection
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
