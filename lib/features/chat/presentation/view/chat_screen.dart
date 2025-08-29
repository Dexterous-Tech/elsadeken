import 'dart:async';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_tab_bar.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_options_card.dart';
import 'package:elsadeken/features/chat/presentation/widgets/empty_chat_illustration.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_room_item.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/services/chat_message_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0; // 0: All, 1: Favorites

  // Stream subscriptions for real-time updates
  StreamSubscription<void>? _refreshChatListSubscription;

  // Track if this is the first load
  bool _hasLoadedInitially = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set initial tab index in cubit
    final chatListCubit = context.read<ChatListCubit>();
    chatListCubit.setCurrentTabIndex(_selectedTabIndex);

    chatListCubit.getChatList();
    _setupRealTimeListeners();
  }

  void _setupRealTimeListeners() {
    // Listen for chat list refresh requests from Firebase notifications only
    _refreshChatListSubscription =
        ChatMessageService.instance.refreshChatListStream.listen((_) {
      if (mounted) {
        print(
            '🔔 [ChatScreen] Firebase notification triggered chat list refresh');
        // Silent background refresh - no UI indicators
        context.read<ChatListCubit>().silentRefreshChatList();
      }
    });

    print(
        '🔔 [ChatScreen] Chat list now depends on Firebase notifications for updates');
  }

  @override
  void dispose() {
    // Cancel stream subscriptions
    _refreshChatListSubscription?.cancel();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Real-time updates handle everything automatically - no manual refresh needed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No manual refresh needed - real-time updates handle everything automatically
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildChatContent()),
            ChatOptionsCard(
              chatListCubit: context.read<ChatListCubit>(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Top Bar

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.starProfile),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          ProfileHeader(
            title: 'الرسائل',
            showBackButton: false,
          ),
          SizedBox(height: 16.h),
          ChatTabBar(
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });

              // Set the current tab index in the cubit
              final chatListCubit = context.read<ChatListCubit>();
              chatListCubit.setCurrentTabIndex(index);

              // Load appropriate data based on selected tab
              if (index == 0) {
                // All chats tab
                chatListCubit.getChatList();
              } else if (index == 1) {
                // Favorites tab
                chatListCubit.getFavoriteChatList();
              }
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Chat Content
  Widget _buildChatContent() {
    return BlocConsumer<ChatListCubit, ChatListState>(
      listener: (context, state) {
        // Mark that we've loaded initially when we get our first successful load
        if (state is ChatListLoaded) {
          _hasLoadedInitially = true;
        }
      },
      buildWhen: (previous, current) {
        // Always rebuild for loading states when switching tabs
        if (current is ChatListLoading) {
          return true;
        }
        // Prevent rebuilding with loading state after initial load for silent refreshes
        if (_hasLoadedInitially && current is ChatListLoading) {
          return false; // Don't rebuild for subsequent loading states
        }
        return true;
      },
      builder: (context, state) {
        // Show loading indicator for the very first load or when switching tabs
        if (state is ChatListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state only if we haven't loaded yet
        if (state is ChatListError && !_hasLoadedInitially) {
          return _buildEmptyState();
        }

        // Show loaded state
        if (state is ChatListLoaded) {
          final chats = state.chatList.data;

          // No filtering needed since the API already returns the correct data
          // based on the selected tab (all chats or favorites)
          final filteredChats = chats;

          if (filteredChats.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredChats.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return ChatRoomItem(
                chat: chat,
                chatListCubit: context.read<ChatListCubit>(),
                onTap: () {
                  // Mark this chat as read when opened
                  _markChatAsRead(chat);

                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatConversationScreen,
                    arguments: {"chatRoom": chat.toChatRoomModel()},
                  );
                },
                onLongPress: () {
                  _showChatOptions(context, chat);
                },
              );
            },
          );
        }

        // Default fallback
        return _buildEmptyState();
      },
    );
  }

  /// 🔹 Empty State

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyChatIllustration(),
          SizedBox(height: 24.h),
          Text(
            _selectedTabIndex == 1
                ? 'لا توجد محادثات مفضلة'
                : 'لا يوجد رسائل حتى الآن',
            style: AppTextStyles.font23ChineseBlackBoldLamaSans.copyWith(
              color: AppColors.darkerBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🔹 Mark Chat as Read
  void _markChatAsRead(ChatData chat) {
    if (chat.unreadCount > 0) {
      // Mark chat as read using the cubit's method
      context.read<ChatListCubit>().markChatAsRead(chat.id);
    }
  }

  /// 🔹 Show Chat Options

  void _showChatOptions(BuildContext context, dynamic chatRoom) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'مسح الدردشة',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('حظر المستخدم'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
