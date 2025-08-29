import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/presentation/widgets/time_formatter.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isCurrentUser) ...[
            // Profile image for received messages (left side)
            Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  message.senderImage,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 16.w,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser ? Color(0xfffeefef) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(!isCurrentUser ? 16.r : 4.r),
                  bottomRight: Radius.circular(!isCurrentUser ? 4.r : 16.r),
                ),
                border: !isCurrentUser ? Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message.message,
                    style: TextStyle(
                      fontFamily: 'LamaSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 17.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Timestamp and read status (only for sent messages)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TimeFormatter.formatMessageTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (isCurrentUser) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14.w,
                          color: Colors.blue[200],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (!isCurrentUser) ...[
            // Profile image for current user's messages (right side)
            Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  message.senderImage,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 16.w,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
