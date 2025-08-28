import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';

class ProfileDataLogo extends StatefulWidget {
  const ProfileDataLogo({super.key});

  @override
  State<ProfileDataLogo> createState() => _ProfileDataLogoState();
}

class _ProfileDataLogoState extends State<ProfileDataLogo> {
  bool isFeatured = false;

  @override
  void initState() {
    super.initState();
    context.read<ManageProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is DeleteImageSuccess) {
          print(
              '🎯 ProfileDataLogo: DeleteImageSuccess detected! Refreshing profile...');
          // Refresh profile data after successful image deletion
          context.read<ManageProfileCubit>().getProfile();
        }
      },
      child: BlocBuilder<ManageProfileCubit, ManageProfileState>(
        builder: (context, state) {
          if (state is ManageProfileFailure) {
            return Center(
              child: Text(
                state.error,
                style: AppTextStyles.font14DesiredMediumLamaSans,
              ),
            );
          } else if (state is ManageProfileSuccess) {
            // Update isFeatured when profile is loaded
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.myProfileResponseModel.data?.isFeatured != null) {
                bool newIsFeatured =
                    state.myProfileResponseModel.data!.isFeatured == 1;
                if (newIsFeatured != isFeatured) {
                  setState(() {
                    isFeatured = newIsFeatured;
                  });
                }
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result =
                        await context.pushNamed(AppRoutes.profileMyImageScreen);
                    // If we returned from the image screen, refresh the profile data
                    if (result == true) {
                      if (context.mounted)
                        context.read<ManageProfileCubit>().getProfile();
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CustomImageNetwork(
                      image: state.myProfileResponseModel.data?.image ?? '',
                      width: 84.w,
                      height: 83.h,
                    ),
                  ),
                ),
                Text(
                  state.myProfileResponseModel.data?.name ?? '',
                  style: AppTextStyles.font23ChineseBlackBoldLamaSans.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeightHelper.semiBold,
                  ),
                ),
                Text(
                  '${state.myProfileResponseModel.data?.email}',
                  style:
                      AppTextStyles.font14ChineseBlackSemiBoldLamaSans.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeightHelper.regular,
                  ),
                ),
                if (isFeatured) ...[
                  verticalSpace(8),
                  Text(
                    'عضو مميز',
                    style: AppTextStyles.font14JetRegularLamaSans.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            );
          } else {
            return SizedBox(
              width: 120.w,
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
