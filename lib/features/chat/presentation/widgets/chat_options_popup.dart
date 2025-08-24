import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';

class ChatOptionsPopup extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onMute;
  final VoidCallback onBlock;
  final VoidCallback onAddToFavorites;

  const ChatOptionsPopup({
    Key? key,
    required this.onDelete,
    required this.onMute,
    required this.onBlock,
    required this.onAddToFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          SizedBox(height: 20.h),
          
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
          
          Divider(height: 1.h, color: Colors.grey[200]),
          
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
          
          Divider(height: 1.h, color: Colors.grey[200]),
          
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
          
          Divider(height: 1.h, color: Colors.grey[200]),
          
          // Add to Favorites
          _buildOptionItem(
            context,
            imagePath: 'assets/images/icons/heart.png',
            text: 'إضافة إلى المفضلة',
            onTap: () {
              Navigator.pop(context);
              onAddToFavorites();
            },
          ),
          
          SizedBox(height: 20.h),
          
          // Cancel Button
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7D4D8), // Light pink background
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: Text(
                'إلغاء',
                style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                  fontSize: 16.sp,
                ),
              ),
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl, // Set RTL direction
          children: [
            Text(
              text,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 24.w), // Spacing between text and icon
            Image.asset(
              imagePath,
              width: 24.w,
              height: 24.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
