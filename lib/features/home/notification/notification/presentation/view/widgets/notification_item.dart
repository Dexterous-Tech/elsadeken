import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../data/model/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItemWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          // gradient: notification.readAt == null
          //     ? LinearGradient(
          //         end: Alignment.bottomCenter,
          //         begin: Alignment.topCenter,
          //         colors: [
          //           Color(0xffF8ECD6).withValues(alpha: 0.1),
          //           Color(0xffF8ECD6),
          //         ],
          //       )
          //     : null,
          color:
              notification.readAt == null ? Colors.white : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment:
              LocalizationService.instance.startCrossAxisAlignment,
          textDirection:
              LocalizationService.instance.textDirection, // Keep RTL for Arabic
          children: [
            /// 👉 ICON on the right
            ClipRRect(
              borderRadius: BorderRadius.circular(50).r,
              child: CustomImageNetwork(
                image: notification.icon ?? '',
              ),
            ),

            SizedBox(width: 16.w),

            /// 👉 TEXT on the left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: LocalizationService.instance.textDirection,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.font14BlackSemiBoldLamaSans,
                    textAlign: TextAlign.right,
                    textDirection: LocalizationService
                        .instance.textDirection, // Keep RTL for Arabic
                  ),
                  verticalSpace(4),
                  RichText(
                      textAlign: LocalizationService.instance.textAlignment,
                      textDirection: LocalizationService
                          .instance.textDirection, // Keep RTL for Arabic
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${notification.body} ',
                            style: AppTextStyles.font14JetRegularLamaSans
                                .copyWith(color: Color(0xff404040))),
                        TextSpan(
                            text: '${notification.userName} ',
                            style: AppTextStyles.font14JetRegularLamaSans
                                .copyWith(color: Color(0xff74370A))),
                      ])),
                  verticalSpace(6),
                  Text(
                    timeago.format(notification.createdAt, locale: LocalizationService.instance.currentLanguageCode),
                    style: AppTextStyles.font12JetRegularLamaSans
                        .copyWith(color: Color(0xffFF6700)),
                    textAlign: LocalizationService.instance.textAlignment,
                    textDirection:
                        LocalizationService.instance.textDirection, // K
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context) {
    // Check if both type and referenceId are null - no navigation
    if (notification.type == null && notification.referenceId == null) {
      return;
    }

    // Navigate based on type
    switch (notification.type) {
      case 'blog':
        // Navigate to blog screen if referenceId is null
        context.pushNamed(AppRoutes.blogScreen);
        break;

      case 'user':
        // Navigate to profile details screen if referenceId has value
        if (notification.referenceId != null) {
          context.pushNamed(AppRoutes.profileDetailsScreen,
              arguments: notification.referenceId);
        }
        break;

      case 'chat':
        // Navigate to chat page (bottom navigation tab) if referenceId has value
        if (notification.referenceId != null) {
          print(
              '🔔 [Notification] Navigating to home screen with chat tab (index: 1)');
          // Navigate to home screen with chat tab selected
          context.pushNamed(AppRoutes.homeScreen,
              arguments: 1); // 1 is the chat tab index
        }
        break;

      case 'story':
        // Navigate to blog screen if referenceId is null
        context.pushNamed(AppRoutes.successStoriesScreen);
        break;

      default:
        // No navigation for unknown types
        break;
    }
  }
}
