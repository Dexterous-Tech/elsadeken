import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/utils/profile_data_mappers.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Base class for all update handlers
abstract class ProfileUpdateHandler {
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  });
}

/// Update handler for login data
class LoginDataUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final name =
        controllers[AppLocalizations.of(context)!.username]?.text ?? '';
    final email = controllers[AppLocalizations.of(context)!.email]?.text ?? '';
    final phone =
        controllers[AppLocalizations.of(context)!.phoneNumber]?.text ?? '';
    final password =
        controllers[AppLocalizations.of(context)!.passwordOptional]?.text ?? '';
    final passwordConfirmation =
        controllers[AppLocalizations.of(context)!.confirmPasswordOptional]
                ?.text ??
            '';

    // Get country code from the ValueNotifier and phone number from text field separately
    String? countryCode;
    String? phoneNumber =
        phone.trim(); // Phone number is directly from text field

    // For now, we'll use a default approach since we need to access the field data
    // This will be fixed when we pass the field data to the update handler
    countryCode = '+966'; // Default, this should be passed from the dialog

    cubit.updateProfileLoginData(
      name: name.isNotEmpty ? name : null,
      email: email.isNotEmpty ? email : null,
      phone: phoneNumber.isNotEmpty ? phoneNumber : null,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      password: password.isNotEmpty ? password : null,
      passwordConfirmation:
          passwordConfirmation.isNotEmpty ? passwordConfirmation : null,
    );
  }

  /// Update method that accepts field data to get country code
  void updateWithFieldData(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context,
    List<ManageProfileField> fields, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final name =
        controllers[AppLocalizations.of(context)!.username]?.text ?? '';
    final email = controllers[AppLocalizations.of(context)!.email]?.text ?? '';
    final phone =
        controllers[AppLocalizations.of(context)!.phoneNumber]?.text ?? '';
    final password =
        controllers[AppLocalizations.of(context)!.passwordOptional]?.text ?? '';
    final passwordConfirmation =
        controllers[AppLocalizations.of(context)!.confirmPasswordOptional]
                ?.text ??
            '';

    // Get country code from the phone field's ValueNotifier
    String? countryCode;
    String? phoneNumber = phone.trim();

    // Find the phone field to get its country code ValueNotifier
    final phoneField = fields.firstWhere(
      (field) => field.type == ManageProfileFieldType.phoneWithCountryCode,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    // Get the country code from the field's ValueNotifier
    if (phoneField.code != null) {
      countryCode = phoneField.code!.value;
    } else {
      countryCode = '+966'; // Default fallback
    }

    print('DEBUG: Login Data Update - Country Code: "$countryCode"');
    print('DEBUG: Login Data Update - Phone Number: "$phoneNumber"');

    cubit.updateProfileLoginData(
      name: name.isNotEmpty ? name : null,
      email: email.isNotEmpty ? email : null,
      phone: phoneNumber.isNotEmpty ? phoneNumber : null,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      password: password.isNotEmpty ? password : null,
      passwordConfirmation:
          passwordConfirmation.isNotEmpty ? passwordConfirmation : null,
    );
  }
}

