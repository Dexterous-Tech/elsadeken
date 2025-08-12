import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'widgets/verification_email_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationEmailScreen extends StatelessWidget {
  const VerificationEmailScreen({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VerificationCubit>(),
      child: Scaffold(
          body: VerificationEmailBody(
        email: email,
      )),
    );
  }
}
