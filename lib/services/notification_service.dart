import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medcare_app/app_router.dart';
import 'package:medcare_app/models/reminder.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _reminderChannel =
      AndroidNotificationChannel(
    'medcare_reminders',
    'MedCare Reminders',
    description: 'Medication and health activity reminders',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel _mainChannel =
      AndroidNotificationChannel(
    'main_channel',
    'Main Channel',
    description: 'Scheduled notifications channel',
    importance: Importance.max,
  );

  // ── Init ──────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    // 1. Timezone setup
    tzdata.initializeTimeZones();

    // 2. Local notifications setup
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    // Create notification channels
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(_reminderChannel);
      await androidImpl.createNotificationChannel(_mainChannel);
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }

    // Handle app launched from terminated via notification
    final NotificationAppLaunchDetails? launchDetails =
        await _notifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      if (launchDetails?.notificationResponse?.payload != null) {
        _handleNotificationTap(
            launchDetails!.notificationResponse!.payload!);
      }
    }

    debugPrint('✅ NotificationService initialised');
  }

  // ── Schedule all notifications for a reminder ─────────────────────────────
  static Future<void> scheduleReminderNotification(Reminder reminder) async {
    if (!reminder.enabled) return;

    for (int i = 0; i < reminder.dateTime.length; i++) {
      final scheduledTime = reminder.dateTime[i];

      // Skip times already in the past
      if (scheduledTime.isBefore(DateTime.now())) continue;

      // Apply lead time offset
      final offset = _getLeadTimeOffset(reminder.notificationType);
      final triggerTime = scheduledTime.subtract(offset);

      // Skip if trigger time is also in the past
      if (triggerTime.isBefore(DateTime.now())) continue;

      final body = reminder.type == ReminderType.medication
          ? 'Time to take your medication.'
          : 'You have a scheduled health activity.';

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannel.id,
          _reminderChannel.name,
          channelDescription: _reminderChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      );

      await _notifications.zonedSchedule(
        id: reminder.id.hashCode + i,
        title: reminder.title,
        body: body,
        scheduledDate: tz.TZDateTime.from(triggerTime, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint(
          '✅ Scheduled: "${reminder.title}" at $triggerTime (slot $i)');
    }
  }

  // ── Cancel all notifications for a reminder ───────────────────────────────
  static Future<void> cancelReminderNotification(Reminder reminder) async {
    for (int i = 0; i < reminder.dateTime.length; i++) {
      await _notifications.cancel(
        id: reminder.id.hashCode + i,
      );
    }
    debugPrint('✅ Cancelled notifications for: ${reminder.title}');
  }

  // ── Cancel by reminder ID only (when dateTime not available) ─────────────
  static Future<void> cancelReminderById(
      String reminderId, int slots) async {
    for (int i = 0; i < slots; i++) {
      await _notifications.cancel(
        id: reminderId.hashCode + i,
      );
    }
    debugPrint('✅ Cancelled notifications for ID: $reminderId');
  }

  // ── Lead time offset helper ───────────────────────────────────────────────
  static Duration _getLeadTimeOffset(List<NotificationLeadTime> types) {
    if (types.isEmpty) return Duration.zero;
    switch (types.first) {
      case NotificationLeadTime.fifteenMinutes:
        return const Duration(minutes: 15);
      case NotificationLeadTime.thirtyMinutes:
        return const Duration(minutes: 30);
      case NotificationLeadTime.oneHour:
        return const Duration(hours: 1);
      case NotificationLeadTime.oneDay:
        return const Duration(days: 1);
      default:
        return Duration.zero;
    }
  }

  // ── Notification tap handler ──────────────────────────────────────────────
  static void _handleNotificationTap(String payload) {
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final String? screen = data['screen'];
      final String? id = data['id']?.toString();

      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context == null || screen == null) return;

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
      debugPrint('Notification Navigation Error: $e');
      if (payload == 'payment') {
        AppRouter.rootNavigatorKey.currentContext?.push('/payment');
      }
    }
  }

  // ── General schedule notification (used by other features) ───────────────
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
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}