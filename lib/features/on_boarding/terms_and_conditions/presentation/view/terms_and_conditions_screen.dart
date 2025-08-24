import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/presentation/manager/terms_and_conditions_cubit.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/presentation/view/widgets/terms_and_conditions_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TermsAndConditionsCubit>(),
      child: Scaffold(
        body: TermsAndConditionsBody(),
      ),
    );
  }
}
