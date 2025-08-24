import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/notification_settings_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/manager/profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileCubit>()),
        BlocProvider(create: (context) => NotificationSettingsCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.darkSunray,
        body: ProfileBody(),
      ),
    );
  }
}
