import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/screens/patient_guide/components/image_card.dart';

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
            imageCard("assets/images/notices/tin_sst1.jpg", context),
            const SizedBox(height: 20),

            imageCard('assets/images/notices/tin_sst2.jpg', context),
            const SizedBox(height: 20),

            imageCard("assets/images/notices/visiting_hours.jpg", context),
          ],
        ),
      ),
    );
  }
}
