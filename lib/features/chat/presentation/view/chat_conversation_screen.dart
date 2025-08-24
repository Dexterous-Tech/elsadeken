import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_message_model.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_message_bubble.dart';

class ChatConversationScreen extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatConversationScreen({
    Key? key,
    required this.chatRoom,
  }) : super(key: key);

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeMockMessages();
  }

  void _initializeMockMessages() {
    // Add some mock messages
    _messages.addAll([
      ChatMessageModel(
        id: '1',
        roomId: widget.chatRoom.id,
        senderId: widget.chatRoom.id,
        senderName: widget.chatRoom.name,
        senderImage: widget.chatRoom.image,
        message: 'مرحبا، كيف حالك؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: true,
      ),
      ChatMessageModel(
        id: '2',
        roomId: widget.chatRoom.id,
        senderId: 'current_user',
        senderName: 'أنا',
        senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
        message: 'أهلا وسهلا، الحمد لله',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isRead: true,
      ),
      ChatMessageModel(
        id: '3',
        roomId: widget.chatRoom.id,
        senderId: widget.chatRoom.id,
        senderName: widget.chatRoom.name,
        senderImage: widget.chatRoom.image,
        message: 'ممتاز، هل تريد أن نلتقي؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ]);
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
      /*actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: AppColors.darkerBlue),
          onPressed: () => _showChatOptions(),
        ),
      ],*/
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _messages.length + 1, // +1 for the day separator
      itemBuilder: (context, index) {
        if (index == 0) {
          // Day separator at the top
          return _buildDaySeparator();
        }
        
        final messageIndex = index - 1;
        final message = _messages[messageIndex];
        final isCurrentUser = message.senderId == 'current_user';
        
        return ChatMessageBubble(
          message: message,
          isCurrentUser: isCurrentUser,
        );
      },
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
      // Format: "15 مارس" (day + month name in Arabic)
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

    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: widget.chatRoom.id,
      senderId: 'current_user',
      senderName: 'أنا',
      senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    
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

  void _showChatOptions() {
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
                _showDeleteConfirmation();
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

  void _showDeleteConfirmation() {
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
              Navigator.pop(context); // Go back to chat list
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
