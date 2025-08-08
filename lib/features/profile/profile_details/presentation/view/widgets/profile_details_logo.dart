import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsLogo extends StatelessWidget {
  const ProfileDetailsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.asset(
                AppImages.profileImageLogo,
                width: 145.w,
                height: 145.h,
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                      border: Border.all(color: AppColors.white)),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Text(
            '@Ammar muhamed',
            style: AppTextStyles.font16BlackSemiBoldLamaSans,
          ),
          verticalSpace(8),
          Text(
            'سنجل',
            style: AppTextStyles.font13BlackMediumPlexSans,
          )
        ],
      ),
    );
  }
}
