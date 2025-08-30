import 'package:elsadeken/core/di/injection_container.dart';
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
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Future<void> logoutDialog(BuildContext context) async {
  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    radius: 16,
    height: 311.h,
    dialogContent: BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: Builder(builder: (context) {
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is LogoutLoading) {
              // Show loading lottie
              return _loadingLogout();
            } else if (state is LogoutFailure) {
              // Show error message
              return _errorLogout(context, state.error);
            } else if (state is LogoutSuccess) {
              // Clear all app state and navigate to login screen
              Future.delayed(Duration(milliseconds: 500), () async {
                if (context.mounted) context.pop(); // Close dialog
                if (context.mounted) {
                  // Clear all app state data
                  await SharedPreferencesHelper.clearAllAppState();
                  // Navigate to login screen
                  context.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
                }
              });
              // Show success message briefly
              return _successLogout();
            } else {
              // Show logout confirmation dialog
              return _logoutContent(context);
            }
          },
        );
      }),
    ),
  );
}

Widget _loadingLogout() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.loadingLottie),
    ],
  );
}

Widget _errorLogout(BuildContext context, String error) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.errorLottie, width: 100.w, height: 100.h),
      verticalSpace(24),
      Text(
        'خطأ في تسجيل الخروج',
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

Widget _successLogout() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.successLottie, width: 150.w, height: 150.h),
      verticalSpace(24),
      Text(
        'تم تسجيل الخروج بنجاح',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.font16BlackSemiBoldLamaSans,
      ),
    ],
  );
}

Widget _logoutContent(BuildContext context) {
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
        'هل تريد تسجيل الخروج؟',
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
              // Trigger logout
              context.read<ProfileCubit>().logout();
            },
            child: Text(
              'تسجيل الخروج',
              style: AppTextStyles.font14LightGrayRegularLamaSans.copyWith(
                fontWeight: FontWeightHelper.semiBold,
                color: AppColors.brightRed,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
