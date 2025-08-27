import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

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
    barrierColor: Color(0xFF120B03).withValues(alpha: 0.7),
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true); // Always pop with true
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 20).r,
          ),
          backgroundColor: Colors.transparent,
          child: FittedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius ?? 20).r,
              child: Container(
                width: width ?? 370.w,
                height: height,
                padding: padding ??
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: ShapeDecoration(
                  color: backgroundColor ??
                      Color(0xFFFFF9F2).withValues(alpha: 0.721),
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
      ),
    ),
  );

  return result ?? false;
}
