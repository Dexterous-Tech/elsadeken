import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListsItemLogo extends StatelessWidget {
  const ProfileListsItemLogo({super.key, this.image, this.isSpecial = false});

  final String? image;
  final bool isSpecial;

  @override
  Widget build(BuildContext context) {
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(100),
    //   child: CustomImageNetwork(
    //     image: image ?? '',
    //     width: 58.w,
    //     height: 58.h,
    //   ),
    // );
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CustomImageNetwork(
            image: image ?? '',
            width: 58.w,
            height: 58.h,
          ),
        ),
        if (isSpecial)
          Positioned(
              bottom: -5,
              right: 0,
              child: Image.asset(
                AppImages.specialMember,
                width: 22.w,
                height: 22,
              ))
      ],
    );
  }
}
