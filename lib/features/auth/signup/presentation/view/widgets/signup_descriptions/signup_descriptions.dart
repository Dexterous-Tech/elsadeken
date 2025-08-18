import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../custom_next_and_previous_button.dart';

class SignupDescriptions extends StatelessWidget {
  const SignupDescriptions({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
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
                  Text('ما هي مواصفات شريكه حياتك التي ترغب الارتباط بها ؟',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                  verticalSpace(16),

                  CustomTextFormField(
                    controller: cubit.aboutMeController,
                    keyboardType: TextInputType.text,
                    hintText: 'اكتب',
                    maxLines: 5,
                    // inputFormatters: [
                    //   // Allow only Arabic & English letters and spaces
                    //   FilteringTextInputFormatter.allow(
                    //       RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                    // ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }

                      final trimmedValue = value.trim();

                      // Block numbers
                      if (RegExp(r'\d').hasMatch(trimmedValue)) {
                        return 'لا يمكن أن يحتوي النص على أرقام';
                      }

                      // Block anything that looks like a phone number (8–15 consecutive digits)
                      if (RegExp(r'\d{8,15}').hasMatch(trimmedValue)) {
                        return 'لا يمكن إدخال رقم هاتف هنا';
                      }

                      // Block links
                      if (RegExp(r'(https?://|www\.|\.com|\.net|\.org)',
                              caseSensitive: false)
                          .hasMatch(trimmedValue)) {
                        return 'لا يمكن أن يحتوي النص على روابط';
                      }

                      return null;
                    },
                  ),

                  verticalSpace(40),

                  // email
                  Text('تحدث عن نفسك',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                  verticalSpace(16),
                  CustomTextFormField(
                    controller: cubit.lifePartnerController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'اكتب',
                    maxLines: 5,
                    // inputFormatters: [
                    //   // Allow only Arabic & English letters and spaces
                    //   FilteringTextInputFormatter.allow(
                    //       RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                    // ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }

                      final trimmedValue = value.trim();

                      // Block numbers
                      if (RegExp(r'\d').hasMatch(trimmedValue)) {
                        return 'لا يمكن أن يحتوي النص على أرقام';
                      }

                      // Block anything that looks like a phone number (8–15 consecutive digits)
                      if (RegExp(r'\d{8,15}').hasMatch(trimmedValue)) {
                        return 'لا يمكن إدخال رقم هاتف هنا';
                      }

                      // Block links
                      if (RegExp(r'(https?://|www\.|\.com|\.net|\.org)',
                              caseSensitive: false)
                          .hasMatch(trimmedValue)) {
                        return 'لا يمكن أن يحتوي النص على روابط';
                      }

                      return null;
                    },
                  ),

                  verticalSpace(50),

                  Spacer(),
                  CustomNextAndPreviousButton(
                    onNextPressed: onNextPressed,
                    onPreviousPressed: onPreviousPressed,
                    isNextEnabled: _canProceedToNext(cubit),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
    // Check if all controllers have non-empty values
    bool hasAboutMe = cubit.aboutMeController.text.trim().isNotEmpty;
    bool hasPartner = cubit.lifePartnerController.text.trim().isNotEmpty;

    return hasAboutMe && hasPartner;
  }
}
