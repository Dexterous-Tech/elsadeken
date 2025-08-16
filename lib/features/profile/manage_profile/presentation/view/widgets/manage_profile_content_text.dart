import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileContentText extends StatelessWidget {
  const ManageProfileContentText({
    super.key,
    required this.text,
    this.isLoading = false,
    this.textColor,
    this.textStyle,
  });

  final String text;
  final bool isLoading;
  final Color? textColor;
  final TextStyle? textStyle;

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

    return Text(
      text.isEmpty ? 'غير محدد' : text,
      style: textStyle ??
          AppTextStyles.font18PhilippineBronzeRegularPlexSans.copyWith(
            color: textColor,
          ),
    );
  }
}
