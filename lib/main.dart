import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/features/search/logic/use_cases/search_use_cases.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
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
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   // localizationsDelegates: [DefaultMaterialLocalizations.delegate],
      //   // supportedLocales: [
      //   //   Locale('ar', 'SA'), // Arabic
      //   //   Locale('en', 'US'), // English
      //   // ],
      //   theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      //   onGenerateRoute: appRouting.onGenerateRouting,
      //   initialRoute: AppRoutes.splashScreen,
      // ),

      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchCubit(sl<SearchUseCase>()),
          ),
          // أي Cubits تانية لو محتاج
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          onGenerateRoute: appRouting.onGenerateRouting,
          initialRoute: AppRoutes.splashScreen,
        ),
      ),
    );
  }
}
