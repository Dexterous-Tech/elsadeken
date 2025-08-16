import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/on_boarding/presentation/view/widgets/oath_dialog/oath_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.symmetric(vertical: 76.h, horizontal: 52.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.onBoardingCoupleImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.white.withAlpha(120),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppImages.splashImage, width: 135.w, height: 263.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تعارف جاد للمسلمين والمسلمات',
                textAlign: TextAlign.center,
                style: AppTextStyles.font40BlackSemiBoldPlexSans(
                  context,
                ).copyWith(letterSpacing: 0, wordSpacing: 0),
              ),
              Text(
                'لكل من يبحث عن شريك حياة على أساس من القيم والاحترام',
                textAlign: TextAlign.center,
                style: AppTextStyles.font26BlackRegularPlexSans(
                  context,
                ).copyWith(letterSpacing: 0, wordSpacing: 0),
              ),
              verticalSpace(30),
              SizedBox(
                width: 210.w,
                child: CustomElevatedButton(
                  onPressed: () {
                    oathDialog(context: context);
                  },
                  // verticalPadding: 17.h,
                  buttonWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 16.sp,
                        color: AppColors.white,
                      ),
                      horizontalSpace(10),
                      Text(
                        'سجل الان',
                        style: AppTextStyles.font16CulturedMediumPlexSans(
                          context,
                        ).copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(7),
              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.loginScreen);
                },
                child: Text(
                  'التسجيل مجانا',
                  style: AppTextStyles.font16CulturedMediumPlexSans(context)
                      .copyWith(color: AppColors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
