import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networking/dio_factory.dart';

class LocalizationService extends ChangeNotifier {
  static LocalizationService? _instance;
  static LocalizationService get instance {
    _instance ??= LocalizationService._internal();
    return _instance!;
  }

  LocalizationService._internal();

  static const String _localeKey = 'app_locale';
  static const String _defaultLocale = 'ar';

  Locale _currentLocale = const Locale('ar');
  Locale get currentLocale => _currentLocale;

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  // Initialize the service
  Future<void> initialize() async {
    await _loadSavedLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey) ?? _defaultLocale;
      _currentLocale = Locale(savedLocale);
      notifyListeners();
    } catch (e) {
      // If there's an error, use default locale
      _currentLocale = const Locale(_defaultLocale);
      notifyListeners();
    }
  }

  // Change locale
  Future<void> changeLocale(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);

      // Update Dio headers with new language
      await DioFactory.updateLanguageHeader();
    } catch (e) {
      // Handle error if needed
    }

    notifyListeners();
  }

  // Show language change snackbar
  void showLanguageChangeSnackBar(BuildContext context) {
    final isArabic = _currentLocale.languageCode == 'ar';
    final message =
        isArabic ? 'تم تغيير اللغة إلى العربية' : 'Language changed to English';
    final flag = isArabic ? '🇸🇦' : '🇺🇸';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isArabic ? Colors.green[600] : Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: isArabic ? 'حسناً' : 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Toggle between Arabic and English
  Future<void> toggleLocale() async {
    final newLocale = _currentLocale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLocale(newLocale);
  }

  // Check if current locale is Arabic
  bool get isArabic => _currentLocale.languageCode == 'ar';

  // Check if current locale is English
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Get current language code
  String get currentLanguageCode => _currentLocale.languageCode;

  // Get text direction
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  // Get alignment for RTL/LTR
  Alignment get startAlignment =>
      isArabic ? Alignment.centerRight : Alignment.centerLeft;
  Alignment get endAlignment =>
      isArabic ? Alignment.centerLeft : Alignment.centerRight;
  Alignment get topAlignment =>
      isArabic ? Alignment.topRight : Alignment.topLeft;

  TextAlign get textAlignment => isArabic ? TextAlign.right : TextAlign.left;
  // Get cross axis alignment for RTL/LTR
  CrossAxisAlignment get startCrossAxisAlignment =>
      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  CrossAxisAlignment get endCrossAxisAlignment =>
      isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.end;

  TextAlign get convertTextAlignment =>
      isArabic ? TextAlign.left : TextAlign.right;
}
