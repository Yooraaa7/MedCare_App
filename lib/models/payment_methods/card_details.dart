class CardDetails {
  final String cardNumber;
  final String expiry;
  final String cvv;
  final String cardholderName;
  bool saveCard;
  bool isDefault;

  CardDetails({
    required this.cardNumber,
    required this.expiry,
    required this.cardholderName,
    required this.cvv,
    this.saveCard = true,
    this.isDefault = false
  });

  // Helper to get formatted last 4 digits (e.g., •••• 4444)
  String get maskedNumber {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), ''); // remove spaces
    final last4 = cleanNumber.length >= 4 
        ? cleanNumber.substring(cleanNumber.length - 4) 
        : "0000";
    return "•••• $last4";
  }

  // Inside your CardDetails class
  String get formattedExpiry {
    if (expiry.isEmpty || !expiry.contains('/')) return expiry;

    final parts = expiry.split('/');
    final month = parts[0].trim();
    final year = parts[1].trim();

    // Returns "MM / 20YY"
    return "$month / 20$year";
  }

  // Helper to get card type 
  String get cardType {
    // Remove spaces or dashes the user might have entered
    String cleanNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.isEmpty) return "Unknown";

    // Define regex patterns for major card brands
    final Map<String, RegExp> patterns = {
      "Visa":       RegExp(r'^4'),
      "Mastercard": RegExp(r'^5[1-5]|^2[2-7]'),
      "American Express": RegExp(r'^3[47]'),
      "Discover":   RegExp(r'^6(?:011|5)'),
      "JCB":        RegExp(r'^(?:2131|1800|35)'),
    };

    for (var entry in patterns.entries) {
      if (entry.value.hasMatch(cleanNumber)) {
        return entry.key;
      }
    }

    return "Unknown";
}

}