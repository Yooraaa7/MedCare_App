// Our Packages
import 'package:medcare_app/models/package.dart';

final List<Package> ourPackages = [
  Package(
    name: "DNA Decode Genetic Screening",
    imagePath: "package1.png",
    category: PackageCategories.healthScreening,
    subCategories: [
      'DNA Decode Fit',
      'DNA Decode Heritage',
      'DNA Decode Prevent',
    ],
  ),
  Package(
    name: "Health Screening Package",
    imagePath: "package2.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Cancer Markers for Women and Men",
    imagePath: "package3.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Diabetes Screening Package",
    imagePath: "package4.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Osteoporosis Screening Package",
    imagePath: "package5.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Pre-marital Screening Package",
    imagePath: "package6.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Apolipoprotein / Lipoprotein Studies",
    imagePath: "package7.png",
    category: PackageCategories.healthScreening,
  ),
];

/// For Children
final List<Package> childrenPackages = [
  Package(
    name: "Children's Screening Package",
    imagePath: "package8.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Weight Management Wellness Screening",
    imagePath: "package9.png",
    category: PackageCategories.healthScreening,
  ),
];

/// Psychological Wellness
final List<Package> wellnessPackages = [
  Package(
    name: "Proactive Lifestyle Screening",
    imagePath: "package10.png",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Cognitive Screening Test",
    imagePath: "package11.png",
    category: PackageCategories.healthScreening,
  ),
];
