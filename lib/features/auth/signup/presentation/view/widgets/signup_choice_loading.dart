import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';

class SignupChoiceLoading extends StatelessWidget {
  const SignupChoiceLoading({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
        ),
        verticalSpace(16),
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
          ),
        ),
        verticalSpace(40),
      ],
    );
  }
}
