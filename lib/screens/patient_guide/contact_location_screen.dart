import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/patient_guide/components/image_card.dart';
import 'package:medcare_app/screens/patient_guide/components/section_box.dart';

class ContactLocationScreen extends StatelessWidget {
  const ContactLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Contact Us'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionBox(
              context: context,
              centerContent: true,
              title: "MEDCARE Hospital",
              children: [
                const Text(
                  "888, Jalan Hospital, 12345, George Town, Penang",
                  textAlign: TextAlign.center,
                ),
                AppSpacing.small,
                _phoneLine("Phone", "+604-345 6789"),
                _phoneLine("Fax", "+604-123 4567"),
                _emailAddress("Email Address", "medcare@med.com"),
                _accommodationLink(
                  "List of accommodations nearby",
                  "Click Here",
                ),
              ],
            ),

            sectionBox(
              context: context,
              centerContent: true,
              title: "Office Hours",
              children: const [
                Text(
                  "Weekdays:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("8:30 AM - 5:00 PM"),
                AppSpacing.small,
                Text(
                  "Saturdays:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("8:30 AM - 1:00 PM"),
                AppSpacing.small,
                Text(
                  "Sundays / Public Holidays:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Closed",
                  style: TextStyle(
                    color: AppColors.strongRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _mapSection(context),
          ],
        ),
      ),
    );
  }

  Widget _phoneLine(String label, String number) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: "),
        Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _emailAddress(String label, String email) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: "),
        Text(email, style: const TextStyle(color: AppColors.linkBlue)),
      ],
    );
  }

  Widget _accommodationLink(String label, String link) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: "),
        Text(
          link,
          style: const TextStyle(
            color: AppColors.linkBlue,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget _mapSection(BuildContext context) {
    return Stack(
      children: [
        imageCard('assets/images/medcare_map.png', context),

        const Positioned(
          top: 12,
          right: 12,
          child: Text(
            'View on Google Map',
            style: TextStyle(
              color: AppColors.defaultWhite,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.defaultWhite,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.black54,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
