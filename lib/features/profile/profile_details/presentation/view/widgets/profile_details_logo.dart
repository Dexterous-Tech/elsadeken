import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class ProfileDetailsLogo extends StatelessWidget {
  const ProfileDetailsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
      buildWhen: (context, state) =>
          state is GetProfileDetailsLoading ||
          state is GetProfileDetailsSuccess ||
          state is GetProfileDetailsFailure,
      builder: (context, state) {
        String image = ''; // Default image
        String name = AppLocalizations.of(context)!.noData;
        String status = AppLocalizations.of(context)!.noData;
        String age = AppLocalizations.of(context)!.noData;
        bool isLoading = state is GetProfileDetailsLoading;
        bool isFeatured = false;
        bool isOnline = false;

        if (state is GetProfileDetailsSuccess) {
          final userData = state.profileDetailsResponseModel.data;
          if (userData != null) {
            // Get image
            image = userData.image ?? '';

            // Get name from email (everything before @)
            if (userData.email != null && userData.email!.contains('@')) {
              name = '@${userData.email!.split('@')[0]}';
            } else {
              name = userData.name ?? AppLocalizations.of(context)!.noData;
            }

            // Get status (you might need to add this field to your model)
            status = userData.attribute?.maritalStatus ??
                AppLocalizations.of(context)!.unknown;
            age = userData.attribute?.age.toString() ??
                AppLocalizations.of(context)!.unknown;

            // Check if user is featured
            isFeatured = userData.isFeatured == 1;
            isOnline = userData.isOnline == true;
          }
        }

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: LocalizationService.instance.textDirection,
            children: [
              state is GetProfileDetailsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.philippineBronze,
                      ),
                    )
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomImageNetwork(
                            image: image,
                            width: 145.w,
                            height: 145.h,
                          ),
                        ),
                        Positioned(
                          right: -10,
                          top: 0,
                          bottom: -50,
                          child: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isOnline ? AppColors.green : AppColors.gray,
                              border: isOnline
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        if (isFeatured)
                          Positioned(
                            top: 0,
                            bottom: -130,
                            child: Container(
                              width: 180.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  // fit: BoxFit.cover,
                                  image: AssetImage(AppImages.ribbonProfile),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.specialMember,
                                  style: AppTextStyles.font14JetRegularLamaSans
                                      .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: LocalizationService
                                      .instance.textAlignment,
                                  textDirection: LocalizationService
                                      .instance.textDirection,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
              verticalSpace(isFeatured ? 32 : 16),
              isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.philippineBronze,
                        ),
                      ),
                    )
                  : Text(
                      name,
                      style: AppTextStyles.font16BlackSemiBoldLamaSans,
                    ),
              verticalSpace(8),
              isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.philippineBronze,
                        ),
                      ),
                    )
                  : Text(
                      '$status - $age ${AppLocalizations.of(context)?.year ?? 'سنة'}',
                      style: AppTextStyles.font13BlackMediumLamaSans
                          .copyWith(color: AppColors.philippineBronze),
                    ),
            ],
          ),
        );
      },
    );
  }
}
