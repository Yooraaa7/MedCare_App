// Our Packages
import 'package:medcare_app/models/package.dart';

final List<Package> ourPackages = [
  Package(
    name: "DNA Decode Genetic Screening",
    imagePath: "dna_package.jpg",
    category: PackageCategories.healthScreening,
    subCategories: [
      'DNA Decode Fit',
      'DNA Decode Heritage',
      'DNA Decode Prevent',
    ],
  ),
  Package(
    name: "Health Screening Package",
    imagePath: "hsc.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Cancer Markers for Women and Men",
    imagePath: "cancer.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Diabetes Screening Package",
    imagePath: "diabetes.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Osteoporosis Screening Package",
    imagePath: "osteo.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Pre-marital Screening Package",
    imagePath: "premarital.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Apolipoprotein / Lipoprotein Studies",
    imagePath: "apolipoprotein.jpg",
    category: PackageCategories.healthScreening,
  ),
];

/// For Children
final List<Package> childrenPackages = [
  Package(
    name: "Children's Screening Package",
    imagePath: "children.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Weight Management Wellness Screening",
    imagePath: "weight.jpg",
    category: PackageCategories.healthScreening,
  ),
];

/// Psychological Wellness
final List<Package> wellnessPackages = [
  Package(
    name: "Proactive Lifestyle Screening",
    imagePath: "proactive.jpg",
    category: PackageCategories.healthScreening,
  ),
  Package(
    name: "Cognitive Screening Test",
    imagePath: "cognitive.jpg",
    category: PackageCategories.healthScreening,
  ),
];
