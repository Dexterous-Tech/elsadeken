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
  final bool isInFavoritesList;

  const ChatRoomItem({
    super.key,
    required this.chat,
    required this.onTap,
    required this.chatListCubit,
    this.onLongPress,
    this.isInFavoritesList = false,
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
              color: Colors.black.withValues(alpha: 0.05),
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
                    chat.lastMessage?.body ??
                        AppLocalizations.of(context)!.noResults,
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
                    context,
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
        onBlock: () => _handleReportUnreport(context),
        onAddToFavorites: () => _toggleFavorite(context),
        isChatFavorite: chat.isFavorite, // Pass the current favorite status
        isChatReported: chat.isReported, // Pass the current report status
        isChatMuted: chat.isMuted, // Pass the current mute status
        isInFavoritesList: isInFavoritesList, // Pass the context
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
          AppLocalizations.of(context)!.confirmDeletion,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.confirmDelCont,
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
                          chat.otherUser.name,
                          style: AppTextStyles.font14BlackSemiBoldLamaSans
                              .copyWith(
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
                        '${chat.id}',
                        style: AppTextStyles.font14BlackSemiBoldLamaSans,
                      ),
                    ],
                  ),
                  if (chat.lastMessage != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.message,
                            size: 16.sp, color: Colors.grey[600]),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            ' ${chat.lastMessage!.body}',
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
                        Icon(Icons.mark_email_unread,
                            size: 16.sp, color: Colors.orange),
                        SizedBox(width: 8.w),
                        Text(
                          ' ${chat.unreadCount}',
                          style: AppTextStyles.font14BlackSemiBoldLamaSans
                              .copyWith(
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('❌ Delete cancelled by user');
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              print('✅ Delete confirmed by user');
              print(
                  '🗑️ Deleting chat ID: ${chat.id} (${chat.otherUser.name})');
              Navigator.of(context).pop();

              // Call the cubit method to delete this specific chat
              chatListCubit.deleteOneChat(chat.id);

              // Show success snackbar with chat details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .chatDeletedSuccess(chat.otherUser.name)),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.deleteChat,
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

  void _handleReportUnreport(BuildContext context) {
    final bool isReported = chat.isReported;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          isReported
              ? AppLocalizations.of(context)!.confirmUnreport
              : AppLocalizations.of(context)!.confirmReport,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Text(
          isReported
              ? AppLocalizations.of(context)!.areYouSureUnreport
              : AppLocalizations.of(context)!.areYouSureReport,
          style: AppTextStyles.font16BlackSemiBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              if (isReported) {
                // Call the cubit method to unreport this user
                chatListCubit.unreportUser(chat.id);

                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.unreportSuccessful),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                // Call the cubit method to report this user
                chatListCubit.reportUser(chat.id);

                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.reportSuccessful),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: isReported ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _muteChat(BuildContext context) {
    final bool isCurrentlyMuted = chat.isMuted;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          isCurrentlyMuted
              ? AppLocalizations.of(context)!.confirmUnmute
              : AppLocalizations.of(context)!.confirmMute,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        content: Text(
          isCurrentlyMuted
              ? AppLocalizations.of(context)!.areYouSureUnmute
              : AppLocalizations.of(context)!.areYouSureMute,
          style: AppTextStyles.font16BlackSemiBoldLamaSans,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call the cubit method to mute/unmute this user
              chatListCubit.muteUser(chat.id);

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isCurrentlyMuted
                      ? AppLocalizations.of(context)!.chatUnmutedSuccess
                      : AppLocalizations.of(context)!.chatMutedSuccess),
                  backgroundColor:
                      isCurrentlyMuted ? Colors.green : Colors.grey,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                color: isCurrentlyMuted ? Colors.green : Colors.orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    final bool isCurrentlyFavorite = chat.isFavorite;

    // Debug: Print the current favorite status
    print(
        '🔍 [ChatRoomItem] Chat ID: ${chat.id}, isFavorite: $isCurrentlyFavorite');
    print('🔍 [ChatRoomItem] Chat otherUser: ${chat.otherUser.name}');
    print('🔍 [ChatRoomItem] isInFavoritesList: $isInFavoritesList');

    // Use the toggle method from cubit
    chatListCubit.addChatToFavorite(chat.id);

    // Show appropriate snackbar based on current state and context
    String message;
    Color backgroundColor;

    if (isInFavoritesList) {
      // In favorites list, always show "removed successfully"
      message = AppLocalizations.of(context)!.removeFromFavoritesSuccess;
      backgroundColor = Colors.grey;
    } else {
      // In all chats list, show based on current state
      message = isCurrentlyFavorite
          ? AppLocalizations.of(context)!.removeFromFavoritesSuccess
          : AppLocalizations.of(context)!.addToFavoritesSuccess;
      backgroundColor = isCurrentlyFavorite ? Colors.grey : Colors.pink;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
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
