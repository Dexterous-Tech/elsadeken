import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileContentText extends StatelessWidget {
  const ManageProfileContentText({
    super.key,
    required this.text,
    this.isLoading = false,
    this.textColor,
    this.textStyle,
    this.textAlign,
    this.isBorder = false,
  });

  final String text;
  final bool isLoading;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final bool isBorder;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 20.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: AppColors.gray.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: SizedBox(
            height: 12,
            width: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.philippineBronze),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: isBorder
          ? EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w)
          : null,
      decoration: isBorder
          ? BoxDecoration(
              color: AppColors.snow,
              borderRadius: BorderRadius.circular(16).r,
              border: Border.all(color: AppColors.brown))
          : null,
      child: Text(
        text.isEmpty ? AppLocalizations.of(context)!.notSpecified : text,

        textDirection: LocalizationService.instance.textDirection,
        textAlign:
            textAlign ?? LocalizationService.instance.convertTextAlignment,
        style: textStyle ??
            AppTextStyles.font18PhilippineBronzeRegularLamaSans.copyWith(
              color: textColor,
            ),
        // textDirection: TextDirection.rtl,
      ),
    );
  }
}
