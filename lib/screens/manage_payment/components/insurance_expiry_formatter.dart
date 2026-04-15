import 'package:flutter/services.dart';

class InsuranceExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 4 digits (MMYY)
    if (digitsOnly.length > 6) {
      return oldValue;
    }

    String formatted;

    if (digitsOnly.length <= 2) {
      // MM
      formatted = digitsOnly;
    } else {
      // MM / YY
      formatted =
          '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
