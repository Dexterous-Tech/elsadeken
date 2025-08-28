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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0; // 0: All, 1: Favorites

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ChatListCubit>().getChatList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh chat list when app is resumed to ensure unread counts are up to date
    if (state == AppLifecycleState.resumed) {
      context.read<ChatListCubit>().getChatList();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Refresh chat list when dependencies change (e.g., when screen becomes focused)
    // This ensures unread counts are updated when returning from a conversation
    context.read<ChatListCubit>().getChatList();
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
          ProfileHeader(title: 'الرسائل',showBackButton: false,),
          SizedBox(height: 16.h),
          ChatTabBar(
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Chat Content
  Widget _buildChatContent() {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatListError) {
          return _buildEmptyState();
        } else if (state is ChatListLoaded) {
          final chats = state.chatList.data;

          final filteredChats = _selectedTabIndex == 1
              ? chats.where((c) => c.unreadCount > 0).toList()
              : chats;

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
      print('[ChatScreen] Marking chat ${chat.id} as read');
      
      // Get current state
      final currentState = context.read<ChatListCubit>().state;
      if (currentState is ChatListLoaded) {
        // Create updated chat list with this chat marked as read
        final updatedChatList = currentState.chatList.copyWith(
          data: currentState.chatList.data.map((c) {
            if (c.id == chat.id) {
              return c.copyWith(unreadCount: 0);
            }
            return c;
          }).toList(),
        );
        
        // Emit updated state
        context.read<ChatListCubit>().emit(ChatListLoaded(updatedChatList));
      }
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
