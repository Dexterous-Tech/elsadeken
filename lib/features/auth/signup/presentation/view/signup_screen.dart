import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/signup_body.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, required this.gender});

  final String gender;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupCubit>(),
      child: Scaffold(body: SignupBody(gender: gender)),
    );
  }
}
