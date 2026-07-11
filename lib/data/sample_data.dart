// TODO: Replace Sample data
import 'dart:io';

import 'package:medcare_app/data/packages/packages_data.dart';
import 'package:medcare_app/models/bill_item.dart';
import 'package:medcare_app/models/notifications.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/doctor.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/models/vaccine.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

var specialties = DataService.allSpecialties;
var doctors = DataService.allDoctors;
Doctor drTan = doctors.first;

class SampleData {
  // TODO: Replace with real data, format ic/passport and contact
  static User sampleUser = User(
    password: '123456',
    mrNo: '00123456',
    icNo: '061031-00-0000',
    name: 'Felix',
    phone: '0123456789',
    email: 'felix@gmail.com',
    isForeign: false,
    totalPayable:
        DataService.getAppointmentsByStatus(AppointmentStatus.completed)
            .where((appt) => appt.paymentStatus == PaymentStatus.unpaid)
            .fold(0.0, (sum, appt) => sum + (appt.fee ?? 0)),
  );

  static var billItems = [
    BillItem(
      description: 'Consultation fee',
      amount: 120,
      relatedAppointment: doctorAppointment2,
    ),
    BillItem(
      description: 'Medication (ABC tablets)',
      amount: 80,
      relatedAppointment: doctorAppointment2,
    ),
    BillItem(
      description: 'Hepatitis B Vaccine',
      amount: 115,
      relatedAppointment: vaccineAppointment2,
    ),
  ];

  static var vaccines = [
    Vaccine(
      id: Uuid().v4(),
      name: 'Chicken Pox',
      details:
          'Protects against varicella virus. Recommended for children and adults without prior infection.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Dengue',
      details:
          'Live attenuated vaccine for dengue virus. Recommended in endemic areas, especially for children.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Hepatitis A - Adult (19 years and above)',
      details:
          'Prevents liver infection caused by hepatitis A virus. Two doses 6 months apart for adults.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Hepatitis B - Adult (20 years and above)',
      details:
          'Protects against hepatitis B virus. Three doses over 6 months. Essential for healthcare workers.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Human Papilloma Virus',
      details:
          'Guards against HPV-related cancers. Most effective before sexual activity. Recommended for ages 9–45.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Influenza',
      details:
          'Seasonal flu vaccine. Updated yearly. Recommended for everyone over 6 months of age.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Japanese Encephalitis',
      details:
          'Prevents mosquito-borne brain infection. Two doses, 28 days apart. Important for travelers to Asia.',
    ),
    Vaccine(
      id: Uuid().v4(),
      name: 'Measles, Mumps, Rubella',
      details:
          'MMR vaccine offers lifelong protection. Two doses recommended in childhood. Prevents viral outbreaks.',
    ),
  ];

