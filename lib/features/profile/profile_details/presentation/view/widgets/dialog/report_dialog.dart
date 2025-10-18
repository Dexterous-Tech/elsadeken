import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_drop_down_menu.dart';
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
import '../../../../../../../core/widgets/forms/custom_elevated_button.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../manager/profile_details_cubit.dart';

void reportDialog({
  required BuildContext context,
  required int userId,
}) {
  customDialog(
    context: context,
    backgroundColor: AppColors.white,
    showFilter: false,
    dialogContent: BlocProvider.value(
      value: sl<ProfileDetailsCubit>()..getReportReasons(),
      child: Builder(builder: (context) {
        return BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
          listenWhen: (context, current) =>
              current is ReportUserLoading ||
              current is ReportUserFailure ||
              current is ReportUserSuccess,
          buildWhen: (context, current) =>
              current is ReportUserLoading ||
              current is ReportUserFailure ||
              current is ReportUserSuccess,
          listener: (context, state) {
            if (state is ReportUserSuccess) {
              context.read<ProfileDetailsCubit>().getProfileDetails(userId);
              successDialog(
                  context: context,
                  message:
                      state.profileDetailsActionResponseModel.message ?? '',
                  onPressed: () {
                    // Pop success dialog
                    Navigator.of(context).pop();
                    // Pop report dialog
                    Navigator.of(context).pop();
                  });
            }
          },
          builder: (context, state) {
            final loading = state is ReportUserLoading;
            if (state is ReportUserFailure) {
              return reportError(context: context, error: state.error);
            }
            return reportContent(
                context: context, loading: loading, userId: userId);
          },
        );
      }),
    ),
  );
}

Widget reportError({required BuildContext context, required String error}) {
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

Widget reportContent({
  required BuildContext context,
  required bool loading,
  required int userId,
}) {
  int? selectedReasonId;
  String? selectedReasonName;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.block, width: 100.w, height: 100.h),
          verticalSpace(24),
          Text(
            AppLocalizations.of(context)!.sureReportQu,
            textAlign: TextAlign.center,
            textDirection: LocalizationService.instance.textDirection,
            style: AppTextStyles.font18JetBoldLamaSans
                .copyWith(color: AppColors.darkBlue),
          ),
          verticalSpace(24),
          BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
            buildWhen: (context, current) =>
                current is ReportReasonLoading ||
                current is ReportReasonFailure ||
                current is ReportReasonSuccess,
            builder: (context, state) {
              if (state is ReportReasonLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.meatBrown),
                );
              } else if (state is ReportReasonSuccess) {
                final items = state.generalInfoResponseModels;

                // Filter out items with null or empty names
                final validItems = items
                    .where((e) => e.name != null && e.name!.isNotEmpty)
                    .toList();

                if (validItems.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noDataAvailable,
                      style: AppTextStyles.font14BlackRegularLamaSans,
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: CustomDropDownMenu(
                    key: ValueKey('report_reason_dropdown'),
                    label: AppLocalizations.of(context)!.reportReasonQu,
                    hint: AppLocalizations.of(context)!.selectReportReason,
                    initialValue: selectedReasonName,
                    items: validItems.map((e) => e.name!).toList(),
                    onChanged: (value) {
                      final selected = validItems.firstWhere(
                        (element) => element.name == value,
                        orElse: () => validItems.first,
                      );
                      setState(() {
                        selectedReasonId = selected.id;
                        selectedReasonName = selected.name;
                      });
                    },
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(color: AppColors.meatBrown),
              );
            },
          ),
          verticalSpace(24),
          loading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.meatBrown),
                )
              : Row(
                  textDirection: LocalizationService.instance.textDirection,
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        ignoring: selectedReasonId == null,
                        child: Opacity(
                          opacity: selectedReasonId == null ? 0.5 : 1.0,
                          child: CustomElevatedButton(
                            onPressed: () {
                              if (selectedReasonId != null) {
                                context
                                    .read<ProfileDetailsCubit>()
                                    .reportUser(userId, selectedReasonId!);
                              }
                            },
                            textButton: AppLocalizations.of(context)!.yesReport,
                            backgroundColor: AppColors.meatBrown,
                            radius: 8,
                            styleTextButton: AppTextStyles
                                .font14BlackSemiBoldLamaSans
                                .copyWith(color: AppColors.white),
                          ),
                        ),
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
                        styleTextButton: AppTextStyles
                            .font14BlackSemiBoldLamaSans
                            .copyWith(color: AppColors.brightRed),
                      ),
                    ),
                  ],
                ),
        ],
      );
    },
  );
}
