import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/toggle_switch/custom_advanced_toggle_switch.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/notification_settings_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/logout/logout_dialog.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_content_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _hasLoadedSettings = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationSettingsCubit, NotificationSettingsState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      child: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
        builder: (context, state) {
          // Load notification settings on first build
          if (!_hasLoadedSettings) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<NotificationSettingsCubit>()
                  .loadNotificationSettings();
              _hasLoadedSettings = true;
            });
          }

          final List<ProfileContentItemModel> personalInformation = [
            ProfileContentItemModel(
              image: AppImages.myProfileIcon,
              title: 'ادارة حسابي',
              onPressed: () {
                context.pushNamed(AppRoutes.manageProfileScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.interestsListIcon,
              title: 'قائمه الاهتمام',
              onPressed: () {
                context.pushNamed(AppRoutes.profileInterestsListScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.ignoringListIcon,
              title: 'قائمه التجاهل',
              onPressed: () {
                context.pushNamed(AppRoutes.profileMyIgnoringListScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.interestingMeIcon,
              title: 'من يهتم بي',
              onPressed: () {
                context.pushNamed(AppRoutes.profileMyInterestingListScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.searchAdvancedIcon,
              title: 'بحث متقدم',
              onPressed: () {
                context.pushNamed(AppRoutes.searchScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.membersProfileImagesIcon,
              title: 'صور الاعضاء',
              onPressed: () {
                context.pushNamed(AppRoutes.profileMembersProfileScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.excellencePackageIcon,
              title: 'باقه التميز',
              onPressed: () {
                context.pushNamed(AppRoutes.profileExcellencePackageScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.successStoryIcon,
              title: 'قصص نجاح',
              onPressed: () {
                context.pushNamed(AppRoutes.successStoriesScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.elsadekenNotesIcon,
              title: 'مدونه الصادقين والصادقات',
              onPressed: () {
                context.pushNamed(AppRoutes.blogScreen);
              },
            ),
          ];

          final List<ProfileContentItemModel> appSettings = [
            ProfileContentItemModel(
              image: AppImages.aboutUsIcon,
              title: 'نبذه عننا',
              onPressed: () {
                context.pushNamed(AppRoutes.profileAboutUsScreen);
              },
            ),
            ProfileContentItemModel(
              image: AppImages.notificationIcon,
              title: 'الاشعارات',
              onPressed: () {
                // Navigate to notification screen
                context.pushNamed(AppRoutes.notificationScreen);
              },
              leading: _buildNotificationToggle(state),
            ),
            ProfileContentItemModel(
              image: AppImages.appShareIcon,
              title: 'مشاركه التطبيق',
              onPressed: () {},
            ),
            ProfileContentItemModel(
              image: AppImages.contactUsIcon,
              title: 'اتصل بنا',
              onPressed: () {
                context.pushNamed(AppRoutes.profileContactUsScreen);
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
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'معلومات شخصية',
                            style: AppTextStyles.font12GrayMediumLamaSans,
                          ),
                          verticalSpace(16),
                          ...listGenerationContentItems(
                              items: personalInformation),
                          verticalSpace(24),
                          Text(
                            'إعدادات التطبيق',
                            style: AppTextStyles.font12GrayMediumLamaSans,
                          ),
                          verticalSpace(16),
                          ...listGenerationContentItems(items: appSettings),
                          verticalSpace(21),
                          GestureDetector(
                            onTap: () {
                              logoutDialog(context);
                            },
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Image.asset(
                                  AppImages.logoutIcon,
                                  width: 44.w,
                                  height: 44.h,
                                ),
                                horizontalSpace(16),
                                Text(
                                  'تسجيل الخروج',
                                  style: AppTextStyles
                                      .font14CharlestonGreenMediumLamaSans
                                      .copyWith(color: AppColors.coralRed),
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
      ),
    );
  }

  Widget _buildNotificationToggle(NotificationSettingsState state) {
    bool isEnabled = true; // Default to true

    if (state is NotificationSettingsLoaded) {
      isEnabled = state.isEnabled;
    }

    return CustomAdvancedToggleSwitch(
      initialValue: isEnabled,
      onChanged: (bool value) {
        // Handle notification toggle change
        context.read<NotificationSettingsCubit>().toggleNotifications(value);
      },
    );
  }
}

List<Widget> listGenerationContentItems({
  required List<ProfileContentItemModel> items,
}) {
  return List.generate(items.length, (index) {
    return Column(
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
