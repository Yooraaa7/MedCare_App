import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/filter_search_bar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/screens/find_doctors/components/doctor_list.dart';
import 'package:medcare_app/screens/find_doctors/components/filter_bar.dart';
import 'package:medcare_app/screens/find_doctors/components/specialty_bottom_sheet.dart';

class FindDoctorScreen extends StatefulWidget {
  final String? selectedSpecialty;

  const FindDoctorScreen({super.key, this.selectedSpecialty});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  late int selectedIndex;
  late List<GlobalKey> _filterKeys;
  final ScrollController _filterScrollController = ScrollController();
  StreamSubscription? _doctorSubscription;

  String searchQuery = "";
  final specialties = DataService.allSpecialties;

  @override
  void initState() {
    super.initState();

    _doctorSubscription = DataService.watchDoctors().listen((doctors) {
      if (!mounted) return;
      setState(() => DataService.allDoctors = doctors);
    });

    // +1 for "All"
    _filterKeys = List.generate(specialties.length + 1, (_) => GlobalKey());

    final foundIndex = specialties.indexWhere(
      (s) => s.name == widget.selectedSpecialty,
    );

    selectedIndex = foundIndex != -1 ? foundIndex + 1 : 0;

    // If a specialty is passed in the screen, scroll to the selected filter
    if (selectedIndex > 0) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _doctorSubscription?.cancel();
    _filterScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _filterKeys[selectedIndex].currentContext;

      if (ctx != null && _filterScrollController.hasClients) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment:
              0.5, // Ensure the selected filter chip is in the middle of the screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGroupedView = selectedIndex == 0;

    final Specialty? selectedSpecialty = selectedIndex == 0
        ? null
        : specialties[selectedIndex - 1];

    // Always compute from LoadService using current filters
    final groupedDoctors = DataService.getGroupedDoctors(
      searchQuery: searchQuery,
      specialtyFilter: selectedSpecialty,
    );

    final barNames = specialties.map((s) => s.name).toList();
    final barIcons = specialties.map((s) => s.fullImagePath).toList();

    return Scaffold(
      appBar: const CustomAppbar(title: 'Find a Doctor'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterSearchBar(
                  hintText: 'Search doctors...',
                  onChanged: (val) {
                    setState(() => searchQuery = val);
                  },
                ),
                AppSpacing.large,
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune, size: 20),
                      onPressed: () async {
                        final selectedIndexResult =
                            await SpecialtyDialogs.showSpecialtySheet(
                              context,
                              specialties,
                            );

                        if (selectedIndexResult != null) {
                          setState(() {
                            selectedIndex = selectedIndexResult;
                            _scrollToSelected();
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: FilterBar(
                        controller: _filterScrollController,
                        categories: barNames,
                        iconPath: barIcons,
                        selectedIndex: selectedIndex,
                        filterKeys: _filterKeys,
                        onSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                            _scrollToSelected();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Doctor list
          DoctorListView(
            isGrouped: isGroupedView,
            groupedDoctors: groupedDoctors,
            selectedSpecialty: selectedSpecialty,
          ),
        ],
      ),
    );
  }
}
