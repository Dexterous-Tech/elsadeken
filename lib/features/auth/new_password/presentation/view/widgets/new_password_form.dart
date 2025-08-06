import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  bool obscurePassword = false;
  bool obscureConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'كلمه المرور الجديده',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
        ),
        verticalSpace(8),
        CustomTextFormField(
          obscureText: obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          hintText: '********',
          validator: (value) {},
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: Icon(
              CupertinoIcons.eye_slash_fill,
              size: 16,
              color: AppColors.lightTaupe,
            ),
          ),
          onChanged: (value) {},
        ),
        verticalSpace(24),
        Text(
          'تاكيد كلمه المرور',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
        ),
        verticalSpace(8),
        CustomTextFormField(
          obscureText: obscureConfirmPassword,
          keyboardType: TextInputType.visiblePassword,
          hintText: '********',
          validator: (value) {},
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              });
            },
            icon: Icon(
              CupertinoIcons.eye_slash_fill,
              size: 16,
              color: AppColors.lightTaupe,
            ),
          ),
        ),
      ],
    );
  }
}
