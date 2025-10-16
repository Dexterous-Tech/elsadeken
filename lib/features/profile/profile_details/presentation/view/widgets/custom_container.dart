import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.img,
    required this.text,
    this.onTap,
  });

  final String text;
  final String img;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100).r,
              child: Image.asset(
                img,
                width: 47.w,
                height: 47.h,
              )),
        ),
        Text(
          text,
          style: AppTextStyles.font11GreyRegularLamaSansArabic,
        ),
      ],
    );
  }
}
