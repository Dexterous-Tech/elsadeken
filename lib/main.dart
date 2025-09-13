import 'dart:developer';
import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/core/services/firebase_notification_service.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/widgets/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize dependencies first
  await initializeDependencies();
  await sl.allReady();

  // Initialize localization service
  await LocalizationService.instance.initialize();

  try {
    // Initialize Firebase and notification services
    await FirebaseNotificationService.instance.initialize();

    // Check notification permissions for debugging
    await FirebaseNotificationService.instance.checkNotificationPermissions();

    // Test foreground notification (remove this in production)
    // await FirebaseNotificationService.instance.testForegroundNotification();
  } catch (e) {
    log("Error initializing Firebase: $e");
    // Continue without Firebase if it fails
  }

  runApp(Elsadeken(appRouting: AppRouting()));
}

class Elsadeken extends StatelessWidget {
  const Elsadeken({super.key, required this.appRouting});
  final AppRouting appRouting;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 937),
      minTextAdapt: true,
      splitScreenMode: true,
      child: LocalizationProvider(),
    );
  }
}
