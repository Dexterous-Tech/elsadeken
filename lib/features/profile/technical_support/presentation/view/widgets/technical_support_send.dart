import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicalSupportSend extends StatelessWidget {
  const TechnicalSupportSend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: Offset(0, -4)),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 22.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16).r,
          color: Color(0xffFFF9F6),
          border: Border.all(color: Color(0xffF3F5F6), width: 1),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: '... اكتب رسالتك',
                  hintStyle: AppTextStyles.font18GreyRegularLamaSans.copyWith(
                    color: Color(0xff444444),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
            Image.asset(
              AppImages.sendProfile,
              width: 24.w,
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}
