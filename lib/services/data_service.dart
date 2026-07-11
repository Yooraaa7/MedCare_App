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

  static List<Reminder> allReminders = [];

  /// Tracks which patient's local reminder list
  /// is currently loaded.
  static String? _configuredUserId;

  static List<Reminder>
      _buildDemoReminders() {
    return [
      Reminder(
        id: const UuidV4().generate(),
        type: ReminderType.medication,
        title: 'Take ABC Medicine',
        frequency: 1,
        unit: UnitType.day,
        dateTime: [
          DateTime.now().copyWith(
            hour: 7,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          ),
        ],
        duration: 1,
        notificationType: [
          NotificationLeadTime
              .fifteenMinutes,
        ],
        enabled: true,
      ),
      Reminder(
        id: const UuidV4().generate(),
        type: ReminderType.custom,
        title: 'Annual Check-up',
        frequency: 1,
        unit: UnitType.year,
        dateTime: [
          DateTime(
            2026,
            12,
            14,
            8,
            0,
          ),
        ],
        duration: 1,
        notificationType: [
          NotificationLeadTime.oneDay,
        ],
        enabled: false,
      ),
    ];
  }

  /// Loads sample reminders only for the
  /// fixed demo account.
  ///
  /// The method does not recreate reminders
  /// when the same user opens the reminder
  /// screen again.
  static void configureUserScopedData({
    required bool isDemoUser,
    String? userId,
    bool force = false,
  }) {
    if (!force &&
        _configuredUserId == userId) {
      return;
    }

    _configuredUserId = userId;

    allReminders = isDemoUser
        ? _buildDemoReminders()
        : <Reminder>[];

    debugPrint(
      'User-scoped reminder data configured: '
      'user=$userId, '
      'demo=$isDemoUser, '
      'count=${allReminders.length}',
    );
  }

  static void clearUserScopedData() {
    _configuredUserId = null;
    allReminders = <Reminder>[];

    debugPrint(
      'User-scoped reminder data cleared.',
    );
  }

  static List<CardDetails> allCards = [
    CardDetails(
      cardNumber: '4111222233330000',
      expiry: '12/26',
      cardholderName: 'JANE DOE',
      cvv: '123',
    ),
    CardDetails(
      cardNumber: '5500111122224444',
      expiry: '10/28',
      cardholderName: 'JOHN DOE',
      cvv: '123',
    ),
  ];

  static List<InsuranceDetails>
      allInsurance = [
    InsuranceDetails(
      provider: 'AIA Insurance',
      policy: 'Policy #123456',
      expiry: '12/2027',
      logo: 'aia.jpg',
      imagePaths: [
        'aia_front.png',
        'aia_back.png',
      ],
    ),
    InsuranceDetails(
      provider: 'Allianz Insurance',
      policy: 'Policy #987654',
      expiry: '11/2028',
      logo: 'allianz.jpg',
      imagePaths: [
        'allianz_front.jpeg',
        'allianz_back.jpeg',
      ],
    ),
  ];

  static Future<
          QuerySnapshot<Map<String, dynamic>>>
      _fetchCollection(
    String collection,
  ) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .get(
          const GetOptions(
            source: Source.server,
          ),
        )
        .timeout(
          const Duration(seconds: 20),
        );
  }

  static Future<void>
      initService() async {
    final String response =
        await rootBundle.loadString(
      'assets/data/specialties.json',
    );

    final List<dynamic> data =
        json.decode(response);

    allSpecialties = data
        .map(
          (item) =>
              Specialty.fromJson(item),
        )
        .toList();
  }

  static Future<void>
      initDoctor() async {
    bool loaded = false;

    try {
      final snapshot =
          await _fetchCollection(
        'doctors',
      );

      if (snapshot.docs.isNotEmpty) {
        allDoctors = snapshot.docs
            .where(
              (document) =>
                  document.data()['active'] !=
                  false,
            )
            .map(
              (document) => Doctor.fromJson(
                document.data(),
                id: document.id,
              ),
            )
            .toList();

        loaded = true;

        debugPrint(
          'Doctors loaded from Firestore: '
          '${allDoctors.length}',
        );
      }
    } catch (error) {
      debugPrint(
        'Firestore doctors failed: $error',
      );
    }

    if (!loaded) {
      try {
        debugPrint(
          'Doctors falling back '
          'to local JSON.',
        );

        final String response =
            await rootBundle.loadString(
          'assets/data/doctors.json',
        );

        final Map<String, dynamic>
            decodedData =
            json.decode(response);

        allDoctors =
            (decodedData['doctors']
                    as List<dynamic>)
                .map(
                  (item) =>
                      Doctor.fromJson(item),
                )
                .toList();

        debugPrint(
          'Doctors loaded from local JSON: '
          '${allDoctors.length}',
        );
      } catch (error) {
        debugPrint(
          'Local doctor JSON failed: $error',
        );
      }
    }

    allAppointments = [];
  }

  static Stream<List<Doctor>>
      watchDoctors() {
    return FirebaseFirestore.instance
        .collection('doctors')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .where(
                (document) =>
                    document.data()['active'] !=
                    false,
              )
              .map(
                (document) => Doctor.fromJson(
                  document.data(),
                  id: document.id,
                ),
              )
              .toList(),
        );
  }

  static Future<void>
      initVaccines() async {
    try {
      final snapshot =
          await _fetchCollection(
        'vaccines',
      );

      if (snapshot.docs.isNotEmpty) {
        allVaccines = snapshot.docs
            .map(
              (document) =>
                  Vaccine.fromJson(
                document.data(),
              ),
            )
            .toList();

        debugPrint(
          'Vaccines loaded from Firestore: '
          '${allVaccines.length}',
        );

        return;
      }
    } catch (error) {
      debugPrint(
        'Vaccines Firestore failed: $error',
      );
    }

    allVaccines = List<Vaccine>.from(
      SampleData.vaccines,
    );

    debugPrint(
      'Vaccines loaded from SampleData: '
      '${allVaccines.length}',
    );
  }

  static Future<void>
      initPackages() async {
    try {
      final snapshot =
          await _fetchCollection(
        'packages',
      );

      if (snapshot.docs.isNotEmpty) {
        final List<Package> all =
            snapshot.docs
                .map(
                  (document) =>
                      Package.fromJson(
                    document.data(),
                  ),
                )
                .toList();

        allPackages = all
            .where(
              (package) =>
                  package.group == 'our',
            )
            .toList();

        allChildrenPackages = all
            .where(
              (package) =>
                  package.group == 'children',
            )
            .toList();

        allWellnessPackages = all
            .where(
              (package) =>
                  package.group == 'wellness',
            )
            .toList();

        debugPrint(
          'Packages loaded from Firestore: '
          '${all.length}',
        );

        return;
      }
    } catch (error) {
      debugPrint(
        'Packages Firestore failed: $error',
      );
    }

    allPackages = List<Package>.from(
      ourPackages,
    );

    allChildrenPackages =
        List<Package>.from(
      childrenPackages,
    );

    allWellnessPackages =
        List<Package>.from(
      wellnessPackages,
    );

    debugPrint(
      'Packages loaded from local data.',
    );
  }

  static Map<Specialty, List<Doctor>>
      getGroupedDoctors({
    String searchQuery = '',
    Specialty? specialtyFilter,
  }) {
    final Map<Specialty, List<Doctor>>
        result = {};

    for (final Specialty specialty
        in allSpecialties) {
      if (specialtyFilter != null &&
          specialty.name.toLowerCase() !=
              specialtyFilter.name
                  .toLowerCase()) {
        continue;
      }

      final List<Doctor> doctors =
          allDoctors.where(
        (doctor) {
          final bool matchesSpecialty =
              doctor.specialty.name
                      .toLowerCase() ==
                  specialty.name
                      .toLowerCase();

          final bool matchesSearch =
              searchQuery.trim().isEmpty ||
                  doctor.nameEng
                      .toLowerCase()
                      .contains(
                        searchQuery
                            .toLowerCase(),
                      );

          return matchesSpecialty &&
              matchesSearch;
        },
      ).toList();

      if (doctors.isNotEmpty) {
        result[specialty] = doctors;
      }
    }

    return result;
  }

  static List<BaseAppointment>
      getAppointmentsByStatus(
    AppointmentStatus status, {
    String order = 'desc',
  }) {
    final List<BaseAppointment> filtered =
        allAppointments
            .where(
              (appointment) =>
                  appointment.status ==
                  status,
            )
            .toList();

    filtered.sort(
      (
        BaseAppointment first,
        BaseAppointment second,
      ) {
        if (first.paymentStatus ==
                PaymentStatus.unpaid &&
            second.paymentStatus ==
                PaymentStatus.paid) {
          return -1;
        }

        if (first.paymentStatus ==
                PaymentStatus.paid &&
            second.paymentStatus ==
                PaymentStatus.unpaid) {
          return 1;
        }

        return order == 'asc'
            ? first.date.compareTo(
                second.date,
              )
            : second.date.compareTo(
                first.date,
              );
      },
    );

    return filtered;
  }

  static List<BaseAppointment>
      getActiveBookings({
    String order = 'asc',
  }) {
    const List<AppointmentStatus>
        activeStatuses = [
      AppointmentStatus.upcoming,
      AppointmentStatus.registered,
    ];

    final List<BaseAppointment> activeList =
        allAppointments
            .where(
              (appointment) =>
                  activeStatuses.contains(
                appointment.status,
              ),
            )
            .toList();

    activeList.sort(
      (
        BaseAppointment first,
        BaseAppointment second,
      ) =>
          order == 'asc'
              ? first.date.compareTo(
                  second.date,
                )
              : second.date.compareTo(
                  first.date,
                ),
    );

    return activeList;
  }

  static bool isSlotClashing(
    DateTime date,
    String timeSlot,
  ) {
    return allAppointments.any(
      (appointment) =>
          appointment.date.year ==
              date.year &&
          appointment.date.month ==
              date.month &&
          appointment.date.day ==
              date.day &&
          appointment.timeSlot ==
              timeSlot &&
          appointment.status !=
              AppointmentStatus.cancelled,
    );
  }

  static Vaccine? findVaccineById(
    String id,
  ) {
    final List<Vaccine> vaccines =
        allVaccines.isNotEmpty
            ? allVaccines
            : SampleData.vaccines;

    if (vaccines.isEmpty) {
      return null;
    }

    try {
      return vaccines.firstWhere(
        (vaccine) =>
            vaccine.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}