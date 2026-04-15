import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/general/components/custom_error_text.dart';
import 'package:medcare_app/general/components/custom_snackbar.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/screens/book_appointments/components/guarantee_letter_upload.dart';
import 'package:medcare_app/screens/book_appointments/components/insurance_picker.dart';

class PaymentMethodSection extends StatefulWidget {
  final ValueChanged<
    (PaymentMethod method, File? file, InsuranceDetails? insurance)
  >?
  onDataChanged;

  final PaymentMethod? initialMethod;
  final File? initialGuaranteeLetter;
  final InsuranceDetails? initialInsurance;
  final bool hasError;

  const PaymentMethodSection({
    super.key,
    this.onDataChanged,
    this.initialMethod,
    this.initialGuaranteeLetter,
    this.initialInsurance,
    this.hasError = false,
  });

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  PaymentMethod? _selected;
  File? _uploadedFile;
  InsuranceDetails? _selectedInsurance;
  InsuranceDetails? defaultInsurance;

  bool get _requiresDocument =>
      _selected == PaymentMethod.insurance ||
      _selected == PaymentMethod.corporate;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialMethod ?? PaymentMethod.selfPay;
    _uploadedFile = widget.initialGuaranteeLetter;

    // Initialize Insurance Defaults
    if (DataService.allInsurance.isNotEmpty) {
      defaultInsurance =
          widget.initialInsurance ??
          DataService.allInsurance.firstWhere(
            (i) => i.isDefault,
            orElse: () => DataService.allInsurance.first,
          );

      // Only set selected if the current method is insurance
      _selectedInsurance = (_selected == PaymentMethod.insurance)
          ? defaultInsurance
          : null;
    }

    // Initial notification to parent to sync state
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  // Centralized method to bubble up state changes to the parent
  void _notifyParent() {
    if (_selected != null) {
      widget.onDataChanged?.call((
        _selected!,
        _uploadedFile,
        _selectedInsurance,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.medium,

        RadioGroup<PaymentMethod>(
          groupValue: _selected,
          onChanged: (value) {
            setState(() {
              _selected = value!;

              if (_selected == PaymentMethod.insurance) {
                // Reset to default card when switching back to insurance
                _selectedInsurance = defaultInsurance;
              } else {
                // Ensure insurance is null for Self-Pay and Corporate
                _selectedInsurance = null;

                // Clear file specifically for Self-Pay
                if (_selected == PaymentMethod.selfPay) {
                  _uploadedFile = null;
                }
              }
            });
            _notifyParent();
          },
          child: Column(
            children: [
              RadioListTile(
                value: PaymentMethod.selfPay,
                title: const Text('Self-Pay'),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              RadioListTile(
                value: PaymentMethod.insurance,
                title: const Text('Insurance'),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),

              // Insurance Selector Sub-Section
              if (_selected == PaymentMethod.insurance) ...[
                InsuranceSelector(
                  options: DataService.allInsurance,
                  selectedValue: _selectedInsurance,
                  onChanged: (val) {
                    setState(() => _selectedInsurance = val);
                    _notifyParent();
                  },
                  onAddTap: () =>
                      context.push('/profile/manage-payment/input-insurance'),
                ),
                AppSpacing.small,
                customErrorText(
                  widget.hasError,
                  'Insurance selection is required.',
                ),
              ],

              RadioListTile(
                value: PaymentMethod.corporate,
                title: const Text('Corporate'),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),

        // Document Upload Section
        if (_requiresDocument) ...[
          AppSpacing.xlarge,
          GuaranteeLetterUpload(
            uploadedFile: _uploadedFile,
            onPickFile: _pickPdf,
            onRemoveFile: () {
              _uploadedFile = null;
              _notifyParent();
            },
          ),
          AppSpacing.small,
        ],
      ],
    );
  }

  void _pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _uploadedFile = File(result.files.single.path!);
        });
        _notifyParent();
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(
          context,
          "Error picking file: $e",
          type: SnackbarType.error,
        );
      }
    }
  }
}
