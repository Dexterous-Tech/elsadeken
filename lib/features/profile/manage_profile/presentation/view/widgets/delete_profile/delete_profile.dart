import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helper/app_images.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';

class DeleteProfile extends StatelessWidget {
  const DeleteProfile({super.key, required this.isLoading});

  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageProfileCubit, ManageProfileState>(
      listenWhen: (previous, current) =>
          current is DeleteProfileLoading ||
          current is DeleteProfileFailure ||
          current is DeleteProfileSuccess,
      listener: (context, state) {
        if (state is DeleteProfileLoading) {
          loadingDialog(context);
        } else if (state is DeleteProfileFailure) {
          context.pop();
          errorDialog(context: context, error: state.error);
        } else if (state is DeleteProfileSuccess) {
          context.pop();
          successDialog(
              context: context,
              message: state.profileActionResponseModel.message.toString(),
              onPressed: () {
                context.pop();
                context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
              });
        }
      },
      child: GestureDetector(
        onTap: () {
          context.read<ManageProfileCubit>().deleteProfile();
        },
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFFEBEB),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.deleteProfile,
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            ),
            horizontalSpace(16),
            Text(
              ' حذف حسابي',
              style: AppTextStyles.font26BlackBoldLamaSans
                  .copyWith(color: AppColors.coralRed, fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }
}
