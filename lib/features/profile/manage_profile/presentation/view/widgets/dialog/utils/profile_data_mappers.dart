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
      final trimmedCountryName = countryName.trim();
      final country = countriesList.firstWhere(
        (country) => country.name?.trim() == trimmedCountryName,
      );
      return country.id;
    } catch (e) {
      return null;
    }
  }

  /// Get nationality ID by nationality name
  static int? getNationalityIdByName(
    String nationalityName,
    List<NationalCountryResponseModel> nationalitiesList,
  ) {
    try {
      final trimmedNationalityName = nationalityName.trim();
      final nationality = nationalitiesList.firstWhere(
        (nationality) => nationality.name?.trim() == trimmedNationalityName,
      );
      return nationality.id;
    } catch (e) {
      return null;
    }
  }

  /// Get city ID by city name
  static int? getCityIdByName(
    String cityName,
    List<CityResponseModels> citiesList,
  ) {
    try {
      final trimmedCityName = cityName.trim();
      final city = citiesList.firstWhere(
        (city) => city.name?.trim() == trimmedCityName,
      );
      return city.id;
    } catch (e) {
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

  /// Get income ID by income name
  static int? getIncomeIdByName(
    String incomeName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final incomes = generalDataLists['incomes'];
      if (incomes != null && incomes.isNotEmpty) {
        final income = incomes.firstWhere((item) => item.name == incomeName);
        return income.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get job ID by job name
  static int? getJobIdByName(
    String jobName,
    Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  ) {
    try {
      final jobs = generalDataLists['jobs'];
      if (jobs != null && jobs.isNotEmpty) {
        final job = jobs.firstWhere((item) => item.name == jobName);
        return job.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Convert marital status from localized text to API value
  static String? mapMaritalStatusToApiValue(String maritalStatus) {
    if (maritalStatus.isEmpty) return null;

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

    // Check if it's already an API value
    if ([
      'irreligious',
      'little_religious',
      'religious',
      'much_religious',
      'dont_say',
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

    // Check if it's already an API value
    if ([
      'always',
      'most_times',
      'sometimes',
      'no_pray',
      'dont_say',
    ].contains(prayer)) {
      return prayer;
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }

  /// Convert hijab from localized text to API value
  static String? mapHijabToApiValue(String hijab) {
    if (hijab.isEmpty) return null;

    // Check if it's already an API value
    if ([
      'not_hijab',
      'hijab',
      'hijab_and_veil',
      'hijab_face',
      'dont_say',
    ].contains(hijab)) {
      return hijab;
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }

  /// Convert beard from localized text to API value
  static String? mapBeardToApiValue(String beard) {
    if (beard.isEmpty) return null;

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

    // Check if it's already an API value (numeric string)
    if (smokingStr == '1' || smokingStr == '0') {
      return int.tryParse(smokingStr);
    }

    // Map display values back to API keys
    // This should work with the new key-value system
    return null; // This will be handled by the dialog's key mapping
  }
}
