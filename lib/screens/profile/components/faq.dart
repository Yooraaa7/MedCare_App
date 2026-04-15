class FAQ {
  final String question;
  final String answer;

  const FAQ({
    required this.question,
    required this.answer,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['q'] as String,
      answer: json['a'] as String,
    );
  }
}
