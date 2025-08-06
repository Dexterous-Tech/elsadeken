import 'package:flutter/material.dart';

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
                    'ما هي مواصفات شريكه حياتك التي ترغب الارتباط بها ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: 'اكتب',
                    maxLines: 5,
                    validator: (value) {},
                  ),
                  verticalSpace(40),

                  // email
                  Text(
                    'تحدث عن نفسك',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'اكتب',
                    maxLines: 5,
                    validator: (value) {},
                  ),

                  verticalSpace(50),

                  Spacer(),
                  CustomNextAndPreviousButton(
                    onNextPressed: onNextPressed,
                    onPreviousPressed: onPreviousPressed,
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
