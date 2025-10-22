import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderFilter extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const GenderFilter({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: double.infinity,
        height: 34.h,
        duration: const Duration(milliseconds: 200),
        // padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.congoPink : AppColors.white,
          borderRadius: BorderRadius.circular(4).r,
        ),
        child: Center(
          child: Text(
              textAlign: TextAlign.center,
              text,
              style: isActive
                  ? AppTextStyles.font14WhiteRegularLamaSans
                      .copyWith(fontWeight: FontWeightHelper.medium)
                  : AppTextStyles.font14BeerMediumLamaSans
                      .copyWith(color: Color(0xff2D2D2D))),
        ),
      ),
    );
  }
}
