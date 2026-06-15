enum PackageCategories {
  healthScreening,
  psychoWellness
}

class Package {
  final String name;
  final String imagePath;
  final PackageCategories category;
  final List<String>? subCategories;
  final String? group; // 'our', 'children', 'wellness' — from Firestore

  const Package({
    required this.name,
    required this.imagePath,
    required this.category,
    this.subCategories = const [],
    this.group,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      category: _categoryFromString(json['category'] as String? ?? 'healthScreening'),
      subCategories: json['subCategories'] != null
          ? List<String>.from(json['subCategories'])
          : [],
      group: json['group'] as String?,
    );
  }

  static PackageCategories _categoryFromString(String value) {
    switch (value) {
      case 'psychoWellness':
        return PackageCategories.psychoWellness;
      case 'healthScreening':
      default:
        return PackageCategories.healthScreening;
    }
  }

  String get location {
    switch (category) {
      case PackageCategories.healthScreening:
        return '7th Floor';
      case PackageCategories.psychoWellness:
        return '7th Floor (Room 19)';
    }
  }

  String get contact {
    switch (category) {
      case PackageCategories.healthScreening:
        return '+604-652 8681 / +604-652 8682';
      case PackageCategories.psychoWellness:
        return '+604-652 8997 / +604-652 8667';
    }
  }

  String get fullImagePath {
    return 'assets/images/packages/$imagePath';
  }
}