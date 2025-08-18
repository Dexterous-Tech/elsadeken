import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_color.dart';

class CustomAuthCard extends StatelessWidget {
  const CustomAuthCard({super.key, required this.cardContent});

  final Widget cardContent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(30).r, // Clip blur inside rounded card
      child: SizedBox(
        width: double.infinity,
        height: 628.h,
        child: Stack(
          children: [
            // Apply blur to whatever is behind this card
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Container(
                color: Colors.transparent, // Must be non-null to apply blur
              ),
            ),

            // Add the gradient and content
            Container(
              padding: EdgeInsets.only(
                right: 14.w,
                top: 47.5.h,
                left: 23.w,
                bottom: 59.5.h,
              ),
              decoration: ShapeDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  colors: [
                    AppColors.sinopia.withValues(alpha: 0.15),
                    AppColors.lightCarminePink.withValues(alpha: 0.07),
                  ],
                  stops: [1.0, 0.77],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: cardContent,
            ),
          ],
        ),
      ),
    );
  }
}
