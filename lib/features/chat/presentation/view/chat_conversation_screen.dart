import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_state.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';

class ChatConversationScreen extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatConversationScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
    _loadCurrentUserProfile();
  }

  void _loadChatMessages() {
    context.read<ChatMessagesCubit>().getChatMessages(widget.chatRoom.id);
  }

  void _loadCurrentUserProfile() {
    context.read<ManageProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: _buildChatMessages(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xfffef6ee),
      elevation: 0,
      leading: const CustomArrowBack(),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.chatRoom.image),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatRoom.name,
                style: TextStyle(
                  color: AppColors.darkerBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.chatRoom.isOnline ? 'متصل الآن' : 'غير متصل',
                style: TextStyle(
                  color: widget.chatRoom.isOnline ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatMessagesCubit, ChatMessagesState>(
          listener: (context, state) {
            if (state is ChatMessagesLoaded && _currentUserId != null) {
              setState(() {
                _messages = state.chatMessages.toChatMessages(
                  _currentUserId.toString(),
                  widget.chatRoom.name,
                  widget.chatRoom.image,
                );
              });

              Future.delayed(Duration(milliseconds: 100), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          },
        ),
        BlocListener<ManageProfileCubit, ManageProfileState>(
          listener: (context, state) {
            if (state is ManageProfileSuccess) {
              setState(() {
                _currentUserId = state.myProfileResponseModel.data?.id;
              });
              if (_currentUserId != null) {
                context
                    .read<ChatMessagesCubit>()
                    .getChatMessages(widget.chatRoom.id);
              }
            }
          },
        ),
        BlocListener<SendMessageCubit, SendMessagesState>(
          listener: (context, state) {
            if (state is SendMessagesLoaded) {
               context
                  .read<ChatMessagesCubit>()
                  .getChatMessages(widget.chatRoom.id);
            } else if (state is SendMessagesError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
        builder: (context, state) {
          if (state is ChatMessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatMessagesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الرسائل',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadChatMessages,
                    child: Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (_messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد رسائل حتى الآن',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ابدأ المحادثة بإرسال رسالة',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: _messages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Day separator at the top
                return _buildDaySeparator();
              }

              final messageIndex = index - 1;
              final message = _messages[messageIndex];
              final isCurrentUser =
                  message.senderId == _currentUserId.toString();

              return ChatMessageBubble(
                message: message,
                isCurrentUser: isCurrentUser,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDaySeparator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _getCurrentDayText(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamilyHelper.plexSansArabic,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDayText() {
    final now = DateTime.now();
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (now.year == today.year &&
        now.month == today.month &&
        now.day == today.day) {
      return 'اليوم';
    } else if (now.year == yesterday.year &&
        now.month == yesterday.month &&
        now.day == yesterday.day) {
      return 'أمس';
    } else {
      // Format: "15 مارس" (day + month name in Arabic)
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${now.day} ${months[now.month - 1]}';
    }
  }

  Widget _buildMessageInput() {
    return BlocBuilder<SendMessageCubit, SendMessagesState>(
      builder: (context, state) {
        final isLoading = state is SendMessagesLoading;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfffff9f6),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    textDirection: TextDirection.rtl,
                    enabled: !isLoading, // Disable input while sending
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 18.sp,
                        fontFamily: FontFamilyHelper.plexSansArabic,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: IconButton(
                          icon: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryOrange),
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/icons/send.png',
                                  width: 24.w,
                                  height: 24.w,
                                  color: AppColors.primaryOrange,
                                ),
                          onPressed: isLoading ? null : _sendMessage,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryOrange.withOpacity(0.1),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(8.w),
                          ),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (message) {
                      if (message.trim().isNotEmpty && !isLoading) {
                        _sendMessage();
                      }
                    },
                    maxLines: null,
                    minLines: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الانتظار حتى يتم تحميل الملف الشخصي'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final message = _messageController.text.trim();
    _messageController.clear();

    // Send message through API
    context.read<SendMessageCubit>().sendMessages(
          widget.chatRoom.receiverId,
          message,
        );

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
