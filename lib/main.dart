import 'dart:developer';
import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/core/services/firebase_notification_service.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies first
  await initializeDependencies();
  await sl.allReady();

  // Initialize localization service
  await LocalizationService.instance.initialize();

  try {
    // Initialize Firebase and notification services
    await FirebaseNotificationService.instance.initialize();
  } catch (e) {
    log("Error initializing Firebase: $e");
    // Continue without Firebase if it fails
  }

  runApp(Elsadeken(appRouting: AppRouting()));
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
      child: ListenableBuilder(
        listenable: LocalizationService.instance,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            onGenerateRoute: appRouting.onGenerateRouting,
            initialRoute: AppRoutes.splashScreen,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationService.supportedLocales,
            // Default language
            locale: LocalizationService.instance.currentLocale,
          );
        },
      ),
    );
  }
}
