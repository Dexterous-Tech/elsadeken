import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/features/home/notification/data/datasources/notification_api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';
import 'firebase_options.dart';

// Background message handler
@pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('Handling a background message: ${message.messageId}');
//   print('Message data: ${message.data}');
//   print('Message notification: ${message.notification?.title}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set background message handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize other dependencies
  await initializeDependencies();

  // Initialize FCM and update token
  // await NotificationApiServiceImpl.initializeFcmAndUpdateToken();

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [DefaultMaterialLocalizations.delegate],
        // supportedLocales: [
        //   Locale('ar', 'SA'), // Arabic
        //   Locale('en', 'US'), // English
        // ],
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        onGenerateRoute: appRouting.onGenerateRouting,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
