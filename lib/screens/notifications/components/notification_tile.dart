import 'package:flutter/material.dart';
import 'package:medcare_app/models/notifications.dart';

Widget notificationTile({
  required BuildContext context,
  required AppNotification notification,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: notification.color.withAlpha(70),
            shape: BoxShape.circle,
          ),
          child: Icon(notification.icon, color: notification.color, size: 28),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    notification.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(notification.message),
            ],
          ),
        ),
      ],
    ),
  );
}
