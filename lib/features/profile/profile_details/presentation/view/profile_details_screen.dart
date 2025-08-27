import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, required this.user});

  final UsersDataModel user;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileDetailsCubit>(),
      child: Scaffold(
        body: ProfileDetailsBody(user: user),
      ),
    );
  }
}
