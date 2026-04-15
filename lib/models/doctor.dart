import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/models/workday.dart';

var specialties = DataService.allSpecialties;

class Doctor {
  final String imagePath;
  final String nameEng;
  final String nameChinese;
  final Specialty specialty;
  final String title;
  final String qualification;
  final String location;
  final String contact;
  final List<String> languages;
  final List<WorkDay>? weeklySchedule;
  final List<String>? holidayClosures;
  final bool isBookable;
  final bool isPrimary;
  final String? remarks;

  const Doctor({
    required this.imagePath,
    required this.nameEng,
    required this.nameChinese,
    required this.specialty,
    required this.title,
    required this.qualification,
    required this.location,
    required this.contact,
    required this.languages,
    this.weeklySchedule,
    this.holidayClosures,
    this.remarks,
    this.isBookable = true,
    this.isPrimary = false,
  });

  String get fullImagePath => 'assets/images/doctors/$imagePath';

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
      imagePath: map['imagePath'] ?? '',
      nameEng: map['nameEng'] ?? '',
      nameChinese: map['nameChinese'] ?? '',
      specialty: specialties.firstWhere((s) => s.name == map['specialty']),
      title: map['title'] ?? '',
      qualification: map['qualification'] ?? '',
      location: map['location'] ?? '',
      contact: map['contact'] ?? '',
      languages: List<String>.from(map['languages'] ?? []),
      holidayClosures: map['holidayClosures'] != null
          ? List<String>.from(map['holidayClosures'])
          : null,
      isBookable: map['isBookable'] ?? true,
      isPrimary: map['isPrimary'] ?? false,
      weeklySchedule: (map['weeklySchedule'] as List<dynamic>?)
          ?.map((x) => WorkDay.fromJson(x as Map<String, dynamic>))
          .toList(),
      remarks: map['remarks'] ?? '',
    );
  }
}
