import 'package:flutter/material.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/general/components/filter_search_bar.dart';
import 'package:medcare_app/screens/home/components/specialty_tile.dart';

class SpecialtyDialogs {
  static Future<int?> showSpecialtySheet(
    BuildContext context,
    List<Specialty> specialties,
  ) {
    List<Specialty> filteredSpecialties = List.from(specialties);
    String currentSearch = "";

    return showModalBottomSheet<int?>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          // Check if we should show the "All" tile based on search
          final showAllTile =
              currentSearch.isEmpty ||
              "all".contains(currentSearch.toLowerCase());

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Specialty",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  FilterSearchBar(
                    hintText: 'Search specialty...',
                    onChanged: (value) {
                      setSheetState(() {
                        currentSearch = value;
                        filteredSpecialties = specialties
                            .where(
                              (s) => s.name.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: (filteredSpecialties.isEmpty && !showAllTile)
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text("No specialties found"),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            // +1 for the "All" tile if showAllTile is true
                            itemCount:
                                filteredSpecialties.length +
                                (showAllTile ? 1 : 0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 7,
                                  childAspectRatio: 0.8,
                                ),
                            itemBuilder: (context, index) {
                              // If showAllTile is true, the first item (index 0) is "All"
                              if (showAllTile && index == 0) {
                                return SpecialtyTile(
                                  "All",
                                  'assets/images/specialties/hospital.png',
                                  onTap: () => Navigator.pop(
                                    context,
                                    0,
                                  ), // Returning null means "All"
                                );
                              }

                              // Adjust index if we are showing the "All" tile
                              final itemIndex = showAllTile ? index - 1 : index;
                              final item = filteredSpecialties[itemIndex];
                              final int originalIndex =
                                  specialties.indexOf(item) + 1;

                              return SpecialtyTile(
                                item.name,
                                item.fullImagePath,
                                onTap: () =>
                                    Navigator.pop(context, originalIndex),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
