import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/services/localization_service.dart';
import '../../../data/model/notification_model.dart';
import 'notification_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final ScrollController scrollController;
  final bool hasNextPage;
  final bool isLoadingMore;
  final VoidCallback? onRefresh;

  const NotificationListWidget({
    super.key,
    required this.notifications,
    required this.scrollController,
    required this.hasNextPage,
    required this.isLoadingMore,
    this.onRefresh,
  });

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
        itemCount:
            notifications.length + (hasNextPage || isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            // Show loading indicator for pagination
            if (isLoadingMore) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: LocalizationService.instance.textDirection,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.deepOrange,
                        strokeWidth: 2.w,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppLocalizations.of(context)!.loadingMore,
                        style: AppTextStyles.font12JetRegularLamaSans
                            .copyWith(color: AppColors.beer),
                        textAlign: LocalizationService.instance.textAlignment,
                        textDirection:
                            LocalizationService.instance.textDirection,
                      ), // K                      ),
                    ],
                  ),
                ),
              );
            } else if (hasNextPage) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.dragLoading,
                    style: AppTextStyles.font12JetRegularLamaSans
                        .copyWith(color: Colors.grey),
                    textDirection: LocalizationService.instance.textDirection,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
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
