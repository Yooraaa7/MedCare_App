class InsuranceDetails {
  String provider;
  String policy;
  String expiry;
  String logo;
  List<String> imagePaths;
  bool isDefault;

  InsuranceDetails({
    required this.provider,
    required this.policy,
    required this.expiry,
    required this.logo,
    this.imagePaths = const [],
    this.isDefault = false
  });

  String get logoPath => 
    'assets/images/insurance/$logo';

  List<String> get fullImagePath => 
    imagePaths.map((img) => 'assets/images/insurance/$img').toList();
}