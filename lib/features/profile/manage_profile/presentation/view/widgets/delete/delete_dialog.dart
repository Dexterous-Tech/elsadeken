import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/app_lottie.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Future<void> deleteProfileDialog(BuildContext context) async {
  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    radius: 16,
    height: 311.h,
    dialogContent: BlocProvider.value(
      value: context.read<ManageProfileCubit>(),
      child: Builder(builder: (context) {
        return BlocBuilder<ManageProfileCubit, ManageProfileState>(
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
              return _successDelete();
            } else {
              // Show delete confirmation dialog
              return _deleteContent(context);
            }
          },
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
        'خطأ في حذف الحساب',
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
            context.pop(); // Close dialog
          },
          textButton: 'إغلاق',
          verticalPadding: 12,
          backgroundColor: AppColors.brightRed,
          radius: 8,
        ),
      ),
    ],
  );
}

Widget _successDelete() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.successLottie, width: 150.w, height: 150.h),
      verticalSpace(24),
      Text(
        'تم حذف الحساب بنجاح',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font16BlackSemiBoldLamaSans,
      ),
    ],
  );
}

Widget _deleteContent(BuildContext context) {
  return Column(
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
        'هل انت متاكد؟',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
          color: AppColors.darkBlue,
          fontWeight: FontWeightHelper.bold,
        ),
      ),
      verticalSpace(4),
      Text(
        'هل تريد حذف حسابك نهائياً؟',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font14LightGrayRegularLamaSans,
      ),
      verticalSpace(8),
      Text(
        'لا يمكن التراجع عن هذا الإجراء',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font12JetRegularLamaSans.copyWith(
          color: AppColors.coralRed,
        ),
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
                context.pop();
              },
              textButton: 'الغاء',
              verticalPadding: 12,
              backgroundColor: AppColors.darkSunray,
              radius: 8,
            ),
          ),
          horizontalSpace(12),
          GestureDetector(
            onTap: () {
              // Trigger delete profile
              context.read<ManageProfileCubit>().deleteProfile();
            },
            child: Text(
              'حذف الحساب',
              style: AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                fontWeight: FontWeightHelper.semiBold,
                color: AppColors.coralRed,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
