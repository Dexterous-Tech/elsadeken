import 'dart:developer';
import 'package:elsadeken/core/services/firebase_notification_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/home/notification/notification/presentation/manager/notification_count_cubit.dart';
import 'package:elsadeken/features/home/notification/notification/presentation/manager/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../notification/notification/presentation/view/notification_screen.dart';

class HomeNotification extends StatefulWidget {
  const HomeNotification({super.key});

  @override
  State<HomeNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<HomeNotification> {
  final _notificationService = FirebaseNotificationService.instance;

  @override
  void initState() {
    _refreshNotificationCount();
    super.initState();
  }

  // Method to refresh notification count
  void _refreshNotificationCount() {
    if (mounted) {
      log('Refreshing notification count...');
      context.read<NotificationCountCubit>().refreshCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          child: Container(
            width: 47.w,
            height: 47.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFCF8F5),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/home_notification.png',
                width: 22.w,
                height: 20.h,
              ),
            ),
          ),
          onTap: () async {
            log('Navigating to notification screen...');
            // Navigate to notification screen and wait for result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
            );

            // Refresh notification count when user returns from notification screen
            // result will be true when user navigates back from notification screen
            if (mounted && result == true) {
              log('User returned from notification screen, refreshing count...');
              _refreshNotificationCount();
            } else {
              log('User returned from notification screen but no refresh needed');
            }
          },
        ),
        Positioned(
          bottom: -2.w,
          right: -2.h,
          child: BlocBuilder<NotificationCountCubit, NotificationCountState>(
            buildWhen: (context, current) =>
                current is NotificationLoading ||
                current is NotificationCountFailure ||
                current is NotificationCountSuccess,
            builder: (context, state) {
              return Container(
                width: 20.w,
                height: 20.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: AppColors.red),
                child: Center(
                  child: state is NotificationCountLoading
                      ? SizedBox(
                          width: 3.w,
                          height: 3.h,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ))
                      : state is NotificationCountSuccess
                          ? Text(
                              '${state.notificationCountResponseModel.data!.countUnreadNotifications ?? 0}',
                              style: AppTextStyles.font14BlackRegularLamaSans
                                  .copyWith(
                                      color: AppColors.white, fontSize: 10.sp),
                            )
                          : Text(
                              '0',
                              style: AppTextStyles.font14BlackRegularLamaSans
                                  .copyWith(
                                      color: AppColors.white, fontSize: 10.sp),
                            ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
