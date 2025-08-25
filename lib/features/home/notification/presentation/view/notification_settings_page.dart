import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/home/notification/presentation/view/notification_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

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
        NotificationSettingsScreen(),
      ],
    );
  }
}
