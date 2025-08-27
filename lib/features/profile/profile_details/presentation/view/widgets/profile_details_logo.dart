import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        String name = 'لا يوجد';
        String status = 'لا يوجد';
        bool isLoading = state is GetProfileDetailsLoading;
        bool isFeatured = false;

        if (state is GetProfileDetailsSuccess) {
          final userData = state.profileDetailsResponseModel.data;
          if (userData != null) {
            // Get image
            image = userData.image ?? '';

            // Get name from email (everything before @)
            if (userData.email != null && userData.email!.contains('@')) {
              name = '@${userData.email!.split('@')[0]}';
            } else {
              name = userData.name ?? 'لا يوجد';
            }

            // Get status (you might need to add this field to your model)
            status = userData.attribute?.maritalStatus ?? 'غير معروف';

            // Check if user is featured
            isFeatured = userData.isFeatured == 1;
          }
        }

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is GetProfileDetailsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.philippineBronze,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CustomImageNetwork(
                        image: image,
                        width: 145.w,
                        height: 145.h,
                      ),
                    ),
              verticalSpace(30),
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
                      status,
                      style: AppTextStyles.font13BlackMediumLamaSans,
                    ),
              if (isFeatured) ...[
                verticalSpace(8),
                Text(
                  'عضو مميز',
                  style: AppTextStyles.font14JetRegularLamaSans.copyWith(
                    color: AppColors.philippineBronze,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
