import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/app_lottie.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/utils/profile_snackbar_handler.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Future<void> deleteProfileDialog(BuildContext context) async {
  // Reset the cubit state to avoid showing previous error states
  final cubit = context.read<ManageProfileCubit>();
  if (cubit.state is DeleteProfileFailure) {
    // Reset to initial state if there's a previous error
    cubit.resetState();
  }
  // Also clear the password field when opening dialog
  cubit.passwordController.clear();

  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    radius: 16,
    height: 400.h,
    dialogContent: BlocProvider.value(
      value: cubit,
      child: Builder(builder: (context) {
        return BlocListener<ManageProfileCubit, ManageProfileState>(
          listener: (context, state) {
            if (state is DeleteProfileFailure) {
              // Show error dialog instead of snackbar
              errorDialog(
                context: context,
                error: state.error,
                onPressed: () {
                  Navigator.pop(context); // Close error dialog
                  // Reset state after showing error
                  context.read<ManageProfileCubit>().resetState();
                },
              );
            } else if (state is DeleteProfileSuccess) {
              // Show success snackbar above dialog
              ProfileSnackbarHandler.showSnackBarAboveDialog(
                context,
                AppLocalizations.of(context)!.accountDeletedSuccessfully,
                AppColors.green,
              );
            }
          },
          child: BlocBuilder<ManageProfileCubit, ManageProfileState>(
            builder: (context, state) {
              if (state is DeleteProfileLoading) {
                // Show loading lottie
                return _loadingDelete();
              } else if (state is DeleteProfileFailure) {
                // Show error message
                return _errorDelete(context, state.error);
              } else if (state is DeleteProfileSuccess) {
                // Clear all app state and navigate to onboarding screen
                Future.delayed(Duration(milliseconds: 500), () async {
                  if (context.mounted) context.pop(); // Close dialog
                  if (context.mounted) {
                    // Clear all app state data
                    await SharedPreferencesHelper.clearAllAppState();
                    // Navigate to onboarding screen
                    context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
                  }
                });
                // Show success message briefly
                return _successDelete(context);
              } else {
                // Show delete confirmation dialog
                return _deleteContent(context);
              }
            },
          ),
        );
      }),
    ),
  );
}

Widget _loadingDelete() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.loadingLottie),
    ],
  );
}

Widget _errorDelete(BuildContext context, String error) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.errorLottie, width: 100.w, height: 100.h),
      verticalSpace(24),
      Text(
        AppLocalizations.of(context)!.deleteAccountError,
        textDirection: LocalizationService.instance.textDirection,
        style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
          color: AppColors.darkBlue,
          fontWeight: FontWeightHelper.bold,
        ),
      ),
      verticalSpace(8),
      Text(
        error,
        textDirection: LocalizationService.instance.textDirection,
        textAlign: TextAlign.center,
        style: AppTextStyles.font14LightGrayRegularLamaSans,
      ),
      verticalSpace(24),
      SizedBox(
        width: 200.w,
        child: CustomElevatedButton(
          onPressed: () {
            context.pop(); // Close dialog
          },
          textButton: AppLocalizations.of(context)!.close,
          verticalPadding: 12,
          backgroundColor: AppColors.brightRed,
          radius: 8,
        ),
      ),
    ],
  );
}

Widget _successDelete(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.successLottie, width: 150.w, height: 150.h),
      verticalSpace(24),
      Text(
        AppLocalizations.of(context)!.accountDeletedSuccessfully,
        textDirection: LocalizationService.instance.textDirection,
        style: AppTextStyles.font16BlackSemiBoldLamaSans,
      ),
    ],
  );
}

class _DeleteContentWidget extends StatefulWidget {
  @override
  _DeleteContentWidgetState createState() => _DeleteContentWidgetState();
}

class _DeleteContentWidgetState extends State<_DeleteContentWidget> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageProfileCubit, ManageProfileState>(
      builder: (context, state) {
        final cubit = context.read<ManageProfileCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: LocalizationService.instance.textDirection,
          children: [
            Image.asset(
              AppImages.warningLogo,
              width: 101.w,
              height: 101.h,
            ),
            verticalSpace(24),
            Text(
              AppLocalizations.of(context)!.areYouSure,
              textDirection: LocalizationService.instance.textDirection,
              style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                color: AppColors.darkBlue,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            verticalSpace(4),
            Text(
              AppLocalizations.of(context)!.doYouWantToDeleteAccount,
              textDirection: LocalizationService.instance.textDirection,
              style: AppTextStyles.font14LightGrayRegularLamaSans,
            ),
            verticalSpace(8),
            Text(
              AppLocalizations.of(context)!.cannotUndoThisAction,
              textDirection: LocalizationService.instance.textDirection,
              style: AppTextStyles.font12JetRegularLamaSans.copyWith(
                color: AppColors.coralRed,
              ),
            ),
            verticalSpace(16),
            // Password verification section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .enterPasswordToConfirmDeletion,
                    textDirection: LocalizationService.instance.textDirection,
                    style:
                        AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeightHelper.medium,
                    ),
                  ),
                  verticalSpace(8),
                  CustomTextFormField(
                    controller: cubit.passwordController,
                    hintText: AppLocalizations.of(context)!.password,
                    obscureText: !isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon:  Icon(
                            isPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 16,
                            color: AppColors.lightTaupe,
                          ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.passwordRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            verticalSpace(24),
            Row(
              textDirection: LocalizationService.instance.textDirection,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 115.w,
                  child: CustomElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    textButton: AppLocalizations.of(context)!.cancel,
                    verticalPadding: 12,
                    backgroundColor: AppColors.darkSunray,
                    radius: 8,
                  ),
                ),
                horizontalSpace(12),
                GestureDetector(
                  onTap: () {
                    // Validate password before deletion
                    if (cubit.passwordController.text.isEmpty) {
                      // Show error for empty password using ProfileSnackbarHandler
                      ProfileSnackbarHandler.showSnackBarAboveDialog(
                        context,
                        AppLocalizations.of(context)!.passwordRequired,
                        AppColors.coralRed,
                      );
                      return;
                    }
                    // Trigger delete profile with password
                    context.read<ManageProfileCubit>().deleteProfile();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.deleteAccount,
                    style:
                        AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                      fontWeight: FontWeightHelper.semiBold,
                      color: AppColors.coralRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget _deleteContent(BuildContext context) {
  return _DeleteContentWidget();
}
