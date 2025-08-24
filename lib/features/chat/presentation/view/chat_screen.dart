import 'package:flutter/material.dart';
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
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Favorites
  
  // Static mock data
  late List<ChatRoomModel> _chatRooms;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _chatRooms = [
      ChatRoomModel(
        id: '1',
        name: 'محمد القحطاني',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'مرحبا كيف حالك ؟',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
        isFavorite: true,
      ),
      ChatRoomModel(
        id: '2',
        name: 'فاطمة علي',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
        lastMessage: 'شكرا لك',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
      ),
      ChatRoomModel(
        id: '3',
        name: 'أحمد محمد',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'أراك غدا',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
        isOnline: true,
        isFavorite: false,
      ),
      ChatRoomModel(
        id: '4',
        name: 'سارة أحمد',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
        lastMessage: 'هل تريد أن نلتقي في المطعم؟',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 3,
        isOnline: false,
        isFavorite: true,
      ),
      ChatRoomModel(
        id: '5',
        name: 'علي حسن',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'أشكرك على المساعدة',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: _buildChatContent(),
              ),
              const ChatOptionsCard(),
            ],
          ),
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
          image: AssetImage(AppImages.starProfile), // Use stars.png background
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
    final chatRooms = _selectedTabIndex == 1 
        ? _chatRooms.where((room) => room.isFavorite).toList()
        : _chatRooms;

    if (chatRooms.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: chatRooms.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return ChatRoomItem(
          chatRoom: chatRoom,
          onTap: () {
            // Navigate to individual chat
            Navigator.pushNamed(
              context,
              AppRoutes.chatConversationScreen,
              arguments: {'chatRoom': chatRoom}, // Fix: Pass as Map with 'chatRoom' key
            );
          },
          onLongPress: () {
            _showChatOptions(context, chatRoom);
          },
        );
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
          SizedBox(height: 8.h),
          Text(
            _selectedTabIndex == 1
                ? 'لم تقم بإضافة أي محادثات إلى المفضلة بعد'
                : 'ليس لديك أي رسائل جديدة في الوقت الحالي.',
            style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
              color: AppColors.darkerBlue.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'عد لاحقاً',
            style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
              color: AppColors.darkerBlue.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🔹 Show Chat Options
  void _showChatOptions(BuildContext context, ChatRoomModel chatRoom) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('مسح الدردشة', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, chatRoom);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text('إضافة إلى المفضلة'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to favorites
              },
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text('حظر المستخدم'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement block user
              },
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Show Delete Confirmation
  void _showDeleteConfirmation(BuildContext context, ChatRoomModel chatRoom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذه المحادثة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
