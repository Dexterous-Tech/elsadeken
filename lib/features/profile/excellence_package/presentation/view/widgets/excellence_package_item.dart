import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';

class ExcellencePackageItem extends StatelessWidget {
  const ExcellencePackageItem(
      {super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          margin:
              const EdgeInsets.only(top: 6), // Aligns bullet with first line
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColors.lightOrange),
        ),
        horizontalSpace(16),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: title,
                    style: AppTextStyles.font19LightOrangeSemiBoldLamaSans),
                TextSpan(
                  text: subTitle,
                  style: AppTextStyles.font19JetRegularLamaSans,
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
