import 'package:elsadeken/core/helper/localization_helper.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_text_styles.dart';

class ResendVerificationCode extends StatelessWidget {
  const ResendVerificationCode({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetCubit, ForgetState>(
      listener: (context, state) {
        if (state is ForgetLoading) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              textDirection: LocalizationService.instance.textDirection,
              crossAxisAlignment:
                  LocalizationService.instance.startCrossAxisAlignment,
              children: [
                Expanded(
                  child: Text(
                    LocalizationHelper.getLocalizedText(
                        'جاري اعادة ارسالة رمز التحقق',
                        'Resending verification code'),
                    textDirection: LocalizationService.instance.textDirection,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.font14PumpkinOrangeBoldLamaSans.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.primaryOrange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(16.w),
            duration: Duration(seconds: 2),
          ));
        } else if (state is ForgetFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                textDirection: LocalizationService.instance.textDirection,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14PumpkinOrangeBoldLamaSans.copyWith(
                  color: AppColors.white,
                ),
              ),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.all(16.w),
              duration: Duration(seconds: 4),
            ),
          );
        } else if (state is ForgetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.forgetResponseModel.message,
                textDirection: LocalizationService.instance.textDirection,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14PumpkinOrangeBoldLamaSans.copyWith(
                  color: AppColors.white,
                ),
              ),
              backgroundColor: AppColors.primaryOrange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.all(16.w),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = ForgetCubit.get(context);
        return RichText(
          textDirection: LocalizationService.instance.textDirection,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocalizationHelper.getLocalizedText(
                    'لم تستلم الرمز؟', 'Don\'t recieve code?'),
                style: AppTextStyles.font16ChineseBlackMediumLamaSans
                    .copyWith(color: AppColors.black),
              ),
              TextSpan(
                text: LocalizationHelper.getLocalizedText(
                    'إعادة الإرسال', 'Send again'),
                style: AppTextStyles.font16ChineseBlackMediumLamaSans.copyWith(
                  color: AppColors.red,
                  fontWeight: FontWeightHelper.semiBold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    cubit.forgetPassword(email: email);
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
