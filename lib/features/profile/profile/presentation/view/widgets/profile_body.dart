import '../../../../../../core/helper/app_images.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/font_weight_helper.dart';
import '../../../../../../core/theme/spacing.dart';
import 'profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.darkSunray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 34.5.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الحساب الشخصي',
                      style: AppTextStyles.font20WhiteBoldLamaSans(context),
                    ),
                    verticalSpace(19),
                    Image.asset(AppImages.profileLogo, width: 84, height: 83),
                    Text(
                      'Esraa Mohamed',
                      style:
                          AppTextStyles.font23ChineseBlackBoldLamaSans(
                            context,
                          ).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeightHelper.semiBold,
                          ),
                    ),
                    Text(
                      'esraa@gmail.com',
                      style:
                          AppTextStyles.font14ChineseBlackSemiBoldLamaSans(
                            context,
                          ).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeightHelper.regular,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(15),
            Expanded(child: ProfileContent()),
          ],
        ),
      ),
    );
  }
}