  static List<AppNotification> sampleNotifications = [
    // 1. URGENT LATE BILL (Generated to be 21 days old)
    AppNotification(
      id: 'bill_001',
      category: NotificationCategory.billing,
      subjectName: 'Dr. Tan Hau Tong',
      timestamp: DateTime.now().subtract(const Duration(days: 21)),
      isRead: false,
    ),

    // 2. QUEUE ALERT (Very recent)
    AppNotification(
      id: 'queue_102',
      category: NotificationCategory.queue,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),

    // 3. MEDICAL REPORT (Today)
    AppNotification(
      id: 'report_55',
      category: NotificationCategory.reports,
      customMessage:
          "Your Annual Blood Screening results are ready. Tap to download PDF.",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),

    // 4. APPOINTMENT UPDATE (Yesterday)
    AppNotification(
      id: 'app_789',
      category: NotificationCategory.appointment,
      subjectName: 'Dr. Tan Hau Tong',
      customMessage:
          'Your appointment with Dr. Tan Hau Tong had been moved to 26th February, Thursday.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),

    // 5. MEDICATION REMINDER (Yesterday)
    AppNotification(
      id: 'med_22',
      category: NotificationCategory.medication,
      subjectName: 'ABC Medicine',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),

    // 6. NEW BILL (Today - should NOT show as late)
    AppNotification(
      id: 'bill_002',
      category: NotificationCategory.billing,
      subjectName: 'Dr. Ali',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),

    // 7. GENERAL INFO
    AppNotification(
      id: 'gen_01',
      category: NotificationCategory.general,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),

    // 8. CUSTOM REMINDER
    AppNotification(
      id: 'cust_01',
      category: NotificationCategory.custom,
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
      subjectName: 'Exercise',
      isRead: true,
    ),
  ];

  static final doctorAppointment = DoctorAppointment(
    id: const Uuid().v4(),
    date: DateTime(2026, 2, 14),
    timeSlot: "11:00 AM - 12:00 PM",
    location: drTan.location,
    contact: drTan.contact,
    doctor: drTan,
    paymentMethod: PaymentMethod.insurance,
    insurance: DataService.allInsurance.first,
    reasonOfVisit: "Annual Checkup",

    // Handling Optional Files
    guaranteeLetter: File('/dummy/gl_document.pdf'),
  );

  static final doctorAppointment2 = DoctorAppointment(
    id: const Uuid().v4(),
    date: DateTime(2026, 1, 24),
    timeSlot: "11:00 AM - 12:00 PM",
    location: drTan.location,
    contact: drTan.contact,
    doctor: drTan, // Passing the object we created above
    paymentMethod: PaymentMethod.insurance,
    insurance: DataService.allInsurance.first,
    status: AppointmentStatus.completed,
    reasonOfVisit: "Hypertension",
    fee: 200,
    billing: [File(r'assets/sample/invoice.pdf')],

    // Handling Optional Files
    guaranteeLetter: File('/dummy/gl_document.pdf'),

    reports: [File('/dummy/blood_test.pdf')],
    doctorComments: ['Reduce salt intake', 'Avoid smoking'],
    prescriptions: [
      Reminder(
        id: const UuidV4().generate(),
        type: ReminderType.medication,
        title: 'Take Nifedipine',
        frequency: 1,
        duration: 2,
        unit: UnitType.day,
        dateTime: [DateTime(2025, 1, 13, 12), DateTime(2025, 1, 14, 12)],
      ),
      Reminder(
        id: const UuidV4().generate(),
        type: ReminderType.medication,
        title: 'Take Metformin',
        frequency: 2,
        duration: 2,
        unit: UnitType.day,
        dateTime: [
          DateTime(2025, 1, 13, 8),
          DateTime(2025, 1, 13, 14),
          DateTime(2025, 1, 14, 8),
          DateTime(2025, 1, 14, 14),
        ],
      ),
    ],
  );

  static final cancelledDoctorAppointment = DoctorAppointment(
    id: const Uuid().v4(),
    date: DateTime(2025, 11, 8),
    timeSlot: "09:00 AM - 10:00 AM",
    location: drTan.location,
    contact: drTan.contact,
    doctor: drTan,
    paymentMethod: PaymentMethod.selfPay,
    paymentStatus: PaymentStatus.unpaid,
    status: AppointmentStatus.cancelled,
    reasonOfVisit: "Follow-up Consultation",
  );

  static final vaccineAppointment = VaccineAppointment(
    id: const Uuid().v4(),
    date: DateTime(2026, 2, 14),
    timeSlot: "13:00 PM - 14:00 PM",
    location: vaccines.elementAt(1).location,
    contact: vaccines.elementAt(1).contact,
    status: AppointmentStatus.registered,
    paymentMethod: PaymentMethod.selfPay,
    selectedVaccines: [vaccines.elementAt(1), vaccines.elementAt(2)],
  );

  static final vaccineAppointment2 = VaccineAppointment(
    id: const Uuid().v4(),
    date: DateTime(2025, 2, 14),
    timeSlot: "13:00 PM - 14:00 PM",
    location: vaccines.elementAt(3).location,
    contact: vaccines.elementAt(3).contact,
    status: AppointmentStatus.completed,
    paymentMethod: PaymentMethod.selfPay,
    billing: [File('/dummy/bill.pdf')],
    fee: 115,
    selectedVaccines: [vaccines.elementAt(3)],
  );

  static final packageAppointment = PackageAppointment(
    id: const Uuid().v4(),
    date: DateTime(2025, 12, 14),
    timeSlot: "13:00 PM - 14:00 PM",
    location: ourPackages.first.location,
    contact: ourPackages.first.contact,
    package: ourPackages.first,
    selectedSubcategory: 'DNA Decode Fit',
    paymentMethod: PaymentMethod.selfPay,
    paymentStatus: PaymentStatus.paid,
    status: AppointmentStatus.completed,
    billing: [File('/dummy/bill.pdf'), File('/dummy/receipt.pdf')],
    reports: [
      File('/dummy/blood_test_results.pdf'),
      File('/dummy/xray_image.jpg'),
    ],
    fee: 1000,
  );
}
