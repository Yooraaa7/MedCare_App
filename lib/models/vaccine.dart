class Vaccine {
  final String id;
  final String name;
  final String details;
  final String location;
  final String contact;

  Vaccine({
    required this.id,
    required this.name,
    required this.details,
    this.location = 'A & E department',
    this.contact = '+604-652 8757',
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'] as String,
      name: json['name'] as String,
      details: json['details'] as String,
      location: json['location'] as String? ?? 'A & E department',
      contact: json['contact'] as String? ?? '+604-652 8757',
    );
  }
}