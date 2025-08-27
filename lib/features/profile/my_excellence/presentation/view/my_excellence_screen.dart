import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/manager/feature_cubit/cubit/features_cubit.dart';

import 'widgets/my_excellence_body.dart';

class MyExcellenceScreen extends StatelessWidget {
  const MyExcellenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FeaturesCubit>()..getFeatures(),
      child: Scaffold(
        body: MyExcellenceBody(),
      ),
    );
  }
}
