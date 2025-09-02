import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

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
                    chat.lastMessage?.body ?? AppLocalizations.of(context)!.noResults,
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
    // Log detailed information for debugging
    print('🗑️ === DELETE CONFIRMATION ===');
    print('Chat ID: ${chat.id}');
    print('Chat Name: ${chat.otherUser.name}');
    print('Other User ID: ${chat.otherUser.id}');
    print('Last Message: ${chat.lastMessage?.body ?? 'No messages'}');
    print('Unread Count: ${chat.unreadCount}');
    print('===========================');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تأكيد حذف المحادثة',
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد من حذف هذه المحادثة؟',
              style: AppTextStyles.font16BlackSemiBoldLamaSans,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'اسم المحادثة: ${chat.otherUser.name}',
                          style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.tag, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Text(
                        'معرف المحادثة: ${chat.id}',
                        style: AppTextStyles.font14BlackSemiBoldLamaSans,
                      ),
                    ],
                  ),
                  if (chat.lastMessage != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.message, size: 16.sp, color: Colors.grey[600]),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'آخر رسالة: ${chat.lastMessage!.body}',
                            style: AppTextStyles.font14BlackSemiBoldLamaSans,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (chat.unreadCount > 0) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.mark_email_unread, size: 16.sp, color: Colors.orange),
                        SizedBox(width: 8.w),
                        Text(
                          'رسائل غير مقروءة: ${chat.unreadCount}',
                          style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '⚠️ لا يمكن التراجع عن هذا الإجراء.',
              style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('❌ Delete cancelled by user');
              Navigator.of(context).pop();
            },
            child: Text(
              'إلغاء',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              print('✅ Delete confirmed by user');
              print('🗑️ Deleting chat ID: ${chat.id} (${chat.otherUser.name})');
              Navigator.of(context).pop();
              
              // Call the cubit method to delete this specific chat
              chatListCubit.deleteOneChat(chat.id);

              // Show success snackbar with chat details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.chatDeletedSuccess(chat.otherUser.name)),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text(
              'حذف المحادثة',
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
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
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.chatBlockedSuccess),
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
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.chatMutedSuccess),
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
