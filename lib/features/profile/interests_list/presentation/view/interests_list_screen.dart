import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/interests_list_body.dart';
import 'package:flutter/material.dart';

class InterestsListScreen extends StatelessWidget {
  const InterestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavUserCubit>(),
      child: Scaffold(
        body: InterestsListBody(),
      ),
    );
  }
}
