import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupStepsProgress extends StatelessWidget {
  const SignupStepsProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100).r,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor:
              AppColors.seashell, // Or AppColor.gainsboro as in your example
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.philippineBronze),
          minHeight: 10.h, // Using .h for responsive height
          borderRadius: BorderRadius.circular(100).r, // For rounded corners
        ),
      ),
    );
  }
}
