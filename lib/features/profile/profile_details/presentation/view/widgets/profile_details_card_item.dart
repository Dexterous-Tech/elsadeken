import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsCardItem extends StatelessWidget {
  const ProfileDetailsCardItem({
    super.key,
    required this.itemTitle,
    required this.itemSubTitle,
    this.loading = false,
  });

  final String itemTitle;
  final String itemSubTitle;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: LocalizationService.instance.textDirection,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              itemTitle,
              textDirection: LocalizationService.instance.textDirection,
              textAlign: LocalizationService.instance.isArabic
                  ? TextAlign.right
                  : TextAlign.left,
              style: AppTextStyles.font18GreyRegularLamaSans,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 194.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.lightRose,
              borderRadius: BorderRadius.circular(8).r,
            ),
            child: loading
                ? Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.philippineBronze,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      itemSubTitle,
                      textDirection: LocalizationService.instance.textDirection,
                      textAlign: LocalizationService.instance.isArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: AppTextStyles.font12PhilippineBronzeMediumLamaSans,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
