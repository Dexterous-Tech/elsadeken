import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';

import 'package:elsadeken/features/chat/presentation/widgets/profile_image_widget.dart';
import 'package:elsadeken/features/chat/presentation/widgets/time_formatter.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_options_popup.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatData chat;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final ChatListCubit chatListCubit;

  const ChatRoomItem({
    super.key,
    required this.chat,
    required this.onTap,
    required this.chatListCubit,
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
          color: _getBackgroundColor(),
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
              unreadCount: chat.unreadCount,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mute icon if chat is muted
                if (_isChatMuted())
                  Container(
                    margin: EdgeInsets.only(right: 4.w),
                    child: Icon(
                      Icons.volume_off,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                // Favorite icon if chat is in favorites
                if (chat.isFavorite)
                  Container(
                    margin: EdgeInsets.only(right: 4.w),
                    child: Icon(
                      Icons.star,
                      size: 16.sp,
                      color: Colors.amber,
                    ),
                  ),
                SizedBox(
                  width: 8.w,
                ),
                // Time
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
              ],
            ),
            SizedBox(height: 6.h),
            if (chat.unreadCount > 0)
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
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
        onBlock: () => _reportUser(context),
        onAddToFavorites: () => _toggleFavorite(context),
        isChatFavorite: chat.isFavorite, // Pass the current favorite status
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تأكيد الحذف',
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: AppTextStyles.font16BlackSemiBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call the cubit method to delete this chat
              chatListCubit.deleteOneChat(chat.id);

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المحادثة بنجاح'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'حذف',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reportUser(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تأكيد الإبلاغ',
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من الإبلاغ عن هذا المستخدم؟',
          style: AppTextStyles.font16BlackSemiBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call the cubit method to report this user
              chatListCubit.reportUser(chat.id);

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حظر الشات بنجاح'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Text(
              'تأكيد',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _muteChat(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تأكيد كتم الصوت',
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل تريد كتم صوت هذا المستخدم؟',
          style: AppTextStyles.font16BlackSemiBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call the cubit method to mute this user
              chatListCubit.muteUser(chat.id);

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم كتم الصوت'),
                  backgroundColor: Colors.grey,
                ),
              );
            },
            child: Text(
              'تأكيد',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    // Toggle the favorite status
    chatListCubit.toggleChatFavorite(chat.id, chat.isFavorite);

    // Show appropriate snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(chat.isFavorite ? 'تم إزالة من المفضلة' : 'تم الإضافة إلى المفضلة'),
        backgroundColor: chat.isFavorite ? Colors.grey : Colors.pink,
      ),
    );
  }

  void _addToFavorites(BuildContext context) {
    // Call the chat_settings_cubit method to add this chat to favorites
    chatListCubit.addChatToFavorite(chat.id);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم الإضافة إلى المفضلة'),
        backgroundColor: Colors.pink,
      ),
    );
  }

  /// Get background color based on chat status
  Color _getBackgroundColor() {
    if (_isChatReported()) {
      return Colors.white10; // Light grey for reported chats
    }
    return Colors.white; // Default white background
  }

  /// Check if chat is muted
  bool _isChatMuted() {
    return chat.isMuted;
  }

  /// Check if chat is reported
  bool _isChatReported() {
    // TODO: Add reported status to ChatData model when API provides it
    // For now, we'll check if the chat has been reported by looking at a property
    // This can be enhanced when the API provides reported status
    return chat.isReported;
  }
}
