import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/login/presentation/view/widgets/login_body.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupCubit>(),
      child: Scaffold(body: LoginBody()),
    );
  }
}
