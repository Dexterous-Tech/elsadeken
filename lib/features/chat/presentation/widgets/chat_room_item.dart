import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_options_popup.dart';
import 'package:elsadeken/features/chat/presentation/widgets/confirmation_dialog.dart';
import 'package:elsadeken/features/chat/presentation/widgets/profile_image_widget.dart';
import 'package:elsadeken/features/chat/presentation/widgets/time_formatter.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatData chat;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ChatRoomItem({
    super.key,
    required this.chat,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showChatOptions(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ProfileImageWidget(
              imageUrl: chat.otherUser.image,
              size: 50,
              showOnlineIndicator: false,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chat.otherUser.name,
                    style:
                        AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    chat.lastMessage?.body ?? 'لا توجد رسائل',
                    style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans
                        .copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  TimeFormatter.formatChatTime(
                    DateTime.tryParse(chat.lastMessage?.createdAt ?? '') ??
                        DateTime.now(),
                  ),
                  style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 6.h),
                if (chat.unreadCount > 0)
                  Container(
                    width: 20.w,
                    height: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ChatOptionsPopup(
        onDelete: () => _showDeleteConfirmation(context),
        onMute: () => _muteChat(context),
        onBlock: () => _blockUser(context),
        onAddToFavorites: () => _addToFavorites(context),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'تأكيد الحذف',
        message:
            'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
        confirmText: 'حذف',
        confirmColor: Colors.red,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('تم حذف المحادثة'), backgroundColor: Colors.red),
          );
        },
      ),
    );
  }

  void _muteChat(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('تم كتم الصوت'), backgroundColor: Colors.orange),
    );
  }

  void _blockUser(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('تم حظر المستخدم'), backgroundColor: Colors.red),
    );
  }

  void _addToFavorites(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('تم الإضافة إلى المفضلة'),
          backgroundColor: Colors.pink),
    );
  }
}
