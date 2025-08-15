import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'widgets/forget_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgetCubit>(),
      child: Scaffold(body: ForgetPasswordBody()),
    );
  }
}
