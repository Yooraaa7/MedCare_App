import 'package:medcare_app/models/appointments/base_appointment.dart';

class BillItem {
  final String description;
  final int qty;
  final double amount;
  final BaseAppointment relatedAppointment; // Link back if needed

  BillItem({
    required this.description,
    this.qty = 1,
    required this.amount,
    required this.relatedAppointment,
  });

  // Helper for formatted amount
  String get formattedAmount => "RM ${amount.toStringAsFixed(2)}";
}
