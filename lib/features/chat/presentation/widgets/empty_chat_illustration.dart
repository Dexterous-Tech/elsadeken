import 'package:elsadeken/core/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyChatIllustration extends StatelessWidget {
  const EmptyChatIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 200.h,
      child: Image.asset(AppImages.emptyChatImage, fit: BoxFit.contain)
    );
  }
}
