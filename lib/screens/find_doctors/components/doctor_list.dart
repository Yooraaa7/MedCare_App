import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/screens/find_doctors/components/doctor_card.dart';
import 'package:medcare_app/screens/find_doctors/components/specialty_info_section.dart';
import 'package:medcare_app/services/user_service.dart';

class DoctorListView extends StatelessWidget {
  final bool isGrouped;
  final Map<Specialty, List<Doctor>>
      groupedDoctors;
  final Specialty? selectedSpecialty;

  const DoctorListView({
    super.key,
    required this.isGrouped,
    required this.groupedDoctors,
    this.selectedSpecialty,
  });

  @override
  Widget build(BuildContext context) {
    final entries =
        groupedDoctors.entries.toList();

    final allDoctors = groupedDoctors.values
        .expand((doctorList) => doctorList)
        .toList();

    final String? primaryDoctorId =
        UserService.currentUser?.primaryDoctorId;

    // Restore the original primary-doctor experience only for the
    // permanent demo account. New patients do not inherit a global
    // primary doctor.
    final Doctor? primaryDoctor = UserService.isDemoUser
        ? _findLegacyPrimaryDoctor(allDoctors)
        : _findDoctorById(allDoctors, primaryDoctorId);

    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              30,
              16,
              30,
              30,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Show the patient-specific primary
                // doctor at the top of the complete list.
                if (isGrouped &&
                    primaryDoctor != null)
                  _buildPrimaryDoctorSection(
                    context,
                    primaryDoctor,
                  ),

                if (!isGrouped &&
                    selectedSpecialty != null) ...[
                  SpecialtyInfoSection(
                    specialty:
                        selectedSpecialty!,
                  ),

                  // primaryDoctor is found from the
                  // currently filtered doctor list.
                  // Therefore, it appears here only if
                  // it belongs to this specialty.
                  if (primaryDoctor != null)
                    _buildPrimaryDoctorSection(
                      context,
                      primaryDoctor,
                    ),

                  if (entries.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 30,
                      ),
                      child:
                          _buildEmptyState(context),
                    ),
                ],

                if (entries.isNotEmpty)
                  for (int i = 0;
                      i < entries.length;
                      i++)
                    Builder(
                      builder: (context) {
                        final entry = entries[i];

                        // Remove only this patient's
                        // primary doctor to avoid showing
                        // the same doctor twice.
                        final displayDoctors =
                            entry.value.where(
                          (doctor) {
                            return doctor.id !=
                                primaryDoctor?.id;
                          },
                        ).toList();

                        if (isGrouped &&
                            displayDoctors.isEmpty) {
                          return const SizedBox
                              .shrink();
                        }

                        return Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            if (isGrouped)
                              _buildGroupedHeader(
                                context,
                                entry.key.name,
                                entry.key
                                    .fullImagePath,
                              ),

                            ...displayDoctors.map(
                              (doctor) =>
                                  DoctorCard(
                                doctor: doctor,
                              ),
                            ),

                            if (i !=
                                    entries.length -
                                        1 &&
                                displayDoctors
                                    .isNotEmpty)
                              const Padding(
                                padding:
                                    EdgeInsets
                                        .symmetric(
                                  vertical: 16,
                                ),
                                child:
                                    CustomDivider(),
                              ),
                          ],
                        );
                      },
                    ),
              ]),
            ),
          ),

          if (isGrouped && entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(context),
            ),
        ],
      ),
    );
  }

  Doctor? _findLegacyPrimaryDoctor(List<Doctor> doctors) {
    for (final doctor in doctors) {
      if (doctor.isPrimary) return doctor;
    }
    return null;
  }

  Doctor? _findDoctorById(
    List<Doctor> doctors,
    String? doctorId,
  ) {
    if (doctorId == null ||
        doctorId.trim().isEmpty) {
      return null;
    }

    for (final doctor in doctors) {
      if (doctor.id == doctorId) {
        return doctor;
      }
    }

    return null;
  }

  Widget _buildGroupedHeader(
    BuildContext context,
    String name,
    String iconPath,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        5,
        0,
        0,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 24,
            width: 24,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const Icon(
                Icons.medical_services,
                size: 24,
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryDoctorSection(
    BuildContext context,
    Doctor doctor,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    final Color tertiary =
        Theme.of(context)
            .colorScheme
            .onTertiary;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person_search_outlined,
          size: 60,
          color: tertiary,
        ),
        const SizedBox(height: 16),
        Text(
          'No doctors found',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: tertiary,
          ),
        ),
      ],
    );
  }
}