import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/core/services/localization_service.dart';

Future<void> oathDialog({
  required BuildContext context,
  bool value = false,
}) async {
  await showDialog(
    barrierColor: Color(0xFF120B03).withValues(alpha: 0.7),
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate to login screen when back button is pressed
          Navigator.of(context).pop(); // Close dialog first
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.loginScreen,
            (route) => false,
          );
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20).r,
          ),
          backgroundColor: Colors.transparent,
          child: FittedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20).r,
              child: Container(
                width: 370.w,
                padding: EdgeInsetsGeometry.symmetric(vertical: 70.h, horizontal: 30.w),
                decoration: ShapeDecoration(
                  color: Color(0xFFFFF9F2).withValues(alpha: 0.721),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                ),
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.greetingSalam,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font22BistreSemiBoldLamaSans,
            ),
            // verticalSpace(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Text(
                AppLocalizations.of(context)!.freeRegistration,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyles.font15BistreSemiBoldLamaSans
                    .copyWith(fontWeight: FontWeightHelper.medium),
              ),
            ),
            verticalSpace(48),
            Text(
              AppLocalizations.of(context)!.oathFormat,
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
                    style:
                        AppTextStyles.font14PumpkinOrangeBoldLamaSans.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFC86D22),
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
                  AppLocalizations.of(context)!.oathAcceptance,
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
                  ? () async {
                      // Mark onboarding as completed
                      await SharedPreferencesHelper.setIsOnboardingCompleted(
                          true);
                      context.pushNamed(AppRoutes.signupScreen,
                          arguments: 'male');
                    }
                  : () {},
              // verticalPadding: 17.32.h,
              textButton: AppLocalizations.of(context)!.registerMaleFree,
              backgroundColor: AppColors.darkSunray,
            ),
            verticalSpace(14),
            CustomElevatedButton(
              height: 45.63711166381836.h,
              onPressed: value
                  ? () async {
                      // Mark onboarding as completed
                      await SharedPreferencesHelper.setIsOnboardingCompleted(
                          true);
                      context.pushNamed(AppRoutes.signupScreen,
                          arguments: 'female');
                    }
                  : () {},
              // verticalPadding: 17.32.h,
              textButton: AppLocalizations.of(context)!.registerFemaleFree,
              backgroundColor: AppColors.desire.withValues(alpha: 0.474),
              border: Border.all(color: AppColors.white),
            ),
          ],
        );
      },
    ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
