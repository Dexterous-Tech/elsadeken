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
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Favorites

  @override
  void initState() {
    super.initState();

    context.read<ChatListCubit>().getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildChatContent()),
            const ChatOptionsCard(),
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
          ProfileHeader(title: 'الرسائل'),
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
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
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
                onTap: () {
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
