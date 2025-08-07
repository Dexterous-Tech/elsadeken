import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsCardItem extends StatelessWidget {
  const ProfileDetailsCardItem(
      {super.key, required this.itemTitle, required this.itemSubTitle});

  final String itemTitle;
  final String itemSubTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemTitle,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font18GreyRegularLamaSans,
          ),
          Container(
            width: 194.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.lightRose,
              borderRadius: BorderRadius.circular(8).r,
            ),
            child: Center(
              child: Text(
                itemSubTitle,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.font12PhilippineBronzeMediumPlexSans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
