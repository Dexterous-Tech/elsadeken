import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_body.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, this.user, this.userId});

  final UsersDataModel? user;
  final int? userId;

  @override
  Widget build(BuildContext context) {
    // Determine the actual user ID to use
    final int actualUserId = user?.id ?? userId ?? 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileDetailsCubit>()),
        BlocProvider(create: (context) => sl<ChatListCubit>()),
      ],
      child: Scaffold(
        body: ProfileDetailsBody(user: user, userId: actualUserId),
      ),
    );
  }
}
