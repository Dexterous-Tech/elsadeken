import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
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
      builder: (context, state) {
        String image = AppImages.profileImageLogo; // Default image
        String name = 'جاري التحميل...';
        String status = 'جاري التحميل...';

        if (state is GetProfileDetailsSuccess) {
          final userData = state.profileDetailsResponseModel.data;
          if (userData != null) {
            // Get image
            image = userData.image ?? AppImages.profileImageLogo;

            // Get name from email (everything before @)
            if (userData.email != null && userData.email!.contains('@')) {
              name = '@${userData.email!.split('@')[0]}';
            } else {
              name = userData.name ?? 'لا يوجد';
            }

            // Get status (you might need to add this field to your model)
            status =
                'متواجد حاليا'; // Default status, you can modify based on your needs
          }
        } else if (state is GetProfileDetailsLoading) {
          name = 'جاري التحميل...';
          status = 'جاري التحميل...';
        } else {
          name = 'لا يوجد';
          status = 'لا يوجد';
        }

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CustomImageNetwork(
                    image: image,
                    width: 145.w,
                    height: 145.h,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green,
                          border: Border.all(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              Text(
                name,
                style: AppTextStyles.font16BlackSemiBoldLamaSans,
              ),
              verticalSpace(8),
              Text(
                status,
                style: AppTextStyles.font13BlackMediumLamaSans,
              )
            ],
          ),
        );
      },
    );
  }
}
