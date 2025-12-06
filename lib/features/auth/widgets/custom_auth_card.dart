import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAuthCard extends StatelessWidget {
  const CustomAuthCard({super.key, required this.cardContent});

  final Widget cardContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 628.h,
      padding: EdgeInsets.only(
        right: 14.w,
        top: 47.5.h,
        left: 23.w,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: cardContent,
    );
  }
}
