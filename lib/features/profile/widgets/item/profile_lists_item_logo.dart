import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListsItemLogo extends StatelessWidget {
  const ProfileListsItemLogo({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CustomImageNetwork(
        image: image ?? '',
        width: 58.w,
        height: 58.h,
      ),
    );
    // return Stack(
    //   alignment: Alignment.bottomRight,
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(100),
    //       child: CustomImageNetwork(
    //         image: image ?? '',
    //         width: 58.w,
    //         height: 58.h,
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 0,
    //       right: 3,
    //       child: Container(
    //         width: 13.w,
    //         height: 13.h,
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           color: AppColors.green,
    //           border: Border.all(
    //             color: AppColors.white,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}
