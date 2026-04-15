import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayAtCounterScreen extends StatelessWidget {
  final double amount;
  const PayAtCounterScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final String qrData =
        "PaymentInfo|Amount:RM${amount.toStringAsFixed(2)}|MRNo:${SampleData.sampleUser.mrNo}|Name:${SampleData.sampleUser.name}";

    return Scaffold(
      appBar: const CustomAppbar(title: 'Pay at Counter / Kiosk'),
      body: Column(
        children: [
          // Step-by-step instructions
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                Center(
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 130.0,
                    backgroundColor: Colors.white,
                  ),
                ),

                AppSpacing.medium,

                Text(
                  "Scan this QR Code at the counter",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),

                AppSpacing.large,

                const _StepCard(
                  icon: Icons.receipt_long,
                  title: "Step 1",
                  description: "Bring your MR number or appointment slip.",
                ),
                const _StepCard(
                  icon: Icons.account_balance,
                  title: "Step 2",
                  description: "Proceed to the cashier counter.",
                ),
                const _StepCard(
                  icon: Icons.qr_code,
                  title: "Step 3",
                  description: "Show the QR code to the cashier.",
                ),
                _StepCard(
                  icon: Icons.payment,
                  title: 'Step 4 ⓘ',
                  description: 'Pay using a supported payment method.',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Supported Payment Methods"),
                          titleTextStyle: Theme.of(
                            context,
                          ).textTheme.titleMedium,
                          content: const Text(
                            "• Cash\n"
                            "• Credit/Debit Card\n"
                            "• Online Banking\n"
                            "• E-Wallets (Touch 'n Go, GrabPay, Boost)",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Step Card widget
class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
