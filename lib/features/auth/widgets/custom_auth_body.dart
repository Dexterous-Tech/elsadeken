import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/app_images.dart';
import '../../../core/theme/spacing.dart';
import 'custom_auth_card.dart';

class CustomAuthBody extends StatelessWidget {
  const CustomAuthBody({super.key, required this.cardContent, this.onTap});

  final Widget cardContent;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cosmicLatte,
            AppColors.antiqueWhite,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsetsGeometry.only(left: 34.w, right: 31.w, top: 32.13.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: LocalizationService.instance.textDirection,
                      children: [
                        GestureDetector(
                          onTap: onTap ??
                              () {
                                context.pop();
                              },
                          child: Transform.rotate(
                            angle: LocalizationService.instance.isArabic
                                ? 0
                                : 3.14,
                            child: Image.asset(
                              AppImages.authArrowBack,
                              width: 14.w,
                              height: 14.h,
                            ),
                          ),
                        ),
                        verticalSpace(33.74.h),
                        Center(
                          child: Image.asset(
                            AppImages.splashImage,
                            height: 140.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        CustomAuthCard(cardContent: cardContent),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
