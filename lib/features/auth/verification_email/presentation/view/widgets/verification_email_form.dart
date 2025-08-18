import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_pin_code_field.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/view/widgets/resend_verification_code.dart';
import 'package:flutter/material.dart';

class VerificationEmailForm extends StatelessWidget {
  const VerificationEmailForm({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    var cubit = VerificationCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'رمز التحقق',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans,
          ),
          Text(
            'ادخل رقم رمز التحقق الذي تم ارساله الي البريد الالكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14BeerMediumLamaSans
                .copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          CustomPinCodeField(
            controller: cubit.otpController,
            validator: (value) {
              if (value == null || value.length < 4) {
                return 'يجب ادخال رمز التحقق علي بريدك الالكتروني';
              }
            },
          ),
          verticalSpace(58),
          Center(child: ResendVerificationCode()),
          Expanded(
            child: Container(), // This will take up remaining space
          ),
          CustomElevatedButton(
            onPressed: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.verifyOtp(email);
              }
            },
            textButton: 'ارسال',
          ),
        ],
      ),
    );
  }
}
