import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/components/warning_dialog.dart';

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

  // Show popup dialog for protected actions
  void performProtectedAction({
    required BuildContext context,
    required VoidCallback onAction,
  }) {
    if (currentRole == UserRole.customer) {
      // User is logged in, let them proceed
      onAction();
    } else {
      // User is a guest, show them the gate
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
        logout(); // Clears guest flag and redirects to Login Screen
      },
      backText: 'Maybe Later',
      onTapBack: () => context.pop(),
    );
  }

  // Initialize and check current status
  Future<void> init() async {
    final token = await _storage.read(key: 'auth_token');
    final guestFlag = await _storage.read(key: 'is_guest');
    _isAuthenticated = token != null;
    _isGuest = guestFlag == 'true';
    notifyListeners();
  }

  Future<void> login(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.delete(key: 'is_guest');
    _isAuthenticated = true;
    _isGuest = false;
    notifyListeners();
  }

  Future<void> setGuestMode() async {
    await _storage.write(key: 'is_guest', value: 'true');
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    _isGuest = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _isAuthenticated = false;
    _isGuest = false;
    notifyListeners();
  }
}
