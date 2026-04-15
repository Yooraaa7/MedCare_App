import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/components/custom_text_field.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/validators.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/screens/manage_payment/components/insurance_expiry_formatter.dart';

class InputInsuranceScreen extends StatefulWidget {
  const InputInsuranceScreen({super.key});

  @override
  State<InputInsuranceScreen> createState() => _InputInsuranceScreenState();
}

class _InputInsuranceScreenState extends State<InputInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _provider;
  String? _policy;
  String? _expiry;

  void _saveInsurance() {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    DataService.allInsurance.add(
      InsuranceDetails(
        provider: _provider!,
        policy: _policy!,
        expiry: _expiry!,
        logo: 'aia.jpg',
        imagePaths: const ['aia_front.png', 'aia_back.png'],
      ),
    );

    showCustomSnackbar(
      context,
      'Insurance linked successfully!',
      type: SnackbarType.success,
    );

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Add Insurance'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Insurance Details',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  /// Provider
                  CustomTextField(
                    label: 'Provider',
                    hintText: 'Enter provider',
                    prefixIcon: const Icon(
                      Icons.business,
                      color: AppColors.strongRed,
                    ),
                    validator: Validators.name('Provider'),
                    onSaved: (value) => _provider = value,
                  ),

                  const SizedBox(height: 20),

                  /// Policy Number
                  CustomTextField(
                    label: 'Policy number',
                    hintText: 'Enter policy number',
                    prefixIcon: const Icon(
                      Icons.confirmation_number,
                      color: AppColors.strongRed,
                    ),
                    validator: Validators.validatePolicyNumber(),
                    onSaved: (value) => _policy = value,
                  ),

                  const SizedBox(height: 20),

                  /// Expiry Date
                  CustomTextField(
                    label: 'Expiry date (MM / YYYY)',
                    hintText: 'Enter expiry date',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                      InsuranceExpiryFormatter(),
                    ],
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: AppColors.strongRed,
                    ),
                    validator: Validators.validateInsuranceExpiry(),
                    onSaved: (value) => _expiry = value,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _saveInsurance,
                    child: const Text('Save Insurance'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
