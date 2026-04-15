import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<String> categories;
  final ScrollController controller;
  final List<GlobalKey> filterKeys;
  final List<String>? iconPath;
  final int selectedIndex;
  final Function(int) onSelected;

  const FilterBar({
    super.key,
    required this.categories,
    required this.controller,
    required this.filterKeys,
    this.iconPath,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        // Added BouncingScrollPhysics for a more premium feel
        physics: const BouncingScrollPhysics(), 
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Using a collection for-loop to build the list
            for (int index = 0; index < categories.length + 1; index++) ...[
              builder(index),
            ]
          ],
        ),
      ),
    );
  }

  Widget builder(int index) {
    final isAllChip = index == 0;
    final label = isAllChip ? 'All' : categories[index - 1];

    final String? currentIcon =
        (!isAllChip && iconPath != null && index - 1 < iconPath!.length)
            ? iconPath![index - 1]
            : null;

    return AppFilterChip(
      key: filterKeys[index], 
      label: label,
      iconPath: currentIcon,
      isSelected: selectedIndex == index,
      onSelected: (selected) {
        if (selected) onSelected(index);
      },
    );
  }
}

// Filter chip for selection
class AppFilterChip extends StatelessWidget {
  final String label;
  final String? iconPath;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    this.iconPath,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        avatar: iconPath != null 
          ? Image.asset(iconPath!)
          : null,
        selected: isSelected,
        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
        selectedColor: Theme.of(context).colorScheme.primary,
        onSelected: onSelected,
        labelStyle: TextStyle(
          fontFamily: "Poppins",
          color: isSelected 
            ? Theme.of(context).colorScheme.onPrimary 
            : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}