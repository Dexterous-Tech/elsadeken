import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_data_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import 'profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.darkSunray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 34.5.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الحساب الشخصي',
                      style: AppTextStyles.font20WhiteBoldLamaSans,
                    ),
                    verticalSpace(19),
                    BlocProvider(
                      create: (context) => sl<ManageProfileCubit>(),
                      child: ProfileDataLogo(),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(15),
            Expanded(child: ProfileContent()),
          ],
        ),
      ),
    );
  }
}
