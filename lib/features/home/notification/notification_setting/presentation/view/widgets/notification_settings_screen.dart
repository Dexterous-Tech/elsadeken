import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/core/di/injection_container.dart';

import 'package:elsadeken/features/home/notification/notification_setting/presentation/manager/notification_settings_cubit.dart'
    as home;

import '../../../../../../../core/services/localization_service.dart';

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
        context.read<home.NotificationSettingsCubit>().loadNotificationSettings(
              whoAddedMeToFavorites:
                  AppLocalizations.of(context)!.whoAddedMeToFavorites,
              profileVisits: AppLocalizations.of(context)!.profileVisits,
              whoAddedMeToIgnoreList:
                  AppLocalizations.of(context)!.whoAddedMeToIgnoreList,
              newMessages: AppLocalizations.of(context)!.newMessages,
              successStories: AppLocalizations.of(context)!.successStories,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizationService.instance.textDirection, // K
      child: Scaffold(
        body: Container(
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
          child: CustomProfileBody(
            contentBody: Column(
              crossAxisAlignment:
                  LocalizationService.instance.startCrossAxisAlignment,
              textDirection: LocalizationService.instance.textDirection, // K

              children: [
                _buildAppBar(),
                SizedBox(height: 12.h),
                _buildSettingsContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Top Bar with background
  Widget _buildAppBar() {
    return Padding(
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
      child: ProfileHeader(
          sizeContainer: 40,
          shape: BoxShape.rectangle,
          title: AppLocalizations.of(context)!.notificationSettings),
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
              textDirection: LocalizationService.instance.textDirection, // K
              children: [
                Text(
                  AppLocalizations.of(context)!.errorLoadingSettings,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.red,
                  ),
                  textDirection: LocalizationService.instance.textDirection,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<home.NotificationSettingsCubit>()
                        .loadNotificationSettings(
                          whoAddedMeToFavorites: AppLocalizations.of(context)!
                              .whoAddedMeToFavorites,
                          profileVisits:
                              AppLocalizations.of(context)!.profileVisits,
                          whoAddedMeToIgnoreList: AppLocalizations.of(context)!
                              .whoAddedMeToIgnoreList,
                          newMessages:
                              AppLocalizations.of(context)!.newMessages,
                          successStories:
                              AppLocalizations.of(context)!.successStories,
                        );
                  },
                  child: Text(AppLocalizations.of(context)!.tryAgain),
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

        return Center(
          child: Text(
            AppLocalizations.of(context)!.noData,
            textDirection: LocalizationService.instance.textDirection,
          ),
        );
      },
    );
  }

  Widget _buildSettingsList(List<Map<String, dynamic>> settings) {
    return Container(
      height: 420.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8).r,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Column(
        children: [
          for (int i = 0; i < settings.length; i++) ...[
            Transform.scale(
              scale: 0.8,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  settings[i]['title'] ?? '',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textDirection: LocalizationService.instance.textDirection,
                ),
                value: settings[i]['value'] ?? false,
                onChanged: (bool newValue) {
                  final settingId = settings[i]['id'];
                  if (settingId != null) {
                    final localizations = AppLocalizations.of(context)!;

                    String settingTitle =
                        _getSettingTitle(settingId, localizations);
                    String actionDescription = _getActionDescription(
                        settingId, newValue, localizations);

                    context
                        .read<home.NotificationSettingsCubit>()
                        .toggleNotificationSetting(
                          settingId,
                          newValue,
                          settingTitle: settingTitle,
                          actionDescription: actionDescription,
                          noCurrentSettingsError:
                              localizations.noCurrentSettingsFound,
                          toggleError:
                              localizations.failedToToggleNotificationSetting,
                        );
                  }
                },
                activeColor: AppColors.primaryOrange,
                activeTrackColor:
                    AppColors.primaryOrange.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey,
              ),
            ),
            if (i != settings.length - 1)
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 16.h,
              ),
          ],
        ],
      ),
    );
  }

  /// Get localized setting title based on settingId
  String _getSettingTitle(String settingId, AppLocalizations localizations) {
    switch (settingId) {
      case 'favorite_list':
        return localizations.whoAddedMeToFavorites;
      case 'visit_profile':
        return localizations.profileVisits;
      case 'ignore_list':
        return localizations.whoAddedMeToIgnoreList;
      case 'message':
        return localizations.newMessages;
      case 'blog':
        return localizations.successStories;
      default:
        return localizations.settingLabel;
    }
  }

  /// Get localized action description based on settingId and isActive
  String _getActionDescription(
      String settingId, bool isActive, AppLocalizations localizations) {
    if (isActive) {
      switch (settingId) {
        case 'favorite_list':
          return localizations.willNotifyWhenAddedToFavorites;
        case 'visit_profile':
          return localizations.willNotifyOnProfileVisit;
        case 'ignore_list':
          return localizations.willNotifyWhenAddedToIgnoreList;
        case 'message':
          return localizations.willNotifyOnNewMessages;
        case 'blog':
          return localizations.willNotifyOnSuccessStories;
        default:
          return localizations.notificationsAllowed;
      }
    } else {
      switch (settingId) {
        case 'favorite_list':
          return localizations.willNotNotifyWhenAddedToFavorites;
        case 'visit_profile':
          return localizations.willNotNotifyOnProfileVisit;
        case 'ignore_list':
          return localizations.willNotNotifyWhenAddedToIgnoreList;
        case 'message':
          return localizations.willNotNotifyOnNewMessages;
        case 'blog':
          return localizations.willNotNotifyOnSuccessStories;
        default:
          return localizations.notificationsNotAllowed;
      }
    }
  }
}
