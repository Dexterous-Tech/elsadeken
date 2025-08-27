import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_arrow_back.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key, 
    required this.title, 
    this.background,
    this.showBackButton = true,
  });

  final String title;
  final Color? background;
  final bool showBackButton;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          CustomArrowBack(
            background: background ?? AppColors.white,
          )
        else
          SizedBox(
            width: 30.w,
            height: 30.h,
          ),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        SizedBox(
          width: 30.w,
          height: 30.h,
        ),
      ],
    );
  }
}
