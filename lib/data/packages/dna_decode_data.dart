class DnaCategory {
  final String name;
  final int reportCount;
  final bool isApprox;

  const DnaCategory(
    this.name, 
    this.reportCount, 
    {this.isApprox = false}
  );
}

class DnaPackage {
  final String title;
  final String description;
  final String priceRange;
  final List<DnaCategory> categories;

  const DnaPackage({
    required this.title, 
    required this.description, 
    required this.priceRange, 
    required this.categories
  });

  // Total reports is calculated dynamically
  int get totalReports => categories.fold(0, (sum, cat) => sum + cat.reportCount);

  // Packages
  static final dnaFit = DnaPackage(
    title: "DNA DECODE FIT",
    description: "Learn how to work with your DNA to build a diet and fitness routine.",
    priceRange: "RM 800 - RM 1,200",
    categories: _fitGroup,
  );

  static final dnaHeritage = DnaPackage(
    title: "DNA DECODE HERITAGE",
    description: "Get screened for hereditary diseases that may affect your future.",
    priceRange:  "RM 1,300 - RM 1,700",
    // Includes Fit + Heritage specific categories
    categories: [..._fitGroup, ..._heritageGroup],
  );

  static final dnaPrevent = DnaPackage(
    title: "DNA DECODE PREVENT",
    description: "Helps you to understand and take control of your risk level of inherited cancers and disease.",
    priceRange:  "RM 2,200 - RM 2,800",
    // Includes everything: Fit + Heritage + Prevent specific categories
    categories: [..._fitGroup, ..._heritageGroup, ..._preventGroup],
  );
}

// Define them separately so the math is forced to be correct
const List<DnaCategory> _fitGroup = [
  DnaCategory("Allergies", 12),
  DnaCategory("Diet & Nutrition", 36),
  DnaCategory("Drug Response", 596, isApprox: true),
  DnaCategory("Lifestyle", 17),
  DnaCategory('Personality', 44),
  DnaCategory('Skin', 26),
  DnaCategory('Sports & Fitness', 16),
]; // Total: 747

const List<DnaCategory> _heritageGroup = [
  DnaCategory("Bone Health", 16),
  DnaCategory("Brain & Mental Health", 36),
  DnaCategory("Cancer", 44, isApprox: true),
  DnaCategory("Cancer-Causing Mutation", 13, isApprox: true),
  DnaCategory("Cardiovascular Diseases", 24),
  DnaCategory("Family Planning", 370),
  DnaCategory("Gastro-intestinal Health", 21),
  DnaCategory("Immune System", 22),
  DnaCategory("Infectious Disease", 26),
  DnaCategory("Metabolic Disease", 25),
  DnaCategory("Neurological Disease", 27),
  DnaCategory("Kidney Health", 3),
  DnaCategory("Reproductive Health", 7, isApprox: true),
  DnaCategory("Respiratory Health", 10),
  DnaCategory("Vision, Hearing & Oral Health", 24),
]; // Total: 654 (747 + 654 = 1401!)

const List<DnaCategory> _preventGroup = [
  DnaCategory("Genetic Blood Disorders", 41),
  DnaCategory("Hereditary Cancer", 44, isApprox: true),
  DnaCategory("Hereditary Cardiovascular Disease", 45),
  DnaCategory("Hereditary Endocrine Disease", 58, isApprox: true),
  DnaCategory("Hereditary Eye Conditions & Disease", 45),
  DnaCategory("Immune System Disorders", 47),
  DnaCategory("Hereditary Neurological Disorders", 63),
  DnaCategory("Hereditary Kidney Disease", 53),
  DnaCategory("Hereditary Skin Conditions", 27),
]; // Total: 423 (1401 + 423 = 1824!)