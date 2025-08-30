import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
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

    // Check if user is logged in
    final isLoggedIn = await SharedPreferencesHelper.getIsLoggedIn();
    final hasValidToken = await SharedPreferencesHelper.getSecuredString(
      'API_TOKEN_KEY',
    ).then((token) => token.isNotEmpty);

    // Check if there's recent signup data (indicating incomplete signup process)
    final hasRecentSignupData =
        await SharedPreferencesHelper.hasRecentSignupData();

    if (isLoggedIn && hasValidToken && !hasRecentSignupData) {
      // User is logged in, has valid token, and no recent signup data (completed signup)
      // Navigate to home
      context.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
    } else {
      // Check if onboarding is completed
      final isOnboardingCompleted =
          await SharedPreferencesHelper.getIsOnboardingCompleted();

      if (isOnboardingCompleted) {
        // Onboarding completed but not logged in or has incomplete signup
        // Go to login
        context.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
      } else {
        // First time user, show onboarding
        context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
      }
    }
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
