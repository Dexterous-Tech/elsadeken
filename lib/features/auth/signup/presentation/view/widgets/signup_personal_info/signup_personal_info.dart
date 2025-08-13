import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_country_code_picker.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        phoneErrorMessage = 'يجب عليك ادخال رقم الجوال';
      } else if (value!.length < 8) {
        phoneErrorMessage = 'رقم الجوال يجب أن يكون أكثر من 8 أرقام';
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
    if (!cubit.signupFormKey.currentState!.validate()) {
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
                key: cubit.signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // name
                    Text(
                      'ما هو اسمك ؟',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                        context,
                      ),
                    ),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.nameController,
                      keyboardType: TextInputType.text,
                      hintText: 'اسمك',
                      validator: (value) {
                        if (value.isNullOrEmpty()) {
                          return 'يجب عليك ادخال اسمك';
                        }
                      },
                    ),
                    verticalSpace(40),

                    // email
                    Text(
                      'ما هو بريدك الالكتروني ؟',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                        context,
                      ),
                    ),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'بريدك الالكتروني',
                      validator: (value) {
                        if (value.isNullOrEmpty()) {
                          return 'يجب عليك ادخال بريدك الالكتروني';
                        }
                        if (!AppRegex.isEmailValid(value!)) {
                          return 'يرجى ادخال بريد الكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),

                    // email
                    Text(
                      'ما هو رقم جوالك ؟',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                        context,
                      ),
                    ),
                    verticalSpace(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 54.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: cubit.phoneController,
                                  keyboardType: TextInputType.phone,
                                  hintText: 'رقم الجوال',
                                  onChanged: _validatePhone,
                                  validator: (value) =>
                                      null, // Empty validator to prevent height changes
                                ),
                              ),
                              horizontalSpace(8),
                              CustomCountryCodePicker(code: countryCode),
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
                    verticalSpace(40),
                    Spacer(),
                    CustomElevatedButton(
                      onPressed: () {
                        if (_validateForm()) {
                          widget.onNextPressed();
                        }
                      },
                      textButton: 'التالي',
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
