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

    // Map of dial codes to country codes (comprehensive list)
    final Map<String, String> dialCodeToCountry = {
      // Middle East & North Africa
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
      '+972': 'IL', // Israel
      '+970': 'PS', // Palestine

      // Asia Pacific
      '+86': 'CN', // China
      '+81': 'JP', // Japan
      '+82': 'KR', // South Korea
      '+84': 'VN', // Vietnam
      '+66': 'TH', // Thailand
      '+60': 'MY', // Malaysia
      '+65': 'SG', // Singapore
      '+62': 'ID', // Indonesia
      '+63': 'PH', // Philippines
      '+855': 'KH', // Cambodia
      '+856': 'LA', // Laos
      '+95': 'MM', // Myanmar
      '+673': 'BN', // Brunei
      '+670': 'TL', // East Timor

      // South Asia
      '+91': 'IN', // India
      '+92': 'PK', // Pakistan
      '+880': 'BD', // Bangladesh
      '+977': 'NP', // Nepal
      '+94': 'LK', // Sri Lanka
      '+960': 'MV', // Maldives
      '+975': 'BT', // Bhutan
      '+93': 'AF', // Afghanistan

      // Europe
      '+44': 'GB', // United Kingdom
      '+33': 'FR', // France
      '+49': 'DE', // Germany
      '+39': 'IT', // Italy
      '+34': 'ES', // Spain
      '+7': 'RU', // Russia
      '+380': 'UA', // Ukraine
      '+48': 'PL', // Poland
      '+40': 'RO', // Romania
      '+36': 'HU', // Hungary
      '+420': 'CZ', // Czech Republic
      '+421': 'SK', // Slovakia
      '+385': 'HR', // Croatia
      '+386': 'SI', // Slovenia
      '+387': 'BA', // Bosnia and Herzegovina
      '+382': 'ME', // Montenegro
      '+383': 'XK', // Kosovo
      '+389': 'MK', // North Macedonia
      '+359': 'BG', // Bulgaria
      '+30': 'GR', // Greece
      '+31': 'NL', // Netherlands
      '+32': 'BE', // Belgium
      '+41': 'CH', // Switzerland
      '+43': 'AT', // Austria
      '+45': 'DK', // Denmark
      '+46': 'SE', // Sweden
      '+47': 'NO', // Norway
      '+358': 'FI', // Finland
      '+354': 'IS', // Iceland
      '+353': 'IE', // Ireland
      '+351': 'PT', // Portugal
      '+370': 'LT', // Lithuania
      '+371': 'LV', // Latvia
      '+372': 'EE', // Estonia
      '+375': 'BY', // Belarus
      '+373': 'MD', // Moldova
      '+374': 'AM', // Armenia
      '+995': 'GE', // Georgia
      '+994': 'AZ', // Azerbaijan
      '+378': 'SM', // San Marino
      '+377': 'MC', // Monaco
      '+376': 'AD', // Andorra
      '+423': 'LI', // Liechtenstein
      '+352': 'LU', // Luxembourg
      '+356': 'MT', // Malta
      '+357': 'CY', // Cyprus

      // Americas - North America
      '+1': 'US', // United States (primary)
      '+52': 'MX', // Mexico

      // Americas - South America
      '+55': 'BR', // Brazil
      '+54': 'AR', // Argentina
      '+56': 'CL', // Chile
      '+57': 'CO', // Colombia
      '+51': 'PE', // Peru
      '+58': 'VE', // Venezuela
      '+593': 'EC', // Ecuador
      '+591': 'BO', // Bolivia
      '+598': 'UY', // Uruguay
      '+595': 'PY', // Paraguay
      '+592': 'GY', // Guyana
      '+597': 'SR', // Suriname

      // Americas - Caribbean
      '+1242': 'BS', // Bahamas
      '+1246': 'BB', // Barbados
      '+1264': 'AI', // Anguilla
      '+1268': 'AG', // Antigua and Barbuda
      '+1284': 'VG', // British Virgin Islands
      '+1340': 'VI', // US Virgin Islands
      '+1345': 'KY', // Cayman Islands
      '+1473': 'GD', // Grenada
      '+1649': 'TC', // Turks and Caicos Islands
      '+1664': 'MS', // Montserrat
      '+1670': 'MP', // Northern Mariana Islands
      '+1671': 'GU', // Guam
      '+1684': 'AS', // American Samoa
      '+1721': 'SX', // Sint Maarten
      '+1758': 'LC', // Saint Lucia
      '+1767': 'DM', // Dominica
      '+1784': 'VC', // Saint Vincent and the Grenadines
      '+1787': 'PR', // Puerto Rico
      '+1809': 'DO', // Dominican Republic
      '+1829': 'DO', // Dominican Republic
      '+1849': 'DO', // Dominican Republic
      '+1868': 'TT', // Trinidad and Tobago
      '+1869': 'KN', // Saint Kitts and Nevis
      '+1876': 'JM', // Jamaica
      '+1939': 'PR', // Puerto Rico

      // Americas - French Territories
      '+590': 'GP', // Guadeloupe
      '+596': 'MQ', // Martinique
      '+594': 'GF', // French Guiana
      '+508': 'PM', // Saint Pierre and Miquelon

      // Americas - Netherlands Territories
      '+599': 'CW', // Curaçao

      // Africa
      '+27': 'ZA', // South Africa
      '+234': 'NG', // Nigeria
      '+254': 'KE', // Kenya
      '+251': 'ET', // Ethiopia
      '+255': 'TZ', // Tanzania
      '+256': 'UG', // Uganda
      '+250': 'RW', // Rwanda
      '+257': 'BI', // Burundi
      '+243': 'CD', // Democratic Republic of the Congo
      '+242': 'CG', // Republic of the Congo
      '+236': 'CF', // Central African Republic
      '+235': 'TD', // Chad
      '+237': 'CM', // Cameroon
      '+240': 'GQ', // Equatorial Guinea
      '+241': 'GA', // Gabon
      '+245': 'GW', // Guinea-Bissau
      '+238': 'CV', // Cape Verde
      '+239': 'ST', // São Tomé and Príncipe
      '+244': 'AO', // Angola
      '+260': 'ZM', // Zambia
      '+263': 'ZW', // Zimbabwe
      '+264': 'NA', // Namibia
      '+267': 'BW', // Botswana
      '+268': 'SZ', // Eswatini
      '+266': 'LS', // Lesotho
      '+258': 'MZ', // Mozambique
      '+261': 'MG', // Madagascar
      '+265': 'MW', // Malawi
      '+269': 'KM', // Comoros
      '+290': 'SH', // Saint Helena
      '+291': 'ER', // Eritrea
      '+249': 'SD', // Sudan
      '+253': 'DJ', // Djibouti
      '+252': 'SO', // Somalia
      '+232': 'SL', // Sierra Leone
      '+233': 'GH', // Ghana
      '+225': 'CI', // Côte d'Ivoire
      '+226': 'BF', // Burkina Faso
      '+227': 'NE', // Niger
      '+228': 'TG', // Togo
      '+229': 'BJ', // Benin
      '+220': 'GM', // Gambia
      '+221': 'SN', // Senegal
      '+222': 'MR', // Mauritania
      '+223': 'ML', // Mali
      '+224': 'GN', // Guinea
      '+231': 'LR', // Liberia

      // Africa - French Territories
      '+262': 'RE', // Réunion

      // Oceania
      '+61': 'AU', // Australia
      '+64': 'NZ', // New Zealand
      '+679': 'FJ', // Fiji
      '+685': 'WS', // Samoa
      '+676': 'TO', // Tonga
      '+678': 'VU', // Vanuatu
      '+675': 'PG', // Papua New Guinea
      '+687': 'NC', // New Caledonia
      '+689': 'PF', // French Polynesia
      '+688': 'TV', // Tuvalu
      '+686': 'KI', // Kiribati
      '+692': 'MH', // Marshall Islands
      '+691': 'FM', // Micronesia
      '+680': 'PW', // Palau
      '+684': 'AS', // American Samoa
      '+683': 'NU', // Niue
      '+682': 'CK', // Cook Islands
      '+690': 'TK', // Tokelau
      '+672': 'NF', // Norfolk Island
      '+674': 'NR', // Nauru
      '+677': 'SB', // Solomon Islands
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
