import 'widgets/members_profile_body.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/members_profile/presentation/manager/members_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersProfileScreen extends StatelessWidget {
  const MembersProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<MembersProfileCubit>()),
        BlocProvider(create: (context) => sl<SignUpListsCubit>()),
      ],
      child: Scaffold(
        body: MembersProfileBody(),
      ),
    );
  }
}
