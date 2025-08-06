import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_color.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../custom_next_and_previous_button.dart';

class SignupCountry extends StatelessWidget {
  const SignupCountry({
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
                    'ما هي دولتك ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: '..بحث',
                    validator: (value) {},
                    suffixIcon: Icon(
                      Icons.search,
                      size: 25,
                      color: AppColors.paleBrown,
                    ),
                    hintStyle: AppTextStyles.font16PaleBrownRegularLamaSans(
                      context,
                    ),
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
