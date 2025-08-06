import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileCustomSeparator extends StatelessWidget {
  const ManageProfileCustomSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
      child: Container(
        height: 1,
        color: AppColors.black.withValues(alpha: 0.04),
      ),
    );
  }
}
