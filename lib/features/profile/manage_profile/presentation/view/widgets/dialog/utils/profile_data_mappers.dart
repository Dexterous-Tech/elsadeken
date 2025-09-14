import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';

/// Utility class for mapping data between UI and API formats
class ProfileDataMappers {
  /// Get country ID by country name
  static int? getCountryIdByName(
    String countryName,
    List<NationalCountryResponseModel> countriesList,
  ) {
    try {
      print('DEBUG: Looking for country: "$countryName"');
      print(
          'DEBUG: Available countries: ${countriesList.map((c) => '${c.name} (ID: ${c.id})').toList()}');
      final country = countriesList.firstWhere(
        (country) => country.name == countryName,
      );
      print('DEBUG: Found country ID: ${country.id}');
      return country.id;
    } catch (e) {
      print('DEBUG: Country not found: $e');
      return null;
    }
  }

  /// Get nationality ID by nationality name
  static int? getNationalityIdByName(
    String nationalityName,
    List<NationalCountryResponseModel> nationalitiesList,
  ) {
    try {
      print('DEBUG: Looking for nationality: "$nationalityName"');
      print(
          'DEBUG: Available nationalities: ${nationalitiesList.map((n) => '${n.name} (ID: ${n.id})').toList()}');
      final nationality = nationalitiesList.firstWhere(
        (nationality) => nationality.name == nationalityName,
      );
      print('DEBUG: Found nationality ID: ${nationality.id}');
      return nationality.id;
    } catch (e) {
      print('DEBUG: Nationality not found: $e');
      return null;
    }
  }

  /// Get city ID by city name
  static int? getCityIdByName(
    String cityName,
    List<CityResponseModels> citiesList,
  ) {
    try {
      print('DEBUG: Looking for city: "$cityName"');
      print(
          'DEBUG: Available cities: ${citiesList.map((c) => '${c.name} (ID: ${c.id})').toList()}');
      final city = citiesList.firstWhere(
        (city) => city.name == cityName,
      );
      print('DEBUG: Found city ID: ${city.id}');
      return city.id;
    } catch (e) {
      print('DEBUG: City not found: $e');
      return null;
    }
  }

