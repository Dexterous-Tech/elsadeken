import 'dart:developer';

import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/core/services/firebase_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase and notification services
    await FirebaseNotificationService.instance.initialize();

    // Initialize other dependencies
    await initializeDependencies();
    await sl.allReady();

    runApp(Elsadeken(appRouting: AppRouting()));
  } catch (e) {
    log("Error initializing app: $e");
    // Still run the app even if Firebase fails
    await initializeDependencies();
    await sl.allReady();
    runApp(Elsadeken(appRouting: AppRouting()));
  }
}

class Elsadeken extends StatelessWidget {
  const Elsadeken({super.key, required this.appRouting});
  final AppRouting appRouting;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 937),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        onGenerateRoute: appRouting.onGenerateRouting,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
