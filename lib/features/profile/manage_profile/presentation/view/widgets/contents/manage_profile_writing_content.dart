import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileWritingContent extends StatelessWidget {
  const ManageProfileWritingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verticalSpace(9),
        Container(
          width: 301.w,
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: AppColors.white,
          ),
        ),
        verticalSpace(11),
        Text(
          'يرجى الكتابة بطريقة جادة يمنع ف هذا القسم كتابة بريدك الإلكتروني أو رقم هاتفك',
          style: AppTextStyles.font14JetRegularPlexSans(
            context,
          ).copyWith(color: AppColors.jasper),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
