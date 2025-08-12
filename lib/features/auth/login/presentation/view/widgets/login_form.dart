import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../core/widgets/forms/custom_text_form_field.dart';
import 'login_create_new_account.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obscurePassword = false;
  @override
  Widget build(BuildContext context) {
    var cubit = LoginCubit.get(context);
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'تسجيل الدخول',
            style: AppTextStyles.font27ChineseBlackBoldLamaSans(context),
          ),
          verticalSpace(24),
          Text(
            'بريد إلكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'user@gmail.com',
            validator: (value) {
              if (cubit.emailController.text.isNullOrEmpty() ||
                  AppRegex.isEmailValid(value!)) {
                return 'Tou must add valid email';
              }
            },
          ),
          verticalSpace(24),
          Text(
            'كلمه المرور',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans(context),
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.passwordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: '********',
            validator: (value) {
              if (cubit.passwordController.text.isNullOrEmpty()) {
                return 'You must add password';
              }
            },
            obscureText: obscurePassword,
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
          verticalSpace(12),
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoutes.forgetPasswordScreen);
            },
            child: Text(
              'نسيت كلمه المرور؟',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font14BeerMediumLamaSans(context),
            ),
          ),
          verticalSpace(31),
          CustomElevatedButton(
            onPressed: () {
              if(cubit.formKey.currentState!.validate()){
                cubit.login();
              }
            },
            textButton: 'تسجيل الدخول',
          ),
          Spacer(),
          Center(child: LoginCreateNewAccount()),
        ],
      ),
    );
  }
}
