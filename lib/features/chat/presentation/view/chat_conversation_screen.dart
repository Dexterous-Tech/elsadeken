import 'dart:async';
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
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_state.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_state.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/chat/data/services/chat_message_service.dart';
import 'package:elsadeken/core/services/firebase_notification_service.dart';

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
  
  // Stream subscriptions for real-time updates
  StreamSubscription<PusherMessageModel>? _messageSubscription;
  StreamSubscription<int>? _chatUpdateSubscription;
  
  // Auto-scroll control
  bool _shouldAutoScroll = true;
  
  // Prevent duplicate subscriptions
  bool _hasSubscribedToPusher = false;
  bool _hasInitializedPusher = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadChatMessages();
    _loadCurrentUserProfile();
    _initializePusher();
    _setupRealTimeListeners();
    _setupScrollListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Re-initialize Pusher if the app is resumed
      _initializePusher();
      
      // Check if we need to refresh due to Firebase notifications
      _checkAndHandleChatRefresh();
    }
  }

  /// Check if chat refresh is needed from Firebase notifications
  Future<void> _checkAndHandleChatRefresh() async {
    try {
      // Check if we need to refresh due to Firebase notifications
      final needsRefresh = await FirebaseNotificationService.instance.checkAndClearChatRefreshFlag();
      
      if (needsRefresh) {
        print('[ChatConversationScreen] Firebase notification triggered chat refresh');
        // Real-time updates will handle everything automatically - no manual refresh needed
      }
    } catch (e) {
      print('[ChatConversationScreen] Error checking chat refresh: $e');
    }
  }

  void _setupRealTimeListeners() {
    print('[ChatConversationScreen] Setting up real-time listeners...');
    
    // Listen for new messages from the message service
    _messageSubscription = ChatMessageService.instance.messageStream.listen((message) {
      if (mounted) {
        print('[ChatConversationScreen] Message stream received: ${message.body}');
        _handleRealTimeMessage(message);
      }
    });

    // Listen for chat updates
    _chatUpdateSubscription = ChatMessageService.instance.chatUpdateStream.listen((chatId) {
      if (mounted && chatId.toString() == widget.chatRoom.id) {
        print('[ChatConversationScreen] Chat update stream received for chat: $chatId');
        // Don't reload from API - real-time messages handle everything
        // _loadChatMessages(); // Commented out to avoid API calls
      }
    });

    print('[ChatConversationScreen] Real-time listeners set up successfully');
  }



  /// Setup scroll listener for auto-scroll behavior
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final position = _scrollController.position;
        final isNearBottom = position.pixels >= position.maxScrollExtent - 100;
        
        // If user is near bottom, enable auto-scroll for new messages
        if (isNearBottom) {
          _shouldAutoScroll = true;
        } else {
          _shouldAutoScroll = false;
        }
      }
    });
  }

  void _handleRealTimeMessage(PusherMessageModel message) {
    // Only handle messages for the current chat room
    if (message.chatId.toString() == widget.chatRoom.id ||
        (widget.chatRoom.id.startsWith('temp_') &&
            message.receiverId == _currentUserId)) {
      
      print('[ChatConversationScreen] Real-time message received: ${message.body}');
      print('[ChatConversationScreen] Message chat ID: ${message.chatId}, Current chat: ${widget.chatRoom.id}');
      
      // Convert Pusher message to ChatMessage
      final chatMessage = message.toChatMessage(
        _currentUserId.toString(),
        widget.chatRoom.name,
        widget.chatRoom.image,
        _currentUserImage,
      );

      // Add message to the list if it doesn't already exist
      if (!_messages.any((msg) => msg.id == chatMessage.id)) {
        setState(() {
          _messages.add(chatMessage);
          print('[ChatConversationScreen] Message added to UI: ${chatMessage.message}');
        });

        // Real-time updates handle chat list updates automatically
        print('[ChatConversationScreen] Real-time message received and processed');

        // Auto-scroll to bottom with improved timing
        _scrollToBottom();
      } else {
        print('[ChatConversationScreen] Message already exists, skipping: ${chatMessage.message}');
      }
    } else {
      print('[ChatConversationScreen] Message not for current chat: ${message.chatId} vs ${widget.chatRoom.id}');
    }
  }

  /// Improved auto-scroll to bottom method
  void _scrollToBottom() {
    // Only auto-scroll if user is near bottom or explicitly requested
    if (!_shouldAutoScroll) {
      print('[ChatConversationScreen] Auto-scroll disabled, user scrolled up');
      return;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        try {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } catch (e) {
          print('[ChatConversationScreen] Error scrolling to bottom: $e');
        }
      }
    });
  }

  void _initializePusher() async {
    if (_hasInitializedPusher) {
      print('✅ Pusher already initialized, skipping...');
      return;
    }
    
    _hasInitializedPusher = true;
    
    // Get the auth token for private channels
    try {
      final token = await SharedPreferencesHelper.getSecuredString(SharedPreferencesKey.apiTokenKey);
      if (token.isNotEmpty) {
        // Set the auth token in PusherCubit
        context.read<PusherCubit>().setAuthToken(token);
        print('🔑 Auth token set for Pusher private channels');
      } else {
        print('⚠️ No auth token available for Pusher');
        return;
      }
    } catch (e) {
      print('⚠️ Error getting auth token: $e');
      return;
    }

    // Initialize Pusher after the widget is fully built with additional delay for network readiness
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hasInitializedPusher) {
        // Give the network stack more time to initialize
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted && _hasInitializedPusher) {
            print('🔄 Initializing Pusher...');
            context.read<PusherCubit>().initialize();
          }
        });
      }
    });
  }

  Future<void> _subscribeToChatRoom() async {
    if (_hasSubscribedToPusher) {
      print('✅ Already subscribed to Pusher channel, skipping...');
      return;
    }
    
    if (_currentUserId != null && !widget.chatRoom.id.startsWith('temp_')) {
      _hasSubscribedToPusher = true;
      
      print('🔗 Subscribing to chat room: ${widget.chatRoom.id}');
      print('👤 Current user ID: $_currentUserId');
      print('👥 Chat room receiver ID: ${widget.chatRoom.receiverId}');
      
      // Subscribe to the specific chat room channel
      final chatRoomId = widget.chatRoom.id;
      print('📡 Subscribing to chat room channel: $chatRoomId');
      
      try {
        final token = await SharedPreferencesHelper.getSecuredString(SharedPreferencesKey.apiTokenKey);
        context.read<PusherCubit>().subscribeToChatChannel(int.parse(chatRoomId), token);
      } catch (e) {
        print('⚠️ Error subscribing to chat room: $e');
        _hasSubscribedToPusher = false; // Reset on error to allow retry
      }
    } else {
      print('⚠️ Cannot subscribe: userId=$_currentUserId, chatRoomId=${widget.chatRoom.id}');
    }
  }



  void _loadChatMessages() {
    // Don't load messages for temporary chat rooms (new conversations)
    if (!widget.chatRoom.id.startsWith('temp_')) {
      print('[ChatConversationScreen] Loading initial messages from API...');
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
      actions: [
        // Temporary testing button - remove after debugging
        IconButton(
          onPressed: () {
            // Test if the message pipeline works
            context.read<PusherCubit>().simulateMessageReceived(
              'Test real-time message ${DateTime.now().millisecond}', 
              int.parse(widget.chatRoom.id)
            );
          },
          icon: Icon(Icons.send, color: Colors.green),
          tooltip: 'Test Message',
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatMessagesCubit, ChatMessagesState>(
          listener: (context, state) {
            if (state is ChatMessagesLoaded && _currentUserId != null) {
              print('[ChatConversationScreen] API messages loaded: ${state.chatMessages.messages.length} messages');
              
              setState(() {
                _messages = state.chatMessages.toChatMessages(
                  _currentUserId.toString(),
                  widget.chatRoom.name,
                  widget.chatRoom.image,
                  _currentUserImage,
                );
              });

              print('[ChatConversationScreen] API messages converted and set: ${_messages.length} messages');
              _scrollToBottom();
            }
          },
        ),
        BlocListener<ManageProfileCubit, ManageProfileState>(
          listener: (context, state) async {
            if (state is ManageProfileSuccess) {
              // Only process if we haven't set user data yet
              if (_currentUserId == null) {
                setState(() {
                  _currentUserId = state.myProfileResponseModel.data?.id;
                  _currentUserName =
                      state.myProfileResponseModel.data?.name ?? '';
                  _currentUserImage =
                      state.myProfileResponseModel.data?.image ?? '';
                });
                
                if (_currentUserId != null && !widget.chatRoom.id.startsWith('temp_')) {
                  // Subscribe to Pusher channel only once
                  await _subscribeToChatRoom();
                  
                  // Load messages only once
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
                _scrollToBottom();
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
              print('🟢 PUSHER: Message chat ID: ${state.message.chatId}');
              print('🟢 PUSHER: Current chat room ID: ${widget.chatRoom.id}');
              print('🟢 PUSHER: Message sender ID: ${state.message.senderId}');
              print('🟢 PUSHER: Current user ID: $_currentUserId');
              
              _handlePusherMessage(state.message);
            } else if (state is PusherConnectionEstablished) {
              print('🟢 PUSHER: Connection established: ${state.message}');
              // Connection established silently - no user notification
            } else if (state is PusherConnectionError) {
              // Handle errors silently - don't show to user
              print('⚠️ PUSHER: Connection issue (handled silently): ${state.error}');
              // No SnackBar - we're handling this silently
            } else if (state is PusherSubscribed) {
              print('🟢 PUSHER: Subscribed to channel successfully');
              // Subscription successful silently - no user notification
            } else if (state is PusherInitialized) {
              print('🟢 PUSHER: Initialized successfully');
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

  void _handlePusherMessage(PusherMessageModel pusherMessage) {
    print('[ChatConversationScreen] Pusher message received: ${pusherMessage.body}');
    print('[ChatConversationScreen] Pusher message chat ID: ${pusherMessage.chatId}, Current chat: ${widget.chatRoom.id}');
    
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
          print('[ChatConversationScreen] Pusher message added to UI: ${chatMessage.message}');
        });

        // Real-time updates handle chat list updates automatically
        print('[ChatConversationScreen] Pusher message received and processed');

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
      } else {
        print('[ChatConversationScreen] Pusher message already exists, skipping: ${chatMessage.message}');
      }
    } else {
      print('[ChatConversationScreen] Pusher message not for current chat: ${pusherMessage.chatId} vs ${widget.chatRoom.id}');
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
    
    // Reset subscription flags
    _hasSubscribedToPusher = false;
    _hasInitializedPusher = false;
    
    // Cancel stream subscriptions
    _messageSubscription?.cancel();
    _chatUpdateSubscription?.cancel();
    
    // Unsubscribe from Pusher channel when leaving the screen
    try {
      context.read<PusherCubit>().unsubscribeFromChatChannel();
    } catch (e) {
      // Widget is being disposed, ignore context errors
      print('Pusher unsubscribe skipped during dispose: $e');
    }
    super.dispose();
  }
}