/// Update handler for national country data
class NationalCountryUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    // This method signature doesn't have access to fields
    // So we need to use a different approach
    throw UnimplementedError(
        'Use updateWithFieldData for NationalCountryUpdateHandler');
  }

  /// Update method that accepts field data to get current values
  void updateWithFieldData(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context,
    List<ManageProfileField> fields, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    // Get current nationality field
    final nationalityField = fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.nationality,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    // Get current country field
    final countryField = fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.country,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    // Get current city field
    final cityField = fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.city,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    // Get new values from controllers
    final nationalityController =
        controllers[AppLocalizations.of(context)!.nationality];
    final countryController =
        controllers[AppLocalizations.of(context)!.country_residence];
    final cityController = controllers[AppLocalizations.of(context)!.city];

    print('DEBUG: National Country Update - Initial values:');
    print('DEBUG: Nationality controller: "${nationalityController?.text}"');
    print(
        'DEBUG: Nationality field currentValue: "${nationalityField.currentValue}"');
    print('DEBUG: Country controller: "${countryController?.text}"');
    print('DEBUG: Country field currentValue: "${countryField.currentValue}"');
    print('DEBUG: City controller: "${cityController?.text}"');
    print('DEBUG: City field currentValue: "${cityField.currentValue}"');

    // Get IDs from controllers or use old values
    // If controller has a value and it's different from old value, use new value
    // Otherwise, use old value
    int? nationalityId;
    int? countryId;
    int? cityId;

    // Handle nationality
    // If controller is null or text is empty, user didn't change it, so use old value
    if (nationalityController == null || nationalityController.text.isEmpty) {
      print('DEBUG: Nationality not changed (empty), using old value');
      nationalityId = ProfileDataMappers.getNationalityIdByName(
          nationalityField.currentValue, nationalitiesList);
      print('DEBUG: Using old nationality ID: $nationalityId');
    } else {
      // Controller has a value - check if it's different from old value
      final nationalityChanged = nationalityController.text.trim() !=
          nationalityField.currentValue.trim();
      print('DEBUG: Nationality changed: $nationalityChanged');

      if (nationalityChanged) {
        // User changed nationality, use new value
        nationalityId = ProfileDataMappers.getNationalityIdByName(
            nationalityController.text, nationalitiesList);
        print('DEBUG: Using new nationality ID: $nationalityId');
      } else {
        // Same value, use old (this handles case where user opens dialog and doesn't change)
        nationalityId = ProfileDataMappers.getNationalityIdByName(
            nationalityField.currentValue, nationalitiesList);
        print('DEBUG: Using old nationality ID: $nationalityId');
      }
    }

    // Handle country
    // If controller is null or text is empty, user didn't change it, so use old value
    if (countryController == null || countryController.text.isEmpty) {
      print('DEBUG: Country not changed (empty), using old value');
      countryId = ProfileDataMappers.getCountryIdByName(
          countryField.currentValue, countriesList);
      print('DEBUG: Using old country ID: $countryId');
    } else {
      // Controller has a value - check if it's different from old value
      final countryChanged =
          countryController.text.trim() != countryField.currentValue.trim();
      print('DEBUG: Country changed: $countryChanged');

      if (countryChanged) {
        // User changed country, use new value
        print('DEBUG: Looking up country name: "${countryController.text}"');
        print(
            'DEBUG: Available countries: ${countriesList.map((c) => c.name).toList()}');
        countryId = ProfileDataMappers.getCountryIdByName(
            countryController.text, countriesList);
        print('DEBUG: Using new country ID: $countryId');
      } else {
        // Same value, use old
        countryId = ProfileDataMappers.getCountryIdByName(
            countryField.currentValue, countriesList);
        print('DEBUG: Using old country ID: $countryId');
      }
    }

    // Handle city
    // If controller is null or text is empty, user didn't change it, so use old value
    if (cityController == null || cityController.text.isEmpty) {
      print('DEBUG: City not changed (empty), using old value');
      cityId = ProfileDataMappers.getCityIdByName(
          cityField.currentValue, citiesList);
      print('DEBUG: Using old city ID: $cityId');
    } else {
      // Controller has a value - check if it's different from old value
      final cityChanged =
          cityController.text.trim() != cityField.currentValue.trim();
      print('DEBUG: City changed: $cityChanged');

      if (cityChanged) {
        // User changed city, use new value
        cityId =
            ProfileDataMappers.getCityIdByName(cityController.text, citiesList);
        print('DEBUG: Using new city ID: $cityId');
      } else {
        // Same value, use old
        cityId = ProfileDataMappers.getCityIdByName(
            cityField.currentValue, citiesList);
        print('DEBUG: Using old city ID: $cityId');
      }
    }

    print(
        'DEBUG: Final IDs - Nationality: $nationalityId, Country: $countryId, City: $cityId');

    // Only proceed if we have valid IDs for all required fields
    if (nationalityId != null && countryId != null && cityId != null) {
      cubit.updateProfileLocationData(
        nationalityId: nationalityId,
        countryId: countryId,
        cityId: cityId,
      );
    }
  }
}

