import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:medcare_app/models/user.dart';
import 'package:medcare_app/services/data_service.dart';

class UserService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;

  static User? currentUser;
  static String? currentUserId;

  static const String demoAuthEmail =
      '0188888888@medcare.local';

  /// Only this Firebase Authentication account
  /// receives the original local sample data.
  static bool get isDemoUser {
    final String? email = _auth
        .currentUser
        ?.email
        ?.trim()
        .toLowerCase();

    return email == demoAuthEmail;
  }

  static double get totalPayable {
    return currentUser?.totalPayable ?? 0.0;
  }

  static String normalizePhone(
    String phone,
  ) {
    return phone.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
  }

  /// Firebase Authentication requires an email,
  /// while patients continue signing in using
  /// their phone number.
  static String _phoneAuthEmail(
    String phone,
  ) {
    return '${normalizePhone(phone)}@medcare.local';
  }

  static Future<String?> register({
    required String name,
    required String phone,
    required String password,
    required String icNo,
    required bool isForeign,
    String? email,
  }) async {
    firebase_auth.UserCredential? credential;

    try {
      final String normalizedPhone =
          normalizePhone(phone);

      credential =
          await _auth.createUserWithEmailAndPassword(
        email: _phoneAuthEmail(
          normalizedPhone,
        ),
        password: password,
      );

      final String uid =
          credential.user!.uid;

      final String mrNo =
          _generateMrNo();

      final Map<String, dynamic> userData = {
        'uid': uid,
        'mrNo': mrNo,
        'name': name.trim(),
        'phone': normalizedPhone,
        'email': email?.trim() ?? '',
        'isForeign': isForeign,
        'role': 'patient',
        'totalPayable': 0.0,
        'primaryDoctorId': null,
        'createdAt':
            FieldValue.serverTimestamp(),
      };

      if (isForeign) {
        userData['passport'] =
            icNo.trim();

        userData['icNo'] = '';
      } else {
        userData['icNo'] =
            icNo.trim();

        userData['passport'] = '';
      }

      await _db
          .collection('users')
          .doc(uid)
          .set(userData);

      await _auth.signOut();

      currentUser = null;
      currentUserId = null;

      DataService.clearUserScopedData();

      debugPrint(
        'User registered successfully: '
        '$name ($normalizedPhone)',
      );

      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth registration error: '
        '${e.code} - ${e.message}',
      );

      switch (e.code) {
        case 'weak-password':
          return 'The password is too weak. '
              'Please use at least 6 characters.';

        case 'email-already-in-use':
          return 'An account with this phone '
              'number already exists.';

        case 'invalid-email':
          return 'The phone number format is invalid.';

        case 'operation-not-allowed':
          return 'Email and password registration '
              'is not enabled.';

        case 'network-request-failed':
          return 'No internet connection. '
              'Please try again.';

        default:
          return e.message ??
              'Registration failed. '
                  'Please try again.';
      }
    } on FirebaseException catch (e) {
      debugPrint(
        'Firestore registration error: '
        '${e.code} - ${e.message}',
      );

      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (deleteError) {
          debugPrint(
            'Unable to remove incomplete '
            'Auth user: $deleteError',
          );
        }
      }

      if (e.code == 'permission-denied') {
        return 'Unable to create the patient '
            'profile because access was denied.';
      }

      return 'Unable to save the patient profile. '
          'Please try again.';
    } catch (e) {
      debugPrint(
        'Register error: $e',
      );

      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (_) {}
      }

      return 'Registration failed. '
          'Please try again.';
    }
  }

  static Future<String?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final String normalizedPhone =
          normalizePhone(phone);

      final credential =
          await _auth.signInWithEmailAndPassword(
        email: _phoneAuthEmail(
          normalizedPhone,
        ),
        password: password,
      );

      return await loadCurrentUser(
        credential.user!.uid,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'Login authentication error: '
        '${e.code}',
      );

      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        return 'Invalid phone number or password.';
      }

      return e.message ??
          'Login failed. Please try again.';
    } catch (e) {
      debugPrint(
        'Login error: $e',
      );

      return 'Login failed. Please try again.';
    }
  }

  static Future<String?> loadCurrentUser(
    String uid,
  ) async {
    try {
      final document = await _db
          .collection('users')
          .doc(uid)
          .get();

      if (!document.exists) {
        currentUser = null;
        currentUserId = null;

        DataService.clearUserScopedData();

        await _auth.signOut();

        return 'Patient profile was not found.';
      }

      final Map<String, dynamic> data =
          document.data()!;

      currentUserId = uid;

      final bool isForeign =
          data['isForeign'] == true;

      currentUser = User(
        mrNo:
            (data['mrNo'] ?? '').toString(),
        name:
            (data['name'] ?? 'Patient').toString(),
        phone:
            (data['phone'] ?? '').toString(),
        password: '',
        email:
            (data['email'] ?? '').toString(),
        isForeign: isForeign,
        icNo: isForeign
            ? null
            : (data['icNo'] ?? '').toString(),
        passport: isForeign
            ? (data['passport'] ?? '').toString()
            : null,
        totalPayable:
            _toDouble(data['totalPayable']),
        isDemoUser: isDemoUser,
        primaryDoctorId:
            _nullableString(
          data['primaryDoctorId'],
        ),
      );

      DataService.configureUserScopedData(
        isDemoUser: isDemoUser,
        userId: uid,
        force: true,
      );

      debugPrint(
        'Current user loaded: '
        '${currentUser!.name}',
      );

      debugPrint(
        'Firebase Auth email: '
        '${_auth.currentUser?.email}',
      );

      debugPrint(
        'Demo user detected: '
        '$isDemoUser',
      );

      debugPrint(
        'Reminders loaded: '
        '${DataService.allReminders.length}',
      );

      debugPrint(
        'Primary doctor ID: '
        '${currentUser!.primaryDoctorId ?? "none"}',
      );

      return null;
    } catch (e) {
      debugPrint(
        'Load user error: $e',
      );

      currentUser = null;
      currentUserId = null;

      DataService.clearUserScopedData();

      return 'Unable to load your profile.';
    }
  }

  static Future<void>
      refreshCurrentUser() async {
    final String? uid =
        currentUserId ??
            _auth.currentUser?.uid;

    if (uid == null) {
      return;
    }

    await loadCurrentUser(uid);
  }

  static Future<void> updateTotalPayable(
    double amount,
  ) async {
    if (currentUserId == null) {
      return;
    }

    await _db
        .collection('users')
        .doc(currentUserId)
        .update({
      'totalPayable': amount,
    });

    if (currentUser != null) {
      currentUser!.totalPayable = amount;
    }
  }

  static Future<void> logout() async {
    currentUser = null;
    currentUserId = null;

    DataService.clearUserScopedData();

    await _auth.signOut();
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  static String? _nullableString(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final String result =
        value.toString().trim();

    if (result.isEmpty ||
        result.toLowerCase() == 'null') {
      return null;
    }

    return result;
  }

  static String _generateMrNo() {
    final DateTime now =
        DateTime.now();

    final String month =
        now.month
            .toString()
            .padLeft(2, '0');

    final String timestamp =
        now.millisecondsSinceEpoch.toString();

    final String suffix =
        timestamp.length >= 6
            ? timestamp.substring(
                timestamp.length - 6,
              )
            : timestamp;

    return 'MR${now.year}$month$suffix';
  }

  static Future<String?> updateProfile({
    required String name,
    required String phone,
  }) async {
    final String? uid =
        currentUserId ??
            _auth.currentUser?.uid;

    if (uid == null ||
        currentUser == null) {
      return 'No logged-in user was found.';
    }

    try {
      final String normalizedPhone =
          normalizePhone(phone);

      await _db
          .collection('users')
          .doc(uid)
          .update({
        'name': name.trim(),
        'phone': normalizedPhone,
        'updatedAt':
            FieldValue.serverTimestamp(),
      });

      currentUser!.name = name.trim();
      currentUser!.phone =
          normalizedPhone;

      debugPrint(
        'Profile updated: '
        '${currentUser!.name}',
      );

      return null;
    } on FirebaseException catch (e) {
      debugPrint(
        'Profile update Firestore error: '
        '${e.code} - ${e.message}',
      );

      if (e.code ==
          'permission-denied') {
        return 'You do not have permission '
            'to update this profile.';
      }

      return 'Unable to update your profile.';
    } catch (e) {
      debugPrint(
        'Profile update error: $e',
      );

      return 'Unable to update your profile.';
    }
  }
}