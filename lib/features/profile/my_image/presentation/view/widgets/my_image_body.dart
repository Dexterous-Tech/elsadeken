import 'dart:developer';

import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/my_image/presentation/manager/my_image_cubit.dart';
import 'package:elsadeken/features/profile/widgets/container_success_way.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';

class MyImageBody extends StatefulWidget {
  final String? photoVisibility;

  const MyImageBody({super.key, this.photoVisibility});

  @override
  State<MyImageBody> createState() => _MyImageBodyState();
}

class _MyImageBodyState extends State<MyImageBody> {
  // Default selection: "لا احد" (No one)
  String selectedPrivacyOption = 'all_members';
  String? userGender;
  bool isLoadingGender = true;
  bool hasChanges = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _loadUserGender();
    _loadPrivacySetting();
  }

  Future<void> _loadUserGender() async {
    try {
      final gender = await SharedPreferencesHelper.getSecuredString(
          SharedPreferencesKey.gender);
      log(gender);
      setState(() {
        userGender = gender;
        isLoadingGender = false;
      });
    } catch (e) {
      setState(() {
        isLoadingGender = false;
      });
    }
  }

  Future<void> _loadPrivacySetting() async {
    // Use photoVisibility from profile response
    if (widget.photoVisibility != null) {
      setState(() {
        selectedPrivacyOption =
            widget.photoVisibility == 'deny' ? 'no_one' : 'all_members';
      });
    } else {
      // Default to all_members if no photoVisibility provided
      setState(() {
        selectedPrivacyOption = 'all_members';
      });
    }
  }

  @override
  void dispose() {
    _isNavigating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: LocalizationService.instance.textDirection,
          children: [
            ProfileHeader(
              title: AppLocalizations.of(context)!.myImage,
              onPressed: () async {
                // Prevent multiple navigation calls
                if (_isNavigating) return;
                _isNavigating = true;

                // Return true if there were changes, false otherwise
                if (mounted) {
                  Navigator.pop(context, hasChanges);
                }
              },
            ),
            verticalSpace(30),
            Text(
              AppLocalizations.of(context)!.importantInformation,
              textDirection: LocalizationService.instance.textDirection,
              style: AppTextStyles.font20LightOrangeMediumLamaSans.copyWith(
                color: Color(0xffF9F9F9),
              ),
            ),
            verticalSpace(30),
            informationItem(AppLocalizations.of(context)!.imageGuidelines1),
            informationItem(AppLocalizations.of(context)!.imageGuidelines2),
            verticalSpace(35),
            BlocConsumer<MyImageCubit, MyImageState>(
              buildWhen: (previous, current) =>
                  current is MyImageLoading ||
                  current is MyImageFailure ||
                  current is MyImageSuccess ||
                  current is MyImageImageSelected ||
                  current is MyImageInitial,
              listenWhen: (previous, current) =>
                  current is MyImageLoading ||
                  current is MyImageFailure ||
                  current is MyImageSuccess ||
                  current is MyImageImageSelected ||
                  current is MyImageInitial,
              listener: (context, state) {
                if (state is MyImageLoading) {
                  loadingDialog(context);
                } else if (state is MyImageFailure) {
                  Navigator.pop(context); // Close loading dialog
                  errorDialog(
                    context: context,
                    error: state.error,
                    onPressed: () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                } else if (state is MyImageSuccess) {
                  Navigator.pop(context); // Close loading dialog
                  successDialog(
                    context: context,
                    message: state.profileActionResponseModel.message ??
                        AppLocalizations.of(context)!.imageUploadedSuccessfully,
                    onPressed: () {
                      if (_isNavigating) return;
                      _isNavigating = true;

                      // Close success dialog and navigate back
                      Navigator.pop(context); // Close success dialog
                      if (mounted) {
                        Navigator.pop(
                            context, true); // Return to previous screen
                      }
                    },
                  );
                } else if (state is MyImageImageSelected) {
                  // Image was selected, mark as changed
                  hasChanges = true;
                } else if (state is MyImageInitial) {
                  // Image was deleted, no need to show any dialog
                  // The UI will automatically rebuild to show the camera icon
                }
              },
              builder: (context, state) {
                return Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceDialog(
                        context, context.read<MyImageCubit>()),
                    child: state is MyImageImageSelected
                        ? Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: Image.file(
                                  state.image,
                                  width: 135.w,
                                  height: 135.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MyImageCubit>()
                                          .deleteImage();
                                    },
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: 22.sp,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Image.asset(
                            AppImages.cameraProfile,
                            width: 134.w,
                            height: 134.h,
                          ),
                  ),
                );
              },
            ),
            verticalSpace(30),
            // Show privacy settings only for males
            if (!isLoadingGender &&
                (userGender!.toLowerCase() == 'ذكر' ||
                    userGender!.toLowerCase() == 'male')) ...[
              BlocListener<MyImageCubit, MyImageState>(
                listenWhen: (previous, current) =>
                    current is UpdateImageSettingLoading ||
                    current is UpdateImageSettingFailure ||
                    current is UpdateImageSettingSuccess,
                listener: (context, state) {
                  if (state is UpdateImageSettingLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .updatingPrivacySettings,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: AppTextStyles
                                    .font14PumpkinOrangeBoldLamaSans
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.primaryOrange,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.all(16.w),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (state is UpdateImageSettingFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.error,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.font14PumpkinOrangeBoldLamaSans
                              .copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        backgroundColor: AppColors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.all(16.w),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  } else if (state is UpdateImageSettingSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          selectedPrivacyOption == 'no_one'
                              ? AppLocalizations.of(context)!
                                  .noOneWillSeeYourImage
                              : AppLocalizations.of(context)!
                                  .everyoneWillSeeYourImage,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.font14PumpkinOrangeBoldLamaSans
                              .copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        backgroundColor: AppColors.primaryOrange,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.all(16.w),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Column(
                  textDirection: LocalizationService.instance.textDirection,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerSuccessWay(
                        text:
                            AppLocalizations.of(context)!.allowedToViewMyImage),
                    verticalSpace(30),
                    Row(
                      textDirection: LocalizationService.instance.textDirection,
                      children: [
                        Radio<String>(
                          value: 'no_one',
                          groupValue: selectedPrivacyOption,
                          onChanged: (value) {
                            setState(() {
                              selectedPrivacyOption = value!;
                              hasChanges = true;
                            });
                            // Call cubit method with 'deny'
                            context
                                .read<MyImageCubit>()
                                .updateImageSetting('deny');
                          },
                          activeColor: AppColors.primaryOrange,
                        ),
                        horizontalSpace(10),
                        Expanded(
                          child: RichText(
                            textAlign:
                                LocalizationService.instance.textAlignment,
                            textDirection:
                                LocalizationService.instance.textDirection,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.noOne} ',
                                    style: AppTextStyles
                                        .font14PumpkinOrangeBoldLamaSans
                                        .copyWith(color: AppColors.black)),
                                TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.hideMyImage,
                                  style: AppTextStyles
                                      .font14PumpkinOrangeBoldLamaSans
                                      .copyWith(color: AppColors.beer),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    Row(
                      textDirection: LocalizationService.instance.textDirection,
                      children: [
                        Radio<String>(
                          value: 'all_members',
                          groupValue: selectedPrivacyOption,
                          onChanged: (value) {
                            setState(() {
                              selectedPrivacyOption = value!;
                              hasChanges = true;
                            });
                            // Call cubit method with 'allow'
                            context
                                .read<MyImageCubit>()
                                .updateImageSetting('allow');
                          },
                          activeColor: AppColors.primaryOrange,
                        ),
                        horizontalSpace(10),
                        Expanded(
                          child: RichText(
                            textAlign:
                                LocalizationService.instance.textAlignment,
                            textDirection:
                                LocalizationService.instance.textDirection,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${AppLocalizations.of(context)!.allMembers} ',
                                  style: AppTextStyles
                                      .font14PumpkinOrangeBoldLamaSans
                                      .copyWith(color: AppColors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(30),
                  ],
                ),
              ),
            ],
            // Show hint text for non-male users
            if (!isLoadingGender &&
                (userGender!.toLowerCase() != 'ذكر' &&
                    userGender!.toLowerCase() != 'male')) ...[
              Column(
                children: [
                  ContainerSuccessWay(
                      text: AppLocalizations.of(context)!.allowedToViewMyImage),
                  verticalSpace(30),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noOneCanSeeYourImage,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14PumpkinOrangeBoldLamaSans
                          .copyWith(
                        color: AppColors.beer,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(30),
            ],
            // Show current privacy status for males

            BlocBuilder<MyImageCubit, MyImageState>(
              buildWhen: (previous, current) =>
                  current is MyImageImageSelected ||
                  previous is MyImageImageSelected,
              builder: (context, state) {
                return CustomElevatedButton(
                  onPressed: context.read<MyImageCubit>().image != null
                      ? () => context.read<MyImageCubit>().updateImage()
                      : () {},
                  textButton: AppLocalizations.of(context)!.uploadImage,
                );
              },
            ),
            verticalSpace(20), // Add bottom padding for scroll safety
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, MyImageCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            AppLocalizations.of(context)!.chooseImageSource,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16BlackSemiBoldLamaSans,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryOrange),
                title: Text(
                  AppLocalizations.of(context)!.takePhotoFromCamera,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font14BlackRegularLamaSans,
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromCamera();
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: AppColors.primaryOrange),
                title: Text(
                  AppLocalizations.of(context)!.chooseFromGallery,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font14BlackRegularLamaSans,
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget informationItem(String info) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
      child: Row(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 14.h),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.jet),
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              info,
              textDirection: LocalizationService.instance.textDirection,
              textAlign: LocalizationService.instance.textAlignment,
              style: AppTextStyles.font19JetRegularLamaSans,
            ),
          )
        ],
      ),
    );
  }
}
