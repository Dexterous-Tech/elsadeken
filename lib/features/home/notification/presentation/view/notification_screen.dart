import 'package:elsadeken/features/home/notification/presentation/view/widgets/empty_notification.dart';
import 'package:elsadeken/features/home/notification/presentation/view/widgets/notification_list.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasNotifications = true;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3F0),
        elevation: 0,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],   

        leading: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ),
      body: hasNotifications
          ? const NotificationListWidget()
          : const EmptyNotificationsWidget(),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خيارات'),
        content: const Text('ستتوفر الخيارات قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
