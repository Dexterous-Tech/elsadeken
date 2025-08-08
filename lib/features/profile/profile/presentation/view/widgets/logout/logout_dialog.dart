import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> logoutDialog(BuildContext context) async {
  customDialog(
    context: context,
    backgroundColor: AppColors.white,
    radius: 16,
    height: 311.h,
    dialogContent: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.warningLogo,
          width: 101.w,
          height: 101.h,
        ),
        verticalSpace(24),
        Text(
          'هل انت متاكد؟',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
            color: AppColors.darkBlue,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        verticalSpace(4),
        Text(
          'هل تريد تسجيل الخروج؟',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font14LightGrayRegularLamaSans,
        ),
        verticalSpace(24),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 115.w,
              child: CustomElevatedButton(
                onPressed: () {
                  context.pop();
                },
                textButton: 'الغاء',
                verticalPadding: 12,
                backgroundColor: AppColors.darkSunray,
                radius: 8,
              ),
            ),
            horizontalSpace(12),
            GestureDetector(
              onTap: () {},
              child: Text(
                'تسجيل الخروج',
                style: AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                  fontWeight: FontWeightHelper.semiBold,
                  color: AppColors.brightRed,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
