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

    // Check if it's already an API value
    if (['single', 'married', 'divorced', 'widower'].contains(maritalStatus)) {
      return maritalStatus;
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    // The display value should be mapped back to its key
    return null; // This will be handled by the dialog's key mapping
  }

  /// Convert type of marriage from localized text to API value
  static String? mapTypeOfMarriageToApiValue(String typeOfMarriage) {
    if (typeOfMarriage.isEmpty) return null;

    print('DEBUG: Mapping type of marriage: "$typeOfMarriage"');

    // Check if it's already an API value
    if (['only_one', 'multi'].contains(typeOfMarriage)) {
      return typeOfMarriage;
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
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

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
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

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
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

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }

  /// Convert beard from localized text to API value
  static String? mapBeardToApiValue(String beard) {
    if (beard.isEmpty) return null;

    print('DEBUG: Mapping beard: "$beard"');

    // Check if it's already an API value
    if (['beard', 'without_beard'].contains(beard)) {
      return beard;
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }

  /// Convert smoking string to int (0 for "لا"/"No", 1 for "نعم"/"Yes")
  static int? mapSmokingToInt(String smokingStr) {
    if (smokingStr.isEmpty) return null;

    print('DEBUG: Mapping smoking: "$smokingStr"');

    // Check if it's already an API value (numeric string)
    if (smokingStr == '1' || smokingStr == '0') {
      return int.tryParse(smokingStr);
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }
}
