import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ForgetCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
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
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'user@gmail.com',
            validator: (value) {
              if (cubit.emailController.text.isNullOrEmpty() ||
                  AppRegex.isEmailValid(value!)) {
                return 'You must add valid email';
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
            textButton: 'التالي',
          ),
        ],
      ),
    );
  }
}
