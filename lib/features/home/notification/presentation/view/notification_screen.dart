import 'dart:developer';

import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/features/home/notification/data/repo/notification_repo.dart';
import 'package:elsadeken/features/home/notification/presentation/manager/notification_cubit.dart';
import 'package:elsadeken/features/home/notification/presentation/view/widgets/empty_notification.dart';
import 'package:elsadeken/features/home/notification/presentation/view/widgets/notification_list.dart';

import '../../../../../core/di/injection_container.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(sl<NotificationRepoInterface>()),
      child: Scaffold(
        backgroundColor: Color(0xffFFFAFC),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: -20,
              child: Image.asset(
                AppImages.starProfile,
                width: 488.w,
                height: 325.h,
              ),
            ),
            SafeArea(
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Return true to indicate that notification count should be refreshed
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: ShapeDecoration(
                                color: AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8).r)),
                            child: Center(
                              child: Image.asset(
                                AppImages.authArrowBack,
                                width: 14.w,
                                height: 14.h,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'الإشعارات',
                          style: AppTextStyles.font20WhiteBoldLamaSans
                              .copyWith(color: AppColors.black),
                        ),
                        SizedBox(
                          width: 40.w,
                          height: 40.h,
                        )
                      ],
                    ),
                  ),
                  verticalSpace(32),
                  Expanded(child: const NotificationScreenContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreenContent extends StatefulWidget {
  const NotificationScreenContent({super.key});

  @override
  State<NotificationScreenContent> createState() =>
      _NotificationScreenContentState();
}

class _NotificationScreenContentState extends State<NotificationScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    context.read<NotificationCubit>().getNotifications(page: 1);
  }

  void _loadMoreNotifications() {
    final cubit = context.read<NotificationCubit>();
    final state = cubit.state;

    if (state is NotificationSuccess && state.hasNextPage && !_isLoadingMore) {
      // Use the current page from the state and increment it
      final nextPage = state.currentPage + 1;
      log('Loading more notifications: current page ${state.currentPage}, next page $nextPage, hasNextPage: ${state.hasNextPage}');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.getNotifications(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          log('Pagination loading completed');
        }
      });
    } else {
      log('Cannot load more: state is ${state.runtimeType}, hasNextPage: ${state is NotificationSuccess ? state.hasNextPage : false}, isLoadingMore: $_isLoadingMore');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      log('Scroll threshold reached, triggering pagination');
      _loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildNotificationBody();
  }

  Widget _buildNotificationBody() {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        log('Notification state changed to: ${state.runtimeType}');
        if (state is NotificationError) {
          setState(() {
            _isLoadingMore = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontSize: 14.sp),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is NotificationSuccess) {
          log('Notification success: ${state.notifications.length} items, page ${state.currentPage}, hasNextPage: ${state.hasNextPage}');
        }
      },
      builder: (context, state) {
        log('Building notification body with state: ${state.runtimeType}');

        if (state is NotificationLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        }

        if (state is NotificationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loadNotifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is NotificationSuccess) {
          if (state.notifications.isEmpty) {
            return const EmptyNotificationsWidget();
          }

          log('Building notification list with ${state.notifications.length} items, isLoadingMore: $_isLoadingMore');
          return NotificationListWidget(
            notifications: state.notifications,
            scrollController: _scrollController,
            hasNextPage: state.hasNextPage,
            isLoadingMore: _isLoadingMore,
            onRefresh: _loadNotifications,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
