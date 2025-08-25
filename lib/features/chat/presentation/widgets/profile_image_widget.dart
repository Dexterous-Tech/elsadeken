import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double? borderWidth;
  final Color? borderColor;
  final bool showOnlineIndicator;

  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    this.size = 50,
    this.borderWidth = 1,
    this.borderColor,
    this.showOnlineIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor ?? Colors.grey[300]!,
              width: borderWidth!,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: size.w,
              height: size.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size.w,
                  height: size.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: (size * 0.5).w,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        ),
        if (showOnlineIndicator)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: (size * 0.24).w,
              height: (size * 0.24).w,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
