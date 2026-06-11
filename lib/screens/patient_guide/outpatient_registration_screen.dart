import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/build_list.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/patient_guide/components/image_card.dart';
import 'package:medcare_app/screens/patient_guide/components/section_box.dart';

class OutpatientRegistrationScreen extends StatelessWidget {
  const OutpatientRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Outpatient Registration'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Required Documents Section
            sectionBox(
              context: context,
              title: "Required Documents",
              children: [
                Text(
                  'Please bring with you the following documents during Outpatient Registration to facilitate proper registration:',
                ),
                AppSpacing.medium,
                buildList([
                  "MyKad or MyKid (NRIC) (Malaysian citizen)",
                  "Passport if not a Malaysian citizen",
                  "Doctor’s referral letter and GL / deposit for self-payment",
                  "Appointment card",
                ], true),
              ],
            ),

            // Outpatient Roadmap
            sectionBox(
              context: context,
              title: 'Outpatient Registration Roadmap',
              children: [
                imageCard(
                  "assets/images/workflows/or_roadmap.png",
                  context,
                ),
              ],
            ),

            // Health Screening Centre Roadmap
            sectionBox(
              context: context,
              title: "Health Screening Centre Roadmap",
              children: [
                imageCard("assets/images/workflows/hs_roadmap.png", context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
