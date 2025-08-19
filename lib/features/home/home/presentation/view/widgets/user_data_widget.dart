import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDataWidget extends StatelessWidget {
  const UserDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageProfileCubit, ManageProfileState>(
      builder: (context, state) {
        if (state is ManageProfileSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CustomImageNetwork(
                  image: state.myProfileResponseModel.data?.image ?? '',
                  width: 84.w,
                  height: 83.h,
                ),
              ),
              Text(
                state.myProfileResponseModel.data?.name ?? '',
                style: AppTextStyles.font23ChineseBlackBoldLamaSans
                    .copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeightHelper.semiBold,
                ),
              ),
              Text(
                '${state.myProfileResponseModel.data?.email?.split('@')[0]}@',
                style: AppTextStyles.font14ChineseBlackSemiBoldLamaSans
                    .copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeightHelper.regular,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}