import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.1,
      upperBound: 0.9,
    );
    _animationController.forward();
    _navigateAfterDelay();
  }

  static const splashDelay = Duration(seconds: 3);

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(splashDelay);
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Center(
          child: Transform.scale(
            scale: _animationController.value,
            child: Image.asset(
              AppImages.splashImage,
              height: 468.h,
              width: 241.w,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
