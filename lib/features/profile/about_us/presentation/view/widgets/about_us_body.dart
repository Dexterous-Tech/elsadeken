import 'package:elsadeken/core/helper/app_lottie.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/about_us/presentation/manager/about_us_cubit.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class AboutUsBody extends StatefulWidget {
  const AboutUsBody({super.key});

  @override
  State<AboutUsBody> createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends State<AboutUsBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    AboutUsCubit.get(context).aboutUs();
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
          ProfileHeader(title: 'نبذه عننا'),
          verticalSpace(16),
          // Text(
          //   'من نحن',
          //   style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
          //     color: AppColors.darkBlue,
          //     fontWeight: FontWeightHelper.bold,
          //   ),
          //   textAlign: TextAlign.right,
          // ),
          // verticalSpace(16),
          BlocBuilder<AboutUsCubit, AboutUsState>(
            buildWhen: (context, state) =>
                state is AboutUsLoading ||
                state is AboutUsFailure ||
                state is AboutUsSuccess,
            builder: (context, state) {
              if (state is AboutUsSuccess) {
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
                          // return Text(
                          //   state.aboutUsResponseModel.data?.description ?? '',
                          //   style: AppTextStyles.font14LightGrayRegularLamaSans
                          //       .copyWith(color: AppColors.lightMixGrayAndBlue),
                          //   textDirection: TextDirection.rtl,
                          //   textAlign: TextAlign.right,
                          // );
                          return Html(
                            data:
                                state.aboutUsResponseModel.data?.description ??
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
              } else if (state is AboutUsFailure) {
                return Expanded(
                    child: Center(
                  child: Text(
                    state.error,
                    style: AppTextStyles.font20LightOrangeMediumPlexSans
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
        ],
      ),
    );
  }
}
