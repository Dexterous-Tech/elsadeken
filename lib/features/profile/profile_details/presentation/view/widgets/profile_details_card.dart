import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard(
      {super.key, required this.cardTitle, required this.cardContent});

  final String cardTitle;
  final Widget cardContent;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.snowWhite,
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withValues(
                alpha: 0.09,
              ),
              blurRadius: 26,
              offset: Offset(0, 4)),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2).r,
          topRight: Radius.circular(2).r,
          bottomRight: Radius.circular(11).r,
          bottomLeft: Radius.circular(11).r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkSunray,
              borderRadius: BorderRadius.circular(2).r,
            ),
            child: Text(
              cardTitle,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font18WhiteSemiBoldLamaSans,
            ),
          ),
          verticalSpace(10),
          cardContent
        ],
      ),
    );
  }
}
