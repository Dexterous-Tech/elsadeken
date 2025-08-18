import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_data.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsBody extends StatefulWidget {
  const ProfileDetailsBody({super.key, required this.userId});

  final int userId;
  @override
  State<ProfileDetailsBody> createState() => _ProfileDetailsBodyState();
}

class _ProfileDetailsBodyState extends State<ProfileDetailsBody> {
  @override
  void initState() {
    super.initState();
    // Call getProfileDetails once when widget initializes
    context.read<ProfileDetailsCubit>().getProfileDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            CustomArrowBack(),
            ProfileDetailsLogo(),
            verticalSpace(20),
            Row(
              // spacing: 37.75,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(
                  img: AppImages.share,
                  color: AppColors.lightBlue.withValues(alpha: 0.07),
                  text: 'مشاركة',
                ),
                BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                  listenWhen: (context, current) =>
                      current is LikeUserLoading ||
                      current is LikeUserFailure ||
                      current is LikeUserSuccess,
                  listener: (context, state) {
                    if (state is LikeUserLoading) {
                      loadingDialog(context);
                    } else if (state is LikeUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is LikeUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم الاعجاب',
                          onPressed: () {
                            context.pop();
                            context.pop();
                          });
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.like,
                    color: AppColors.lightPink.withValues(alpha: 0.07),
                    text: 'اهتمام',
                    onTap: () {
                      context
                          .read<ProfileDetailsCubit>()
                          .likeUser(widget.userId);
                    },
                  ),
                ),
                BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                  listenWhen: (context, current) =>
                      current is IgnoreUserLoading ||
                      current is IgnoreUserFailure ||
                      current is IgnoreUserSuccess,
                  listener: (context, state) {
                    if (state is IgnoreUserLoading) {
                      loadingDialog(context);
                    } else if (state is IgnoreUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is IgnoreUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم التجاهل',
                          onPressed: () {
                            context.pop();
                            context.pop();
                          });
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.thumbDown,
                    color: AppColors.lightPink.withValues(alpha: 0.07),
                    text: 'تجاهل',
                    onTap: () {
                      context
                          .read<ProfileDetailsCubit>()
                          .ignoreUser(widget.userId);
                    },
                  ),
                ),
                CustomContainer(
                  img: AppImages.message,
                  color: AppColors.orangeLight.withValues(alpha: 0.07),
                  text: 'رسائل',
                ),
                CustomContainer(
                  img: AppImages.block,
                  color: AppColors.lightRed.withValues(alpha: 0.07),
                  text: 'ابلاغ',
                ),
              ],
            ),
            verticalSpace(40),
            ProfileDetailsData(),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
