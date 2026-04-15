import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/screens/find_doctors/components/doctor_card.dart';
import 'package:medcare_app/screens/find_doctors/components/specialty_info_section.dart';

class DoctorListView extends StatelessWidget {
  final bool isGrouped;
  final Map<Specialty, List<Doctor>> groupedDoctors;
  final Specialty? selectedSpecialty;

  const DoctorListView({
    super.key,
    required this.isGrouped,
    required this.groupedDoctors,
    this.selectedSpecialty,
  });

  @override
  Widget build(BuildContext context) {
    final entries = groupedDoctors.entries.toList();

    // 1. Find the Primary Doctor globally in the filtered results
    final allDoctors = groupedDoctors.values.expand((list) => list).toList();
    final primaryDoctor = allDoctors.cast<Doctor?>().firstWhere(
      (d) => d?.isPrimary ?? false,
      orElse: () => null,
    );

    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- SECTION 1: HEADER & PRIMARY (FOR GROUPED VIEW) ---
                // Only show Primary at the very top if we are in "All" (Grouped) mode
                if (authService.isAuthenticated &&
                    isGrouped &&
                    primaryDoctor != null)
                  _buildPrimaryDoctorSection(context, primaryDoctor),

                // CASE 1: Single Specialty View - Header first, then results
                if (!isGrouped && selectedSpecialty != null) ...[
                  SpecialtyInfoSection(specialty: selectedSpecialty!),

                  // If the primary doctor belongs to this specialty, show them immediately under info
                  if (authService.isAuthenticated && primaryDoctor != null)
                    _buildPrimaryDoctorSection(context, primaryDoctor),

                  // If no doctors at all (primary or otherwise)
                  if (entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: _buildEmptyState(context),
                    ),
                ],

                // --- SECTION 2: THE REST OF THE LIST ---
                if (entries.isNotEmpty)
                  for (int i = 0; i < entries.length; i++)
                    Builder(
                      builder: (context) {
                        final entry = entries[i];
                        // Filter out primary so they aren't duplicated (ONLY FOR AUTHENTICATED USER)
                        final displayDoctors = authService.isAuthenticated
                            ? entry.value.where((d) => !d.isPrimary).toList()
                            : entry.value;

                        // Hide empty groups in grouped view
                        if (isGrouped && displayDoctors.isEmpty)
                          return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // We only show Grouped Headers in "All" mode.
                            if (isGrouped)
                              _buildGroupedHeader(
                                context,
                                entry.key.name,
                                entry.key.fullImagePath,
                              ),

                            ...displayDoctors.map(
                              (doctor) => DoctorCard(doctor: doctor),
                            ),

                            if (i != entries.length - 1 &&
                                displayDoctors.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        );
                      },
                    ),
              ]),
            ),
          ),

          // If no doctors were found, display empty state
          if (isGrouped && entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(context),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupedHeader(
    BuildContext context,
    String name,
    String iconPath,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The Specialty Icon
          Image.asset(
            iconPath,
            height: 24,
            width: 24,
            // Fallback icon
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.medical_services, size: 24),
          ),
          const SizedBox(width: 10),

          // The Specialty Name
          Text(name, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildPrimaryDoctorSection(BuildContext context, Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.large,
        _buildGroupedHeader(
          context,
          'Your Primary Doctor',
          'assets/images/primary_doctor.png',
        ),
        const SizedBox(height: 12),
        DoctorCard(doctor: doctor),
        AppSpacing.medium,
        const CustomDivider(),
        AppSpacing.medium,
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    Color tertiary = Theme.of(context).colorScheme.onTertiary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person_search_outlined, size: 60, color: tertiary),
        SizedBox(height: 16),
        Text(
          "No doctors found",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: tertiary),
        ),
      ],
    );
  }
}
