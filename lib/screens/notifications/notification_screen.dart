import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/data/sample_data.dart';
import 'package:medcare_app/general/components/custom_appbar.dart';
import 'package:medcare_app/models/notifications.dart';
import 'package:medcare_app/screens/notifications/components/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _markAllNotificationsAsRead();
  }

  void _markAllNotificationsAsRead() {
    for (final n in SampleData.sampleNotifications) {
      n.isRead = true;
    }
  }

  // Helper to categorize dates
  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));

    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return "TODAY";
    if (checkDate == yesterday) return "YESTERDAY";
    if (checkDate.isAfter(lastWeek)) return "THIS WEEK";
    return "OLDER";
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications logic
    final Map<String, List<AppNotification>> groupedNotifications = {};

    for (var n in SampleData.sampleNotifications) {
      final header = _getDateHeader(n.timestamp);
      groupedNotifications.putIfAbsent(header, () => []);
      groupedNotifications[header]!.add(n);
    }

    final sortedHeaders = [
      "TODAY",
      "YESTERDAY",
      "THIS WEEK",
      "OLDER",
    ].where(groupedNotifications.containsKey).toList();

    return PopScope(
      // Prevents the default system back behavior
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // If the screen has already been popped, do nothing
        if (didPop) return;

        // Manually pop and pass 'true' to ensure the Home screen refreshes
        context.pop(true);
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'Notifications',
          onBackPressed: () => context.pop(true),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: sortedHeaders.length,
          itemBuilder: (context, index) {
            final header = sortedHeaders[index];
            final items = groupedNotifications[header]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 12),
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ...items.map(
                  (n) => notificationTile(context: context, notification: n),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
