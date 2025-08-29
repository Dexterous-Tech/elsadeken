import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/core/di/injection_container.dart';

import 'package:elsadeken/features/home/notification/notification_setting/presentation/manager/notification_settings_cubit.dart'
    as home;

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<home.NotificationSettingsCubit>(),
      child: _NotificationSettingsContent(),
    );
  }
}

class _NotificationSettingsContent extends StatefulWidget {
  @override
  State<_NotificationSettingsContent> createState() =>
      _NotificationSettingsContentState();
}

class _NotificationSettingsContentState
    extends State<_NotificationSettingsContent> {
  @override
  void initState() {
    super.initState();
    // Load notification settings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<home.NotificationSettingsCubit>()
            .loadNotificationSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: CustomProfileBody(
          contentBody: Column(
            children: [
              _buildAppBar(),
              SizedBox(height: 12.h),
              Expanded(
                child: _buildSettingsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Top Bar with background
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: const ProfileHeader(title: 'إعدادات الإشعارات'),
    );
  }

  /// Settings List
  Widget _buildSettingsContent() {
    return BlocBuilder<home.NotificationSettingsCubit,
        home.NotificationSettingsState>(
      builder: (context, state) {
        if (state is home.NotificationSettingsLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.beer,
            ),
          );
        }

        if (state is home.NotificationSettingsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'خطأ في تحميل الإعدادات',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<home.NotificationSettingsCubit>()
                        .loadNotificationSettings();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is home.NotificationSettingsLoaded) {
          return _buildSettingsList(state.settings);
        }

        if (state is home.NotificationSettingsSuccess) {
          // Show snackbar for success
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          });

          return _buildSettingsList(state.settings);
        }

        return const Center(
          child: Text('لا توجد إعدادات'),
        );
      },
    );
  }

  Widget _buildSettingsList(List<Map<String, dynamic>> settings) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        itemCount: settings.length,
        separatorBuilder: (_, __) => Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 16.h,
        ),
        itemBuilder: (context, index) {
          final setting = settings[index];
          return Transform.scale(
            scale: 0.8,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                setting['title'] ?? '',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              value: setting['value'] ?? false,
              onChanged: (bool newValue) {
                final settingId = setting['id'];
                if (settingId != null) {
                  context
                      .read<home.NotificationSettingsCubit>()
                      .toggleNotificationSetting(
                        settingId,
                        newValue,
                      );
                }
              },
              activeColor: AppColors.primaryOrange,
              activeTrackColor: AppColors.primaryOrange.withValues(alpha: 0.3),
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.grey,
            ),
          );
        },
      ),
    );
  }
}
