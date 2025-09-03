import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/app_lottie.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Future<void> deleteImageDialog(BuildContext context) async {
  try {
    return customDialog(
      context: context,
      backgroundColor: AppColors.white,
      radius: 16,
      height: null, // Make height flexible to prevent overflow
      dialogContent: BlocProvider.value(
        value: sl<ProfileCubit>(),
        child: Builder(builder: (context) {
          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is DeleteImageLoading) {
                // Show loading lottie
                return _loadingDeleteImage(context);
              } else if (state is DeleteImageFailure) {
                // Show error message
                return _errorDeleteImage(context, state.error);
              } else if (state is DeleteImageSuccess) {
                // Show success message briefly then close
                Future.delayed(Duration(milliseconds: 1500), () {
                  if (context.mounted) {
                    try {
                      context.pop(); // Close dialog
                    } catch (e) {
                      // Handle any overflow when closing dialog
                    }
                  }
                });
                return _successDeleteImage(context);
              } else {
                // Show delete confirmation dialog
                return _deleteImageContent(context);
              }
            },
          );
        }),
      ),
    );
  } catch (e) {
    // Handle any overflow or error in dialog creation
    if (context.mounted) {
      context.pop();
    }
  }
}

Widget _loadingDeleteImage(BuildContext context) {
  final tr = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.loadingLottie),
      verticalSpace(16),
      Text(
        tr.deleteImageLoading,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font16BlackSemiBoldLamaSans,
      ),
    ],
  );
}

Widget _errorDeleteImage(BuildContext context, String error) {
  return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.errorLottie, width: 100.w, height: 100.h),
      verticalSpace(24),
      Text(
        AppLocalizations.of(context)!.deleteImageError,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
          color: AppColors.darkBlue,
          fontWeight: FontWeightHelper.bold,
        ),
      ),
      verticalSpace(8),
      Text(
        error,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: AppTextStyles.font14LightGrayRegularLamaSans,
      ),
      verticalSpace(24),
      SizedBox(
        width: 200.w,
        child: CustomElevatedButton(
          onPressed: () {
            if (context.mounted) {
              context.pop(); // Close dialog
            }
          },
          textButton: AppLocalizations.of(context)!.close,
          verticalPadding: 12,
          backgroundColor: AppColors.brightRed,
          radius: 8,
        ),
      ),
    ],
  ));
}

Widget _successDeleteImage(BuildContext context) {
  final tr = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.successLottie, width: 150.w, height: 150.h),
      verticalSpace(24),
      Text(
        tr.deleteImageSuccess,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font16BlackSemiBoldLamaSans,
      ),
    ],
  );
}

Widget _deleteImageContent(BuildContext context) {
  final tr = AppLocalizations.of(context)!;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.warningLogo,
          width: 101.w,
          height: 101.h,
        ),
        verticalSpace(24),
        Text(
          tr.areYouSure,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
            color: AppColors.darkBlue,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        verticalSpace(4),
        Text(
          tr.deleteImageConfirm,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font14LightGrayRegularLamaSans,
        ),
        verticalSpace(24),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 115.w,
              child: CustomElevatedButton(
                onPressed: () {
                  if (context.mounted) {
                    context.pop();
                  }
                },
                textButton: tr.cancel,
                verticalPadding: 12,
                backgroundColor: AppColors.darkSunray,
                radius: 8,
              ),
            ),
            horizontalSpace(12),
            GestureDetector(
              onTap: () {
                // Trigger delete image and handle overflow
                try {
                  if (context.mounted) {
                    context.read<ProfileCubit>().deleteImage();
                  }
                } catch (e) {
                  // Handle any overflow or error
                  if (context.mounted) {
                    context.pop(); // Close dialog on error
                  }
                }
              },
              child: Text(
                tr.deleteImage,
                style: AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                  fontWeight: FontWeightHelper.semiBold,
                  color: AppColors.brightRed,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(16), // Add bottom padding for better spacing
      ],
    ),
  );
}
