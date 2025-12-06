import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class LocalizationHelper {
  static LocalizationService get service => LocalizationService.instance;

  // Get current locale
  static Locale get currentLocale => service.currentLocale;

  // Get current language code
  static String get currentLanguageCode => service.currentLanguageCode;

  // Check if current locale is Arabic
  static bool get isArabic => service.isArabic;

  // Check if current locale is English
  static bool get isEnglish => service.isEnglish;

  // Get text direction
  static TextDirection get textDirection => service.textDirection;

  // Get alignment for RTL/LTR
  static Alignment get startAlignment => service.startAlignment;
  static Alignment get endAlignment => service.endAlignment;

  // Get cross axis alignment for RTL/LTR
  static CrossAxisAlignment get startCrossAxisAlignment =>
      service.startCrossAxisAlignment;
  static CrossAxisAlignment get endCrossAxisAlignment =>
      service.endCrossAxisAlignment;

  // Get main axis alignment for RTL/LTR
  static MainAxisAlignment get startMainAxisAlignment =>
      isArabic ? MainAxisAlignment.end : MainAxisAlignment.start;
  static MainAxisAlignment get endMainAxisAlignment =>
      isArabic ? MainAxisAlignment.start : MainAxisAlignment.end;

  // Get padding for RTL/LTR
  static EdgeInsets get startPadding => isArabic
      ? const EdgeInsets.only(right: 16)
      : const EdgeInsets.only(left: 16);
  static EdgeInsets get endPadding => isArabic
      ? const EdgeInsets.only(left: 16)
      : const EdgeInsets.only(right: 16);

  // Get margin for RTL/LTR
  static EdgeInsets get startMargin => isArabic
      ? const EdgeInsets.only(right: 8)
      : const EdgeInsets.only(left: 8);
  static EdgeInsets get endMargin => isArabic
      ? const EdgeInsets.only(left: 8)
      : const EdgeInsets.only(right: 8);

  // Get border radius for RTL/LTR
  static BorderRadius get startBorderRadius => isArabic
      ? const BorderRadius.only(
          topRight: Radius.circular(8), bottomRight: Radius.circular(8))
      : const BorderRadius.only(
          topLeft: Radius.circular(8), bottomLeft: Radius.circular(8));

  static BorderRadius get endBorderRadius => isArabic
      ? const BorderRadius.only(
          topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
      : const BorderRadius.only(
          topRight: Radius.circular(8), bottomRight: Radius.circular(8));

  // Get localized text based on current locale
  static String getLocalizedText(String arabicText, String englishText) {
    return isArabic ? arabicText : englishText;
  }

  // Get localized text with parameters
  static String getLocalizedTextWithParams(
      String arabicText, String englishText, Map<String, String> params) {
    String text = getLocalizedText(arabicText, englishText);
    params.forEach((key, value) {
      text = text.replaceAll('{$key}', value);
    });
    return text;
  }

  // Get localized number format
  static String getLocalizedNumber(int number) {
    if (isArabic) {
      // Convert to Arabic numerals if needed
      return number.toString().replaceAllMapped(
            RegExp(r'[0-9]'),
            (match) =>
                String.fromCharCode(match.group(0)!.codeUnitAt(0) + 1584),
          );
    }
    return number.toString();
  }

  // Get localized date format
  static String getLocalizedDate(DateTime date) {
    if (isArabic) {
      // Arabic date format
      return '${date.day}/${date.month}/${date.year}';
    } else {
      // English date format
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  // Get localized time format
  static String getLocalizedTime(DateTime time) {
    if (isArabic) {
      // Arabic time format (24-hour)
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      // English time format (12-hour)
      final hour = time.hour > 12 ? time.hour - 12 : time.hour;
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  // Get localized currency format
  static String getLocalizedCurrency(double amount, String currencyCode) {
    if (isArabic) {
      // Arabic currency format
      return '${amount.toStringAsFixed(2)} $currencyCode';
    } else {
      // English currency format
      return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  // Get localized percentage format
  static String getLocalizedPercentage(double percentage) {
    if (isArabic) {
      // Arabic percentage format
      return '${percentage.toStringAsFixed(1)}%';
    } else {
      // English percentage format
      return '${percentage.toStringAsFixed(1)}%';
    }
  }

  // Get localized phone number format
  static String getLocalizedPhoneNumber(String phoneNumber) {
    if (isArabic) {
      // Arabic phone number format
      return phoneNumber;
    } else {
      // English phone number format
      return phoneNumber;
    }
  }

  // Get localized address format
  static String getLocalizedAddress({
    required String street,
    required String city,
    required String country,
    String? state,
    String? postalCode,
  }) {
    if (isArabic) {
      // Arabic address format
      final parts = <String>[];
      if (street.isNotEmpty) parts.add(street);
      if (city.isNotEmpty) parts.add(city);
      if (state?.isNotEmpty == true) parts.add(state!);
      if (postalCode?.isNotEmpty == true) parts.add(postalCode!);
      if (country.isNotEmpty) parts.add(country);
      return parts.join('، ');
    } else {
      // English address format
      final parts = <String>[];
      if (street.isNotEmpty) parts.add(street);
      if (city.isNotEmpty) parts.add(city);
      if (state?.isNotEmpty == true) parts.add(state!);
      if (postalCode?.isNotEmpty == true) parts.add(postalCode!);
      if (country.isNotEmpty) parts.add(country);
      return parts.join(', ');
    }
  }
}
