import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/new_password/presentation/manager/reset_password_cubit.dart';
import 'widgets/new_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: Scaffold(
          body: NewPasswordBody(
        email: email,
      )),
    );
  }
}
