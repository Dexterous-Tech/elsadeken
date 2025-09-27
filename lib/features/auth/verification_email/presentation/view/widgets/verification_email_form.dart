import 'package:elsadeken/core/helper/localization_helper.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_pin_code_field.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/view/widgets/resend_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection_container.dart';

class VerificationEmailForm extends StatelessWidget {
  const VerificationEmailForm({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    var cubit = VerificationCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: LocalizationService.instance.textDirection,
        children: [
          Text(
            LocalizationHelper.getLocalizedText(
                'رمز التحقق', 'Verification code'),
            textDirection: LocalizationService.instance.textDirection,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans,
          ),
          Text(
            LocalizationHelper.getLocalizedText(
                'ادخل رقم رمز التحقق الذي تم ارساله الي البريد الالكتروني',
                'Enter the verification code that was sent to your email.'),
            textDirection: LocalizationService.instance.textDirection,
            style: AppTextStyles.font14BeerMediumLamaSans
                .copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          CustomPinCodeField(
            controller: cubit.otpController,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 4) {
                return ' '; // No visible text, but triggers errorBorderColor (red)
              }
              return null; // Valid
            },
          ),
          verticalSpace(58),
          BlocProvider(
            create: (context) => sl<ForgetCubit>(),
            child: Center(
                child: ResendVerificationCode(
              email: email,
            )),
          ),
          Expanded(
            child: Container(), // This will take up remaining space
          ),
          CustomElevatedButton(
            onPressed: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.verifyOtp(email);
              }
            },
            textButton: LocalizationHelper.getLocalizedText('ارسال', 'Send'),
          ),
        ],
      ),
    );
  }
}
