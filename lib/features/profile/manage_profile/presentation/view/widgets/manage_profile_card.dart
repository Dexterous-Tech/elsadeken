import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileCard extends StatelessWidget {
  const ManageProfileCard({
    super.key,
    required this.title,
    required this.cardContent,
  });

  final String title;
  final Widget cardContent;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.only(
        top: 12.h,
        left: 27.w,
        right: 27.w,
        bottom: 29.h,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: AppColors.lightCarminePink.withValues(alpha: 0.05),
      ),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: AppTextStyles.font18JetBoldLamaSans,
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpace(15),
          cardContent,
        ],
      ),
    );
  }
}
