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
                  "MedCare provides 24-hour accident and emergency services for all patients. Please proceed directly to the A&E department located at the main entrance.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Ambulance Service",
              centerContent: true,
              children: const [
                Text(
                  "MedCare operates an ambulance service round the clock. The ambulance is fully equipped with essential life-saving equipment.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Air-Conditioned Room / Ward",
              children: const [
                Text(
                  "All rooms have been upgraded to full air-conditioning for the comfort of our patients. For room selection assistance, please approach the front desk.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Beverage / Snack Vending Machines",
              children: const [
                Text(
                  "Beverage/Snack vendor machines are available at our Cafeteria and Ground Floor along the corridor.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Locker Service",
              children: const [
                Text(
                  "Locker facilities (small, medium, large) are available at a minimal charge. The hospital is not responsible for loss or damage of valuables.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Medication Service",
              children: const [
                Text(
                  "Please bring all existing prescriptions during admission. Our pharmacy team is available to assist at any time.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Television",
              children: const [
                Text(
                  "Television sets are provided in all standard wards and rooms. Channel lists and rates are available at the front desk.",
                ),
              ],
            ),

            sectionBox(
              context: context,
              title: "Free Wi-Fi",
              children: const [
                Text(
                  "Complimentary Wi-Fi internet service is available throughout MedCare Hospital for all patients and visitors.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
