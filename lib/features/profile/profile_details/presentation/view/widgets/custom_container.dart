import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.img,
    required this.color,
    required this.text,
    this.onTap,
  });

  final String text;
  final String img;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 47,
            height: 67,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Image.asset(img),
          ),
        ),
        Text(
          text,
          style: AppTextStyles.font11GreyRegularLamaSansArabic,
        ),
      ],
    );
  }
}
