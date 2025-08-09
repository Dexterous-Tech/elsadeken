import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';
import '../../theme/app_text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.paddingButton,
    required this.onPressed,
    this.textButton,
    this.styleTextButton,
    this.backgroundColor,
    this.horizontalPadding,
    this.buttonWidget,
    this.verticalPadding,
    this.border,
    this.radius,
  });

  final EdgeInsetsGeometry? paddingButton;
  final void Function() onPressed;
  final String? textButton;

  final TextStyle? styleTextButton;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? buttonWidget;
  final BoxBorder? border;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        width: double.infinity,
        padding: paddingButton ??
            EdgeInsets.symmetric(
              vertical: verticalPadding ?? 10.h,
              horizontal: horizontalPadding ?? 10.w,
            ),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: backgroundColor == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // stops: [0.65, 0.5],
                  colors: [
                    AppColors.sunray,
                    AppColors.giantsOrange.withValues(alpha: 1.65),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(radius ?? 30.31),
          border: border,
        ),
        child: buttonWidget ??
            Center(
              child: Text(
                textButton ?? '',
                textAlign: TextAlign.center,
                style: styleTextButton ??
                    AppTextStyles.font16CulturedMediumPlexSans(context),
              ),
            ),
      ),
    );
    // return ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     padding:
    //         paddingButton ??
    //         EdgeInsets.symmetric(
    //           vertical: verticalPadding ?? 25.h,
    //           horizontal: horizontalPadding ?? 0,
    //         ),
    //     backgroundColor: backgroundColor ?? AppColor.pumpkinOrange,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(radius ?? 30),
    //       side: side ?? BorderSide.none,
    //     ),
    //   ),
    //   onPressed: onPressed,
    //   child:
    //       buttonWidget ??
    //       Center(
    //         child: Text(
    //           textButton ?? '',
    //           textAlign: TextAlign.center,
    //           style:
    //               styleTextButton ??
    //               AppTextStyles.font16CulturedMediumPlexSans(context),
    //         ),
    //       ),
    // );
  }
}
