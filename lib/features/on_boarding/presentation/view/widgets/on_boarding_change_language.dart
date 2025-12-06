import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_styles.dart';

class OnBoardingChangeLanguage extends StatelessWidget {
  const OnBoardingChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = LocalizationService.instance.isArabic;
    final code = isArabic ? 'en' : 'ar';
    final textCode = isArabic ? 'EN' : 'ع';
    return GestureDetector(
      onTap: () async {
        await LocalizationService.instance.changeLocale(code);
        // Show  after language change
        if (context.mounted) {
          LocalizationService.instance.showLanguageChangeSnackBar(context);
        }
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8).r,
        ),
        child: Center(
          child: Text(
            textCode,
            style: AppTextStyles.font16ChineseBlackMediumLamaSans.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
