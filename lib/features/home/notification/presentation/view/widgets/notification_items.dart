import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timego;
import '../../../data/models/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 253, 251).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          textDirection: TextDirection.rtl, // Keep RTL for Arabic
          children: [
            /// 👉 ICON on the right
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 10),

            /// 👉 TEXT on the left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // align left
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          notification.isRead ? FontWeight.w500 : FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timego.format(notification.timestamp, locale: 'ar'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.deepOrange,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return const Color(0xFF4CAF50); // Green
      case NotificationType.like:
        return const Color(0xFFE53E3E); // Red
      case NotificationType.follow:
        return const Color(0xFF2196F3); // Blue
      case NotificationType.comment:
        return const Color(0xFFFF9800); // Orange
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.comment:
        return Icons.comment;
    }
  }
}
