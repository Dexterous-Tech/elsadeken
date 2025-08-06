import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/widgets/forms/custom_pin_code_field.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/view/widgets/resend_verification_code.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../widgets/custom_auth_body.dart';

class VerificationEmailBody extends StatelessWidget {
  const VerificationEmailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
      cardContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'رمز التحقق',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans(context),
          ),
          Text(
            'ادخل رقم رمز التحقق الذي تم ارساله الي البريد الالكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14BeerMediumLamaSans(
              context,
            ).copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          CustomPinCodeField(validator: (value) {}),
          verticalSpace(58),
          Center(child: ResendVerificationCode()),
          Spacer(),
          CustomElevatedButton(
            onPressed: () {
              context.pushReplacementNamed(AppRoutes.newPasswordScreen);
            },
            textButton: 'ارسال',
          ),
        ],
      ),
    );
  }
}