/// Update handler for job data
class JobUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final qualificationName =
        controllers[AppLocalizations.of(context)!.educationalQualification]
                ?.text ??
            '';
    final financialSituationName =
        controllers[AppLocalizations.of(context)!.financialStatus]?.text ?? '';
    final jobName = controllers[AppLocalizations.of(context)!.job]?.text ?? '';
    final incomeName =
        controllers[AppLocalizations.of(context)!.monthlyIncome]?.text ?? '';
    final healthConditionName =
        controllers[AppLocalizations.of(context)!.healthStatus]?.text ?? '';

    // Get IDs from names using mapping functions
    final qualificationId = ProfileDataMappers.getQualificationIdByName(
        qualificationName, generalDataLists);
    final financialSituationId =
        ProfileDataMappers.getFinancialSituationIdByName(
            financialSituationName, generalDataLists);
    final jobId = ProfileDataMappers.getJobIdByName(jobName, generalDataLists);
    final incomeId =
        ProfileDataMappers.getIncomeIdByName(incomeName, generalDataLists);
    final healthConditionId = ProfileDataMappers.getHealthConditionIdByName(
        healthConditionName, generalDataLists);

    cubit.updateProfileWorkData(
      qualificationId: qualificationId?.toString(),
      income: incomeId,
      job: jobId?.toString(),
      healthConditionId: healthConditionId?.toString(),
      financialSituationId: financialSituationId?.toString(),
    );
  }
}

/// Update handler for social status data
class SocialStatusUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final maritalStatus =
        controllers[AppLocalizations.of(context)!.maritalStatus]?.text ?? '';
    final typeOfMarriage =
        controllers[AppLocalizations.of(context)!.marriageType]?.text ?? '';
    final ageStr = controllers[AppLocalizations.of(context)!.age]?.text ?? '';
    final childrenStr =
        controllers[AppLocalizations.of(context)!.numberOfChildren]?.text ?? '';

    print('DEBUG: Social Status Update - Raw values:');
    print('DEBUG: Marital Status: "$maritalStatus"');
    print('DEBUG: Type of Marriage: "$typeOfMarriage"');
    print('DEBUG: Age: "$ageStr"');
    print('DEBUG: Children: "$childrenStr"');

    // The values should now be API keys directly from the key-value mapping
    final maritalStatusValue = maritalStatus.isNotEmpty ? maritalStatus : null;
    final typeOfMarriageValue =
        typeOfMarriage.isNotEmpty ? typeOfMarriage : null;

    print('DEBUG: Social Status Update - Mapped values:');
    print('DEBUG: Marital Status Value: "$maritalStatusValue"');
    print('DEBUG: Type of Marriage Value: "$typeOfMarriageValue"');

    // Convert strings to numbers
    int? age;
    int? childrenNumber;
    try {
      age = ageStr.isNotEmpty ? int.parse(ageStr) : null;
    } catch (e) {
      // Handle age parsing error
    }
    try {
      // If marital status is 'single', set children to 0
      // Otherwise, parse the children string
      if (maritalStatusValue == 'single') {
        print('DEBUG: Marital status is single - setting children to 0');
        childrenNumber = 0;
      } else {
        childrenNumber = childrenStr.isNotEmpty ? int.parse(childrenStr) : null;
      }
    } catch (e) {
      // Handle children number parsing error
      // If single, set to 0, otherwise null
      childrenNumber = (maritalStatusValue == 'single') ? 0 : null;
    }

    print('DEBUG: Social Status Update - Final values to send:');
    print('DEBUG: Marital Status: "$maritalStatusValue"');
    print('DEBUG: Type of Marriage: "$typeOfMarriageValue"');
    print('DEBUG: Age: "$age"');
    print('DEBUG: Children Number: "$childrenNumber"');

    cubit.updateProfileMarriageData(
      maritalStatus: maritalStatusValue,
      typeOfMarriage: typeOfMarriageValue,
      childrenNumber: childrenNumber,
      age: age,
    );
  }
}

