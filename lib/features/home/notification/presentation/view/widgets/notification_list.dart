import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import 'notification_items.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel)? onNotificationTap;

  const NotificationListWidget({
    Key? key,
    required this.notifications,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configure Arabic locale for timeago
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItemWidget(
          notification: notification,
          onTap: () => onNotificationTap?.call(notification),
        );
      },
    );
  }
}