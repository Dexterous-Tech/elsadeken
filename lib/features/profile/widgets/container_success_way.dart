import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_styles.dart';

class ContainerSuccessWay extends StatelessWidget {
  const ContainerSuccessWay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lighterOrange,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Center(
        child: Text(
          'دليلـــــك نحــــــو النجــــــــاح',
          style: AppTextStyles.font20LightOrangeMediumLamaSans
              .copyWith(color: AppColors.jasper),
        ),
      ),
    );
  }
}
