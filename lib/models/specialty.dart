class Specialty {
  final String name;
  final String intro;
  final String imagePath;
  final List<SpecialtySection> sections;

  Specialty({
    required this.name,
    required this.intro,
    required this.imagePath,
    this.sections = const [],
  });

  String get fullImagePath => 'assets/images/specialties/$imagePath';

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      name: json['name'] as String,
      intro: json['intro'] as String,
      imagePath: json['imagePath'] as String,
      // Map the nested list of sections
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => SpecialtySection.fromJson(e as Map<String, dynamic>))
              .toList() ?? 
          const [],
    );
  }
}

class SpecialtySection {
  final String title;
  final String content;

  SpecialtySection({
    required this.title,
    required this.content,
  });

  factory SpecialtySection.fromJson(Map<String, dynamic> json) {
    return SpecialtySection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}