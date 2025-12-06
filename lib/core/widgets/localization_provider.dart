import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../services/localization_service.dart';
import '../../l10n/app_localizations.dart';

class LocalizationProvider extends StatefulWidget {

  const LocalizationProvider({
    super.key,
  });

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();
}

class _LocalizationProviderState extends State<LocalizationProvider> {
  late LocalizationService _localizationService;


  @override
  void initState() {
    super.initState();
    _localizationService = LocalizationService.instance;
    _initializeLocalization();
  }

  Future<void> _initializeLocalization() async {
    await _localizationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localizationService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: FontFamilyHelper.lamaSansArabic),
          onGenerateRoute: AppRouting().onGenerateRouting,
          initialRoute: AppRoutes.splashScreen,
          locale: _localizationService.currentLocale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: _localizationService.textDirection,
              child: child!,
            );
          },
        );
      },
    );
  }
}
