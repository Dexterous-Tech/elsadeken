import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/notification_model.dart';
import 'notification_items.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final ScrollController scrollController;
  final bool hasNextPage;
  final bool isLoadingMore;
  final VoidCallback? onRefresh;

  const NotificationListWidget({
    Key? key,
    required this.notifications,
    required this.scrollController,
    required this.hasNextPage,
    required this.isLoadingMore,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configure Arabic locale for timeago
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      color: Colors.deepOrange,
      child: ListView.builder(
        controller: scrollController,
        itemCount: notifications.length + (hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            // Show loading indicator for pagination
            return hasNextPage
                ? Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                        strokeWidth: 2.w,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final notification = notifications[index];
          return NotificationItemWidget(
            notification: notification,
          );
        },
      ),
    );
  }
}
