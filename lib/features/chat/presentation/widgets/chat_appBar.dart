import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_online_setting_cubit/chat_online_setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chatRoomId;
  final String chatRoomName;
  final String chatRoomImage;
  final VoidCallback onBack;

  const ChatAppBar({
    super.key,
    required this.chatRoomId,
    required this.chatRoomName,
    required this.chatRoomImage,
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
      title: BlocProvider<ChatOnlineSettingCubit>(
        create: (context) => sl<ChatOnlineSettingCubit>()..getOnline(),
        child: Builder(builder: (context) {
          return Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(chatRoomImage),
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
                          BlocBuilder<ChatOnlineSettingCubit,
                              ChatOnlineSettingState>(
                            buildWhen: (previous, current) =>
                                current is ChatOnlineSettingGetSuccess ||
                                current is ChatOnlineSettingGetFailure ||
                                current is ChatOnlineSettingGetLoading,
                            builder: (context, state) {
                              if (state is ChatOnlineSettingGetSuccess) {
                                final status = state.chatOnlineSettingModel.data
                                        ?.enableOnline ==
                                    1;
                                return Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: status
                                        ? AppColors.primaryOrange
                                        : Colors.red,
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
                          BlocBuilder<ChatOnlineSettingCubit,
                              ChatOnlineSettingState>(
                            buildWhen: (previous, current) =>
                                current is ChatOnlineSettingGetSuccess ||
                                current is ChatOnlineSettingGetFailure ||
                                current is ChatOnlineSettingGetLoading,
                            builder: (context, state) {
                              if (state is ChatOnlineSettingGetFailure) {
                                return Text(
                                  'حدث خطأ اثناء تحديث الحالة',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              } else if (state is ChatOnlineSettingGetSuccess) {
                                final status = state.chatOnlineSettingModel.data
                                        ?.enableOnline ==
                                    1;
                                return Text(
                                  status ? 'متصل الآن' : 'غير متصل',
                                  style: TextStyle(
                                    color: Colors.red,
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
