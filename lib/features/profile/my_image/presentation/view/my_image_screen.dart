import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/my_image/presentation/manager/my_image_cubit.dart';
import 'package:elsadeken/features/profile/my_image/presentation/view/widgets/my_image_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyImageScreen extends StatelessWidget {
  const MyImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyImageBody(),
    );
  }
}
