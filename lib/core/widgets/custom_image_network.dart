import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork(
      {super.key, required this.image, this.width, this.height});

  final String image;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image, size: 24.sp),
      ),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Center(
              child: SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryOrange,
                  ))),
    );
  }
}
