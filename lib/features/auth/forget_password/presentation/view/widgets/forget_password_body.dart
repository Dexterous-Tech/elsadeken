import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/auth/widgets/custom_auth_body.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
      cardContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'نسيت كلمه المرور',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans(context),
          ),
          Text(
            'ادخل بريدك الالكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14BeerMediumLamaSans(
              context,
            ).copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          Text(
            'بريد إلكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
          ),
          verticalSpace(8),
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            hintText: 'user@gmail.com',
            validator: (value) {},
          ),
          Spacer(),
          CustomElevatedButton(
            onPressed: () {
              context.pushReplacementNamed(AppRoutes.verificationEmailScreen);
            },
            textButton: 'التالي',
          ),
        ],
      ),
    );
  }
}
