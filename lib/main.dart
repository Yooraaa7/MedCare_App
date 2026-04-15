import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/services/auth_service.dart';
import 'package:medcare_app/services/data_service.dart';
import 'package:medcare_app/services/notification_service.dart';
import 'package:medcare_app/general/themes/dark_theme.dart';
import 'package:medcare_app/general/themes/light_theme.dart';
import 'app_router.dart';

// Global notifier for theme switching
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final authService = AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await authService.init();
    await NotificationService.init();
    await DataService.initService();
    await DataService.initDoctor();
  } catch (e) {
    debugPrint("Initialization Error: $e");
  }

  final appRouter = AppRouter(authService);

  runApp(MyApp(router: appRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp.router(
          title: 'HLWE App',
          themeMode: currentMode,
          theme: LightTheme.getLightTheme(),
          darkTheme: DarkTheme.getDarkTheme(),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
