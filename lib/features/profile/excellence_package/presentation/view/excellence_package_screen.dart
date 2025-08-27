import 'widgets/excellence_package_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_cubit.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/manager/feature_cubit/cubit/features_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';

class ExcellencePackageScreen extends StatelessWidget {
  const ExcellencePackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PackagesCubit>()..getPackages(),
        ),
        BlocProvider(
          create: (context) => sl<FeaturesCubit>()..getFeatures(),
        ),
        BlocProvider(
          create: (context) => sl<ManageProfileCubit>()..getProfile(),
        ),
      ],
      child: Scaffold(
        body: ExcellencePackageBody(),
      ),
    );
  }
}
