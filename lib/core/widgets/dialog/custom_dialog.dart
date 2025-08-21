import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_color.dart';

Future customDialog({
  required BuildContext context,
  required Widget dialogContent,
  double? height,
  double? width,
  double? radius,
  EdgeInsetsGeometry? padding,
  Color? backgroundColor,
}) async {
  final result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true); // Always pop with true
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 20).r,
        ),
        backgroundColor:
            Colors.transparent, // Important: Transparent background
        child: FittedBox(
          child: Container(
            width: width ?? 370.w,
            height: height,
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: ShapeDecoration(
              color: backgroundColor ??
                  AppColors.papayaWhip.withValues(alpha: 0.86),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(radius ?? 20).r,
              ),
            ),
            child: dialogContent,
          ),
        ),
      ),
    ),
  );

  return result ?? false;
}
