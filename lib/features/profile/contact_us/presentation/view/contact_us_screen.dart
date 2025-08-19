import 'widgets/contact_us_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/profile/contact_us/presentation/manager/contact_us_cubit.dart';
import 'package:elsadeken/core/di/injection_container.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactUsCubit>(),
      child: Scaffold(
        body: ContactUsBody(),
      ),
    );
  }
}
