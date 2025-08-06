import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class LoginCreateNewAccount extends StatelessWidget {
  const LoginCreateNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'ليس لديك حساب ؟ ',
            style: AppTextStyles.font14BeerMediumLamaSans(
              context,
            ).copyWith(color: AppColors.auroMetalSaurus),
          ),
          TextSpan(
            text: 'انشاء حساب',
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(
              context,
            ).copyWith(color: AppColors.red),
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
