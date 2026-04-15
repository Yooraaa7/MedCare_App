import 'package:flutter/material.dart';
import 'package:medcare_app/data/packages/packages_data.dart';
import 'package:medcare_app/general/components/auto_scroll_banner.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/filter_search_bar.dart';
import 'package:medcare_app/general/components/view_all_button.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/screens/packages/components/package_card.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final List<String> bannerImages = [
    'assets/images/banners/dna_banner.jpg',
    'assets/images/banners/proactive_banner.jpg',
  ];

  bool showAll = false;
  int currentBanner = 0;

  String _searchQuery = '';
  List<Package> _filteredResults = [];
  List<Package> get _allPackages => [
    ...ourPackages,
    ...childrenPackages,
    ...wellnessPackages,
  ];

  void _searchPackage(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredResults = [];
      } else {
        _filteredResults = _allPackages
            .where(
              (pkg) => pkg.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedOurPackages = showAll
        ? ourPackages
        : ourPackages.take(2).toList();

    return Scaffold(
      appBar: const CustomAppbar(title: 'Packages'),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          FilterSearchBar(
            hintText: 'Search packages...',
            onChanged: (val) => _searchPackage(val),
          ),

          AppSpacing.large,

          if (_searchQuery.isEmpty) ...[
            AutoScrollBanner(bannerImages: bannerImages),
            const SizedBox(height: 12),
            const SizedBox(height: 20),

            Text(
              "Our Packages",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...displayedOurPackages.map((pkg) => PackageCard(package: pkg)),

            Center(
              child: ViewAllButton(
                onPressed: () => setState(() {
                  showAll = !showAll;
                }),
                text: showAll ? 'Show less' : 'Show all',
                alignment: Alignment.center,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "For Children",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...childrenPackages.map((pkg) => PackageCard(package: pkg)),

            const SizedBox(height: 20),
            Text(
              "Psychological Wellness",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...wellnessPackages.map((pkg) => PackageCard(package: pkg)),
          ] else ...[
            // --- SEARCH RESULTS VIEW ---
            Text(
              "Search Results for '$_searchQuery'",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppSpacing.xlarge,
            if (_filteredResults.isEmpty)
              const Center(child: Text("No packages found."))
            else
              ..._filteredResults.map((pkg) => PackageCard(package: pkg)),
          ],
        ],
      ),
    );
  }
}
