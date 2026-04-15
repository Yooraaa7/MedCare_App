import 'package:flutter/material.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/screens/patient_guide/components/section_box.dart';

class GeneralInfoScreen extends StatelessWidget {
  const GeneralInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'General Information'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionBox(
              context: context,
              title: "2-Way Nursing Call System",
              children: const [
                Text(
                  "Two-way communication nurse call system is available at the bedside when assistance is required at all times. A nurse call bell is also available in the toilet in case of an emergency. The call bell service is free of charge.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Accident & Emergency Service",
              children: const [
                Text(
                  "Doctors are available 24 hours a day to provide emergency management.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Ambulance Service",
              centerContent: true,
              children: const [
                Text(
                  "For Ambulance Service to and from the Hospital, please call:",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "+604 - 652 6868",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Air-Conditioned Room / Ward",
              children: const [
                Text(
                  "The hospital has been upgraded to a 24-hour fully air-conditioned environment.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Beverage / Snack Vending Machines",
              children: const [
                Text(
                  "Available at our Cafeteria, Ground Floor corridor toward Haemodialysis Unit, and 1st Floor.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Food Service (Pork Free)",
              children: const [
                Text(
                  "Variety of meal choices are provided to meet patients’ and lodgers’ needs. Lodger meals are charged accordingly. Do not use hospital kitchenware if you bring your own food. Kitchen appliances are not allowed.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Locker Service",
              children: const [
                Text(
                  "Smart Lockers are provided to private, 2-bedded, and 4-bedded room patients. QR wristbands safeguard lockers. Common ward patients receive key lockers. Hospital is not responsible for losses.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Medication Service",
              children: const [
                Text(
                  "Bring your medications in original packaging and hand them to nursing staff upon admission.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Television",
              children: const [
                Text(
                  "Televisions with Astro channels are provided in private, 2-bedded, and 4-bedded rooms free of charge.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Free Wi-Fi",
              children: const [
                Text(
                  "Free Wi-Fi internet service is available throughout the hospital premises.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
