import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:medcare_app/data/packages/packages_data.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/package.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:uuid/v4.dart';

class DataService {
  static List<Specialty> allSpecialties = [];
  static List<Doctor> allDoctors = [];
  static List<Vaccine> allVaccines = [];
  static List<Package> allPackages = [];
  static List<Package> allChildrenPackages = [];
  static List<Package> allWellnessPackages = [];
  static List<BaseAppointment> allAppointments = [];
  static List<Reminder> allReminders = [
    Reminder(
      id: const UuidV4().generate(),
      type: ReminderType.medication,
      title: "Take ABC Medicine",
      frequency: 1,
      unit: UnitType.day,
      dateTime: [DateTime.now().copyWith(hour: 7, minute: 0)],
      duration: 1,
      notificationType: [NotificationLeadTime.fifteenMinutes],
      enabled: true,
    ),
    Reminder(
      id: const UuidV4().generate(),
      type: ReminderType.custom,
      title: "Annual Check-up",
      frequency: 1,
      unit: UnitType.year,
      dateTime: [DateTime(2026, 2, 14, 8, 0)],
      duration: 1,
      notificationType: [NotificationLeadTime.oneDay],
      enabled: false,
    ),
  ];
  static List<CardDetails> allCards = [
    CardDetails(cardNumber: "4111222233330000", expiry: "12/26", cardholderName: "JANE DOE", cvv: '123'),
    CardDetails(cardNumber: "5500111122224444", expiry: "10/28", cardholderName: "JOHN DOE", cvv: '123'),
  ];
  static List<InsuranceDetails> allInsurance = [
    InsuranceDetails(provider: "AIA Insurance", policy: "Policy #123456", expiry: "12/2027", logo: "aia.jpg", imagePaths: ["aia_front.png", "aia_back.png"]),
    InsuranceDetails(provider: "Allianz Insurance", policy: "Policy #987654", expiry: "11/2028", logo: "allianz.jpg", imagePaths: ["allianz_front.jpeg", "allianz_back.jpeg"]),
  ];

