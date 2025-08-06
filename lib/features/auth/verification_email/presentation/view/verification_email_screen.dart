import 'widgets/verification_email_body.dart';
import 'package:flutter/material.dart';

class VerificationEmailScreen extends StatelessWidget {
  const VerificationEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: VerificationEmailBody());
  }
}
