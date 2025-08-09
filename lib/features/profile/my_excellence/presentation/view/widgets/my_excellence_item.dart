import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyExcellenceItem extends StatelessWidget {
  const MyExcellenceItem(
      {super.key, required this.isCorrect, required this.title});

  final bool isCorrect;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Image.asset(
            isCorrect ? AppImages.correctProfile : AppImages.wrongProfile,
            width: 32.w,
            height: 32.h,
          ),
          SizedBox(
            width: 11,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font18JetMediumLamaSans.copyWith(
                    fontSize: 20.sp,
                    fontFamily: FontFamilyHelper.plexSansArabic,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  height: 11,
                ),
                Container(
                  color: AppColors.black.withValues(alpha: 0.14),
                  height: 1.h,
                  margin: EdgeInsets.only(left: 42.w, bottom: 13.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
