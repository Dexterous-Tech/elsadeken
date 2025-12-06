import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_arrow_back.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    this.background,
    this.showBackButton = true,
    this.titleStyle,
    this.onPressed,
    this.shape,
    this.sizeContainer,
  });

  final String title;
  final Color? background;
  final bool showBackButton;
  final TextStyle? titleStyle;
  final void Function()? onPressed;
  final BoxShape? shape;
  final double? sizeContainer;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          CustomArrowBack(
            sizeContainer: sizeContainer,
            background: background ?? AppColors.white,
            onPressed: onPressed,
            shape: shape,
          )
        else
          SizedBox(
            width: 30.w,
            height: 30.h,
          ),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle ??
                AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeightHelper.medium,
                  fontFamily: 'Lama Sans',
                  color: AppColors.darkBlue,
                ),
          ),
        ),
        SizedBox(
          width: 30.w,
          height: 30.h,
        ),
      ],
    );
  }
}
