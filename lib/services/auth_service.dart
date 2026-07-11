import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';
import 'package:medcare_app/services/user_service.dart';

enum UserRole { unauthenticated, guest, customer }

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  bool _isGuest = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;

  UserRole get currentRole {
    if (_isAuthenticated) return UserRole.customer;
    if (_isGuest) return UserRole.guest;
    return UserRole.unauthenticated;
  }

  void performProtectedAction({
    required BuildContext context,
    required VoidCallback onAction,
  }) {
    if (currentRole == UserRole.customer) {
      onAction();
    } else {
      _showSignInDialog(context);
    }
  }

  void _showSignInDialog(BuildContext context) {
    showWarningDialog(
      context,
      title: 'Member Feature',
      content: 'Please sign in or register to access this feature.',
      actionText: 'Sign In',
      onTapAction: () {
        context.pop();
        logout();
      },
      backText: 'Maybe Later',
      onTapBack: () => context.pop(),
    );
  }

  Future<void> init() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final guestFlag = await _storage.read(key: 'is_guest');

    if (firebaseUser != null) {
      final error = await UserService.loadCurrentUser(firebaseUser.uid);
      _isAuthenticated = error == null;
      _isGuest = false;
    } else {
      _isAuthenticated = false;
      _isGuest = guestFlag == 'true';
    }
    notifyListeners();
  }

  Future<void> login(String uid) async {
    await _storage.delete(key: 'is_guest');
    _isAuthenticated = true;
    _isGuest = false;
    notifyListeners();
  }

  Future<void> setGuestMode() async {
    await UserService.logout();
    await _storage.write(key: 'is_guest', value: 'true');
    _isAuthenticated = false;
    _isGuest = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await UserService.logout();
    await _storage.deleteAll();
    _isAuthenticated = false;
    _isGuest = false;
    notifyListeners();
  }
}
