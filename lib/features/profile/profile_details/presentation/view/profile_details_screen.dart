import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/ignore_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/like_user_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<LikeUserCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<IgnoreUserCubit>(),
        ),
      ],
      child: Scaffold(
        body: ProfileDetailsBody(),
      ),
    );
  }
}
