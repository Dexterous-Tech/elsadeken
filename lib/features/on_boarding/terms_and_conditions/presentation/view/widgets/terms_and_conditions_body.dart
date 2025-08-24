import 'package:elsadeken/core/helper/app_lottie.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/presentation/manager/terms_and_conditions_cubit.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class TermsAndConditionsBody extends StatefulWidget {
  const TermsAndConditionsBody({super.key});

  @override
  State<TermsAndConditionsBody> createState() => _TermsAndConditionsBodyState();
}

class _TermsAndConditionsBodyState extends State<TermsAndConditionsBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    TermsAndConditionsCubit.get(context).getTermsAndConditions();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(title: 'الشروط والأحكام'),
          verticalSpace(16),
          BlocBuilder<TermsAndConditionsCubit, TermsAndConditionsState>(
            buildWhen: (context, state) =>
                state is TermsAndConditionsLoading ||
                state is TermsAndConditionsFailure ||
                state is TermsAndConditionsSuccess,
            builder: (context, state) {
              if (state is TermsAndConditionsSuccess) {
                return Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: VsScrollbar(
                      controller: _scrollController,
                      showTrackOnHover: true,
                      isAlwaysShown: true,
                      scrollbarFadeDuration: const Duration(milliseconds: 500),
                      scrollbarTimeToFade: const Duration(milliseconds: 800),
                      style: VsScrollbarStyle(
                        hoverThickness: 5.0,
                        radius: const Radius.circular(10),
                        thickness: 8.0,
                        color: AppColors.desire.withValues(alpha: 0.474),
                      ),
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Html(
                            data: state.termsAndConditionsResponseModel.data
                                    ?.description ??
                                '',
                            style: {
                              "body": Style(
                                fontSize: FontSize(14.sp),
                                color: AppColors.lightMixGrayAndBlue,
                                textAlign: TextAlign.right,
                                direction: TextDirection.rtl,
                              ),
                              "p": Style(
                                margin: Margins.symmetric(vertical: 8.h),
                              ),
                            },
                          );
                        },
                        separatorBuilder: (_, index) {
                          return verticalSpace(30);
                        },
                        itemCount: 1,
                      ),
                    ),
                  ),
                );
              } else if (state is TermsAndConditionsFailure) {
                return Expanded(
                    child: Center(
                  child: Text(
                    state.error,
                    style: AppTextStyles.font20LightOrangeMediumLamaSans
                        .copyWith(color: AppColors.red),
                  ),
                ));
              } else {
                return Expanded(
                    child: Center(
                        child: Lottie.asset(AppLottie.loadingLottie,
                            width: 120.w, height: 120.h)));
              }
            },
          ),
          verticalSpace(20),
          // Close button at the end of screen
          CustomElevatedButton(
            onPressed: () => Navigator.pop(context),
            textButton: 'اغلاق',
            backgroundColor: AppColors.desire.withValues(alpha: 0.474),
            height: 45.h,
          ),
        ],
      ),
    );
  }
}
