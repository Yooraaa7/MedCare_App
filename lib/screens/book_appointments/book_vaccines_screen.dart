import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/appointment_service.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:medcare_app/screens/book_appointments/components/base_booking_form.dart';
import 'package:medcare_app/screens/book_appointments/components/vaccine_picker.dart';

class BookVaccinesScreen extends StatefulWidget {
  final VaccineAppointment? existingAppointment;

  const BookVaccinesScreen({super.key, this.existingAppointment});

  @override
  State<BookVaccinesScreen> createState() => _BookVaccinesScreenState();
}

class _BookVaccinesScreenState extends State<BookVaccinesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Vaccine> _selectedVaccines = [];
  bool _validateVaccine = false;

  bool prevalidation() {
    if (_selectedVaccines.isEmpty) {
      setState(() => _validateVaccine = true);
      return false;
    }
    return true;
  }

  Future<void> _onFormSubmit(BaseAppointmentDraft draft) async {
    final appointment = VaccineAppointment.fromDraft(
      draft: draft,
      selectedVaccines: _selectedVaccines,
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
      DataService.allAppointments.add(appointment);
      await AppointmentService.saveAppointment(appointment); // ← Firestore
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
    // Use Firestore vaccines if available, otherwise fall back to sample data
    final vaccines = DataService.allVaccines.isNotEmpty
        ? DataService.allVaccines
        : DataService.allVaccines; // DataService.allVaccines already has fallback

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.existingAppointment != null
            ? 'Edit Vaccine Booking'
            : 'Book Vaccines',
      ),
      body: authService.isGuest
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  VaccinePicker(vaccines: vaccines, hasError: false),
                  AppSpacing.xlarge,
                  Card(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Sign in to choose your vaccine slot.",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => authService.logout(),
                            icon: const Icon(Icons.login),
                            label: const Text("Sign In Now"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : BaseBookingForm(
              formKey: _formKey,
              subject: _selectedVaccines.isNotEmpty
                  ? _selectedVaccines.first
                  : 'Vaccine',
              existingAppointment: widget.existingAppointment,
              buttonText: widget.existingAppointment != null
                  ? 'Save Changes'
                  : 'Book Now!',
              prevalidation: prevalidation,
              onSubmit: _onFormSubmit,
              beforeSections: [
                VaccinePicker(
                  vaccines: vaccines,
                  hasError: _validateVaccine && _selectedVaccines.isEmpty,
                  initialSelection:
                      widget.existingAppointment is VaccineAppointment
                      ? (widget.existingAppointment as VaccineAppointment)
                            .selectedVaccines
                      : [],
                  onChanged: (selected) {
                    setState(() => _selectedVaccines = selected);
                  },
                ),
                AppSpacing.xlarge,
              ],
            ),
    );
  }
}