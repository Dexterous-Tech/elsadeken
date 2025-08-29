import 'dart:developer';
import 'dart:async';

import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_state.dart';
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

class _ChatConversationScreenState extends State<ChatConversationScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  int? _currentUserId;
  String _currentUserName = '';
  String _currentUserImage = '';
  bool _pusherInitialized = false;
  Timer? _connectionHealthTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadChatMessages();
    _loadCurrentUserProfile();
    _initializePusher();
    _startConnectionHealthCheck();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Add a post-frame callback to handle when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Always try to load messages when returning to existing chat rooms
      if (!widget.chatRoom.id.startsWith('temp_')) {
        log('🔄 Returning to existing chat room, loading messages...');
        _loadChatMessages();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reset Pusher state and re-initialize if the app is resumed
      _pusherInitialized = false;
      context.read<PusherCubit>().resetInitializationState();
      _initializePusher();

      // Always reload messages when returning to existing chat rooms
      // This ensures we have the latest messages
      if (!widget.chatRoom.id.startsWith('temp_')) {
        log('🔄 App resumed, reloading messages for existing chat room');
        _loadChatMessages();
      }

      // Restart connection health check
      _startConnectionHealthCheck();
    } else if (state == AppLifecycleState.paused) {
      // Pause connection health check when app goes to background
      _connectionHealthTimer?.cancel();
    } else if (state == AppLifecycleState.inactive) {
      // Disconnect Pusher when app becomes inactive
      try {
        context.read<PusherCubit>().disconnect();
      } catch (e) {
        log('⚠️ Error disconnecting Pusher: $e');
      }
    }
  }

  void _initializePusher() {
    // Prevent multiple initialization attempts
    if (_pusherInitialized) {
      log('⚠️ Pusher already initialized, skipping...');
      return;
    }

    // Initialize Pusher after the widget is fully built with additional delay for network readiness
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_pusherInitialized) {
        // Give the network stack more time to initialize
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted && !_pusherInitialized) {
            log('🔄 Initializing Pusher...');
            _pusherInitialized = true;
            context.read<PusherCubit>().initialize();
          }
        });
      }
    });
  }

  /// Retry Pusher connection when network issues occur
  void _retryPusherConnection() {
    log('🔄 Retrying Pusher connection...');
    _pusherInitialized = false;
    context.read<PusherCubit>().resetInitializationState();
    _initializePusher();
  }

  /// Start periodic connection health check
  void _startConnectionHealthCheck() {
    _connectionHealthTimer?.cancel();
    _connectionHealthTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted && _pusherInitialized) {
        final pusherCubit = context.read<PusherCubit>();
        if (pusherCubit.isConnected == false) {
          log('⚠️ Pusher connection lost, attempting to reconnect...');
          _retryPusherConnection();
        }
      }
    });
  }

  void _subscribeToChatRoom() {
    if (_currentUserId != null && !widget.chatRoom.id.startsWith('temp_')) {
      log('🔗 Subscribing to chat room: ${widget.chatRoom.id}');
      log('👤 Current user ID: $_currentUserId');
      log('👥 Chat room receiver ID: ${widget.chatRoom.receiverId}');

      // Subscribe to the specific chat room channel
      // The channel name should match what the backend is using
      final chatRoomId = widget.chatRoom.id;
      log('📡 Subscribing to chat room channel: $chatRoomId');

      // Try different channel naming conventions that the backend might be using
      context.read<PusherCubit>().subscribeToChatChannel(int.parse(chatRoomId));
    } else {
      log('⚠️ Cannot subscribe: userId=$_currentUserId, chatRoomId=${widget.chatRoom.id}');
    }
  }

  void _loadChatMessages() {
    // Don't load messages for temporary chat rooms (new conversations)
    if (!widget.chatRoom.id.startsWith('temp_')) {
      // Always load messages for existing chat rooms to ensure we have the latest
      log('🔄 Loading chat messages for room: ${widget.chatRoom.id}');

      // Clear any existing messages to show loading state
      if (_messages.isNotEmpty) {
        setState(() {
          _messages = [];
        });
      }

      context.read<ChatMessagesCubit>().getChatMessages(widget.chatRoom.id);
    }
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
              ],
            ),
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
              log('📨 Chat messages loaded: ${state.chatMessages.messages.length} messages');

              final newMessages = state.chatMessages.toChatMessages(
                _currentUserId.toString(),
                widget.chatRoom.name,
                widget.chatRoom.image,
                _currentUserImage,
              );

              // Always update messages when they're loaded from the server
              setState(() {
                _messages = newMessages;
              });

              // Scroll to bottom only if we have messages
              if (newMessages.isNotEmpty) {
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
            } else if (state is ChatMessagesError) {
              log('❌ Error loading chat messages: ${state.message}');
              // Show error state but don't clear existing messages
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

                // Always load messages for existing chat rooms when profile is loaded
                if (!widget.chatRoom.id.startsWith('temp_')) {
                  log('🔄 Profile loaded, loading chat messages...');
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
              log('Message sent successfully: ${state.sendMessageModel.message}');

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
              log('🟢 PUSHER: Message received: ${state.message.body}');
              log('🟢 PUSHER: Message chat ID: ${state.message.chatId}');
              log('🟢 PUSHER: Current chat room ID: ${widget.chatRoom.id}');
              log('🟢 PUSHER: Message sender ID: ${state.message.senderId}');
              log('🟢 PUSHER: Current user ID: $_currentUserId');

              _handlePusherMessage(state.message);
            } else if (state is PusherConnectionEstablished) {
              log('🟢 PUSHER: Connection established: ${state.message}');
              // Connection established silently - no user notification
            } else if (state is PusherConnectionError) {
              // Handle errors silently - don't show to user
              log('⚠️ PUSHER: Connection issue (handled silently): ${state.error}');
              // Reset initialization state to allow retry
              _pusherInitialized = false;
              // No SnackBar - we're handling this silently
            } else if (state is PusherSubscribed) {
              log('🟢 PUSHER: Subscribed to channel successfully');
              // Subscription successful silently - no user notification
            } else if (state is PusherInitialized) {
              log('🟢 PUSHER: Initialized successfully');
              // Now subscribe to the chat room
              _subscribeToChatRoom();
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
            // Check if we're still loading messages
            final chatMessagesState = context.read<ChatMessagesCubit>().state;
            if (chatMessagesState is ChatMessagesLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'جاري تحميل الرسائل...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            // For existing chat rooms, show loading indicator while waiting for messages
            if (!widget.chatRoom.id.startsWith('temp_')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'جاري تحميل الرسائل...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            // For new temporary chat rooms, show the welcome message
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

  /// Check if two message lists are equal
  bool _areMessagesEqual(
      List<ChatMessage> messages1, List<ChatMessage> messages2) {
    if (messages1.length != messages2.length) return false;

    for (int i = 0; i < messages1.length; i++) {
      if (messages1[i].id != messages2[i].id ||
          messages1[i].message != messages2[i].message ||
          messages1[i].timestamp != messages2[i].timestamp) {
        return false;
      }
    }
    return true;
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

        // Update the chat list to reflect the new message
        // This ensures the chat list shows updated unread count and last message
        try {
          final chatListCubit = context.read<ChatListCubit>();
          if (chatListCubit != null) {
            // Refresh the chat list to show the new message
            chatListCubit.getChatList();
            log('[ChatConversationScreen] Chat list refreshed after receiving Pusher message');
          }
        } catch (e) {
          log('[ChatConversationScreen] Error refreshing chat list: $e');
        }

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

    // For temporary chat rooms, we'll add the message when the API response comes back
    // This ensures consistency with the server data

    // Send message through API
    context.read<SendMessageCubit>().sendMessages(
          widget.chatRoom.receiverId,
          message,
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _connectionHealthTimer?.cancel();
    // Unsubscribe from Pusher channel when leaving the screen
    try {
      context.read<PusherCubit>().unsubscribeFromChatChannel();
    } catch (e) {
      log('[ChatConversationScreen] Error during dispose: $e');
    }
    super.dispose();
  }
}
