import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/on_boarding/presentation/view/widgets/oath_dialog/oath_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class LoginCreateNewAccount extends StatelessWidget {
  const LoginCreateNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!; // shortcut

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: tr.nosignup,
            style: AppTextStyles.font14BeerMediumLamaSans
                .copyWith(color: AppColors.auroMetalSaurus),
          ),
          TextSpan(
            text: tr.signup,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans
                .copyWith(color: AppColors.red),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // Mark onboarding as completed
                await SharedPreferencesHelper.setIsOnboardingCompleted(true);
                context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
                oathDialog(context: context);
              },
          ),
        ],
      ),
    );
  }
}
