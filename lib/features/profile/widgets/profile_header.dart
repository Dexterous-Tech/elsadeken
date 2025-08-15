import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/font_weight_helper.dart';
import '../../../core/widgets/custom_arrow_back.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomArrowBack(
          background: Color(0xffF9F9F9),
        ),
        Text(
          title,
          style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
