import 'package:flutter/material.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:medcare_app/screens/appointments_list/components/register_slider.dart';

class AppointmentProfile extends StatelessWidget {
  final BaseAppointment appointment;
  final VoidCallback onStatusChanged;
  const AppointmentProfile({
    super.key,
    required this.appointment,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Extract type-specific data using switch expression
    final profileData = switch (appointment) {
      DoctorAppointment doc => (
        image: doc.doctor.fullImagePath,
        title: doc.doctor.nameEng,
        subtitle: doc.doctor.nameChinese,
        desc: doc.doctor.title,
      ),
      PackageAppointment pkg => (
        image: pkg.package.fullImagePath,
        title: pkg.package.name,
        subtitle: null,
        desc: pkg.selectedSubcategory ?? '',
      ),
      VaccineAppointment vac => (
        image: vac.vaccineIconPath,
        title: 'Vaccine Appointment',
        subtitle: null,
        desc: vac.selectedVaccines.map((v) => v.name).join(', '),
      ),
      _ => (
        image: 'assets/images/placeholder.png',
        title: 'Appointment',
        subtitle: null,
        desc: '',
      ),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image Section
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            profileData.image,
            width: 100,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),

        // Info Section
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileData.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Only show subtitle if it exists (e.g., Doctor Chinese Name)
              if (profileData.subtitle != null)
                Text(
                  profileData.subtitle!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 8),
              Text(profileData.desc),
              const SizedBox(height: 12),
              if (appointment.status == AppointmentStatus.upcoming ||
                  appointment.status == AppointmentStatus.registered)
                RegisterSlider(
                  appointment: appointment,
                  onUpdate: onStatusChanged,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
