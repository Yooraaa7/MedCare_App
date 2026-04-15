import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/auto_scroll_banner.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/home/components/appointments_section.dart';
import 'package:medcare_app/screens/home/components/home_header.dart';
import 'package:medcare_app/screens/home/components/services_section.dart';
import 'package:medcare_app/screens/home/components/specialties_section.dart';
import 'package:medcare_app/screens/home/components/welcome_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Header Background with search bar
                const HomeHeader(),

                // The Overlapping Container
                Padding(
                  padding: const EdgeInsets.only(
                    top: HomeHeader.headerHeight - 20,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, -8),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const WelcomeSection(),
                        AppSpacing.xlarge,

                        AutoScrollBanner(
                          bannerImages: [
                            'assets/images/placeholder.png',
                            'assets/images/placeholder.png',
                            'assets/images/placeholder.png',
                          ],
                          colorFilters: [
                            ColorFilter.mode(
                              Colors.black.withAlpha(40),
                              BlendMode.darken,
                            ),
                            ColorFilter.mode(
                              Colors.white.withAlpha(100),
                              BlendMode.lighten,
                            ),
                          ],
                        ),
                        AppSpacing.xlarge,

                        const AppointmentsSection(),
                        AppSpacing.xlarge,
                        const ServicesSection(),
                        AppSpacing.xlarge,
                        const SpecialtiesSection(),
                        AppSpacing.large,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
