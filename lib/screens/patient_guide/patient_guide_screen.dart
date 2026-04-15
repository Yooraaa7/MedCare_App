import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class PatientGuideScreen extends StatelessWidget {
  const PatientGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> guideItems = [
      {
        "title": "Hospital Notice",
        "subtitle": "Important Notice for All Patients and Visitors.",
        'route': 'hospital-notice',
      },
      {
        "title": "Outpatient Registration",
        "subtitle": "Learn more about outpatient registration procedures.",
        'route': 'outpatient-registration',
      },
      {
        "title": "Admissions",
        "subtitle": "Learn more about the procedures of admission.",
        "route": 'admission-details',
      },
      {
        "title": "General Information",
        "subtitle": "Helpful information for planning your visit.",
        'route': 'general-information',
      },

      {
        "title": "Contact Us & Location",
        "subtitle": "Contact us and find your way to and around the hospital.",
        'route': 'contact-us',
      },
    ];

    return Scaffold(
      appBar: const CustomAppbar(title: 'Patient Guide', implyLeading: false),
      body: ListView.separated(
        padding: const EdgeInsets.all(30),
        itemCount: guideItems.length,
        separatorBuilder: (context, index) {
          return AppSpacing.medium;
        },
        itemBuilder: (context, index) {
          final item = guideItems[index];
          return _buildGuideCard(context, item);
        },
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/patient-guide/${item['route']}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left Bar Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSpacing.widthLarge,

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(item["subtitle"], style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              // Trailing Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
