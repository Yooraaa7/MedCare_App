import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/bill_item.dart';
import 'package:medcare_app/services/user_service.dart';

class BillSummaryScreen extends StatefulWidget {
  const BillSummaryScreen({
    super.key,
  });

  @override
  State<BillSummaryScreen> createState() =>
      _BillSummaryScreenState();
}

class _BillSummaryScreenState
    extends State<BillSummaryScreen> {
  late List<BillItem> billItems;

  @override
  void initState() {
    super.initState();

    // Only the fixed demo account receives
    // the original sample bill records.
    billItems = UserService.isDemoUser
        ? List<BillItem>.from(
            SampleData.billItems,
          )
        : <BillItem>[];
  }

  double get subtotal {
    return billItems.fold<double>(
      0.0,
      (total, item) => total + item.amount,
    );
  }

  double get discount {
    return 0.0;
  }

  double get total {
    return subtotal - discount;
  }

  String _formatAppointmentDate(
    DateTime date,
  ) {
    final String day =
        date.day.toString().padLeft(2, '0');

    final String month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Bill Summary',
      ),
      body: billItems.isEmpty
          ? _buildEmptyState(context)
          : _buildBillContent(
              context,
              isDark,
            ),
      bottomNavigationBar: billItems.isEmpty
          ? null
          : _buildBottomPaymentBar(
              context,
            ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onTertiary,
            ),
            const SizedBox(height: 20),
            Text(
              'No Bill Items',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You do not have any outstanding '
              'bill items at this time.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              label: const Text(
                'Back to Payment',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillContent(
    BuildContext context,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        130,
      ),
      children: [
        _buildPatientSection(context),
        const SizedBox(height: 24),
        Text(
          'Outstanding Items',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...billItems.map(
          (item) => _buildBillItemCard(
            context,
            item,
            isDark,
          ),
        ),
        const SizedBox(height: 12),
        _buildTotalCard(
          context,
          isDark,
        ),
      ],
    );
  }

  Widget _buildPatientSection(
    BuildContext context,
  ) {
    final patient =
        UserService.currentUser;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  Theme.of(context)
                      .colorScheme
                      .primary
                      .withAlpha(30),
              child: Icon(
                Icons.person,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    patient?.name ??
                        'Patient',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MR No: '
                    '${patient?.mrNo ?? "-"}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillItemCard(
    BuildContext context,
    BillItem item,
    bool isDark,
  ) {
    final DateTime appointmentDate =
        item.relatedAppointment.date;

    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(30),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatAppointmentDate(
                      appointmentDate,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'RM ${item.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.strongRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(
    BuildContext context,
    bool isDark,
  ) {
    return Card(
      color: isDark
          ? Theme.of(context)
              .colorScheme
              .secondary
              .withAlpha(70)
          : Theme.of(context)
              .colorScheme
              .primary
              .withAlpha(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountRow(
              context,
              'Subtotal',
              subtotal,
            ),
            const SizedBox(height: 10),
            _buildAmountRow(
              context,
              'Discount',
              discount,
            ),
            const Divider(height: 26),
            _buildAmountRow(
              context,
              'Total Payable',
              total,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: isTotal ? 17 : 14,
          ),
        ),
        Text(
          'RM ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
            color: isTotal
                ? AppColors.strongRed
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPaymentBar(
    BuildContext context,
  ) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          14,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, -3),
              color: Colors.black12,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            context.push(
              '/payment-selection'
              '?amount=$total',
            );
          },
          child: Text(
            'Pay RM ${total.toStringAsFixed(2)}',
          ),
        ),
      ),
    );
  }
}