import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/signup_body.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.gender});

  final String gender;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late SignupCubit _signupCubit;
  String _currentGender = '';
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _signupCubit = sl<SignupCubit>();
    _initializeSignup();
  }

  Future<void> _initializeSignup() async {
    // Check if there's recent signup data
    final hasRecentData = await _signupCubit.hasRecentSignupData();

    if (hasRecentData) {
      // Load saved gender and determine appropriate starting step
      final savedGender = await _signupCubit.getSavedGender();
      final appropriateStep = await _signupCubit.getAppropriateStartingStep();

      setState(() {
        _currentGender = savedGender.isNotEmpty ? savedGender : widget.gender;
        _currentStep = appropriateStep;
      });

      // Initialize cubit with saved data
      await _signupCubit.initialize(_currentGender);
    } else {
      // Start fresh signup
      setState(() {
        _currentGender = widget.gender;
        _currentStep = 0;
      });

      await _signupCubit.initialize(widget.gender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _signupCubit,
      child: Scaffold(
        body: SignupBody(
          gender: _currentGender,
          initialStep: _currentStep,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
