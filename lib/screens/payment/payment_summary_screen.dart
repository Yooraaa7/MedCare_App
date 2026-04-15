import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double totalPayable = SampleData.sampleUser.totalPayable;

    final String logoPath = isDark
        ? 'assets/images/medcare_banner.png'
        : 'assets/images/medcare_banner.png';

    final Color payButtonColor = isDark
        ? AppColors.green.withAlpha(180)
        : AppColors.green;

    return Scaffold(
      appBar: const CustomAppbar(title: 'Payment Summary', implyLeading: false),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                isDark
                    ? Theme.of(context).colorScheme.surface.withAlpha(220)
                    : Theme.of(context).colorScheme.surface.withAlpha(180),
                isDark ? BlendMode.darken : BlendMode.lighten,
              ),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(logoPath, height: 60),

                  AppSpacing.xlarge,

                  Text(
                    "Total Payable",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  AppSpacing.small,

                  Text(
                    'RM ${totalPayable.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.strongRed,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  AppSpacing.large,
                  if (totalPayable != 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: payButtonColor,
                      ),
                      onPressed: totalPayable == 0
                          ? null
                          : () => context.push(
                              '/payment-selection?amount=$totalPayable',
                            ),
                      child: const Text(
                        "Pay Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  const SizedBox(height: 16),

                  if (totalPayable != 0)
                    _buildViewBillButton(context, isDark)
                  else
                    _buildEmptyStatus(context, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildViewBillButton(BuildContext context, bool isDark) {
  final color = Theme.of(context).colorScheme.primary;

  return Card(
    color: Colors.transparent,
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => context.push('/payment/bill-summary'),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 20,
              color: isDark ? AppColors.defaultWhite : color,
            ),
            const SizedBox(width: 15),
            Text(
              "View Bill Summary",
              style: TextStyle(
                color: isDark ? AppColors.defaultWhite : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildEmptyStatus(BuildContext context, bool isDark) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.green,
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(
            "Bill Settled",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.green.shade200 : Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You have no outstanding balance to pay at this time.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
