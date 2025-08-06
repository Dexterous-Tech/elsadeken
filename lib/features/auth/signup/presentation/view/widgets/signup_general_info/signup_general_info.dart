import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../custom_next_and_previous_button.dart';

class SignupGeneralInfo extends StatelessWidget {
  const SignupGeneralInfo({
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
                  Text(
                    'كم عمرك ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    hintText: '25',
                    validator: (value) {},
                  ),
                  verticalSpace(40),
                  Text(
                    'كم عدد الاطفال ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    hintText: '0',
                    validator: (value) {},
                  ),
                  verticalSpace(40),
                  Text(
                    'كم وزنك (كجم) ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    hintText: '70',
                    validator: (value) {},
                  ),
                  verticalSpace(40),
                  Text(
                    'كم طولك (سم) ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    hintText: '180',
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
