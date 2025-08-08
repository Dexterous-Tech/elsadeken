import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'profile_lists_item_logo.dart';
import 'package:flutter/material.dart';

class ProfileListsItem extends StatelessWidget {
  const ProfileListsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        ProfileListsItemLogo(),
        horizontalSpace(16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Muhammed ibrahim',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font14BlackSemiBoldLamaSans,
              ),
              Text(
                'Okay then lets meet in 15 mi.. ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12JetRegularLamaSans,
              ),
            ],
          ),
        ),
        Spacer(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'منذ دقيقه',
                maxLines: 1,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12JetRegularLamaSans,
              ),
              verticalSpace(6),
              Container(
                width: 19.w,
                height: 19.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.redLight),
                child: Center(
                  child: Text(
                    '1',
                    style: AppTextStyles.font18WhiteSemiBoldLamaSans
                        .copyWith(fontSize: 11.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
