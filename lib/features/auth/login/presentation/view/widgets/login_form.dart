import 'package:elsadeken/core/helper/app_regex.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:elsadeken/features/auth/login/presentation/view/widgets/login_create_new_account.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var cubit = LoginCubit.get(context);
    final tr = AppLocalizations.of(context)!; // shortcut

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ will flip in RTL
        textDirection: LocalizationService.instance.textDirection,
        children: [
          Text(
            tr.login,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans,
          ),
          verticalSpace(24),
          Text(
            tr.email,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans,
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'user@gmail.com',
            validator: (value) {
              if (cubit.emailController.text.isNullOrEmpty() ||
                  !AppRegex.isEmailValid(value!)) {
                return tr.emailError;
              }
              return null;
            },
          ),
          verticalSpace(24),
          Text(
            tr.password,
            style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans,
          ),
          verticalSpace(8),
          CustomTextFormField(
            controller: cubit.passwordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: '********',
            validator: (value) {
              if (cubit.passwordController.text.isNullOrEmpty()) {
                return tr.passwordError;
              }
              return null;
            },
            obscureText: obscurePassword,
            suffixIcon: IconButton(
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
              tr.forgotPassword,
              style: AppTextStyles.font14BeerMediumLamaSans,
            ),
          ),
          verticalSpace(31),
          CustomElevatedButton(
            onPressed: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.login();
              }
            },
            textButton: tr.login,
          ),
          const Spacer(),
          const Center(child: LoginCreateNewAccount()),
        ],
      ),
    );
  }
}
