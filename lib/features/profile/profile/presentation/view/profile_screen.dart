import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.darkSunray, body: ProfileBody());
  }
}
