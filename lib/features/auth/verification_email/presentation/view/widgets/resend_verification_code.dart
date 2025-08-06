import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ResendVerificationCode extends StatelessWidget {
  const ResendVerificationCode({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'لم تستلم الرمز؟ ',
            style: AppTextStyles.font16ChineseBlackMediumLamaSans(
              context,
            ).copyWith(color: AppColors.black),
          ),
          TextSpan(
            text: 'إعادة الإرسال',
            style: AppTextStyles.font16ChineseBlackMediumLamaSans(context)
                .copyWith(
                  color: AppColors.red,
                  fontWeight: FontWeightHelper.semiBold,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
              },
          ),
        ],
      ),
    );
  }
}
