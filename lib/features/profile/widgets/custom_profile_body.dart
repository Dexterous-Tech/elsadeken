import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/app_images.dart';

class CustomProfileBody extends StatelessWidget {
  const CustomProfileBody(
      {super.key,
      required this.contentBody,
      this.padding,
      this.withStar = true});

  final Widget contentBody;
  final EdgeInsetsGeometry? padding;
  final bool withStar;
  @override
  Widget build(BuildContext context) {
    return withStar
        ? Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: -20,
                child: Image.asset(
                  AppImages.starProfile,
                  width: 488.w,
                  height: 325.h,
                ),
              ),
              SafeArea(
                child: Padding(
                    padding: padding ??
                        EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 16.h,
                        ),
                    child: contentBody),
              ),
            ],
          )
        : SafeArea(
            child: Padding(
                padding: padding ??
                    EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 16.h,
                    ),
                child: contentBody),
          );
  }
}
