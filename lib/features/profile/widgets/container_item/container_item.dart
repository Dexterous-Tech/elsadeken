import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../item/profile_lists_item_logo.dart';

class ContainerItem extends StatelessWidget {
  const ContainerItem({
    super.key,
    this.isTime = false,
    this.favUser,
    this.isSpecial = false,
    this.time = '',
  });

  final bool isTime;
  final UsersDataModel? favUser;
  final bool isSpecial;
  final String time;

  @override
  Widget build(BuildContext context) {
    final country = favUser?.attribute?.country?.trim();
    final city = favUser?.attribute?.city?.trim();

    final location = [
      country?.isNotEmpty == true
          ? country
          : AppLocalizations.of(context)!.notAvailable,
      city?.isNotEmpty == true
          ? city
          : AppLocalizations.of(context)!.notAvailable,
    ].join(' , ');
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.profileDetailsScreen, arguments: favUser);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6).r,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 36,
                offset: Offset(0, 4),
              ),
            ]),
        child: Row(
          textDirection: LocalizationService.instance.textDirection,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileListsItemLogo(
              image: favUser?.image,
              isSpecial: isSpecial,
            ),
            horizontalSpace(16),
            Expanded(
              flex: 2,
              child: Column(
                textDirection: LocalizationService.instance.textDirection,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favUser?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14BeerMediumLamaSans
                        .copyWith(color: Color(0xff7D7D7D)),
                  ),
                  if (isTime) ...[
                    Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12JetRegularLamaSans
                          .copyWith(color: AppColors.pumpkinOrange),
                    ),
                  ],
                  Row(
                    textDirection: LocalizationService.instance.textDirection,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.homeLocation,
                        width: 12.5.w,
                        height: 15.h,
                      ),
                      horizontalSpace(3),
                      Expanded(
                        child: Text(
                          textDirection:
                              LocalizationService.instance.textDirection,
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style:
                              AppTextStyles.font13BlackMediumLamaSans.copyWith(
                            color: AppColors.black.withValues(
                              alpha: 0.87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 34.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100).r,
                color: AppColors.darkSunray,
              ),
              child: Center(
                child: Text(
                  favUser?.attribute?.age != null
                      ? '${favUser!.attribute!.age} ${AppLocalizations.of(context)!.year}'
                      : AppLocalizations.of(context)!.notAvailable,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font14BlackSemiBoldLamaSans
                      .copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
