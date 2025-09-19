import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_country_code_picker.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/services/localization_service.dart';

class SignupPersonalInfo extends StatefulWidget {
  const SignupPersonalInfo(
      {super.key, required this.onNextPressed, required this.gender});

  final void Function() onNextPressed;
  final String gender;

  @override
  State<SignupPersonalInfo> createState() => _SignupPersonalInfoState();
}

class _SignupPersonalInfoState extends State<SignupPersonalInfo> {
  ValueNotifier<String> countryCode = ValueNotifier<String>('');
  String? phoneErrorMessage;

  @override
  void initState() {
    super.initState();
    // Listen to country code changes and update the controller
    final cubit = SignupCubit.get(context);
    countryCode.addListener(() {
      cubit.countryCodeController.text = countryCode.value;
    });

    cubit.genderController.text = widget.gender;
  }

  @override
  void dispose() {
    countryCode.dispose();
    super.dispose();
  }

  void _validatePhone(String? value) {
    setState(() {
      if (value.isNullOrEmpty()) {
        phoneErrorMessage = AppLocalizations.of(context)!.phoneRequired;
      } else if (value!.length < 8) {
        phoneErrorMessage = AppLocalizations.of(context)!.phoneMinLength;
      } else {
        phoneErrorMessage = null;
      }
    });
  }

  bool _validateForm() {
    final cubit = SignupCubit.get(context);
    bool isValid = true;

    // Validate phone number
    _validatePhone(cubit.phoneController.text);
    if (phoneErrorMessage != null) {
      isValid = false;
    }

    // Validate other fields using form key
    if (!cubit.personalInfoFormKey.currentState!.validate()) {
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SignupCubit.get(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: cubit.personalInfoFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: LocalizationService.instance.textDirection,
                  children: [
                    // name
                    Text(AppLocalizations.of(context)!.whatIsYourName,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.nameController,
                      keyboardType: TextInputType.text,
                      hintText: AppLocalizations.of(context)!.yourName,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                        // Explicitly deny Arabic numbers (٠-٩) and regular numbers (0-9)
                        FilteringTextInputFormatter.deny(
                            RegExp(r'[0-9\u0660-\u0669]')),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.nameRequired;
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),

                    // email
                    Text(AppLocalizations.of(context)!.whatIsYourEmail,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: AppLocalizations.of(context)!.yourEmail,
                      inputFormatters: [
                        // Allow only characters valid in an email address
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._\-+]'),
                        ),
                      ],
                      validator: (value) {
                        if (value.isNullOrEmpty()) {
                          return AppLocalizations.of(context)!.emailRequired;
                        }
                        if (!AppRegex.isEmailValid(value!)) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),

                    // email
                    Text(AppLocalizations.of(context)!.whatIsYourPhoneNumber,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: LocalizationService.instance.textDirection,
                      children: [
                        SizedBox(
                          height: 54.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection:
                                LocalizationService.instance.textDirection,
                            children: [
                              CustomCountryCodePicker(code: countryCode),
                              horizontalSpace(8),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: cubit.phoneController,
                                  keyboardType: TextInputType.phone,
                                  hintText:
                                      AppLocalizations.of(context)!.phoneNumber,
                                  onChanged: _validatePhone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // ✅ Only numbers
                                  ],
                                  borderColor: phoneErrorMessage != null
                                      ? AppColors.red
                                      : AppColors
                                          .brown, // Change border color based on error
                                  validator: (value) =>
                                      null, // Empty validator to prevent height changes
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Show error message below the row
                        if (phoneErrorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h, right: 4.w),
                            child: Text(
                              phoneErrorMessage!,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(child: verticalSpace(20)),
                    // Spacer(),
                    CustomElevatedButton(
                      onPressed: () {
                        if (_validateForm()) {
                          widget.onNextPressed();
                        }
                      },
                      textButton: AppLocalizations.of(context)!.next,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
