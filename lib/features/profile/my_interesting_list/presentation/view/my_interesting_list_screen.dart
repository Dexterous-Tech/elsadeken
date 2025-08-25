import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_cubit.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/view/widgets/my_interesting_list_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyInterestingListScreen extends StatelessWidget {
  const MyInterestingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InterestingListCubit>()..favUser(page: 1),
      child: Scaffold(
        body: MyInterestingListBody(),
      ),
    );
  }
}