  /// Get skin color ID by skin color name
  static int? getSkinColorIdByName(
    String skinColorName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final skinColors = generalDataLists['skinColors'];
      if (skinColors != null && skinColors.isNotEmpty) {
        final skinColor = skinColors.firstWhere(
          (item) => item.name == skinColorName,
        );
        return skinColor.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get physique ID by physique name
  static int? getPhysiqueIdByName(
    String physiqueName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final physiques = generalDataLists['physiques'];
      if (physiques != null && physiques.isNotEmpty) {
        final physique = physiques.firstWhere(
          (item) => item.name == physiqueName,
        );
        return physique.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get qualification ID by qualification name
  static int? getQualificationIdByName(
    String qualificationName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final qualifications = generalDataLists['qualifications'];
      if (qualifications != null && qualifications.isNotEmpty) {
        final qualification = qualifications.firstWhere(
          (item) => item.name == qualificationName,
        );
        return qualification.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get financial situation ID by financial situation name
  static int? getFinancialSituationIdByName(
    String financialSituationName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final financialSituations = generalDataLists['financialSituations'];
      if (financialSituations != null && financialSituations.isNotEmpty) {
        final financialSituation = financialSituations.firstWhere(
          (item) => item.name == financialSituationName,
        );
        return financialSituation.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get health condition ID by health condition name
  static int? getHealthConditionIdByName(
    String healthConditionName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final healthConditions = generalDataLists['healthConditions'];
      if (healthConditions != null && healthConditions.isNotEmpty) {
        final healthCondition = healthConditions.firstWhere(
          (item) => item.name == healthConditionName,
        );
        return healthCondition.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Convert marital status from localized text to API value
  static String? mapMaritalStatusToApiValue(String maritalStatus) {
    if (maritalStatus.isEmpty) return null;

    print('DEBUG: Mapping marital status: "$maritalStatus"');

    switch (maritalStatus) {
      // English options (from localized strings)
      case 'Single':
        return 'single';
      case 'Married':
        return 'married';
      case 'Divorced':
        return 'divorced';
      case 'Widower':
        return 'widower';
      // Female English options
      case 'Single Female':
        return 'single';
      case 'Married Female':
        return 'married';
      case 'Divorced Female':
        return 'divorced';
      case 'Widowed Female':
        return 'widower';
      // Arabic options
      case 'آنسة':
        return 'single';
      case 'مطلقة':
        return 'divorced';
      case 'أرملة':
        return 'widower';
      case 'عازب':
        return 'single';
      case 'متزوج':
        return 'married';
      case 'مطلق':
        return 'divorced';
      case 'أرمل':
        return 'widower';
      default:
        print('DEBUG: No mapping found for marital status: "$maritalStatus"');
        return null;
    }
  }

  /// Convert type of marriage from localized text to API value
  static String? mapTypeOfMarriageToApiValue(String typeOfMarriage) {
    if (typeOfMarriage.isEmpty) return null;

    print('DEBUG: Mapping type of marriage: "$typeOfMarriage"');

    switch (typeOfMarriage) {
      // English options (from localized strings)
      case 'First Wife':
        return 'only_one';
      case 'Second Wife':
        return 'multi';
      case 'Only Husband':
        return 'only_one';
      case 'No Objection to Polygamy':
        return 'multi';
      // Arabic options
      case 'الزوج الوحيد':
        return 'only_one';
      case 'لا مانع من تعدل الزوجات':
        return 'multi';
      case 'زوجة اولي':
        return 'only_one';
      case 'زوجة ثانية':
        return 'multi';
      default:
        print(
            'DEBUG: No mapping found for type of marriage: "$typeOfMarriage"');
        return null;
    }
  }

  /// Convert religious commitment from localized text to API value
  static String? mapReligiousCommitmentToApiValue(String religiousCommitment) {
    if (religiousCommitment.isEmpty) return null;

    print('DEBUG: Mapping religious commitment: "$religiousCommitment"');

    // Check if it's already an API value
    if ([
      'irreligious',
      'little_religious',
      'religious',
      'much_religious',
      'dont_say'
    ].contains(religiousCommitment)) {
      return religiousCommitment;
    }

    // Map localized values to API values
    switch (religiousCommitment) {
      case 'غير متدين':
      case 'Not religious':
        return 'irreligious';
      case 'متدين قليلاً':
      case 'A little religious':
      case 'Little religious':
        return 'little_religious';
      case 'متدين':
      case 'Religious':
        return 'religious';
      case 'متدين كثيراً':
      case 'Very religious':
        return 'much_religious';
      case 'أفضل ألا أقول':
      case 'Prefer not to say':
        return 'dont_say';
      default:
        print(
            'DEBUG: No mapping found for religious commitment: "$religiousCommitment"');
        return null;
    }
  }

  /// Convert prayer from localized text to API value
  static String? mapPrayerToApiValue(String prayer) {
    if (prayer.isEmpty) return null;

    print('DEBUG: Mapping prayer: "$prayer"');

    // Check if it's already an API value
    if (['always', 'most_times', 'sometimes', 'no_pray', 'dont_say']
        .contains(prayer)) {
      return prayer;
    }

    // Map localized values to API values
    switch (prayer) {
      case 'أصلي دائماً':
      case 'I always pray':
        return 'always';
      case 'أصلي أغلب الأوقات':
      case 'I pray most of the time':
        return 'most_times';
      case 'أصلي أحياناً':
      case 'I pray sometimes':
        return 'sometimes';
      case 'لا أصلي':
      case 'I don\'t pray':
        return 'no_pray';
      case 'أفضل ألا أقول':
      case 'Prefer not to say':
        return 'dont_say';
      default:
        print('DEBUG: No mapping found for prayer: "$prayer"');
        return null;
    }
  }

  /// Convert hijab from localized text to API value
  static String? mapHijabToApiValue(String hijab) {
    if (hijab.isEmpty) return null;

    print('DEBUG: Mapping hijab: "$hijab"');

    // Check if it's already an API value
    if (['not_hijab', 'hijab', 'hijab_and_veil', 'hijab_face', 'dont_say']
        .contains(hijab)) {
      return hijab;
    }

    // Map localized values to API values
    switch (hijab) {
      case 'غير محجبة':
      case 'Not wearing hijab':
        return 'not_hijab';
      case 'محجبة (كشف الوجه)':
      case 'Hijab (face visible)':
        return 'hijab';
      case 'محجبة (النقاب)':
      case 'Hijab with veil':
        return 'hijab_and_veil';
      case 'محجبة (غطاء الوجه)':
      case 'Hijab (face covered)':
        return 'hijab_face';
      case 'أفضل ألا أقول':
      case 'Prefer not to say':
        return 'dont_say';
      default:
        print('DEBUG: No mapping found for hijab: "$hijab"');
        return null;
    }
  }

  /// Convert beard from localized text to API value
  static String? mapBeardToApiValue(String beard) {
    if (beard.isEmpty) return null;

    print('DEBUG: Mapping beard: "$beard"');

    // Check if it's already an API value
    if (['beard', 'without_beard'].contains(beard)) {
      return beard;
    }

    // Map localized values to API values
    switch (beard) {
      case 'ملتحي':
      case 'With beard':
        return 'beard';
      case 'بدون لحية':
      case 'Without beard':
        return 'without_beard';
      default:
        print('DEBUG: No mapping found for beard: "$beard"');
        return null;
    }
  }

  /// Convert smoking string to int (0 for "لا"/"No", 1 for "نعم"/"Yes")
  static int? mapSmokingToInt(String smokingStr) {
    if (smokingStr.isEmpty) return null;

    print('DEBUG: Mapping smoking: "$smokingStr"');

    final result = (smokingStr == 'نعم' || smokingStr == 'Yes') ? 1 : 0;
    print('DEBUG: Smoking mapped to: $result');

    return result;
  }
}
