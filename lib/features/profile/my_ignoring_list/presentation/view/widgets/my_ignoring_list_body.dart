import 'package:elsadeken/features/profile/my_ignoring_list/presentation/view/widgets/my_ignoring_list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/font_weight_helper.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/widgets/custom_arrow_back.dart';

class MyIgnoringListBody extends StatelessWidget {
  const MyIgnoringListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomArrowBack(),
              Text(
                'قائمة التجاهل',
                style: AppTextStyles.font20WhiteBoldLamaSans(context).copyWith(
                  fontWeight: FontWeightHelper.medium,
                  color: AppColors.jet,
                ),
              ),
              SizedBox(),
            ],
          ),
          verticalSpace(42),
          Container(
            color: AppColors.lighterOrange,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Center(
              child: Text(
                'دليلـــــك نحــــــو النجــــــــاح',
                style: AppTextStyles.font20LightOrangeMediumPlexSans
                    .copyWith(color: AppColors.jasper),
              ),
            ),
          ),
          verticalSpace(32),
          Expanded(child: MyIgnoringListItems()),
        ],
      ),
    ));
  }
}
