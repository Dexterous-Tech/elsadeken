import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/home/person_details/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../chat/data/models/chat_room_model.dart';
import '../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import '../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';

class PersonInfoSheet extends StatefulWidget {
  final PersonModel person;

  const PersonInfoSheet({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonInfoSheet> createState() => _PersonInfoSheetState();
}

class _PersonInfoSheetState extends State<PersonInfoSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.5, 0.6, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildPersonHeader(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                    const SizedBox(height: 30),
                    _buildLogTable(),
                    const SizedBox(height: 30),
                    _buildDataTable(),
                    const SizedBox(height: 30),
                    Center(child: _buildActionButtons()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final isExpanded = _controller.size > 0.7;
        _controller.animateTo(
          isExpanded ? 0.4 : 0.95,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Center(
        child: Container(
          width: 60.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonHeader() {
    final p = widget.person;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                p.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${p.attribute.country}, ${p.attribute.city}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    final p = widget.person;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'عن الشخص',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 8),
        Text(
          p.attribute.aboutMe,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLogTable() {
    final p = widget.person;
    final data = [
      {'label': 'مسجل منذ', 'value': p.createdAt},
      {'label': 'تاريخ آخر زيادة', 'value': 'متواجد حاليا'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius: BorderRadius.circular(2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: const Text(
                'تاريخ السجل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lighterOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['value']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 46, 34, 30),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final p = widget.person;
    final data = [
      {'label': 'الجنسيه', 'value': p.attribute.nationality},
      {'label': 'الاقامه', 'value': p.attribute.city},
      {'label': 'المدينه', 'value': p.attribute.city},
      {'label': 'نوع الزواج', 'value': p.attribute.typeOfMarriage},
      {'label': 'الحاله الاجتماعيه', 'value': p.attribute.maritalStatus},
      {'label': 'عدد الاطفال', 'value': p.attribute.children.toString()},
      {'label': 'لون البشره', 'value': p.attribute.skinColor},
      {'label': 'الطول', 'value': "${p.attribute.height} سم"},
      {'label': 'الوزن', 'value': "${p.attribute.weight} كجم"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerRight,
            child: const Text(
              'المعلومات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lighterOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['value']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 46, 34, 30),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, 'rejected');
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
        horizontalSpace(21),
        GestureDetector(
          onTap: () async {
            try {
              print('🔍 [PersonInfo] Message icon tapped for user ID: ${widget.person.id}');
              
              // Check if there's an existing chat room first
              final chatListCubit = context.read<ChatListCubit>();
              
              // Check if chat list is already loaded, if not, load it
              if (chatListCubit.state is! ChatListLoaded) {
                print('🔄 [PersonInfo] Chat list not loaded, loading now...');
                await chatListCubit.forceRefreshChatList();
              } else {
                print('✅ [PersonInfo] Chat list already loaded');
              }
              
              // Find existing chat room between current user and this profile user
              final existingChatRoom = chatListCubit.findExistingChatRoom(widget.person.id);
              
              if (existingChatRoom != null) {
                print('✅ [PersonInfo] Found existing chat room, navigating to it');
                // Navigate to existing chat room
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatConversationScreen,
                  arguments: {
                    "chatRoom": existingChatRoom,
                  },
                );
              } else {
                print('🆕 [PersonInfo] No existing chat room found, creating new temporary chat');
                // Create new temporary chat room for new conversation
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatConversationScreen,
                  arguments: {
                    "chatRoom": ChatRoomModel.fromUser(
                      userId: widget.person.id,
                      userName: widget.person.name,
                      userImage: widget.person.image,
                    ),
                  },
                );
              }
            } catch (e) {
              print('❌ [PersonInfo] Error in message icon onTap: $e');
              // Fallback to creating new chat
              Navigator.pushNamed(
                context,
                AppRoutes.chatConversationScreen,
                arguments: {
                  "chatRoom": ChatRoomModel.fromUser(
                    userId: widget.person.id,
                    userName: widget.person.name,
                    userImage: widget.person.image,
                  ),
                },
              );
            }
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/home_outline_message.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 16)
      ],
    );
  }
}
