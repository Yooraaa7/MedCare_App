import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/app_router.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_hlwe');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: null,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTap(response.payload!);
        }
      },
    );

    final NotificationAppLaunchDetails? launchDetails = await _notifications
        .getNotificationAppLaunchDetails();

    // Launch the app if in terminate status
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      if (launchDetails?.notificationResponse?.payload != null) {
        _handleNotificationTap(launchDetails!.notificationResponse!.payload!);
      }
    }

    // Request permission for Android
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      // Also required for exact alarms (like zonedSchedule) on Android 13+
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  static void _handleNotificationTap(String payload) {
    try {
      // 1. Decode JSON
      final Map<String, dynamic> data = jsonDecode(payload);

      // 2. Safely get values (handling potential nulls)
      final String? screen = data['screen'];
      final String? id = data['id']?.toString();

      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context == null || screen == null) return;

      // 3. Navigate
      switch (screen) {
        case 'payment':
          context.go('/payment');
          break;
        case 'appointment':
          if (id != null) {
            context.push('/appointments/appointment-details/$id');
          }
          break;
        default:
          context.go('/');
      }
    } catch (e) {
      debugPrint("Notification Navigation Error: $e");
      // If it's not JSON, try navigating to the raw payload string as a backup
      if (payload == 'payment') {
        AppRouter.rootNavigatorKey.currentContext?.push('/payment');
      }
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'Scheduled notifications channel',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(''),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
