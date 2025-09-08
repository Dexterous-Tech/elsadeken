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
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: notification.readAt == null
            ? Color(0xffE0A25E).withValues(alpha: 0.1)
            : Color(0xffFFFAFC),
      ),
      child: Row(
        crossAxisAlignment:
            LocalizationService.instance.startCrossAxisAlignment,
        textDirection:
            LocalizationService.instance.textDirection, // Keep RTL for Arabic
        children: [
          /// 👉 ICON on the right
          CustomImageNetwork(
            image: notification.icon ?? '',
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
                  timeago.format(notification.createdAt, locale: 'ar'),
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
    );
  }
}
