import 'login_form.dart';
import '../../../../widgets/custom_auth_body.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(cardContent: LoginForm());
  }
}