  // ── Helper: server first → cache fallback ────────────────────────────────
  static Future<QuerySnapshot<Map<String, dynamic>>> _fetchCollection(
      String collection) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 6));
  }

  // ── Specialties — always local JSON ──────────────────────────────────────
  static Future<void> initService() async {
    final String response = await rootBundle.loadString('assets/data/specialties.json');
    final List<dynamic> data = json.decode(response);
    allSpecialties = data.map((json) => Specialty.fromJson(json)).toList();
  }

  // ── Doctors — Firestore → cache → local JSON ──────────────────────────────
  static Future<void> initDoctor() async {
    bool loaded = false;
    try {
      final snapshot = await _fetchCollection('doctors');
      if (snapshot.docs.isNotEmpty) {
        allDoctors = snapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList();
        loaded = true;
        debugPrint('✅ Doctors loaded from Firestore: ${allDoctors.length}');
      }
    } catch (e) {
      debugPrint('❌ Firestore doctors failed: $e');
    }

    if (!loaded) {
      try {
        debugPrint('↩️ Doctors: falling back to local JSON...');
        final String response = await rootBundle.loadString('assets/data/doctors.json');
        final Map<String, dynamic> decodedData = json.decode(response);
        allDoctors = (decodedData['doctors'] as List<dynamic>)
            .map((json) => Doctor.fromJson(json)).toList();
        debugPrint('✅ Doctors loaded from local JSON: ${allDoctors.length}');
      } catch (e2) {
        debugPrint('❌ Local JSON also failed: $e2');
      }
    }

    if (allDoctors.isNotEmpty) {
      allAppointments = [
        SampleData.doctorAppointment,
        SampleData.doctorAppointment2,
        SampleData.packageAppointment,
        SampleData.vaccineAppointment,
        SampleData.vaccineAppointment2,
      ];
    } else {
      debugPrint('⚠️ Doctors empty — skipping sample appointments');
      allAppointments = [];
    }
  }

  // ── Vaccines — Firestore → cache → SampleData ─────────────────────────────
  static Future<void> initVaccines() async {
    try {
      final snapshot = await _fetchCollection('vaccines');
      if (snapshot.docs.isNotEmpty) {
        allVaccines = snapshot.docs.map((doc) => Vaccine.fromJson(doc.data())).toList();
        debugPrint('✅ Vaccines loaded from Firestore: ${allVaccines.length}');
        return;
      }
    } catch (e) {
      debugPrint('❌ Vaccines Firestore failed: $e');
    }
    debugPrint('↩️ Vaccines: falling back to SampleData...');
    allVaccines = List.from(SampleData.vaccines);
    debugPrint('✅ Vaccines loaded from SampleData: ${allVaccines.length}');
  }

  // ── Packages — Firestore → cache → local packages_data.dart ──────────────
  static Future<void> initPackages() async {
    try {
      final snapshot = await _fetchCollection('packages');
      if (snapshot.docs.isNotEmpty) {
        final all = snapshot.docs.map((doc) => Package.fromJson(doc.data())).toList();
        allPackages         = all.where((p) => p.group == 'our').toList();
        allChildrenPackages = all.where((p) => p.group == 'children').toList();
        allWellnessPackages = all.where((p) => p.group == 'wellness').toList();
        debugPrint('✅ Packages loaded from Firestore: ${all.length}');
        return;
      }
    } catch (e) {
      debugPrint('❌ Packages Firestore failed: $e');
    }
    debugPrint('↩️ Packages: falling back to local data...');
    allPackages         = List.from(ourPackages);
    allChildrenPackages = List.from(childrenPackages);
    allWellnessPackages = List.from(wellnessPackages);
    debugPrint('✅ Packages loaded from local data: ${allPackages.length + allChildrenPackages.length + allWellnessPackages.length}');
  }

  // ── Group doctors by specialty ────────────────────────────────────────────
  static Map<Specialty, List<Doctor>> getGroupedDoctors({String searchQuery = '', Specialty? specialtyFilter}) {
    final Map<Specialty, List<Doctor>> map = {};
    for (final specialty in DataService.allSpecialties) {
      if (specialtyFilter != null && specialty.name.toLowerCase() != specialtyFilter.name.toLowerCase()) continue;
      final doctorsInSpecialty = allDoctors.where((doc) {
        final matchesSpecialty = doc.specialty.name.toLowerCase() == specialty.name.toLowerCase();
        final matchesSearch = searchQuery.isEmpty || doc.nameEng.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesSpecialty && matchesSearch;
      }).toList();
      if (doctorsInSpecialty.isNotEmpty) map[specialty] = doctorsInSpecialty;
    }
    return map;
  }

  static List<BaseAppointment> getAppointmentsByStatus(AppointmentStatus status, {String order = 'desc'}) {
    final filtered = allAppointments.where((a) => a.status == status).toList();
    return filtered..sort((a, b) {
      if (a.paymentStatus == PaymentStatus.unpaid && b.paymentStatus == PaymentStatus.paid) return -1;
      if (a.paymentStatus == PaymentStatus.paid && b.paymentStatus == PaymentStatus.unpaid) return 1;
      return order == 'asc' ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
    });
  }

  static List<BaseAppointment> getActiveBookings({String order = 'asc'}) {
    const activeStatuses = [AppointmentStatus.upcoming, AppointmentStatus.registered];
    final List<BaseAppointment> activeList = allAppointments.where((a) => activeStatuses.contains(a.status)).toList();
    return activeList..sort((a, b) => order == 'asc' ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
  }

  static bool isSlotClashing(DateTime date, String timeSlot) {
    return allAppointments.any((a) =>
      a.date.year == date.year && a.date.month == date.month && a.date.day == date.day &&
      a.timeSlot == timeSlot && a.status != AppointmentStatus.cancelled);
  }

  static Vaccine? findVaccineById(String id) {
    final vaccines = allVaccines.isNotEmpty ? allVaccines : SampleData.vaccines;
    if (vaccines.isEmpty) return null;
    try { return vaccines.firstWhere((v) => v.id == id); } catch (_) { return null; }
  }
}