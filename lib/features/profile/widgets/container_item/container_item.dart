import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../item/profile_lists_item_logo.dart';

class ContainerItem extends StatelessWidget {
  const ContainerItem({
    super.key,
    this.isTime = false,
    this.favUser,
  });

  final bool isTime;
  final UsersDataModel? favUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.profileDetailsScreen,
            arguments: favUser!.id);
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
          textDirection: TextDirection.rtl,
          children: [
            ProfileListsItemLogo(
              image: favUser?.image,
            ),
            horizontalSpace(16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    favUser?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14BeerMediumLamaSans
                        .copyWith(color: Color(0xff7D7D7D)),
                  ),
                  isTime
                      ? Text(
                          'Okay then lets meet in 15 mi.. ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font12JetRegularLamaSans
                              .copyWith(color: AppColors.pumpkinOrange),
                        )
                      : Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Image.asset(
                              AppImages.homeLocation,
                              width: 12.5.w,
                              height: 15.h,
                            ),
                            horizontalSpace(3),
                            Text(
                              '${favUser?.attribute?.country ?? 'لا دولة'} , ${favUser?.attribute?.city ?? 'لا مدينة'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.font13BlackMediumLamaSans
                                  .copyWith(
                                color: AppColors.black.withValues(
                                  alpha: 0.87,
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
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100).r,
                color: AppColors.darkSunray,
              ),
              child: Center(
                child: Text(
                  '56 سنه',
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
