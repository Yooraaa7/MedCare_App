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
}