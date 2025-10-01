import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/toggle_switch/custom_advanced_toggle_switch.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/notification_settings_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/logout/logout_dialog.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/delete_image/delete_image_dialog.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_content_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';

import '../../../../../../core/di/injection_container.dart';
import '../../../../../../core/widgets/language_toggle.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _hasLoadedSettings = false;
  @override
  void initState() {
    super.initState();
    // We'll load notification settings in the build method instead
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ManageProfileCubit>(),
      child: BlocProvider(
        create: (context) => sl<ProfileCubit>(),
        child: BlocProvider(
          create: (context) => sl<NotificationSettingsProfileCubit>(),
          child: BlocListener<ManageProfileCubit, ManageProfileState>(
            listener: (context, state) {
              if (state is ManageProfileSuccess) {
                // Check if user is blocked (isBlocked = 0 means not blocked, 1 means blocked)
                final isBlocked = state.myProfileResponseModel.data?.isBlocked;
                if (isBlocked == 1) {
                  // User is not blocked, navigate to login
                  print(
                      '🚫 User is not blocked (isBlocked: $isBlocked), navigating to login');
                  context.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
                }
              }
            },
            child: BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is DeleteImageLoading) {
                  // Show loading indicator if needed
                } else if (state is DeleteImageFailure) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: AppColors.coralRed,
                    ),
                  );
                } else if (state is DeleteImageSuccess) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.logoutResponseModel.message ??
                            AppLocalizations.of(context)!.deleteImageSuccess,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: BlocListener<NotificationSettingsProfileCubit,
                  NotificationSettingsProfileState>(
                listener: (context, state) {
                  if (state is NotificationSettingsToggleSuccess) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          textDirection:
                              LocalizationService.instance.textDirection,
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is NotificationSettingsError) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          textDirection:
                              LocalizationService.instance.textDirection,
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: AppColors.coralRed,
                      ),
                    );
                  }
                },
                child: BlocBuilder<ManageProfileCubit, ManageProfileState>(
                  builder: (context, profileState) {
                    return BlocBuilder<NotificationSettingsProfileCubit,
                        NotificationSettingsProfileState>(
                      builder: (context, notificationState) {
                        // Load notification settings immediately on first build
                        if (notificationState
                            is NotificationSettingsProfileInitial) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context
                                .read<NotificationSettingsProfileCubit>()
                                .loadNotificationFromPrefs();
                          });
                        }

                        // Load profile data if not already loaded
                        if (profileState is ManageProfileInitial) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<ManageProfileCubit>().getProfile();
                          });
                        }

                        // Set profile data to notification cubit when profile is loaded
                        if (profileState is ManageProfileSuccess &&
                            !_hasLoadedSettings) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            print(
                                '🔔 Setting profile data to notification cubit - isNotifable: ${profileState.myProfileResponseModel.data?.isNotifable}');
                            context
                                .read<NotificationSettingsProfileCubit>()
                                .setProfileData(
                                    profileState.myProfileResponseModel);
                            _hasLoadedSettings = true;
                          });
                        }

                        // Load notification settings on first build if no profile data
                        if (!_hasLoadedSettings &&
                            profileState is! ManageProfileSuccess) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context
                                .read<NotificationSettingsProfileCubit>()
                                .loadNotificationFromPrefs();
                            _hasLoadedSettings = true;
                          });
                        }

                        final List<ProfileContentItemModel>
                            personalInformation = [
                          ProfileContentItemModel(
                            image: AppImages.myProfileIcon,
                            title: AppLocalizations.of(context)!.manageAccount,
                            onPressed: () {
                              context.pushNamed(AppRoutes.manageProfileScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.interestsListIcon,
                            title: AppLocalizations.of(context)!.interestsList,
                            onPressed: () {
                              context.pushNamed(
                                  AppRoutes.profileInterestsListScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.ignoringListIcon,
                            title: AppLocalizations.of(context)!.ignoringList,
                            onPressed: () {
                              context.pushNamed(
                                  AppRoutes.profileMyIgnoringListScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.interestingMeIcon,
                            title: AppLocalizations.of(context)!.whoInterestsMe,
                            onPressed: () {
                              context.pushNamed(
                                  AppRoutes.profileMyInterestingListScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.searchAdvancedIcon,
                            title: AppLocalizations.of(context)!.advancedSearch,
                            onPressed: () {
                              context.pushNamed(AppRoutes.searchScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.membersProfileImagesIcon,
                            title: AppLocalizations.of(context)!.membersPhotos,
                            onPressed: () {
                              context.pushNamed(
                                  AppRoutes.profileMembersProfileScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.excellencePackageIcon,
                            title:
                                AppLocalizations.of(context)!.excellencePackage,
                            onPressed: () {
                              context.pushNamed(
                                  AppRoutes.profileExcellencePackageScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.successStoryIcon,
                            title: AppLocalizations.of(context)!.successStories,
                            onPressed: () {
                              context.pushNamed(AppRoutes.successStoriesScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.elsadekenNotesIcon,
                            title: AppLocalizations.of(context)!.blog,
                            onPressed: () {
                              context.pushNamed(AppRoutes.blogScreen);
                            },
                          ),
                        ];

                        final List<ProfileContentItemModel> appSettings = [
                          ProfileContentItemModel(
                            image: AppImages.aboutUsIcon,
                            title: AppLocalizations.of(context)!.aboutUs,
                            onPressed: () {
                              context.pushNamed(AppRoutes.profileAboutUsScreen);
                            },
                          ),
                          ProfileContentItemModel(
                            image: AppImages.appShareIcon,
                            title: AppLocalizations.of(context)!.shareApp,
                            onPressed: () {},
                          ),
                          ProfileContentItemModel(
                            image: AppImages.contactUsIcon,
                            title: AppLocalizations.of(context)!.contactUs,
                            onPressed: () {
                              context
                                  .pushNamed(AppRoutes.profileContactUsScreen);
                            },
                          ),
                        ];

                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            top: 21.h,
                            right: 46.5.w,
                            left: 66.5,
                            bottom: 19.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .personalInfo,
                                          style: AppTextStyles
                                              .font12GrayMediumLamaSans,
                                        ),
                                        verticalSpace(16),
                                        ...listGenerationContentItems(
                                            items: personalInformation),
                                        verticalSpace(24),
                                        Text(
                                          textDirection: LocalizationService
                                              .instance.textDirection,
                                          AppLocalizations.of(context)!
                                              .appSettings,
                                          style: AppTextStyles
                                              .font12GrayMediumLamaSans,
                                        ),
                                        verticalSpace(16),
                                        // Notification toggle widget above the notification item
                                        // Notification item
                                        ProfileContentItem(
                                          image: AppImages.notificationIcon,
                                          title: AppLocalizations.of(context)!
                                              .notifications,
                                          onPressed: () {
                                            // Navigate to notification screen
                                            // context.pushNamed(AppRoutes.notificationScreen);
                                          },
                                          leading: _buildNotificationToggle(
                                              notificationState),
                                        ),

                                        verticalSpace(16),

                                        ...listGenerationContentItems(
                                            items: appSettings),
                                        verticalSpace(15),
                                        // Language Toggle Section
                                        LanguageToggle(),
                                        verticalSpace(21),

                                        GestureDetector(
                                          onTap: () {
                                            deleteImageDialog(context);
                                          },
                                          child: Row(
                                            textDirection: LocalizationService
                                                .instance.textDirection,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.delete_forever,
                                                size: 40,
                                                color: AppColors.coralRed,
                                              ),
                                              horizontalSpace(16),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .deleteMyPhoto,
                                                style: AppTextStyles
                                                    .font14CharlestonGreenMediumLamaSans
                                                    .copyWith(
                                                        color:
                                                            AppColors.coralRed),
                                              ),
                                            ],
                                          ),
                                        ),
                                        verticalSpace(21),
                                        GestureDetector(
                                          onTap: () {
                                            logoutDialog(context);
                                          },
                                          child: Row(
                                            textDirection: LocalizationService
                                                .instance.textDirection,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                AppImages.logoutIcon,
                                                width: 44.w,
                                                height: 44.h,
                                              ),
                                              horizontalSpace(16),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .logout,
                                                style: AppTextStyles
                                                    .font14CharlestonGreenMediumLamaSans
                                                    .copyWith(
                                                        color:
                                                            AppColors.coralRed),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(NotificationSettingsProfileState state) {
    bool isEnabled = false; // Default to false

    if (state is NotificationSettingsProfileLoaded) {
      isEnabled = state.isEnabled;
      print(
          '🔔 Notification toggle: ProfileLoaded state - isEnabled: $isEnabled');
    } else if (state is NotificationSettingsToggleSuccess) {
      isEnabled = state.isEnabled;
      print(
          '🔔 Notification toggle: ToggleSuccess state - isEnabled: $isEnabled');
    } else if (state is NotificationSettingsProfileInitial) {
      // When in initial state, show loading indicator
      // The loadNotificationFromPrefs() should be called in initState()
      print(
          '🔔 Notification toggle: Initial state - showing loading indicator');
      return const SizedBox(
        width: 50,
        height: 30,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (state is NotificationSettingsProfileLoading) {
      print(
          '🔔 Notification toggle: Loading state - showing loading indicator');
      return const SizedBox(
        width: 50,
        height: 30,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (state is NotificationSettingsError) {
      print('🔔 Notification toggle: Error state - defaulting to false');
      // Could show an error indicator here if needed
    }

    print('🔔 Final toggle value: $isEnabled');

    return CustomAdvancedToggleSwitch(
      initialValue: isEnabled,
      onChanged: (bool value) {
        print('🔔 Toggle changed to: $value');
        // Handle notification toggle change using API only
        context
            .read<NotificationSettingsProfileCubit>()
            .toggleNotificationWithApi(value);
      },
    );
  }
}

List<Widget> listGenerationContentItems({
  required List<ProfileContentItemModel> items,
}) {
  return List.generate(items.length, (index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: LocalizationService.instance.textDirection,
      children: [
        ProfileContentItem(
          image: items[index].image,
          title: items[index].title,
          onPressed: items[index].onPressed,
          leading: items[index].leading,
        ),
        if (index != items.length - 1) ...[
          verticalSpace(16),
          Container(
            width: double.infinity,
            height: 1.h,
            color: AppColors.brightGray,
          ),
          verticalSpace(9),
        ],
      ],
    );
  });
}

class ProfileContentItemModel {
  final String image;
  final String title;
  final void Function()? onPressed;
  final Widget? leading;

  ProfileContentItemModel({
    required this.image,
    required this.title,
    required this.onPressed,
    this.leading,
  });
}
