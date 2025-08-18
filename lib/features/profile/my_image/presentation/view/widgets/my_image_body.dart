import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyImageBody extends StatelessWidget {
  const MyImageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          ProfileHeader(title: 'صورتي'),
          verticalSpace(30),
          Text(
            'معلومات هامة :',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font20LightOrangeMediumLamaSans.copyWith(
              color: Color(0xffF9F9F9),
            ),
          ),
          verticalSpace(30),
          informationItem(
              'يجب ان تكون الصورة محترمة ، ولائقة بطابع التطبيق الإسلامي'),
          informationItem(
              'أي إستخدام سيء لهذه الخدمة يؤدي إاى حظر إشتراكك بدون سابق إنذار'),
          verticalSpace(35),
          Center(
            child: Image.asset(
              AppImages.cameraProfile,
              width: 134.w,
              height: 134.h,
            ),
          ),
          Spacer(),
          CustomElevatedButton(
            onPressed: () {},
            textButton: 'تحميل صوره',
          )
        ],
      ),
    );
  }

  Widget informationItem(String info) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 14.h),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.jet),
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              info,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.font19JetRegularLamaSans,
            ),
          )
        ],
      ),
    );
  }
}
