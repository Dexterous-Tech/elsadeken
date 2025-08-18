import 'package:elsadeken/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/app_images.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/spacing.dart';
import 'custom_auth_card.dart';

class CustomAuthBody extends StatelessWidget {
  const CustomAuthBody({super.key, required this.cardContent});

  final Widget cardContent;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 34.w, right: 31.w, top: 32.13.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Image.asset(
                          AppImages.authArrowBack,
                          width: 14.w,
                          height: 14.h,
                        ),
                      ),
                      verticalSpace(33.74.h),
                      Image.asset(
                        AppImages.authElsadekenMarriageImage,
                        width: 170.w,
                        height: 49.h,
                      ),
                      verticalSpace(30),
                      CustomAuthCard(cardContent: cardContent),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
