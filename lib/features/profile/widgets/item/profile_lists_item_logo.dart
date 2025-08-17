import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListsItemLogo extends StatelessWidget {
  const ProfileListsItemLogo({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Image.network(
          image!,
          width: 58.w,
          height: 58.h,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          right: 3,
          child: Container(
            width: 13.w,
            height: 13.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green,
              border: Border.all(
                color: AppColors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
