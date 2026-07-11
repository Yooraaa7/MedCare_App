import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/models/appointments/base_appointment.dart';
import 'package:medcare_app/models/appointments/doctor_appointment.dart';
import 'package:medcare_app/models/appointments/package_appointment.dart';
import 'package:medcare_app/models/appointments/vaccine_appointment.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/services/user_service.dart';

class AppointmentService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static String _dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String _slotId(
    String doctorId,
    DateTime date,
    String slot,
  ) {
    final String safeSlot = slot
        .replaceAll(
          RegExp(r'[^a-zA-Z0-9]'),
          '-',
        )
        .toLowerCase();

    return '${doctorId}_${_dateKey(date)}_$safeSlot';
  }

  static Future<String?> saveAppointment(
    BaseAppointment appointment,
  ) async {
    final String? uid =
        UserService.currentUserId;

    if (uid == null) {
      return 'Please sign in before booking.';
    }

    final Map<String, dynamic> data = {
      'id': appointment.id,
      'patientUid': uid,
      'patientMrNo':
          UserService.currentUser?.mrNo ?? '',
      'date':
          Timestamp.fromDate(appointment.date),
      'appointmentDate':
          _dateKey(appointment.date),
      'timeSlot': appointment.timeSlot,
      'location': appointment.location,
      'contact': appointment.contact,
      'status': appointment.status.name,
      'paymentStatus':
          appointment.paymentStatus.name,
      'paymentMethod':
          appointment.paymentMethod.name,
      'fee': appointment.fee,
      'createdAt':
          FieldValue.serverTimestamp(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    };

    try {
      if (appointment is DoctorAppointment) {
        final String doctorId =
            appointment.doctor.id.isNotEmpty
                ? appointment.doctor.id
                : appointment.doctor.nameEng
                    .replaceAll(' ', '_')
                    .toLowerCase();

        final String slotId = _slotId(
          doctorId,
          appointment.date,
          appointment.timeSlot,
        );

        data.addAll({
          'type': 'doctor',
          'doctorId': doctorId,
          'doctorName':
              appointment.doctor.nameEng,
          'doctorSpecialty':
              appointment.doctor.specialty.name,
          'reasonOfVisit':
              appointment.reasonOfVisit,
          'slotId': slotId,
        });

        final DocumentReference<
                Map<String, dynamic>>
            slotReference = _db
                .collection('appointmentSlots')
                .doc(slotId);

        final DocumentReference<
                Map<String, dynamic>>
            appointmentReference = _db
                .collection('appointments')
                .doc(appointment.id);

        await _db.runTransaction(
          (Transaction transaction) async {
            final DocumentSnapshot<
                    Map<String, dynamic>>
                existingSlot =
                await transaction.get(
              slotReference,
            );

            if (existingSlot.exists) {
              final Map<String, dynamic>?
                  slotData =
                  existingSlot.data();

              final String slotStatus =
                  (slotData?['status'] ??
                          'reserved')
                      .toString();

              if (slotStatus == 'reserved') {
                throw StateError(
                  'SLOT_ALREADY_BOOKED',
                );
              }
            }

            transaction.set(
              slotReference,
              {
                'slotId': slotId,
                'doctorId': doctorId,
                'appointmentDate':
                    _dateKey(
                  appointment.date,
                ),
                'timeSlot':
                    appointment.timeSlot,
                'appointmentId':
                    appointment.id,
                'patientUid': uid,
                'status': 'reserved',
                'createdAt':
                    FieldValue.serverTimestamp(),
                'updatedAt':
                    FieldValue.serverTimestamp(),
              },
            );

            transaction.set(
              appointmentReference,
              data,
            );
          },
        );
      } else {
        if (appointment
            is VaccineAppointment) {
          data.addAll({
            'type': 'vaccine',
            'selectedVaccineNames':
                appointment.selectedVaccines
                    .map(
                      (vaccine) =>
                          vaccine.name,
                    )
                    .toList(),
            'selectedVaccineIds':
                appointment.selectedVaccines
                    .map(
                      (vaccine) =>
                          vaccine.id,
                    )
                    .toList(),
          });
        } else if (appointment
            is PackageAppointment) {
          data.addAll({
            'type': 'package',
            'packageName':
                appointment.package.name,
            'selectedSubcategory':
                appointment
                    .selectedSubcategory,
          });
        }

        await _db
            .collection('appointments')
            .doc(appointment.id)
            .set(data);
      }

      return null;
    } catch (error) {
      debugPrint(
        'Save appointment error: $error',
      );

      if (error
          .toString()
          .contains('SLOT_ALREADY_BOOKED')) {
        return 'This doctor time slot has '
            'already been booked.';
      }

      return 'Unable to save the appointment. '
          'Please try again.';
    }
  }

  static Future<Set<String>>
      getBookedDoctorSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    if (doctorId.trim().isEmpty) {
      return <String>{};
    }

    try {
      final QuerySnapshot<
              Map<String, dynamic>>
          snapshot = await _db
              .collection('appointmentSlots')
              .where(
                'doctorId',
                isEqualTo: doctorId,
              )
              .where(
                'appointmentDate',
                isEqualTo: _dateKey(date),
              )
              .where(
                'status',
                isEqualTo: 'reserved',
              )
              .get(
                const GetOptions(
                  source: Source.server,
                ),
              );

      return snapshot.docs
          .map(
            (document) =>
                (document.data()['timeSlot'] ??
                        '')
                    .toString(),
          )
          .where(
            (timeSlot) =>
                timeSlot.isNotEmpty,
          )
          .toSet();
    } catch (error) {
      debugPrint(
        'Load booked doctor slots error: '
        '$error',
      );

      return <String>{};
    }
  }

  static Stream<Set<String>> watchBookedDoctorSlots({
    required String doctorId,
    required DateTime date,
  }) {
    if (doctorId.trim().isEmpty) {
      return Stream.value(<String>{});
    }

    return _db
        .collection('appointmentSlots')
        .where(
          'doctorId',
          isEqualTo: doctorId,
        )
        .where(
          'appointmentDate',
          isEqualTo: _dateKey(date),
        )
        .where(
          'status',
          isEqualTo: 'reserved',
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    (doc.data()['timeSlot'] ?? '')
                        .toString(),
              )
              .where(
                (slot) => slot.isNotEmpty,
              )
              .toSet(),
        );
  }

  static Future<void>
      loadCurrentUserAppointments() async {
    DataService.allAppointments =
        UserService.isDemoUser
            ? [
                SampleData.doctorAppointment,
                SampleData
                    .doctorAppointment2,
                SampleData
                    .packageAppointment,
                SampleData
                    .vaccineAppointment,
                SampleData
                    .cancelledDoctorAppointment,
              ]
            : [];

    final String? uid =
        UserService.currentUserId;

    if (uid == null) {
      return;
    }

    try {
      final QuerySnapshot<
              Map<String, dynamic>>
          snapshot = await _db
              .collection('appointments')
              .where(
                'patientUid',
                isEqualTo: uid,
              )
              .get();

      for (final QueryDocumentSnapshot<
              Map<String, dynamic>>
          document in snapshot.docs) {
        final Map<String, dynamic> data =
            document.data();

        final DateTime? date =
            (data['date'] as Timestamp?)
                ?.toDate();

        if (date == null) {
          continue;
        }

        final PaymentMethod paymentMethod =
            PaymentMethod.values.firstWhere(
          (method) =>
              method.name ==
              data['paymentMethod'],
          orElse: () =>
              PaymentMethod.selfPay,
        );

        final PaymentStatus paymentStatus =
            PaymentStatus.values.firstWhere(
          (status) =>
              status.name ==
              data['paymentStatus'],
          orElse: () =>
              PaymentStatus.unpaid,
        );

        final AppointmentStatus status =
            AppointmentStatus.values
                .firstWhere(
          (appointmentStatus) =>
              appointmentStatus.name ==
              data['status'],
          orElse: () =>
              AppointmentStatus.upcoming,
        );

        BaseAppointment? appointment;

        if (data['type'] == 'doctor') {
          final String doctorId =
              (data['doctorId'] ?? '')
                  .toString();

          final dynamic doctor =
              DataService.allDoctors
                  .cast<dynamic>()
                  .firstWhere(
            (item) =>
                item.id == doctorId ||
                item.nameEng ==
                    data['doctorName'],
            orElse: () => null,
          );

          if (doctor != null) {
            appointment =
                DoctorAppointment(
              id: document.id,
              date: date,
              timeSlot:
                  data['timeSlot'] ?? '',
              location:
                  data['location'] ??
                      doctor.location,
              contact:
                  data['contact'] ??
                      doctor.contact,
              paymentMethod:
                  paymentMethod,
              paymentStatus:
                  paymentStatus,
              status: status,
              fee: (data['fee'] as num?)
                  ?.toDouble(),
              doctor: doctor,
              reasonOfVisit:
                  data['reasonOfVisit'] ??
                      '',
            );
          }
        } else if (data['type'] ==
            'package') {
          final dynamic package =
              [
                ...DataService
                    .allPackages,
                ...DataService
                    .allChildrenPackages,
                ...DataService
                    .allWellnessPackages,
              ]
                  .cast<dynamic>()
                  .firstWhere(
            (item) =>
                item.name ==
                data['packageName'],
            orElse: () => null,
          );

          if (package != null) {
            appointment =
                PackageAppointment(
              id: document.id,
              date: date,
              timeSlot:
                  data['timeSlot'] ?? '',
              location:
                  data['location'] ??
                      package.location,
              contact:
                  data['contact'] ??
                      package.contact,
              paymentMethod:
                  paymentMethod,
              paymentStatus:
                  paymentStatus,
              status: status,
              fee: (data['fee'] as num?)
                  ?.toDouble(),
              package: package,
              selectedSubcategory:
                  data[
                      'selectedSubcategory'],
            );
          }
        } else if (data['type'] ==
            'vaccine') {
          final List<String> ids =
              List<String>.from(
            data['selectedVaccineIds'] ??
                [],
          );

          final vaccines =
              DataService.allVaccines
                  .where(
                    (vaccine) =>
                        ids.contains(
                      vaccine.id,
                    ),
                  )
                  .toList();

          if (vaccines.isNotEmpty) {
            appointment =
                VaccineAppointment(
              id: document.id,
              date: date,
              timeSlot:
                  data['timeSlot'] ?? '',
              location:
                  data['location'] ??
                      vaccines
                          .first.location,
              contact:
                  data['contact'] ??
                      vaccines
                          .first.contact,
              paymentMethod:
                  paymentMethod,
              paymentStatus:
                  paymentStatus,
              status: status,
              fee: (data['fee'] as num?)
                  ?.toDouble(),
              selectedVaccines:
                  vaccines,
            );
          }
        }

        if (appointment != null) {
          final bool alreadyExists =
              DataService.allAppointments
                  .any(
            (existing) =>
                existing.id ==
                appointment!.id,
          );

          if (!alreadyExists) {
            DataService.allAppointments
                .add(appointment);
          }
        }
      }
    } catch (error) {
      debugPrint(
        'Load appointments error: $error',
      );
    }
  }

  static Future<void> updateStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    if (status ==
        AppointmentStatus.cancelled) {
      final String? error =
          await cancelAppointment(
        appointmentId: appointmentId,
      );

      if (error != null) {
        throw Exception(error);
      }

      return;
    }

    await _db
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': status.name,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  static Future<String?>
      cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      final DocumentReference<
              Map<String, dynamic>>
          appointmentReference = _db
              .collection('appointments')
              .doc(appointmentId);

      await _db.runTransaction(
        (Transaction transaction) async {
          final DocumentSnapshot<
                  Map<String, dynamic>>
              appointmentSnapshot =
              await transaction.get(
            appointmentReference,
          );

          if (!appointmentSnapshot.exists) {
            throw StateError(
              'APPOINTMENT_NOT_FOUND',
            );
          }

          final Map<String, dynamic> data =
              appointmentSnapshot.data()!;

          final String appointmentType =
              (data['type'] ?? '')
                  .toString();

          String? slotId =
              data['slotId']?.toString();

          // Support appointments created before
          // slotId was added to Firestore.
          if ((slotId == null ||
                  slotId.trim().isEmpty) &&
              appointmentType ==
                  'doctor') {
            final String doctorId =
                (data['doctorId'] ?? '')
                    .toString();

            final String timeSlot =
                (data['timeSlot'] ?? '')
                    .toString();

            DateTime? appointmentDate;

            if (data['date'] is Timestamp) {
              appointmentDate =
                  (data['date']
                          as Timestamp)
                      .toDate();
            } else {
              final String dateText =
                  (data[
                              'appointmentDate'] ??
                          '')
                      .toString();

              appointmentDate =
                  DateTime.tryParse(
                dateText,
              );
            }

            if (doctorId.isNotEmpty &&
                timeSlot.isNotEmpty &&
                appointmentDate != null) {
              slotId = _slotId(
                doctorId,
                appointmentDate,
                timeSlot,
              );
            }
          }

          transaction.update(
            appointmentReference,
            {
              'status':
                  AppointmentStatus
                      .cancelled.name,
              'cancelledAt':
                  FieldValue.serverTimestamp(),
              'updatedAt':
                  FieldValue.serverTimestamp(),
            },
          );

          if (appointmentType ==
                  'doctor' &&
              slotId != null &&
              slotId.trim().isNotEmpty) {
            final DocumentReference<
                    Map<String, dynamic>>
                slotReference = _db
                    .collection(
                      'appointmentSlots',
                    )
                    .doc(slotId);

            final DocumentSnapshot<
                    Map<String, dynamic>>
                slotSnapshot =
                await transaction.get(
              slotReference,
            );

            if (slotSnapshot.exists) {
              transaction.delete(
                slotReference,
              );
            }
          }
        },
      );

      final int localIndex =
          DataService.allAppointments
              .indexWhere(
        (appointment) =>
            appointment.id ==
            appointmentId,
      );

      if (localIndex != -1) {
        DataService
                .allAppointments[localIndex]
                .status =
            AppointmentStatus.cancelled;
      }

      debugPrint(
        'Appointment cancelled and slot '
        'released: $appointmentId',
      );

      return null;
    } catch (error) {
      debugPrint(
        'Cancel appointment error: $error',
      );

      if (error
          .toString()
          .contains(
            'APPOINTMENT_NOT_FOUND',
          )) {
        return 'Appointment was not found.';
      }

      return 'Unable to cancel the '
          'appointment.';
    }
  }

  static Future<void>
      updatePaymentStatus(
    String appointmentId,
    PaymentStatus status,
  ) async {
    await _db
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'paymentStatus': status.name,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }
}