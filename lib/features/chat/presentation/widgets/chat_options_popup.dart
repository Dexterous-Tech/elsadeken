import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';

class ChatOptionsPopup extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onMute;
  final VoidCallback onBlock;
  final VoidCallback onAddToFavorites;
  final bool isChatFavorite;

  const ChatOptionsPopup({
    Key? key,
    required this.onDelete,
    required this.onMute,
    required this.onBlock,
    required this.onAddToFavorites,
    this.isChatFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 31.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Delete Chat
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/trash.png',
                  text: 'مسح الدردشة',
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Mute
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/mute.png',
                  text: 'وضع الصامت',
                  onTap: () {
                    Navigator.pop(context);
                    onMute();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Block User
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/block-user.png',
                  text: 'حظر المستخدم',
                  onTap: () {
                    Navigator.pop(context);
                    onBlock();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Add to Favorites / Remove from Favorites
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/heart.png',
                  text: isChatFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                  onTap: () {
                    Navigator.pop(context);
                    onAddToFavorites();
                  },
                  iconColor: isChatFavorite ? Colors.red : null,
                ),
              ],
            ),
          ),
          verticalSpace(10),
          // Cancel Button
          CustomElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textButton: 'الغاء',
            height: 56.h,
            radius: 10.r,
            styleTextButton: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.jet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required String imagePath,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.font18BabyBlueRegularLamaSans,
                    textDirection: TextDirection.rtl,
                  ),
                  horizontalSpace(16),
                  Image.asset(
                    imagePath,
                    width: 24.w,
                    height: 24.w,
                    color: iconColor,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}
