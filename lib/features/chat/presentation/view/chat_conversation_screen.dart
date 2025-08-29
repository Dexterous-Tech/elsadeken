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
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
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

/// Chat Conversation Screen with optimal loading strategy:
/// 1. Load chat messages FIRST (fast API call for instant user experience)
/// 2. Setup WebSocket/Pusher connections SECOND (background real-time setup)
/// This ensures users see content immediately while real-time connections establish
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

  // Auto-scroll control
  bool _shouldAutoScroll = true;

  // Simplified connection state
  bool _isPusherSetup = false;

  // Store Cubit references to avoid context access in dispose
  ChatMessagesCubit? _chatMessagesCubit;
  ChatListCubit? _chatListCubit;
  PusherCubit? _pusherCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentUserProfile();
    _setupRealTimeListeners();
    _setupScrollListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store references to Cubits when dependencies change
    _chatMessagesCubit = context.read<ChatMessagesCubit>();
    _chatListCubit = context.read<ChatListCubit>();
    _pusherCubit = context.read<PusherCubit>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Check connection health on resume
      _checkPusherConnectionHealth();
      
      // Resume auto-refresh when app is resumed
      if (!widget.chatRoom.id.startsWith('temp_') && _currentUserId != null) {
        if (_chatMessagesCubit != null && !_chatMessagesCubit!.isClosed) {
          _chatMessagesCubit!.startAutoRefresh(widget.chatRoom.id);
        }
      }
    } else if (state == AppLifecycleState.paused) {
      // Stop auto-refresh when app is paused to save resources
      if (_chatMessagesCubit != null && !_chatMessagesCubit!.isClosed) {
        _chatMessagesCubit!.stopAutoRefresh();
      }
    }
  }

  Future<void> _checkPusherConnectionHealth() async {
    if (_isPusherSetup && _currentUserId != null && _pusherCubit != null && !_pusherCubit!.isClosed) {
      final isHealthy = await _pusherCubit!.checkConnectionHealth();
      if (isHealthy == false) {
        print('Connection unhealthy, re-initializing...');
        await _initializeAndSubscribePusher();
      }
    }
  }

  void _setupRealTimeListeners() {
    print('[ChatConversationScreen] Setting up real-time listeners...');

    // Single message stream listener
    _messageSubscription = ChatMessageService.instance.messageStream.listen((message) {
      if (mounted) {
        print('[ChatConversationScreen] Message stream received: ${message.body}');
        _handleRealTimeMessage(message);
      }
    });
  }

  /// Streamed messages
  void _handleRealTimeMessage(PusherMessageModel message) {
    // Only handle messages for the current chat room
    if (message.chatId.toString() == widget.chatRoom.id ||
        (widget.chatRoom.id.startsWith('temp_') &&
            message.receiverId == _currentUserId)) {

      print('[ChatConversationScreen] Processing real-time message: ${message.body}');

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
        });

        print('[ChatConversationScreen] Message added to UI successfully');
        _scrollToBottom();

        // Update chat list to reflect new message and maintain sorting
        if (!widget.chatRoom.id.startsWith('temp_')) {
          final chatId = int.tryParse(widget.chatRoom.id);
          if (chatId != null) {
            if (_chatListCubit != null && !_chatListCubit!.isClosed) {
              _chatListCubit!.handleNewMessage(
                chatId,
                message.body,
                message.createdAt.toIso8601String(),
                message.senderId,
              );
            }
          }
        }
      }
    }
  }



  /// Setup scroll listener for auto-scroll behavior
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final position = _scrollController.position;
        final isNearBottom = position.pixels >= position.maxScrollExtent - 100;
        _shouldAutoScroll = isNearBottom;
      }
    });
  }


  /// Improved auto-scroll to bottom method
  void _scrollToBottom() {
    if (!_shouldAutoScroll) return;

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

  /// Setup WebSocket/Pusher connections in background (non-blocking)
  /// This runs AFTER chat messages are loaded for optimal user experience
  Future<void> _initializeAndSubscribePusher() async {
    if (_currentUserId == null) {
      print('Cannot setup Pusher without user ID');
      return;
    }

    try {
      final token = await SharedPreferencesHelper.getSecuredString(SharedPreferencesKey.apiTokenKey);
      if (token.isEmpty) {
        print('No auth token available for Pusher');
        return;
      }

      // Set auth token
      if (_pusherCubit != null && !_pusherCubit!.isClosed) {
        _pusherCubit!.setAuthToken(token);

        // Initialize Pusher
        await _pusherCubit!.initialize();

        // Small delay to ensure initialization completes
        await Future.delayed(Duration(milliseconds: 1000));

        // Subscribe to chat channel if not temporary
        if (!widget.chatRoom.id.startsWith('temp_')) {
          final chatRoomId = int.tryParse(widget.chatRoom.id);
          if (chatRoomId != null) {
            await _pusherCubit!.subscribeToChatChannel(chatRoomId, token);
          }
        }
      }

      _isPusherSetup = true;
      print('Pusher setup completed successfully');
    } catch (e) {
      print('Error setting up Pusher: $e');
    }
  }

  void _loadCurrentUserProfile() {
    context.read<ManageProfileCubit>().getProfile();
  }

  /// Load chat messages FIRST for instant user experience
  /// This runs before WebSocket/Pusher setup to show content immediately
  void _loadChatMessages() {
    // Don't load messages for temporary chat rooms
    if (!widget.chatRoom.id.startsWith('temp_')) {
      print('[ChatConversationScreen] 🚀 Loading initial messages from API (FAST PATH)...');
      if (_chatMessagesCubit != null && !_chatMessagesCubit!.isClosed) {
        _chatMessagesCubit!.getChatMessages(widget.chatRoom.id);
      }
    }
  }

  /// Manual refresh method for pull-to-refresh
  Future<void> _refreshMessages() async {
    if (!widget.chatRoom.id.startsWith('temp_')) {
      print('[ChatConversationScreen] Manual refresh triggered');
      if (_chatMessagesCubit != null && !_chatMessagesCubit!.isClosed) {
        await _chatMessagesCubit!.refreshChatMessages(widget.chatRoom.id);
      }
    }
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
                if (!widget.chatRoom.id.startsWith('temp_'))
                  Row(
                    children: [
                      Text(
                        'متصل الآن',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
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
              print('[ChatConversationScreen] API messages loaded: ${state.chatMessages.messages.length} messages');

              setState(() {
                _messages = state.chatMessages.toChatMessages(
                  _currentUserId.toString(),
                  widget.chatRoom.name,
                  widget.chatRoom.image,
                  _currentUserImage,
                );
              });

              _scrollToBottom();
              
              // Start auto-refresh after initial messages are loaded
              if (!widget.chatRoom.id.startsWith('temp_')) {
                if (_chatMessagesCubit != null && !_chatMessagesCubit!.isClosed) {
                  _chatMessagesCubit!.startAutoRefresh(widget.chatRoom.id);
                }
              }
            }
          },
        ),
        BlocListener<ManageProfileCubit, ManageProfileState>(
          listener: (context, state) async {
            if (state is ManageProfileSuccess && _currentUserId == null) {
              setState(() {
                _currentUserId = state.myProfileResponseModel.data?.id;
                _currentUserName = state.myProfileResponseModel.data?.name ?? '';
                _currentUserImage = state.myProfileResponseModel.data?.image ?? '';
              });

              // OPTIMAL LOADING STRATEGY:
              // 1. Load chat messages FIRST for instant user experience
              print('[ChatConversationScreen] 🚀 Loading chat messages FIRST for instant user experience');
              _loadChatMessages();
              
              // 2. Setup Pusher connections SECOND in background (non-blocking)
              print('[ChatConversationScreen] 🔌 Setting up Pusher connections in background');
              _initializeAndSubscribePusher();
            }
          },
        ),
        BlocListener<SendMessageCubit, SendMessagesState>(
          listener: (context, state) {
            if (state is SendMessagesLoaded) {
              // Add the sent message immediately to UI
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

                // Only add if not already in list
                if (!_messages.any((msg) => msg.id == newMessage.id)) {
                  setState(() {
                    _messages.add(newMessage);
                  });
                  _scrollToBottom();
                }
                
                // Update chat list to reflect new message and maintain sorting
                if (!widget.chatRoom.id.startsWith('temp_')) {
                  final chatId = int.tryParse(widget.chatRoom.id);
                  if (chatId != null) {
                    if (_chatListCubit != null && !_chatListCubit!.isClosed) {
                      _chatListCubit!.handleNewMessage(
                        chatId,
                        state.sendMessageModel.data.body,
                        state.sendMessageModel.data.createdAt.toIso8601String(),
                        _currentUserId!,
                      );
                    }
                  }
                }
              }
            } else if (state is SendMessagesError) {
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
              print('PUSHER: Direct message received: ${state.message.body}');
              _handleRealTimeMessage(state.message);
            } else if (state is PusherConnectionError) {
              print('PUSHER: Connection error (handled silently): ${state.error}');
            } else if (state is PusherInitialized) {
              print('PUSHER: Initialized successfully');
            } else if (state is PusherSubscribed) {
              print('PUSHER: Subscribed to channel successfully');
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
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
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

          return RefreshIndicator(
            onRefresh: _refreshMessages,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildDaySeparator();
                }

                final messageIndex = index - 1;
                final message = _messages[messageIndex];
                final isCurrentUser = message.senderId == _currentUserId.toString();

                return ChatMessageBubble(
                  message: message,
                  isCurrentUser: isCurrentUser,
                );
              },
            ),
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

    if (now.year == today.year && now.month == today.month && now.day == today.day) {
      return 'اليوم';
    } else if (now.year == yesterday.year && now.month == yesterday.month && now.day == yesterday.day) {
      return 'أمس';
    } else {
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
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
                        backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
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
  }

  @override
  void dispose() {
    // Stop auto-refresh when disposing using stored reference
    if (!widget.chatRoom.id.startsWith('temp_') && _chatMessagesCubit != null) {
      try {
        // Check if cubit is still active before calling methods
        if (!_chatMessagesCubit!.isClosed) {
          _chatMessagesCubit!.stopAutoRefresh();
        }
      } catch (e) {
        print('Error stopping auto-refresh during dispose: $e');
      }
    }
    
    _messageController.dispose();
    _scrollController.dispose();
    _messageSubscription?.cancel();

    // Safely unsubscribe from Pusher channel when leaving
    if (_isPusherSetup && _pusherCubit != null) {
      try {
        // Check if cubit is still active before calling methods
        if (!_pusherCubit!.isClosed) {
          _pusherCubit!.unsubscribeFromChatChannel();
        }
      } catch (e) {
        print('Error unsubscribing during dispose: $e');
      }
    }

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}