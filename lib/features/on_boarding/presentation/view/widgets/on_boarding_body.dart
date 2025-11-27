import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/on_boarding/presentation/view/widgets/oath_dialog/oath_dialog.dart';
import 'package:elsadeken/features/on_boarding/presentation/view/widgets/on_boarding_change_language.dart';
// import 'package:elsadeken/features/on_boarding/presentation/view/widgets/oath_dialog/oath_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.only(
        top: 76.h,
        right: 52.w,
        left: 52.w,
        bottom: 96.h,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.onBoardingCoupleImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.white.withAlpha(155),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: LocalizationService.instance.textDirection,
              children: [
                OnBoardingChangeLanguage(),
                verticalSpace(16),
                Center(
                    child: Image.asset(AppImages.splashImage,
                        width: 135.w, height: 263.h)),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.onboardingTitle,
                      textAlign: TextAlign.center,
                      textDirection: LocalizationService.instance.textDirection,
                      style: AppTextStyles.font40BlackSemiBoldPlexSans
                          .copyWith(letterSpacing: 0, wordSpacing: 0),
                    ),
                    Text(
                      AppLocalizations.of(context)!.onboardingSubtitle,
                      textAlign: TextAlign.center,
                      textDirection: LocalizationService.instance.textDirection,
                      style: AppTextStyles.font26BlackRegularPlexSans
                          .copyWith(letterSpacing: 0, wordSpacing: 0),
                    ),
                    verticalSpace(30),
                    SizedBox(
                      width: 219.w,
                      child: CustomElevatedButton(
                        height: 50.25.h,
                        onPressed: () async {
                          // Mark onboarding as completed
                          await SharedPreferencesHelper
                              .setIsOnboardingCompleted(true);
                          // Navigate to login screen
                          if (context.mounted) {
                            context.pushNamed(AppRoutes.loginScreen);
                          }
                        },
                        // verticalPadding: 17.h,
                        buttonWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15.586699222654454.w,
                              height: 15.586699222654454.h,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 8.646721693936545.sp,
                                color: AppColors.white,
                              ),
                            ),
                            horizontalSpace(10),
                            Text(
                              AppLocalizations.of(context)!.loginNow,
                              style: AppTextStyles.font16CulturedMediumPlexSans
                                  .copyWith(color: AppColors.white),
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(7),
                    GestureDetector(
                      onTap: () {
                        oathDialog(context: context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .freeRegistrationOnboarding,
                        style: AppTextStyles.font16CulturedMediumPlexSans
                            .copyWith(color: AppColors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
