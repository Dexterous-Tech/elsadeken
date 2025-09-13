import 'package:country_code_picker/country_code_picker.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';

class CustomCountryCodePicker extends StatefulWidget {
  final ValueNotifier<String> code; // Controller-like notifier
  final String?
      initialCountryCode; // Optional initial country code (e.g., '+966')

  const CustomCountryCodePicker({
    super.key,
    required this.code,
    this.initialCountryCode,
  });

  @override
  State<CustomCountryCodePicker> createState() =>
      _CustomCountryCodePickerState();
}

class _CustomCountryCodePickerState extends State<CustomCountryCodePicker> {
  @override
  void initState() {
    super.initState();
    // Set initial value to provided country code or default to SA (+966)
    widget.code.value = widget.initialCountryCode ?? '+966';
  }

  /// Convert country dial code to country code
  String _getCountryCodeFromDialCode(String? dialCode) {
    if (dialCode == null) return 'SA';

    // Map of common dial codes to country codes
    final Map<String, String> dialCodeToCountry = {
      '+966': 'SA', // Saudi Arabia
      '+20': 'EG', // Egypt
      '+971': 'AE', // UAE
      '+965': 'KW', // Kuwait
      '+974': 'QA', // Qatar
      '+973': 'BH', // Bahrain
      '+968': 'OM', // Oman
      '+962': 'JO', // Jordan
      '+961': 'LB', // Lebanon
      '+963': 'SY', // Syria
      '+964': 'IQ', // Iraq
      '+212': 'MA', // Morocco
      '+213': 'DZ', // Algeria
      '+216': 'TN', // Tunisia
      '+218': 'LY', // Libya
      '+90': 'TR', // Turkey
      '+98': 'IR', // Iran
      '+1': 'US', // United States
      '+44': 'GB', // United Kingdom
      '+33': 'FR', // France
      '+49': 'DE', // Germany
      '+39': 'IT', // Italy
      '+34': 'ES', // Spain
      '+7': 'RU', // Russia
      '+86': 'CN', // China
      '+81': 'JP', // Japan
      '+82': 'KR', // South Korea
      '+91': 'IN', // India
      '+92': 'PK', // Pakistan
      '+880': 'BD', // Bangladesh
    };

    return dialCodeToCountry[dialCode] ?? 'SA';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppColors.snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16).r,
          side: BorderSide(color: AppColors.brown),
        ),
      ),
      child: Center(
        child: Directionality(
          textDirection: LocalizationService.instance.textDirection,
          child: CountryCodePicker(
            searchDecoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.selectCountry,
            ),
            headerText: AppLocalizations.of(context)!.selectCountry,
            padding: EdgeInsets.zero,
            onChanged: (code) {
              widget.code.value = code.dialCode ?? '';
            },
            initialSelection:
                _getCountryCodeFromDialCode(widget.initialCountryCode),
            favorite: ['+966', 'SA'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ),
        ),
      ),
    );
  }
}
