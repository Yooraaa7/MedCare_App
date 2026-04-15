import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/page_indicator.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/screens/manage_payment/components/payment_row.dart';
import 'package:intl/intl.dart';

class InsuranceDetailsScreen extends StatefulWidget {
  final InsuranceDetails insurance;

  const InsuranceDetailsScreen({super.key, required this.insurance});

  @override
  State<InsuranceDetailsScreen> createState() => _InsuranceDetailsScreenState();
}

class _InsuranceDetailsScreenState extends State<InsuranceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final insurance = widget.insurance;

    return Scaffold(
      appBar: const CustomAppbar(title: 'Insurance Details'),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (insurance.imagePaths.isNotEmpty) ...[
              SizedBox(
                height: 180,
                child: PageView(
                  controller: pageController,
                  children: insurance.fullImagePath.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(img, fit: BoxFit.contain),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              pageIndicator(
                context,
                controller: pageController,
                count: insurance.fullImagePath.length,
              ),
              const SizedBox(height: 30),
            ],

            paymentRow(
              context,
              title: 'Provider',
              trailing: Text(
                insurance.provider,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            paymentRow(
              context,
              title: 'Policy Number',
              trailing: Text(
                insurance.policy,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            paymentRow(
              context,
              title: 'Expiry Date',
              trailing: Text(
                insurance.expiry,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            paymentRow(
              context,
              title: 'Set as Default',
              trailing: Switch(
                value: insurance.isDefault,
                onChanged: (value) {
                  if (value == true) {
                    for (final i in DataService.allInsurance) {
                      if (i != widget.insurance) i.isDefault = false;
                    }
                  }

                  setState(() {
                    insurance.isDefault = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                _showDeleteDialog(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: AppColors.strongRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showWarningDialog(
      context,
      title: 'Delete Insurance',
      content: 'Are you sure you want to delete this insurance?',
      actionColor: AppColors.strongRed,
      actionText: 'Delete',
      onTapAction: () {
        BaseAppointment? linkedAppt;

        for (final appt in DataService.getActiveBookings()) {
          if (appt.insurance == widget.insurance) {
            linkedAppt = appt;
            break; // stop at the first match
          }
        }

        if (linkedAppt != null) {
          final dateStr = DateFormat(
            'dd MMM yyyy, EEEE',
          ).format(linkedAppt.date);
          final timeStr = linkedAppt.timeSlot;

          showCustomSnackbar(
            context,
            'This insurance is already linked to an upcoming appointment on '
            '$dateStr at $timeStr.',
            type: SnackbarType.error,
          );

          context.pop();
          return;
        }

        DataService.allInsurance.remove(widget.insurance);
        showCustomSnackbar(
          context,
          'Insurance deleted successfully!',
          type: SnackbarType.success,
        );
        context.pop();
        context.pop();
      },
      onTapBack: () => context.pop(),
    );
  }
}
