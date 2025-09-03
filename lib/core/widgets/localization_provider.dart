import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../services/localization_service.dart';

class LocalizationProvider extends StatefulWidget {
  final Widget child;

  const LocalizationProvider({
    super.key,
    required this.child,
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
          locale: _localizationService.currentLocale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: const [
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
          home: widget.child,
        );
      },
    );
  }
}
