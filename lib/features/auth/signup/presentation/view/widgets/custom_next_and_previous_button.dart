import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';

class CustomNextAndPreviousButton extends StatelessWidget {
  const CustomNextAndPreviousButton({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
    this.isNextEnabled = true, this.textButton,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;
  final bool isNextEnabled;
  final String? textButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: isNextEnabled ? onNextPressed : () {},
            textButton: textButton ?? 'التالي',
            backgroundColor: isNextEnabled
                ? null // Use default gradient
                : AppColors.paleBrown.withValues(alpha: 0.5), // Disabled color
          ),
        ),
        horizontalSpace(16),
        Expanded(
          child: CustomElevatedButton(
            onPressed: onPreviousPressed,
            textButton: 'السابق',
            backgroundColor: AppColors.desire.withValues(alpha: 0.474),
          ),
        ),
      ],
    );
  }
}
