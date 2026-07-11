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

  // Patient-specific fields
  final bool isDemoUser;
  final String? primaryDoctorId;

  User({
    required this.mrNo,
    required this.name,
    required this.phone,
    required this.password,
    required this.email,
    required this.isForeign,
    this.icNo,
    this.passport,
    this.totalPayable = 0,
    this.isDemoUser = false,
    this.primaryDoctorId,
  }) : assert(
          (isForeign && passport != null) ||
              (!isForeign && icNo != null),
          'Foreigners must have a passport, locals must have an IC.',
        );

  String get identification {
    if (isForeign) {
      return passport ?? '';
    }

    return icNo ?? '';
  }

  String get idLabel {
    return isForeign ? 'Passport' : 'IC Number';
  }

  bool get hasPrimaryDoctor {
    return primaryDoctorId != null &&
        primaryDoctorId!.trim().isNotEmpty;
  }
}