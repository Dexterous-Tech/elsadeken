import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/view/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/app_images.dart';
import '../../../../core/theme/app_color.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cosmicLatte,
            AppColors.antiqueWhite,
          ],
        ),
      ),
      child: Stack(
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
      ),
    );
  }
}
