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
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/services/localization_service.dart';
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
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String password = '';
  late PasswordValidationResult result;
  bool hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    // Check if there's saved password data and initialize validation
    final cubit = SignupCubit.get(context);
    if (cubit.passwordController.text.isNotEmpty) {
      password = cubit.passwordController.text;
      result = validatePasswordDisplay(password);
      hasStartedTyping = true;
    } else {
      result = validatePasswordDisplay('');
    }

    // Ensure validation is properly initialized after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Re-validate with current password data
          if (cubit.passwordController.text.isNotEmpty) {
            password = cubit.passwordController.text;
            result = validatePasswordDisplay(password);
            hasStartedTyping = true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SignupCubit.get(context);
    double progress = hasStartedTyping
        ? calculateProgress(result)
        : 0; // ✅ only show after typing
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (context, state) =>
          state is SignupLoading ||
          state is SignupFailure ||
          state is SignupSuccess,
      listener: (context, state) {
        if (state is SignupLoading) {
          loadingDialog(context);
        } else if (state is SignupFailure) {
          context.pop(); // Close loading dialog
          errorDialog(
            context: context,
            error: state.error,
            onPressed: () {
              Navigator.pop(context); // Close error dialog
            },
          );
        } else if (state is SignupSuccess) {
          context.pop(); // Close loading dialog
          successDialog(
            context: context,
            message: AppLocalizations.of(context)!.registrationSuccessful,
            onPressed: () {
              Navigator.pop(context); // Close success dialog
              widget.onNextPressed(); // Move to next step
            },
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: cubit.passwordsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: LocalizationService.instance.textDirection,
                    children: [
                      // password
                      Text(AppLocalizations.of(context)!.createPassword,
                          textDirection:
                              LocalizationService.instance.textDirection,
                          style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                      verticalSpace(16),
                      CustomTextFormField(
                        controller: cubit.passwordController,
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '********',
                        validator: (value) {
                          if (value.isNullOrEmpty()) {
                            return AppLocalizations.of(context)!
                                .passwordRequired;
                          }

                          final result = validatePasswordDisplay(value!);

                          if (!result.hasMinLength) {
                            return AppLocalizations.of(context)!
                                .passwordMinLength;
                          }
                          if (!result.hasNumberOrSymbol) {
                            return AppLocalizations.of(context)!
                                .passwordNumberOrSymbol;
                          }
                          if (!result.hasUpperAndLower) {
                            return AppLocalizations.of(context)!.passwordCase;
                          }

                          return null; // ✅ كل الشروط متحققة
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
                      buildValidationItem(
                          result.hasMinLength,
                          AppLocalizations.of(context)!
                              .passwordMinLengthValidation),
                      buildValidationItem(
                        result.hasNumberOrSymbol,
                        AppLocalizations.of(context)!
                            .passwordNumberSymbolValidation,
                      ),
                      buildValidationItem(
                        result.hasUpperAndLower,
                        AppLocalizations.of(context)!.passwordCaseValidation,
                      ),
                      verticalSpace(40),

                      // confirm password
                      Text(AppLocalizations.of(context)!.confirmPasswordField,
                          textDirection:
                              LocalizationService.instance.textDirection,
                          style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                      verticalSpace(16),
                      CustomTextFormField(
                        controller: cubit.passwordConfirmationController,
                        obscureText: obscureConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: '********',
                        validator: (value) {
                          if (value.isNullOrEmpty()) {
                            return AppLocalizations.of(context)!
                                .confirmPasswordRequired;
                          }
                          if (value != cubit.passwordController.text) {
                            return AppLocalizations.of(context)!
                                .passwordsDoNotMatch;
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
                              if (cubit.passwordsFormKey.currentState!
                                      .validate() &&
                                  result.hasMinLength &&
                                  result.hasNumberOrSymbol &&
                                  result.hasUpperAndLower) {
                                // Call signup method instead of just moving to next step
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
      // mainAxisAlignment: MainAxisAlignment.start,
      textDirection: LocalizationService.instance.textDirection,
      children: [
        Image.asset(
          isValid ? AppImages.checkCorrect : AppImages.checkPoint,
          width: 18.w,
          height: 18.h,
        ),
        horizontalSpace(8),
        Text(
          text,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font12SilverPinkMediumLamaSans.copyWith(
            color: isValid ? AppColors.yellowGreen : AppColors.silverPink,
          ),
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
  final hasNumber = RegExp(r'[0-9]').hasMatch(password);
  final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  final hasNumberAndSymbol = hasNumber && hasSymbol;

  // true only if contains no symbols or uppercase
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
  final hasUpperAndLower = hasUppercase && hasLowercase;

  return PasswordValidationResult(
    hasMinLength: hasMinLength,
    hasNumberOrSymbol: hasNumberAndSymbol,
    hasUpperAndLower: hasUpperAndLower,
  );
}
