import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/chat/presentation/manager/cubit/chatListCubit/cubit/chat_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/app_images.dart';
import 'chat_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 10,
          left: -20,
          child: Image.asset(
            AppImages.starProfile,
            width: 488.w,
            height: 325.h,
          ),
        ),
        BlocProvider(
          create: (context) => sl<ChatListCubit>(),
          child: ChatScreen(),
        ),
      ],
    );
  }
}
