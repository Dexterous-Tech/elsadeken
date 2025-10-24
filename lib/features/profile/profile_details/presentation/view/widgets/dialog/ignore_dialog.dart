import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../core/di/injection_container.dart';
import '../../../../../../../core/helper/app_images.dart';
import '../../../../../../../core/helper/app_lottie.dart';
import '../../../../../../../core/theme/app_color.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../../../core/widgets/dialog/success_dialog.dart';
import '../../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../manager/profile_details_cubit.dart';

void ignoreDialog({
  required BuildContext context,
  required String message,
  required String textButton,
  required int userId,
  required void Function() afterSuccess,
}) {
  customDialog(
    context: context,
    backgroundColor: AppColors.white,
    showFilter: false,
    dialogContent: BlocProvider.value(
      value: sl<ProfileDetailsCubit>(),
      child: Builder(builder: (context) {
        return BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
          listenWhen: (context, current) =>
              current is IgnoreUserLoading ||
              current is IgnoreUserFailure ||
              current is IgnoreUserSuccess,
          buildWhen: (context, current) =>
              current is IgnoreUserLoading ||
              current is IgnoreUserFailure ||
              current is IgnoreUserSuccess,
          listener: (context, state) {
            if (state is IgnoreUserSuccess) {
              successDialog(
                  context: context,
                  message:
                      state.profileDetailsActionResponseModel.message ?? '',
                  onPressed: () {
                    Navigator.of(context).pop();
                    afterSuccess();
                    context
                        .read<ProfileDetailsCubit>()
                        .getProfileDetails(userId);
                    // Pop success dialog
                    // Pop report dialog
                    Navigator.of(context).pop();
                  });
            }
          },
          builder: (context, state) {
            final loading = state is IgnoreUserLoading;
            if (state is IgnoreUserFailure) {
              return ignoreError(context: context, error: state.error);
            }
            return ignoreContent(
                context: context,
                loading: loading,
                textButton: textButton,
                message: message,
                onPressed: () {
                  context.read<ProfileDetailsCubit>().ignoreUser(userId);
                });
          },
        );
      }),
    ),
  );
}

Widget ignoreError({required BuildContext context, required String error}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(AppLottie.errorLottie, width: 100.w, height: 100.h),
      verticalSpace(15),
      Text(error,
          textAlign: TextAlign.center,
          textDirection: LocalizationService.instance.textDirection,
          style: AppTextStyles.font14BlackRegularLamaSans),
      verticalSpace(15),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              textButton: AppLocalizations.of(context)!.tryAgain,
            )),
      ),
    ],
  );
}

Widget ignoreContent(
    {required BuildContext context,
    required bool loading,
    required String textButton,
    required String message,
    required void Function() onPressed}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(AppImages.thumbDown, width: 100.w, height: 100.h),
      verticalSpace(24),
      Text(message,
          textAlign: TextAlign.center,
          textDirection: LocalizationService.instance.textDirection,
          style: AppTextStyles.font18JetBoldLamaSans
              .copyWith(color: AppColors.darkBlue)),
      verticalSpace(24),
      loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.meatBrown,
              ),
            )
          : Row(
              textDirection: LocalizationService.instance.textDirection,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: onPressed,
                    textButton: textButton,
                    backgroundColor: AppColors.meatBrown,
                    radius: 8,
                    styleTextButton: AppTextStyles.font14BlackSemiBoldLamaSans
                        .copyWith(color: AppColors.white),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.transparent,
                    textButton: AppLocalizations.of(context)!.back,
                    styleTextButton: AppTextStyles.font14BlackSemiBoldLamaSans
                        .copyWith(color: AppColors.brightRed),
                  ),
                ),
              ],
            ),
    ],
  );
}
