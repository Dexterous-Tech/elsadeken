import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final String avatarAsset;
  final VoidCallback onTap;

  const MenuItemWidget({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.avatarAsset,
    required this.onTap,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // final isHighlighted = _isPressed;
    // final textColor = isHighlighted ? Colors.white : Colors.black;
    final bgColor = _isPressed ? Color(0xffF0E7D6) : AppColors.white;

    return GestureDetector(
      onTap: () async {
        setState(() => _isPressed = true);
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          setState(() => _isPressed = false);
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 75.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          textDirection: LocalizationService.instance.textDirection,
          children: [
            _buildAvatar(),
            horizontalSpace(14),
            Text(
              widget.title,
              style: AppTextStyles.font14BlackSemiBoldLamaSans,
              textDirection: LocalizationService.instance.textDirection,
              textAlign: LocalizationService.instance.textAlignment,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios, // point left in LTR
              size: 15.sp,
              color: Color(0xff7F909F),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          width: 46.w,
          height: 46.h,
          widget.avatarAsset,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.person, size: 28, color: Colors.grey[600]),
            );
          },
        ),
      ),
    );
  }
}
