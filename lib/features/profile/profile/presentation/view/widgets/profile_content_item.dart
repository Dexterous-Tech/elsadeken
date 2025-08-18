import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileContentItem extends StatelessWidget {
  const ProfileContentItem({
    super.key,
    required this.image,
    required this.title,
    this.onPressed,
    this.leading,
  });

  final String image;
  final String title;
  final void Function()? onPressed;

  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Image.asset(image, width: 44.w, height: 44.h),
            horizontalSpace(16),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: AppTextStyles.font14CharlestonGreenMediumLamaSans,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            leading ??
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.gray,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
