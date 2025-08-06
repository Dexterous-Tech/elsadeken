import 'package:flutter/material.dart';

import 'notification_items.dart';

class NotificationListWidget extends StatelessWidget {
  const NotificationListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        NotificationItemWidget(
          title: 'رسالة جديدة',
          body: 'رسالة من المستخدم osama97 تم إرسالها',
          time: 'منذ 5 دقائق',
          isRead: false,
        ),
        
        NotificationItemWidget(
          title: 'رسالة جديدة',
          body: 'رسالة من المستخدم osama97 تم إرسالها',
          time: 'منذ ساعة واحدة',
          isRead: false,
        ),
        
        NotificationItemWidget(
          title: 'من يهتم بي',
          body: 'المستخدم osama97 بدأ يتابعك',
          time: 'منذ ساعتين',
          isRead: true,
        ),
      ],
    );
  }
}