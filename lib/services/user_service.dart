import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:medcare_app/models/user.dart';

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static User? currentUser;

  // ── Register new user — saves to Firestore ────────────────────────────────
  static Future<String?> register({
    required String name,
    required String phone,
    required String password,
    required String icNo,
    required bool isForeign,
    String? email,
  }) async {
    try {
      // Check if phone already exists
      final existing = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (existing.docs.isNotEmpty) {
        return 'An account with this phone number already exists.';
      }

      // Generate MR number
      final mrNo = _generateMrNo();

      // Save to Firestore
      final docRef = _db.collection('users').doc();
      await docRef.set({
        'uid': docRef.id,
        'mrNo': mrNo,
        'name': name,
        'phone': phone,
        'password': password, // Note: hash in production
        'icNo': icNo,
        'isForeign': isForeign,
        'email': email ?? '',
        'totalPayable': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ User registered: $name ($phone)');
      return null; // null = success

    } catch (e) {
      debugPrint('❌ Register error: $e');
      return 'Registration failed. Please try again.';
    }
  }

  // ── Login — check phone + password against Firestore ─────────────────────
  static Future<String?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .get();

      if (snapshot.docs.isEmpty) {
        return 'Invalid phone number or password.';
      }

      // Load user into memory
      final data = snapshot.docs.first.data();
      currentUser = User(
        mrNo: data['mrNo'] ?? '',
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        password: data['password'] ?? '',
        icNo: data['icNo'] ?? '',
        email: data['email'] ?? '',
        isForeign: data['isForeign'] ?? false,
        totalPayable: (data['totalPayable'] ?? 0.0).toDouble(),
      );

      debugPrint('✅ User logged in: ${currentUser!.name}');
      return null; // null = success

    } catch (e) {
      debugPrint('❌ Login error: $e');
      return 'Login failed. Please try again.';
    }
  }

  // ── Update user total payable ─────────────────────────────────────────────
  static Future<void> updateTotalPayable(double amount) async {
    try {
      if (currentUser == null) return;
      final snapshot = await _db
          .collection('users')
          .where('phone', isEqualTo: currentUser!.phone)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference
            .update({'totalPayable': amount});
      }
    } catch (e) {
      debugPrint('❌ Failed to update totalPayable: $e');
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  static void logout() {
    currentUser = null;
    debugPrint('✅ User logged out');
  }

  // ── Generate MR number ────────────────────────────────────────────────────
  static String _generateMrNo() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2,'0')}${now.millisecondsSinceEpoch.toString().substring(9)}';
  }
}