import 'package:flutter/material.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/screens/find_doctors/components/info_tile.dart';
import 'package:intl/intl.dart';

class AppointmentInfoBlock extends StatelessWidget {
  final BaseAppointment appointment;
  const AppointmentInfoBlock({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat('dd MMM yyyy, EEEE').format(appointment.date);
    String paymentStr = switch (appointment.paymentMethod) {
      PaymentMethod.corporate => 'Corporate',
      PaymentMethod.insurance => 'Insurance',
      PaymentMethod.selfPay => 'Self Pay',
    };

    return Column(
      children: [
        InfoTile(
          icon: Icons.calendar_today,
          label: "Date",
          value: textValue(dateStr),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.access_time,
          label: "Time Slot",
          value: textValue(appointment.timeSlot),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.location_on_outlined,
          label: "Location",
          value: textValue(appointment.location),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.call,
          label: "Contact",
          value: textValue(appointment.contact),
        ),
        const SizedBox(height: 14),
        InfoTile(
          icon: Icons.payment,
          label: "Payment Method",
          value: textValue(paymentStr),
        ),

        if (appointment.paymentMethod == PaymentMethod.insurance &&
            appointment.insurance != null) ...[
          const SizedBox(height: 14),

          InfoTile(
            icon: Icons.shield_outlined,
            label: 'Insurance Details',
            value: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  appointment.insurance?.logoPath ??
                      'assets/images/insurance/insurance_default.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      Text(appointment.insurance!.provider),
                      const SizedBox(height: 3),
                      Text(
                        appointment.insurance!.policy,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        if (appointment is DoctorAppointment) ...[
          const SizedBox(height: 14),
          InfoTile(
            icon: Icons.note_outlined,
            label: 'Reason of Visit',
            value: textValue((appointment as DoctorAppointment).reasonOfVisit),
          ),
        ],
      ],
    );
  }
}

Widget textValue(String value) =>
    Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(value));
