class TermItem {
  final int? number;
  final String text;

  const TermItem({
    this.number,
    required this.text,
  });

  factory TermItem.fromJson(Map<String, dynamic> json) {
    return TermItem(
      number: json['number'],
      text: json['text'] as String,
    );
  }
}
