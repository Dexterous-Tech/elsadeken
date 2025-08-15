import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../custom_next_and_previous_button.dart';

class SignupPasswords extends StatefulWidget {
  const SignupPasswords({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupPasswords> createState() => _SignupPasswordsState();
}

class _SignupPasswordsState extends State<SignupPasswords> {
  bool obscurePassword = false;
  bool obscureConfirmPassword = false;

  String password = '';
  late PasswordValidationResult result;
  bool hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    result = validatePasswordDisplay('');
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SignupCubit.get(context);
    double progress = hasStartedTyping
        ? calculateProgress(result)
        : 0; // ✅ only show after typing
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          loadingDialog(context);
        } else if (state is SignupSuccess) {
          context.pop();
          successDialog(
              context: context,
              message:
                  '${state.signupResponseModel.message}\n استمر في تسجيل البيانات',
              onPressed: () {
                context.pop();
                widget.onNextPressed();
              });
        } else if (state is SignupFailure) {
          context.pop();
          errorDialog(context: context, error: state.error);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: cubit.signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // password
                      Text(
                        'انشا كلمه المرور',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                          context,
                        ),
                      ),
                      verticalSpace(16),
                      CustomTextFormField(
                        controller: cubit.passwordController,
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '********',
                        validator: (value) {
                          if (value.isNullOrEmpty()) {
                            return 'يجب عليك ادخال كلمة المرور';
                          }
                          if (value!.length < 6) {
                            return 'كلمة المرور يجب أن تحتوي على 6 أرقام علي الاقل';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 16,
                            color: AppColors.lightTaupe,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                            result = validatePasswordDisplay(password);
                            hasStartedTyping = password.isNotEmpty;
                          });
                        },
                      ),
                      verticalSpace(16),
                      // Progress bar
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.gainsboro,
                            // ✅ Wrap color in setState to update
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1.0
                                  ? AppColors.yellowGreen
                                  : AppColors.pumpkinOrange,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),

                      verticalSpace(12),
                      buildValidationItem(result.hasMinLength, 'اقل من 6 أحرف'),
                      buildValidationItem(
                        result.hasNumberOrSymbol,
                        'على الأقل رقم واحد (0-9) أو رمز',
                      ),
                      buildValidationItem(
                        result.hasUpperAndLower,
                        'بدون علامات او اشكال او حروف كبيرة',
                      ),
                      verticalSpace(40),

                      // confirm password
                      Text(
                        'تاكيد كلمه المرور',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                          context,
                        ),
                      ),
                      verticalSpace(16),
                      CustomTextFormField(
                        controller: cubit.passwordConfirmationController,
                        obscureText: obscureConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '********',
                        validator: (value) {
                          if (value.isNullOrEmpty()) {
                            return 'يجب عليك تأكيد كلمة المرور';
                          }
                          if (value != cubit.passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 16,
                            color: AppColors.lightTaupe,
                          ),
                        ),
                      ),

                      verticalSpace(50),
                      Spacer(),

                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return CustomNextAndPreviousButton(
                            onNextPressed: () {
                              if (state is! SignupLoading &&
                                  cubit.signupFormKey.currentState!
                                      .validate()) {
                                cubit.signup();
                              }
                            },
                            onPreviousPressed: widget.onPreviousPressed,
                            isNextEnabled: state is! SignupLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildValidationItem(bool isValid, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font12SilverPinkMediumLamaSans(context).copyWith(
            color: isValid ? AppColors.yellowGreen : AppColors.silverPink,
          ),
        ),
        horizontalSpace(8),
        Image.asset(
          isValid ? AppImages.checkCorrect : AppImages.checkPoint,
          width: 18.w,
          height: 18.h,
        ),
      ],
    );
  }

  double calculateProgress(PasswordValidationResult result) {
    int count = 0;
    if (result.hasMinLength) count++;
    if (result.hasNumberOrSymbol) count++;
    if (result.hasUpperAndLower) count++;
    return count / 3;
  }
}

class PasswordValidationResult {
  final bool hasMinLength;
  final bool hasNumberOrSymbol;
  final bool hasUpperAndLower;

  PasswordValidationResult({
    required this.hasMinLength,
    required this.hasNumberOrSymbol,
    required this.hasUpperAndLower,
  });
}

PasswordValidationResult validatePasswordDisplay(String password) {
  if (password.isEmpty) {
    return PasswordValidationResult(
      hasMinLength: false,
      hasNumberOrSymbol: false,
      hasUpperAndLower: false, // ✅ default to false
    );
  }

  final hasMinLength = password.length >= 6;
  final hasNumberOrSymbol =
      RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  // true only if contains no symbols or uppercase
  final hasNoSymbolsOrUppercase =
      !RegExp(r'[A-Z!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  return PasswordValidationResult(
    hasMinLength: hasMinLength,
    hasNumberOrSymbol: hasNumberOrSymbol,
    hasUpperAndLower: hasNoSymbolsOrUppercase,
  );
}
