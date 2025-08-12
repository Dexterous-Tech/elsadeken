import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/auth/new_password/presentation/manager/reset_password_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key, required this.email});

  final String email;
  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    var cubit = ResetPasswordCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'كلمه المرور الجديده',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.newPasswordController,
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            hintText: '********',
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'كلمة المرور يجب أن تكون أكثر من 6 أحرف';
              }
              return null;
            },
            prefixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
                size: 16,
                color: AppColors.lightTaupe,
              ),
            ),
          ),
          verticalSpace(24),
          Text(
            'تاكيد كلمه المرور',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.newConfirmPasswordController,
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            hintText: '********',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يجب تأكيد كلمة المرور';
              }
              if (value != cubit.newPasswordController.text) {
                return 'كلمة المرور غير متطابقة';
              }
              return null;
            },
            prefixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
                size: 16,
                color: AppColors.lightTaupe,
              ),
            ),
          ),
          verticalSpace(58),
          CustomElevatedButton(
            onPressed: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.resetPassword(widget.email);
              }
            },
            textButton: 'تحديث كلمة المرور',
          ),
        ],
      ),
    );
  }
}
