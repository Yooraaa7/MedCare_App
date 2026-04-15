import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/payment_methods/card_details.dart';
import 'package:medcare_app/models/payment_methods/insurance_details.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/models/specialty.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:uuid/v4.dart';

class DataService {
  // Global access point for data
  static List<Specialty> allSpecialties = [];
  static List<Doctor> allDoctors = [];
  static List<BaseAppointment> allAppointments = [
    SampleData.doctorAppointment,
    SampleData.doctorAppointment2,
    SampleData.packageAppointment,
    SampleData.vaccineAppointment,
  ];
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
    CardDetails(
      cardNumber: "4111222233330000",
      expiry: "12/26",
      cardholderName: "JANE DOE",
      cvv: '123',
    ),
    CardDetails(
      cardNumber: "5500111122224444",
      expiry: "10/28",
      cardholderName: "JOHN DOE",
      cvv: '123',
    ),
  ];
  static List<InsuranceDetails> allInsurance = [
    InsuranceDetails(
      provider: "AIA Insurance",
      policy: "Policy #123456",
      expiry: "12/2027",
      logo: "aia.jpg",
      imagePaths: ["aia_front.png", "aia_back.png"],
    ),
    InsuranceDetails(
      provider: "Allianz Insurance",
      policy: "Policy #987654",
      expiry: "11/2028",
      logo: "allianz.jpg",
      imagePaths: ["allianz_front.jpeg", "allianz_back.jpeg"],
    ),
  ];

  static Future<void> initService() async {
    final String response = await rootBundle.loadString(
      'assets/data/specialties.json',
    );
    final List<dynamic> data = json.decode(response);
    allSpecialties = data.map((json) => Specialty.fromJson(json)).toList();
  }

  static Future<void> initDoctor() async {
    final String response = await rootBundle.loadString(
      'assets/data/doctors.json',
    );

    // 1. Decode the string into a Map
    final Map<String, dynamic> decodedData = json.decode(response);

    // 2. Access the list inside the "doctors" key
    final List<dynamic> doctorList = decodedData['doctors'];

    // 3. Map the list to Doctor objects
    allDoctors = doctorList.map((json) => Doctor.fromJson(json)).toList();
  }

  // Group doctors based on their specialty
  static Map<Specialty, List<Doctor>> getGroupedDoctors({
    String searchQuery = '',
    Specialty? specialtyFilter,
  }) {
    final Map<Specialty, List<Doctor>> map = {};

    for (final specialty in DataService.allSpecialties) {
      // If a specialty filter exists, skip others
      if (specialtyFilter != null &&
          specialty.name.toLowerCase() != specialtyFilter.name.toLowerCase()) {
        continue;
      }

      final doctorsInSpecialty = allDoctors.where((doc) {
        final matchesSpecialty =
            doc.specialty.name.toLowerCase() == specialty.name.toLowerCase();

        final matchesSearch =
            searchQuery.isEmpty ||
            doc.nameEng.toLowerCase().contains(searchQuery.toLowerCase());

        return matchesSpecialty && matchesSearch;
      }).toList();

      // If no doctors match, don't put the specialty inside
      if (doctorsInSpecialty.isNotEmpty) {
        map[specialty] = doctorsInSpecialty;
      }
    }

    return map;
  }

  static List<BaseAppointment> getAppointmentsByStatus(
    AppointmentStatus status, {
    String order = 'desc',
  }) {
    final filtered = allAppointments.where((a) => a.status == status).toList();

    return filtered..sort((a, b) {
      // 1. Primary Sort: Payment Status (Unpaid first)
      // If 'a' is unpaid and 'b' is paid, 'a' should come first (-1)
      if (a.paymentStatus == PaymentStatus.unpaid &&
          b.paymentStatus == PaymentStatus.paid) {
        return -1;
      }
      if (a.paymentStatus == PaymentStatus.paid &&
          b.paymentStatus == PaymentStatus.unpaid) {
        return 1;
      }

      // 2. Secondary Sort: Date (based on 'order' parameter)
      if (order == 'asc') {
        return a.date.compareTo(b.date);
      } else {
        return b.date.compareTo(a.date);
      }
    });
  }

  static List<BaseAppointment> getActiveBookings({String order = 'asc'}) {
    // Define which statuses count as "Active"
    const activeStatuses = [
      AppointmentStatus.upcoming,
      AppointmentStatus.registered,
    ];

    // Filter the master list
    final List<BaseAppointment> activeList = allAppointments
        .where((a) => activeStatuses.contains(a.status))
        .toList();

    // Sort the combined result so dates aren't jumbled
    return activeList..sort(
      (a, b) =>
          order == 'asc' ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
  }

  static bool isSlotClashing(DateTime date, String timeSlot) {
    return allAppointments.any(
      (appointment) =>
          // Check if the date is the same (ignoring time hours/minutes of the DateTime object)
          appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day &&
          // Check if the string time slot is identical
          appointment.timeSlot == timeSlot &&
          // Only clash with active bookings, not canceled ones
          appointment.status != AppointmentStatus.cancelled,
    );
  }

  static Vaccine? findVaccineById(String id) {
    if (SampleData.vaccines.isNotEmpty) {
      return SampleData.vaccines.firstWhere((v) => v.id == id);
    } else {
      return null;
    }
  }
}
