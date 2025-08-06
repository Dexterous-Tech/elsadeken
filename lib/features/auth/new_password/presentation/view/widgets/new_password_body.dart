import 'package:elsadeken/features/auth/new_password/presentation/view/widgets/new_password_form.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../widgets/custom_auth_body.dart';

class NewPasswordBody extends StatelessWidget {
  const NewPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
      cardContent: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'كلمه المرور الجديده',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans(context),
          ),
          Text(
            'قم بادخال كمله مرور جديده وقويه',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14BeerMediumLamaSans(
              context,
            ).copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          NewPasswordForm(),
          Spacer(),

          CustomElevatedButton(
            onPressed: () {},
            textButton: 'اعادة تسجيل الدخول',
          ),
        ],
      ),
    );
  }
}
