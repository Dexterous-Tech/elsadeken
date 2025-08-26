import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:elsadeken/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'dart:async';

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
  String _currentUserName = '';
  String _currentUserImage = '';
  Timer? _refreshTimer;

  // Typing indicator state
  bool _isOtherUserTyping = false;
  Timer? _typingTimer;
  Timer? _messageDelayTimer;

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
    _loadCurrentUserProfile();
    _initializePusher();
    _startPeriodicRefresh();
    _simulateTypingIndicator(); // Show typing indicator when chat opens
  }

  void _initializePusher() {
    // Initialize Pusher after the widget is fully built with additional delay for network readiness
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Give the network stack more time to initialize
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            try {
              context.read<PusherCubit>().initialize();
            } catch (e) {
              // Handle Pusher initialization errors gracefully
              print('⚠️ Pusher initialization failed: $e');
              print('ℹ️ Chat will continue to work without real-time updates');
            }
          }
        });
      }
    });
  }

  void _loadChatMessages() {
    // Don't load messages for temporary chat rooms (new conversations)
    if (!widget.chatRoom.id.startsWith('temp_')) {
      context.read<ChatMessagesCubit>().getChatMessages(widget.chatRoom.id);
      // Also refresh chat list to clear unread count immediately
      _refreshChatListOnBack();
    }
  }

  void _loadCurrentUserProfile() {
    context.read<ManageProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          // Refresh chat list when going back to update unread counts
          _refreshChatListOnBack();
          return true;
        },
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
      ),
    );
  }

  /// Check if Pusher is available and working
  bool _isPusherAvailable() {
    try {
      final pusherCubit = context.read<PusherCubit>();
      return pusherCubit.state is! PusherConnectionError;
    } catch (e) {
      return false;
    }
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
          Expanded(
            child: Column(
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
                    color:
                        widget.chatRoom.isOnline ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
                if (widget.chatRoom.id.startsWith('temp_'))
                  Text(
                    'محادثة جديدة',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Add refresh button when Pusher is not available
        if (!_isPusherAvailable())
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.darkerBlue),
            onPressed: _refreshChatMessages,
            tooltip: 'تحديث الرسائل',
          ),
        // Only show Pusher test button if Pusher is available
        if (_isPusherAvailable())
          IconButton(
            icon: Icon(Icons.wifi, color: AppColors.darkerBlue),
            onPressed: _testPusherConnection,
            tooltip: 'Test Pusher Connection',
          ),
      ],
    );
  }

  /// Refresh chat messages manually when Pusher is not available
  void _refreshChatMessages() {
    try {
      _loadChatMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('جاري تحديث الرسائل...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print('Error refreshing chat messages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تحديث الرسائل'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                  _currentUserImage,
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
                _currentUserName =
                    state.myProfileResponseModel.data?.name ?? '';
                _currentUserImage =
                    state.myProfileResponseModel.data?.image ?? '';
              });
              if (_currentUserId != null) {
                // Subscribe to Pusher channel for real-time messages
                context
                    .read<PusherCubit>()
                    .subscribeToChatChannel(_currentUserId!);

                if (!widget.chatRoom.id.startsWith('temp_')) {
                  context
                      .read<ChatMessagesCubit>()
                      .getChatMessages(widget.chatRoom.id);
                }
              }
            }
          },
        ),
        BlocListener<SendMessageCubit, SendMessagesState>(
          listener: (context, state) {
            if (state is SendMessagesLoaded) {
              // Don't reload all messages, just add the new message locally
              // The message will be added when the user types and sends it
              print(
                  'Message sent successfully: ${state.sendMessageModel.message}');

              // Add the sent message to the local list for immediate display
              if (_currentUserId != null) {
                final newMessage = ChatMessage(
                  id: state.sendMessageModel.data.id.toString(),
                  roomId: state.sendMessageModel.data.chatId.toString(),
                  senderId: _currentUserId.toString(),
                  senderName: _currentUserName,
                  senderImage: _currentUserImage,
                  message: state.sendMessageModel.data.body,
                  timestamp: state.sendMessageModel.data.createdAt,
                  isRead: false,
                );

                setState(() {
                  _messages.add(newMessage);
                });

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

                // If this was a temporary chat, refresh the chat list to show the new chat
                if (widget.chatRoom.id.startsWith('temp_')) {
                  _refreshChatListAfterTemporaryMessage();

                  // Show success message for first message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إنشاء المحادثة بنجاح!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
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
        BlocListener<PusherCubit, PusherState>(
          listener: (context, state) {
            if (state is PusherMessageReceived) {
              // Handle real-time message from Pusher
              print('🟢 PUSHER: Message received: ${state.message.body}');
              _handlePusherMessage(state.message);
            } else if (state is PusherConnectionEstablished) {
              print('🟢 PUSHER: Connection established: ${state.message}');
              // Show success message to user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم الاتصال بالخادم بنجاح'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is PusherConnectionError) {
              // Handle errors gracefully - show user-friendly message
              print('⚠️ PUSHER: Connection issue: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'فشل في الاتصال بالخادم - الرسائل ستظهر عند التحديث'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (state is PusherSubscribed) {
              print('🟢 PUSHER: Subscribed to channel successfully');
            } else if (state is PusherInitialized) {
              print('🟢 PUSHER: Initialized successfully');
            }
          },
        ),
      ],
      child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
        builder: (context, state) {
          // Show loading indicator first when loading messages
          if (state is ChatMessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error state if there's an error
          if (state is ChatMessagesError) {
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

          // Show empty state only after messages have been loaded and are empty
          if (state is ChatMessagesLoaded && _messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    widget.chatRoom.id.startsWith('temp_')
                        ? 'ابدأ المحادثة الآن'
                        : 'لا توجد رسائل حتى الآن',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.chatRoom.id.startsWith('temp_')
                        ? 'أرسل رسالة لبدء المحادثة مع ${widget.chatRoom.name}'
                        : 'ابدأ المحادثة بإرسال رسالة',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show messages if they exist
          if (_messages.isNotEmpty) {
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _messages.length + 1 + (_isOtherUserTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Day separator at the top
                  return _buildDaySeparator();
                }

                final messageIndex = index - 1;

                // Show typing indicator at the bottom if other user is typing
                if (_isOtherUserTyping && messageIndex == _messages.length) {
                  return TypingIndicator(
                    isCurrentUser: false,
                    otherUserName: widget.chatRoom.name,
                    otherUserImage: widget.chatRoom.image,
                  );
                }

                final message = _messages[messageIndex];
                final isCurrentUser =
                    message.senderId == _currentUserId.toString();

                return ChatMessageBubble(
                  message: message,
                  isCurrentUser: isCurrentUser,
                );
              },
            );
          }

          // Default case: show loading indicator while waiting for initial state
          return const Center(child: CircularProgressIndicator());
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
                onChanged: _onTextChanged,
                decoration: InputDecoration(
                  hintText: widget.chatRoom.id.startsWith('temp_')
                      ? 'اكتب رسالتك الأولى...'
                      : 'اكتب رسالتك...',
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
                      icon: Image.asset(
                        'assets/images/icons/send.png',
                        width: 24.w,
                        height: 24.w,
                        color: AppColors.primaryOrange,
                      ),
                      onPressed: _sendMessage,
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
                  if (message.trim().isNotEmpty) {
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
  }

  void _handlePusherMessage(PusherMessageModel pusherMessage) {
    // Only handle messages for the current chat room
    if (pusherMessage.chatId.toString() == widget.chatRoom.id ||
        (widget.chatRoom.id.startsWith('temp_') &&
            pusherMessage.receiverId == _currentUserId)) {
      // Convert Pusher message to ChatMessage
      final chatMessage = pusherMessage.toChatMessage(
        _currentUserId.toString(),
        widget.chatRoom.name,
        widget.chatRoom.image,
        _currentUserImage,
      );

      // Add message to the list if it doesn't already exist
      if (!_messages.any((msg) => msg.id == chatMessage.id)) {
        setState(() {
          _messages.add(chatMessage);
        });

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

        // Simulate typing indicator after receiving a message (for demo purposes)
        _simulateOtherUserTyping();
      }
    }
  }

  /// Simulate the other user typing after receiving a message
  void _simulateOtherUserTyping() {
    // Wait a moment then show typing indicator
    Timer(Duration(milliseconds: 800), () {
      if (mounted) {
        _showTypingIndicator();
      }
    });
  }

  void _testPusherConnection() {
    if (!_isPusherAvailable()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pusher غير متاح حالياً'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    print('🧪 Testing Pusher connection...');
    if (_currentUserId != null) {
      try {
        context.read<PusherCubit>().subscribeToChatChannel(_currentUserId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('جاري اختبار الاتصال...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error testing Pusher connection: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في اختبار الاتصال'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى الانتظار حتى يتم تحميل الملف الشخصي'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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

    if (_currentUserName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الانتظار حتى يتم تحميل بيانات المستخدم'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final message = _messageController.text.trim();
    _messageController.clear();

    // Hide typing indicator when sending a message
    _hideTypingIndicator();

    // For temporary chat rooms, we'll add the message when the API response comes back
    // This ensures consistency with the server data

    // Send message through API
    context.read<SendMessageCubit>().sendMessages(
          widget.chatRoom.receiverId,
          message,
        );
  }

  /// Handle text field changes to show typing indicator
  void _onTextChanged(String text) {
    // Show typing indicator when user starts typing (for demo purposes)
    if (text.isNotEmpty && !_isOtherUserTyping) {
      _showTypingIndicator();
    }

    // Hide typing indicator when text is cleared
    if (text.isEmpty) {
      _hideTypingIndicator();
    }
  }

  /// Start periodic refresh when Pusher is not available
  void _startPeriodicRefresh() {
    // Refresh messages every 30 seconds when Pusher is not available
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted && !_isPusherAvailable()) {
        _loadChatMessages();
      }
    });
  }

  /// Show typing indicator for the other user
  void _showTypingIndicator() {
    if (!_isOtherUserTyping) {
      setState(() {
        _isOtherUserTyping = true;
      });

      // Auto-hide typing indicator after 2 seconds
      _typingTimer?.cancel();
      _typingTimer = Timer(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isOtherUserTyping = false;
          });
        }
      });
    }
  }

  /// Hide typing indicator immediately
  void _hideTypingIndicator() {
    _typingTimer?.cancel();
    setState(() {
      _isOtherUserTyping = false;
    });
  }

  /// Simulate typing indicator when chat is opened (for demo purposes)
  void _simulateTypingIndicator() {
    // Show typing indicator after a short delay when chat opens
    _messageDelayTimer?.cancel();
    _messageDelayTimer = Timer(Duration(milliseconds: 4000), () {
      if (mounted) {
        _showTypingIndicator();
      }
    });
  }

  /// Refresh chat list when going back to update unread counts
  void _refreshChatListOnBack() {
    try {
      // Use a post-frame callback to ensure the navigation has completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Navigate to the chat list and refresh it
          context.read<ChatListCubit>().getChatList();
          print('🔄 Refreshing chat list on back to update unread counts');
        } catch (e) {
          print('⚠️ Error refreshing chat list on back: $e');
        }
      });
    } catch (e) {
      print('⚠️ Error setting up chat list refresh: $e');
    }
  }

  /// Refresh the chat list after sending a message in a temporary chat
  void _refreshChatListAfterTemporaryMessage() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          context.read<ChatListCubit>().getChatList();
          print('🔄 Refreshing chat list after temporary message');
        } catch (e) {
          print('⚠️ Error refreshing chat list after temporary message: $e');
        }
      });
    } catch (e) {
      print('⚠️ Error setting up temporary message refresh: $e');
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _typingTimer?.cancel();
    _messageDelayTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();

    // If this was a temporary chat, refresh the chat list to show the new chat
    if (widget.chatRoom.id.startsWith('temp_')) {
      _refreshChatListAfterTemporaryMessage();
    }

    // Unsubscribe from Pusher channel when leaving the screen
    try {
      context.read<PusherCubit>().unsubscribeFromChatChannel();
    } catch (e) {
      print('Error unsubscribing from Pusher: $e');
    }

    super.dispose();
  }
}
