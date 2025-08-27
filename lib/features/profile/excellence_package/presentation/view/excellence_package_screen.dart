import 'widgets/excellence_package_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_cubit.dart';

class ExcellencePackageScreen extends StatelessWidget {
  const ExcellencePackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PackagesCubit>()..getPackages(),
      child: Scaffold(
        body: ExcellencePackageBody(),
      ),
    );
  }
}
