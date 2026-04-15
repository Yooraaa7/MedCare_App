import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_divider.dart';
import 'package:medcare_app/screens/payment/components/bill_item_tile.dart';
import 'package:medcare_app/models/bill_item.dart';
import 'package:intl/intl.dart';

class BillSummaryScreen extends StatelessWidget {
  const BillSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final billItems = SampleData.billItems;
    final grandTotal = billItems.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    // Group by Date first
    final Map<String, List<BillItem>> dateGroups = {};
    for (var item in billItems) {
      String dateKey = DateFormat(
        'dd MMM yyyy, EEEE',
      ).format(item.relatedAppointment.date);
      dateGroups.putIfAbsent(dateKey, () => []).add(item);
    }

    return Scaffold(
      appBar: const CustomAppbar(title: 'Bill Summary'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  _buildHeader(),

                  ...dateGroups.entries.map((dateEntry) {
                    final String date = dateEntry.key;
                    final List<BillItem> itemsInDate = dateEntry.value;
                    final double dailySubtotal = itemsInDate.fold(
                      0,
                      (sum, item) => sum + item.amount,
                    );

                    // 2. Group items within this date by Appointment ID
                    final Map<String, List<BillItem>> appointmentGroups = {};

                    for (var item in itemsInDate) {
                      appointmentGroups
                          .putIfAbsent(item.relatedAppointment.id, () => [])
                          .add(item);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateHeader(context, date),

                        // Render Grouped Appointment Items
                        ...appointmentGroups.entries.map((apptEntry) {
                          return _buildAppointmentGroup(
                            context,
                            apptEntry.key,
                            apptEntry.value,
                          );
                        }),

                        _buildDailySubtotal(context, dailySubtotal),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildGrandTotalRow(context, grandTotal),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to build the nested appointment block
  Widget _buildAppointmentGroup(
    BuildContext context,
    String apptId,
    List<BillItem> items,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List of items belonging to this appointment
          ...items.map((item) => BillItemTile(item: item)),

          // Navigates to the related appointment
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 4, top: 4),
            child: InkWell(
              onTap: () =>
                  context.push('/appointments/appointment-details/$apptId'),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Appointment Details",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border(
          top: BorderSide(color: Colors.grey.shade400, width: 1),
          bottom: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
      ),
      child: Text(
        date,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildDailySubtotal(BuildContext context, double amount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Subtotal",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
          Text(
            'RM ${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 16, 88, 159),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text("Qty", style: headerStyle)),
          Expanded(flex: 5, child: Text("Description", style: headerStyle)),
          Expanded(
            flex: 3,
            child: Text(
              "Amount (RM)",
              textAlign: TextAlign.right,
              style: headerStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrandTotalRow(BuildContext context, double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Total Payable",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Text(
          "RM ${total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

const headerStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white);
