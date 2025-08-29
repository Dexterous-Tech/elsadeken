import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(AppImages.emptyNotification ,width: 256.w,height: 256.h,),
                       verticalSpace(54),
            Text(
              'لا يوجد إشعارات حتى الآن',
              style: AppTextStyles.font26BlackBoldLamaSans,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            Text(
              'ستظهر إشعاراتك هنا عند وصول\nرسائل جديدة',
              style: AppTextStyles.font14JetRegularLamaSans.copyWith(color: Color(0xff404040)),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
