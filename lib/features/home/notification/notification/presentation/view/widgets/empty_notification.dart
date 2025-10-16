import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(96).r,
              child: Image.asset(
                AppImages.emptyNotification,
                width: 162.w,
                height: 162.h,
              ),
            ),
            verticalSpace(54),
            Text(
              AppLocalizations.of(context)!.noNotificationsYet,
              style: AppTextStyles.font26BlackBoldLamaSans,
              textAlign: TextAlign.center,
              textDirection: LocalizationService.instance.textDirection,
            ),
            Text(
              AppLocalizations.of(context)!.notificationsWillAppearHere,
              style: AppTextStyles.font14JetRegularLamaSans
                  .copyWith(color: Color(0xff404040)),
              textAlign: TextAlign.center,
              textDirection: LocalizationService.instance.textDirection,
            ),
          ],
        ),
      ),
    );
  }
}