/// Update handler for body info data
class BodyInfoUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final weightStr =
        controllers[AppLocalizations.of(context)!.weight]?.text ?? '';
    final heightStr =
        controllers[AppLocalizations.of(context)!.height]?.text ?? '';
    final skinColorName =
        controllers[AppLocalizations.of(context)!.skinColor]?.text ?? '';
    final physiqueName =
        controllers[AppLocalizations.of(context)!.physique]?.text ?? '';

    // Convert string values to integers
    int? weight = weightStr.isNotEmpty ? int.tryParse(weightStr) : null;
    int? height = heightStr.isNotEmpty ? int.tryParse(heightStr) : null;

    // Get IDs from names
    int? skinColorId = ProfileDataMappers.getSkinColorIdByName(
        skinColorName, generalDataLists);
    int? physiqueId =
        ProfileDataMappers.getPhysiqueIdByName(physiqueName, generalDataLists);

    cubit.updateProfilePhysicalData(
      weight: weight,
      height: height,
      skinColorId: skinColorId,
      physiqueId: physiqueId,
    );
  }
}

/// Update handler for education data (same as job data)
class EducationUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final qualificationName =
        controllers[AppLocalizations.of(context)!.educationalQualification]
                ?.text ??
            '';
    final financialSituationName =
        controllers[AppLocalizations.of(context)!.financialStatus]?.text ?? '';
    final jobName = controllers[AppLocalizations.of(context)!.job]?.text ?? '';
    final incomeName =
        controllers[AppLocalizations.of(context)!.monthlyIncome]?.text ?? '';
    final healthConditionName =
        controllers[AppLocalizations.of(context)!.healthStatus]?.text ?? '';

    // Get IDs from names using mapping functions
    final qualificationId = ProfileDataMappers.getQualificationIdByName(
        qualificationName, generalDataLists);
    final financialSituationId =
        ProfileDataMappers.getFinancialSituationIdByName(
            financialSituationName, generalDataLists);
    final jobId = ProfileDataMappers.getJobIdByName(jobName, generalDataLists);
    final incomeId =
        ProfileDataMappers.getIncomeIdByName(incomeName, generalDataLists);
    final healthConditionId = ProfileDataMappers.getHealthConditionIdByName(
        healthConditionName, generalDataLists);

    cubit.updateProfileWorkData(
      qualificationId: qualificationId?.toString(),
      income: incomeId,
      job: jobId?.toString(),
      healthConditionId: healthConditionId?.toString(),
      financialSituationId: financialSituationId?.toString(),
    );
  }
}

/// Update handler for descriptions data
class DescriptionsUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final aboutMe =
        controllers[AppLocalizations.of(context)!.aboutMe]?.text ?? '';
    final aboutPartner =
        controllers[AppLocalizations.of(context)!.lifePartner]?.text ?? '';

    // Update about me if field exists and is not empty
    if (aboutMe.isNotEmpty) {
      cubit.updateProfileAboutMeData(aboutMe: aboutMe);
    }

    // Update about partner if field exists and is not empty
    if (aboutPartner.isNotEmpty) {
      cubit.updateProfileAboutPartnerData(lifePartner: aboutPartner);
    }
  }
}

