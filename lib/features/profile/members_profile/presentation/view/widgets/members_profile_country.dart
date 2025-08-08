import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MembersProfileCountry extends StatelessWidget {
  const MembersProfileCountry({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الدولة',
            style: AppTextStyles.font20LightOrangeMediumPlexSans.copyWith(
              color: Color(0xff2D2D2D),
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'السعوديه',
                style: AppTextStyles.font18GreyRegularLamaSans.copyWith(
                    color: AppColors.darkSunray,
                    fontFamily: FontFamilyHelper.plexSansArabic),
              ),
              horizontalSpace(8),
              Image.asset(
                AppImages.bottomArrowProfile,
                width: 18.w,
                height: 18.h,
              )
            ],
          ),
        ],
      ),
    );
  }
}
