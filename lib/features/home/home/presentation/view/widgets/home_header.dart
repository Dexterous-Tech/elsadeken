import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/widgets/custom_image_network.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/home_notification.dart';
import 'package:elsadeken/features/home/notification/presentation/manager/notification_count_cubit.dart';
import 'package:elsadeken/features/home/notification/presentation/view/notification_screen.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/di/injection_container.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    context.read<ManageProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        BlocBuilder<ManageProfileCubit, ManageProfileState>(
          builder: (context, state) {
            if (state is ManageProfileSuccess) {
              final profileData = state.myProfileResponseModel.data;
              final name = profileData?.name ?? '';
              final country = profileData?.attribute?.country ?? 'لا يوجد';
              final city = profileData?.attribute?.city ?? 'لا يوجد';
              final image = profileData?.image ?? '';

              return Row(
                textDirection: TextDirection.rtl,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CustomImageNetwork(
                      width: 64.w,
                      height: 64.h,
                      image: image.isNotEmpty
                          ? image
                          : 'https://img.freepik.com/premium-vector/hijab-girl-cartoon-illustration-vector-design_1058532-14452.jpg?w=1380',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.font16BlackSemiBoldLamaSans,
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Image.asset(
                            'assets/images/home/home_location.png',
                            width: 15.w,
                            height: 18.h,
                          ),
                          SizedBox(width: 13.w),
                          Text('$country, $city',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.font15BistreSemiBoldLamaSans
                                  .copyWith(
                                      color: AppColors.black.withValues(
                                        alpha: 0.87,
                                      ),
                                      fontWeight: FontWeightHelper.medium)),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is ManageProfileFailure) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Error loading profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeightHelper.semiBold,
                        ),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Image.asset(
                            'assets/images/home/home_location.png',
                            width: 15.w,
                            height: 18.h,
                          ),
                          SizedBox(width: 13),
                          Text(
                            'Location not available',
                            style: TextStyle(
                                color:
                                    Color(0xff000000).withValues(alpha: 0.87),
                                fontSize: 15.sp,
                                fontWeight: FontWeightHelper.medium),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: NetworkImage(
                      'https://img.freepik.com/premium-vector/hijab-girl-cartoon-illustration-vector-design_1058532-14452.jpg?w=1380',
                    ),
                  ),
                ],
              );
            } else {
              // Loading state
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Image.asset(
                            'assets/images/home/home_location.png',
                            width: 15.w,
                            height: 18.h,
                          ),
                          SizedBox(width: 13),
                          Container(
                            width: 80.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              );
            }
          },
        ),
        Spacer(),
        BlocProvider(
          create: (context) => sl<NotificationCountCubit>(),
          child: HomeNotification(),
        ),
      ],
    );
  }
}
