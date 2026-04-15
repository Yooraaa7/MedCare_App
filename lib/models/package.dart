enum PackageCategories {
  healthScreening,
  psychoWellness
}

class Package {
  final String name;
  final String imagePath;
  final PackageCategories category;
  final List<String>? subCategories;
  
  const Package({
    required this.name,
    required this.imagePath,
    required this.category,
    this.subCategories = const [],
  });

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

  String get fullImagePath{
    return 'assets/images/packages/$imagePath';
  }
}