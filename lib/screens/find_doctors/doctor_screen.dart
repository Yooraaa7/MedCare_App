import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/screens/find_doctors/components/info_tile.dart';

class DoctorScreen extends StatelessWidget {
  final Doctor doctor;
  const DoctorScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Doctor Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildHeader(context),
            _buildMiddleInfo(),
            _buildScheduleSection(context),
            _buildRemarksSection(context),
            const SizedBox(height: 40),

            if (doctor.isBookable) _buildBookButton(context),
          ],
        ),
      ),
    );
  }

  // Header: Profile Image and Name/Title
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            doctor.fullImagePath,
            width: 100,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.nameEng,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                doctor.nameChinese,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(doctor.title),
            ],
          ),
        ),
      ],
    );
  }

  /// 2. Middle: Qualifications, Location, Contact, Language
  Widget _buildMiddleInfo() {
    return Column(
      children: [
        AppSpacing.large,
        const CustomDivider(),
        AppSpacing.large,
        InfoTile(
          icon: Icons.school_outlined,
          label: "Qualification",
          value: textValue(doctor.qualification),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.location_on_outlined,
          label: "Location",
          value: textValue(doctor.location),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.call,
          label: "Contact",
          value: textValue(doctor.contact),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.language_outlined,
          label: "Language",
          value: textValue(doctor.languages.join(', ')),
        ),
      ],
    );
  }

  /// 3. Schedule: Clinic Days and Holiday Closures
  Widget _buildScheduleSection(BuildContext context) {
    final hasSchedule =
        doctor.weeklySchedule != null && doctor.weeklySchedule!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const CustomDivider(),
        const SizedBox(height: 24),
        Text(
          "Clinic Days / Hours",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        if (!hasSchedule)
          const Text(
            "Schedule not available. Please contact the clinic for operating hours.",
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        else
          ...doctor.weeklySchedule!.map(
            (workDay) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. If shifts are empty and the work day isn't close, render only the title across the whole row
                  if (workDay.shifts.isEmpty && !workDay.isClosed)
                    Expanded(child: Text(workDay.dayOfWeek))
                  // 2. Otherwise, render the standard two-column layout
                  else ...[
                    SizedBox(
                      width: 100,
                      child: Text(
                        workDay.dayOfWeek,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    AppSpacing.widthLarge,
                    Expanded(
                      child: workDay.isClosed
                          ? const Text(
                              "Closed",
                              style: TextStyle(color: AppColors.strongRed),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: workDay.shifts
                                  .map(
                                    (shift) =>
                                        Text("${shift.open} - ${shift.close}"),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        if (doctor.holidayClosures != null &&
            doctor.holidayClosures!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Closed on ${doctor.holidayClosures!.join(' & ')}",
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
      ],
    );
  }

  /// 4. Remarks Section
  Widget _buildRemarksSection(BuildContext context) {
    final hasRemarks = doctor.remarks != null && doctor.remarks!.isNotEmpty;

    if (!hasRemarks) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const CustomDivider(),
        const SizedBox(height: 24),

        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              const TextSpan(text: 'Note '),
              const TextSpan(
                text: '*',
                style: TextStyle(color: AppColors.strongRed),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Text(doctor.remarks ?? ''),
      ],
    );
  }

  /// 5. Bottom: Action Button
  Widget _buildBookButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          authService.performProtectedAction(
            context: context,
            onAction: () => context.push(
              '/book-doctor',
              extra: {'doctor': doctor, 'appointment': null},
            ),
          );
        },
        child: const Text("Book an Appointment"),
      ),
    );
  }

  Widget textValue(String value) =>
      Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(value));
}
