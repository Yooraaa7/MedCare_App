import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcare_app/main.dart';
import 'package:medcare_app/services/auth_service.dart';
import 'package:medcare_app/app_router.dart';

// 1. Create a simple fake version of your service
class FakeAuthService extends AuthService {
  @override
  bool get isAuthenticated => true; // Force "logged in" for the test

  @override
  Future<void> init() async {} // Do nothing during init
}

void main() {
  testWidgets('App smoke test - verifies home screen renders', (
    WidgetTester tester,
  ) async {
    // 2. Setup dependencies
    final authService = FakeAuthService();
    final appRouter = AppRouter(authService);

    // 3. Build our app with the router instance
    await tester.pumpWidget(MyApp(router: appRouter.router));

    // 4. Wait for the GoRouter to process the initial route and animations
    await tester.pumpAndSettle();

    // 5. Verify that we are on the Home Screen
    // (Replace 'Home' with whatever unique text is on your actual Home Screen)
    expect(find.text('Home'), findsOneWidget);

    // Verify that the Bottom Navigation Bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
