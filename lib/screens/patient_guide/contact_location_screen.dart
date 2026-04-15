import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/screens/patient_guide/components/image_card.dart';
import 'package:medcare_app/screens/patient_guide/components/section_box.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactLocationScreen extends StatelessWidget {
  const ContactLocationScreen({super.key});

  final String mapUrl =
      "https://www.google.com.my/maps/place/Lam+Wah+Ee+Hospital/@5.3916778,100.302411,17z/data=!3m1!4b1!4m5!3m4!1s0x304ac22ac4e0a22f:0x7754935724fa89f2!8m2!3d5.3916778!4d100.3045997?hl=en";

  // TODO: Convert to indoor floorplans perhaps
  Future<void> _launchMap(BuildContext context) async {
    final uri = Uri.parse(mapUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Check if the context is still valid after the 'await'
      if (!context.mounted) return;
      showCustomSnackbar(
        context,
        'Unable to open Google Maps.',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _launchEmail(String email, BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: email);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Check if the context is still valid after the 'await'
      if (!context.mounted) return;
      showCustomSnackbar(
        context,
        'Unable to open email.',
        type: SnackbarType.error,
      );
    }
  }

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
              title: "Hospital Lam Wah Ee",
              children: [
                const Text(
                  "141, Jalan Tan Sri Teh Ewe Lim, 11600 Georgetown, Pulau Pinang",
                  textAlign: TextAlign.center,
                ),
                AppSpacing.small,
                _phoneLine("Phone", "+604-652 8888"),
                _phoneLine("Emergency", "+604-652 8946"),
                _emailLink("iremmah@pch.moh.gov.my", context),
              ],
            ),
            sectionBox(
              context: context,
              centerContent: true,
              title: "Chinese Medicine Division",
              children: [
                _phoneLine("Phone", "+604-652 8877"),
                _emailLink("cmadrrahim@live.com", context),
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
                  'Closed',
                  style: TextStyle(
                    color: AppColors.strongRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Map section
            const SizedBox(height: 20),

            _mapSection(context, _launchMap),
          ],
        ),
      ),
    );
  }

  // Phone line widget
  Widget _phoneLine(String label, String number) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: "),
        Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Email link widget
  Widget _emailLink(String email, BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        children: [
          const TextSpan(text: "Email Address: "),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => ContactLocationScreen()._launchEmail(email, context),
              child: Text(
                email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Map section
Widget _mapSection(BuildContext context, Function launchMap) => Stack(
  children: [
    imageCard('assets/images/hospital_location_map.jpg', context),
    Positioned(
      top: 12,
      right: 12,
      // Wrap the button in a SizedBox or ConstrainedBox to give it boundaries
      child: SizedBox(
        width: 270,
        child: ElevatedButton.icon(
          onPressed: () => launchMap(context),
          icon: Icon(Icons.map),
          label: Text("View on Google Maps"),
        ),
      ),
    ),
  ],
);
