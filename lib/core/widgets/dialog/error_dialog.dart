import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../helper/app_lottie.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_styles.dart';

void errorDialog(
    {required BuildContext context,
    required String error,
    void Function()? onPressed}) {
  customDialog(
    context: context,
    backgroundColor: AppColors.white,
    dialogContent: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(AppLottie.errorLottie, width: 100.w, height: 100.h),
        verticalSpace(15),
        Text(error,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14BlackRegularLamaSans),
        verticalSpace(15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16).r,
                ),
                backgroundColor: AppColors.primaryOrange,
                padding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                ),
              ),
              onPressed: onPressed ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(
                'Retry',
                style: AppTextStyles.font14WhiteRegularLamaSans,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
