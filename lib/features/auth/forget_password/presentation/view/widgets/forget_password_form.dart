import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/helper/localization_helper.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../../../../../../l10n/app_localizations.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ForgetCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment:
            LocalizationService.instance.startCrossAxisAlignment,
        textDirection: LocalizationService.instance.textDirection,
        children: [
          Text(
            LocalizationHelper.getLocalizedText(
                'نسيت كلمه المرور', 'ForgetPassword'),
            textDirection: LocalizationService.instance.textDirection,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans,
          ),
          Text(
            LocalizationHelper.getLocalizedText(
                'ادخل بريدك الالكتروني', 'Enter Your Email'),
            textDirection: LocalizationService.instance.textDirection,
            style: AppTextStyles.font14BeerMediumLamaSans
                .copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          Text(
            LocalizationHelper.getLocalizedText('بريد إلكتروني', 'Email'),
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans,
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'user@gmail.com',
            validator: (value) {
              if (cubit.emailController.text.isNullOrEmpty() ||
                  !AppRegex.isEmailValid(value!)) {
                return AppLocalizations.of(context)!.emailError;
              }
            },
          ),
          Spacer(),
          CustomElevatedButton(
            onPressed: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.forgetPassword();
              }
            },
            textButton: LocalizationHelper.getLocalizedText('التالي', 'Next'),
          ),
        ],
      ),
    );
  }
}
