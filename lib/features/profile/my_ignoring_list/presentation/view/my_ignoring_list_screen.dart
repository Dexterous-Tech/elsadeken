import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_cubit.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/view/widgets/my_ignoring_list_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyIgnoringListScreen extends StatelessWidget {
  const MyIgnoringListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IgnoreUserCubit>()..ignoreUsers(),
      child: Scaffold(
        body: MyIgnoringListBody(),
      ),
    );
  }
}
