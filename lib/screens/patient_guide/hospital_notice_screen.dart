import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/screens/patient_guide/components/image_card.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
class HospitalNoticeScreen extends StatelessWidget {
  const HospitalNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Hospital Notice'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            imageCard("assets/images/notices/medcare_notice.png", context),
            const SizedBox(height: 20),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }
}
