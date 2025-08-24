import 'package:elsadeken/core/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';

class ChatOptionsCard extends StatelessWidget {
  const ChatOptionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:  const Color(0xFFF7D4D8),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message Settings
          _buildOptionItem(
            image_icon: AppImages.settingsIcon,
            text: 'إعدادات الرسائل',
            iconColor: Colors.grey.shade100,
            onTap: () {
              // Navigate to message settings
            },
          ),
          
          Divider(height: 1.h, color: Colors.grey[300]),
          
          // Delete Chats
          _buildOptionItem(
            image_icon: AppImages.deleteChatIcon,
            text: 'حذف المحادثات',
            iconColor: Colors.blue,
            onTap: () {
              // _showDeleteConfirmationDialog(context);
            },
          ),
          
          Divider(height: 1.h, color: Colors.grey[300]),
          
          // Mark All as Read
          _buildOptionItem(
            image_icon: AppImages.readChatIcon,
            text: 'وضع علامة مقروء على جميع المحادثات',
            iconColor: Colors.green,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String image_icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Image.asset(
              image_icon,
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                  color: AppColors.darkerBlue,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  // void _showDeleteConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.r),
  //         ),
  //         title: Text(
  //           'حذف المحادثات',
  //           style: AppTextStyles.font40BlackSemiBoldPlexSans,
  //           textAlign: TextAlign.center,
  //         ),
  //         content: Text(
  //           'هل أنت متأكد من حذف جميع المحادثات؟ لا يمكن التراجع عن هذا الإجراء.',
  //           style: AppTextStyles.font16BlackSemiBoldLamaSans,
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text(
  //               'إلغاء',
  //               style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
  //                 color: Colors.grey[600],
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {},
  //             child: Text(
  //               'حذف',
  //               style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
  //                 color: Colors.red,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
