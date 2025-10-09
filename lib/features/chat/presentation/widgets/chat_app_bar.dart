import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/routes/app_routes.dart';

import '../../../../core/di/injection_container.dart';
import '../manager/chat_messages/cubit/chat_messages_state.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chatRoomId;
  final String chatRoomName;
  final String chatRoomImage;
  final int? receiverId;
  final VoidCallback onBack;

  const ChatAppBar({
    super.key,
    required this.chatRoomId,
    required this.chatRoomName,
    required this.chatRoomImage,
    this.receiverId,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfffef6ee),
      elevation: 0,
      leading: CustomArrowBack(onPressed: onBack),
      title: BlocProvider<ChatMessagesCubit>(
        create: (context) =>
            sl<ChatMessagesCubit>()..getChatMessages(chatRoomId),
        child: Builder(builder: (context) {
          return Row(
            children: [
              GestureDetector(
                onTap: receiverId != null
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profileDetailsScreen,
                          arguments: receiverId!,
                        );
                      }
                    : null,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(chatRoomImage),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatRoomName,
                      style: TextStyle(
                        color: AppColors.darkerBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!chatRoomId.startsWith('temp_'))
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                            buildWhen: (previous, current) =>
                                current is ChatMessagesLoaded ||
                                current is ChatMessagesError ||
                                current is ChatMessagesLoading,
                            builder: (context, state) {
                              if (state is ChatMessagesLoaded) {
                                final status = state.chatMessages.isOnline;
                                return Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: status
                                        ? AppColors.green
                                        : AppColors.red,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                            buildWhen: (previous, current) =>
                                current is ChatMessagesLoaded ||
                                current is ChatMessagesError ||
                                current is ChatMessagesLoading,
                            builder: (context, state) {
                              if (state is ChatMessagesError) {
                                return Text(
                                  AppLocalizations.of(context)!
                                      .errorUpdatingStatus,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              } else if (state is ChatMessagesLoaded) {
                                final status = state.chatMessages.isOnline;
                                return Text(
                                  status
                                      ? AppLocalizations.of(context)!.onlineNow
                                      : AppLocalizations.of(context)!.offline,
                                  style: TextStyle(
                                    color: status
                                        ? AppColors.green
                                        : AppColors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: 8.w,
                                  height: 8.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
