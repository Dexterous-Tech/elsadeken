import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/manage_profile_body.dart';
import 'package:flutter/material.dart';

class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ManageProfileCubit>()),
        BlocProvider(create: (context) => sl<UpdateProfileCubit>()),
      ],
      child: Scaffold(body: ManageProfileBody()),
    );
  }
}
