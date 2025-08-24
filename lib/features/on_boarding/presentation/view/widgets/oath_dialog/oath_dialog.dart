import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/custom_radio.dart';
import 'package:elsadeken/features/profile/about_us/presentation/view/about_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/presentation/view/terms_and_conditions_screen.dart';

Future<void> oathDialog({
  required BuildContext context,
  bool value = false,
}) async {
  await customDialog(
    context: context,
    padding: EdgeInsetsGeometry.symmetric(vertical: 50.h, horizontal: 30.w),
    dialogContent: StatefulBuilder(
      builder: (context, setStateDialog) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'السلام عليكم ورحمة الله',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font22BistreSemiBoldLamaSans,
            ),
            verticalSpace(6),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'لإتاحة الفرصة لجميع الأعضاء، فإن\n التسجيل مجاني.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyles.font15BistreSemiBoldLamaSans
                    .copyWith(fontWeight: FontWeightHelper.medium),
              ),
            ),
            verticalSpace(48),
            Text(
              'صيغة القسم:',
              style: AppTextStyles.font15BistreSemiBoldLamaSans
                  .copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            Text(
              '\n\n«أقسم بالله العظيم أنني سجلت في هذا التطبيق زواجًا شرعيًا، وأن قصدي جاد وصادق في بناء أسرة قائمة على المودة والرحمة، وفقًا لأحكام الشريعة الإسلامية.',
              style: AppTextStyles.font15BistreSemiBoldLamaSans
                  .copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            RichText(
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: AppTextStyles.font15BistreSemiBoldLamaSans
                    .copyWith(color: AppColors.black),
                children: [
                  const TextSpan(
                    text: '\n\nوأتعهد بالالتزام الكامل ',
                  ),
                  TextSpan(
                    text: 'بشروط وقوانين',
                    style: AppTextStyles.font15BistreSemiBoldLamaSans.copyWith(
                      color: AppColors.pumpkinOrange,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.pushNamed(AppRoutes.termsAndConditionsScreen);
                      },
                  ),
                  const TextSpan(
                    text:
                        ' هذا التطبيق، وعدم استخدامه لأي غرض يسيء للدين أو الأخلاق أو يخالف ما وضع له من أهداف، والله على ما أقول شهيد.».',
                  ),
                ],
              ),
            ),
            verticalSpace(28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'لقد قمت باداء القسم وسالتزم به',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font14PumpkinOrangeBoldLamaSans,
                ),
                horizontalSpace(10),
                CustomRadio(
                  value: value,
                  onChanged: () {
                    setStateDialog(() {
                      value = !value;
                    });
                  },
                ),
              ],
            ),
            verticalSpace(48),
            CustomElevatedButton(
              height: 45.63711166381836.h,
              onPressed: value
                  ? () {
                      context.pushNamed(AppRoutes.signupScreen,
                          arguments: 'male');
                    }
                  : () {},
              // verticalPadding: 17.32.h,
              textButton: 'تسجيل كزوج مجانا (ذكر)',
              backgroundColor: AppColors.darkSunray,
            ),
            verticalSpace(14),
            CustomElevatedButton(
              height: 45.63711166381836.h,
              onPressed: value
                  ? () {
                      context.pushNamed(AppRoutes.signupScreen,
                          arguments: 'female');
                    }
                  : () {},
              // verticalPadding: 17.32.h,
              textButton: 'تسجيل كزوجة مجانا (انثي)',
              backgroundColor: AppColors.desire.withValues(alpha: 0.474),
              border: Border.all(color: AppColors.white),
            ),
          ],
        );
      },
    ),
  );
}
