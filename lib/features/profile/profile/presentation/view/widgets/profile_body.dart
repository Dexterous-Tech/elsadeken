import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_data_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../core/services/localization_service.dart';
import '../../../../../../core/helper/localization_helper.dart';
import '../../manager/notification_settings_profile_cubit.dart';
import 'profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalizationService.instance,
      builder: (context, child) {
        return Container(
          color: AppColors.darkSunray,
          child: BlocProvider(
            create: (context) => sl<ProfileCubit>(),
            child: Column(
              crossAxisAlignment: LocalizationHelper.startCrossAxisAlignment,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.5.h),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.personalAccount,
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
                Expanded(
                  child: BlocProvider(
                    create: (context) => sl<NotificationSettingsProfileCubit>(),
                    child: ProfileContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
