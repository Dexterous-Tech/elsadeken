import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicalSupportMessage extends StatelessWidget {
  const TechnicalSupportMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.orangeLighter,
          ),
          child: Center(
            child: Image.asset(
              AppImages.splashImage,
              width: 20.w,
              height: 39.h,
            ),
          ),
        ),
        horizontalSpace(10),
        Expanded(
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الدعم الفني',
                style: AppTextStyles.font16BlackSemiBoldLamaSans
                    .copyWith(color: AppColors.darkerBlue),
              ),
              verticalSpace(5),
              Container(
                width: double.infinity, // Take all available width
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.lighterOrange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10).r,
                    bottomLeft: Radius.circular(10).r,
                    bottomRight: Radius.circular(10).r,
                  ),
                ),
                child: Text(
                  'كيف يمكنني مساعدتك ؟',
                  style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                      color: AppColors.darkerBlue,
                      fontWeight: FontWeightHelper.regular),
                  textDirection: TextDirection.rtl,
                ),
              ),
              verticalSpace(5),
              Text(
                '08:16 صباحا',
                style: AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                  color: AppColors.darkerBlue.withValues(alpha: 0.4),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