/// Update handler for religion data
class ReligionUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    // Get the localized field labels
    final religiousCommitmentLabel =
        AppLocalizations.of(context)!.religiousCommitment;
    final prayerLabel = AppLocalizations.of(context)!.prayer;
    final smokingLabel = AppLocalizations.of(context)!.smoking;
    final hijabLabel = AppLocalizations.of(context)!.hijabTitle;
    final beardLabel = AppLocalizations.of(context)!.beardTitle;

    print('DEBUG: Religion Update - Looking for controllers with labels:');
    print('DEBUG: Religious Commitment label: "$religiousCommitmentLabel"');
    print('DEBUG: Prayer label: "$prayerLabel"');
    print('DEBUG: Smoking label: "$smokingLabel"');
    print('DEBUG: Hijab label: "$hijabLabel"');
    print('DEBUG: Beard label: "$beardLabel"');

    // Print all available controller keys first
    print('DEBUG: All available controller keys:');
    controllers.forEach((key, controller) {
      print('DEBUG: Controller key: "$key" = "${controller.text}"');
    });

    // Get values from controllers
    final religiousCommitment =
        controllers[religiousCommitmentLabel]?.text ?? '';
    final prayer = controllers[prayerLabel]?.text ?? '';
    final smokingStr = controllers[smokingLabel]?.text ?? '';
    final hijab = controllers[hijabLabel]?.text ?? '';
    final beard = controllers[beardLabel]?.text ?? '';

    print('DEBUG: Religion Update - Raw values from controllers:');
    print('DEBUG: Religious Commitment: "$religiousCommitment"');
    print('DEBUG: Prayer: "$prayer"');
    print('DEBUG: Smoking: "$smokingStr"');
    print('DEBUG: Hijab: "$hijab"');
    print('DEBUG: Beard: "$beard"');

    // The values should now be API keys directly from the key-value mapping
    final religiousCommitmentValue =
        religiousCommitment.isNotEmpty ? religiousCommitment : null;
    final prayerValue = prayer.isNotEmpty ? prayer : null;
    final smoking = smokingStr.isNotEmpty ? int.tryParse(smokingStr) : null;
    final hijabValue = hijab.isNotEmpty ? hijab : null;
    final beardValue = beard.isNotEmpty ? beard : null;

    print('DEBUG: Religion Update - Final values to send to API:');
    print('DEBUG: Religious Commitment Value: "$religiousCommitmentValue"');
    print('DEBUG: Prayer Value: "$prayerValue"');
    print('DEBUG: Smoking Value: "$smoking"');
    print('DEBUG: Hijab Value: "$hijabValue"');
    print('DEBUG: Beard Value: "$beardValue"');

    cubit.updateProfileReligiousData(
      religiousCommitment: religiousCommitmentValue,
      prayer: prayerValue,
      smoking: smoking,
      hijab: hijabValue,
      beard: beardValue,
    );
  }
}

/// Update handler for personal info data (same as login data)
class PersonalInfoUpdateHandler extends ProfileUpdateHandler {
  @override
  void update(
    Map<String, TextEditingController> controllers,
    UpdateProfileCubit cubit,
    BuildContext context, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    final name =
        controllers[AppLocalizations.of(context)!.username]?.text ?? '';
    final email = controllers[AppLocalizations.of(context)!.email]?.text ?? '';
    final phone =
        controllers[AppLocalizations.of(context)!.phoneNumber]?.text ?? '';

    cubit.updateProfileLoginData(
      name: name.isNotEmpty ? name : null,
      email: email.isNotEmpty ? email : null,
      phone: phone.isNotEmpty ? phone : null,
      password: null,
      passwordConfirmation: null,
    );
  }
}

/// Factory class to get the appropriate update handler
class ProfileUpdateHandlerFactory {
  static ProfileUpdateHandler getHandler(ManageProfileDialogType? dialogType) {
    switch (dialogType) {
      case ManageProfileDialogType.loginData:
        return LoginDataUpdateHandler();
      case ManageProfileDialogType.nationalCountry:
        return NationalCountryUpdateHandler();
      case ManageProfileDialogType.job:
        return JobUpdateHandler();
      case ManageProfileDialogType.socialStatus:
        return SocialStatusUpdateHandler();
      case ManageProfileDialogType.bodyInfo:
        return BodyInfoUpdateHandler();
      case ManageProfileDialogType.education:
        return EducationUpdateHandler();
      case ManageProfileDialogType.descriptions:
        return DescriptionsUpdateHandler();
      case ManageProfileDialogType.religion:
        return ReligionUpdateHandler();
      case ManageProfileDialogType.personalInfo:
        return PersonalInfoUpdateHandler();
      case null:
        return LoginDataUpdateHandler(); // Default fallback
    }
  }
}
