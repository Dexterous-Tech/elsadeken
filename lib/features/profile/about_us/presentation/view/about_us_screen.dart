import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/about_us/presentation/manager/about_us_cubit.dart';
import 'package:elsadeken/features/profile/about_us/presentation/view/widgets/about_us_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AboutUsCubit>(),
      child: Scaffold(
        body: AboutUsBody(),
      ),
    );
  }
}
