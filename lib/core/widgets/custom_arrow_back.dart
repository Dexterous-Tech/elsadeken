import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomArrowBack extends StatelessWidget {
  const CustomArrowBack({
    super.key,
    this.background,
    this.onPressed,
    this.color,
    this.size,
    this.shape,
    this.sizeContainer,
  });

  final Color? background;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final BoxShape? shape;
  final double? sizeContainer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('CustomArrowBack: Back button pressed');
        if (onPressed != null) {
          onPressed!();
        } else {
          try {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              print('CustomArrowBack: Navigation successful');
            } else {
              print('CustomArrowBack: Cannot pop - no previous route');
              // Try alternative navigation methods
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
                print('CustomArrowBack: Root navigation successful');
              } else {
                print('CustomArrowBack: No navigation possible');
              }
            }
          } catch (e) {
            print('CustomArrowBack: Navigation error: $e');
          }
        }
      },
      child: Container(
        width: sizeContainer != null ? sizeContainer?.w : 30.w,
        height: sizeContainer != null ? sizeContainer?.h : 30.h,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.circle,
          color: background ?? Colors.transparent,
          borderRadius: shape != null ? BorderRadius.circular(8).r : null,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: color ?? Colors.black,
            size: size ?? 20,
          ),
        ),
      ),
    );
  }
}
