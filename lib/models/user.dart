class User {
  final String mrNo;
  final String? icNo;
  String name;
  final String? passport;
  final String password;
  String phone;
  String email;
  final bool isForeign;
  double totalPayable;

  User({
    required this.mrNo,
    required this.name,
    required this.phone,
    required this.password,
    required this.email,
    required this.isForeign,
    this.icNo,
    this.passport,
    this.totalPayable = 0
  }) : assert(
          (isForeign && passport != null) || (!isForeign && icNo != null),
          'Foreigners must have a passport, locals must have an IC.',
        );

  // Helper to get the primary ID string
  String get identification => isForeign ? passport! : icNo!;
  
  // Helper to get ID Label
  String get idLabel => isForeign ? "Passport" : "IC Number";
}