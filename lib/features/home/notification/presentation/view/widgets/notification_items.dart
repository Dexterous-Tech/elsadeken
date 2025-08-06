import 'package:flutter/material.dart';

class NotificationItemWidget extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isRead;

  const NotificationItemWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
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
        onTap: () {
          print('Notification tapped: $title');
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          textDirection: TextDirection.rtl, // Keep RTL for Arabic
          children: [
            /// 👉 ICON on the right
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE53E3E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications,
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
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isRead ? FontWeight.w500 : FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
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
}
