import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/app_images.dart';
import 'chat_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

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
        ChatScreen(),
      ],
    );
  }
}
