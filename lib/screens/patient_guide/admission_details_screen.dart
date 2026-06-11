import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/build_list.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/photo_dialog.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/patient_guide/components/section_box.dart';

class AdmissionDetailScreen extends StatelessWidget {
  const AdmissionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Admission Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionBox(
              context: context,
              title: "Required Documents",
              children: [
                Text(
                  'Please bring with you the following documents to facilitate proper and smooth admission:',
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
            sectionBox(
              context: context,
              title: "Admission Kit",
              children: [
                Text(
                  "Patients may obtain our admission kits at a minimal charge. Pyjamas are provided but patients may bring their own. Toiletries may also be brought.",
                ),
                AppSpacing.medium,
                Text('The admission kit contains the following items:'),
                AppSpacing.small,
                buildList([
                  'Comb',
                  'Face towel',
                  'Neck pouch (for money and handphone)',
                  'Plastic water jug',
                  'Plastic cup',
                  'Bottle of shampoo',
                  'Bottle of shower gel',
                  'Toothbrush',
                  'Toothpaste',
                  'Packet of tissue',
                ], true),
              ],
            ),
            sectionBox(
              context: context,
              title: "Visiting Hours",
              centerContent: true,
              children: const [
                Text(
                  "Mondays to Saturdays:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("12:00 PM – 2:00 PM\n5:00 PM – 8:00 PM"),
                AppSpacing.small,
                Text(
                  "Sundays / Public Holidays:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("12:00 PM – 8:00 PM"),
              ],
            ),
            sectionBox(
              context: context,
              title: "Admission Roadmap",
              centerContent: true,
              children: [
                PhotoDialog(
                  imagePath: 'assets/images/workflows/admission_flow.png',
                  imageWidget: Image.asset(
                    'assets/images/workflows/admission_flow.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
