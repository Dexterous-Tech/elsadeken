import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_country_code_picker.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPersonalInfo extends StatefulWidget {
  const SignupPersonalInfo({super.key, required this.onNextPressed});

  final void Function() onNextPressed;

  @override
  State<SignupPersonalInfo> createState() => _SignupPersonalInfoState();
}

class _SignupPersonalInfoState extends State<SignupPersonalInfo> {
  ValueNotifier<String> countryCode = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
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
                    keyboardType: TextInputType.text,
                    hintText: 'اسمك',
                    validator: (value) {},
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
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'بريدك الالكتروني',
                    validator: (value) {},
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
                  SizedBox(
                    height: 54.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            keyboardType: TextInputType.phone,
                            hintText: 'رقم الجوال',
                            validator: (value) {},
                          ),
                        ),
                        horizontalSpace(8),
                        CustomCountryCodePicker(code: countryCode),
                      ],
                    ),
                  ),
                  verticalSpace(40),
                  Spacer(),
                  CustomElevatedButton(
                    onPressed: widget.onNextPressed,
                    textButton: 'التالي',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
