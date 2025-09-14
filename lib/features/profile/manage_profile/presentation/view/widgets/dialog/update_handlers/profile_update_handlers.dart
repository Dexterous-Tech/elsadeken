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
    final nationalityName =
        controllers[AppLocalizations.of(context)!.nationality]?.text ?? '';
    final countryName =
        controllers[AppLocalizations.of(context)!.country]?.text ?? '';
    final cityName =
        controllers[AppLocalizations.of(context)!.city]?.text ?? '';

    // Get IDs from names using mapping functions
    final nationalityId = ProfileDataMappers.getNationalityIdByName(
        nationalityName, nationalitiesList);
    final countryId =
        ProfileDataMappers.getCountryIdByName(countryName, countriesList);
    final cityId = ProfileDataMappers.getCityIdByName(cityName, citiesList);

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
    final jobTitle = controllers[AppLocalizations.of(context)!.job]?.text ?? '';
    final monthlyIncomeStr =
        controllers[AppLocalizations.of(context)!.monthlyIncome]?.text ?? '';
    final healthConditionName =
        controllers[AppLocalizations.of(context)!.healthStatus]?.text ?? '';

    // Get IDs from names using mapping functions
    final qualificationId = ProfileDataMappers.getQualificationIdByName(
        qualificationName, generalDataLists);
    final financialSituationId =
        ProfileDataMappers.getFinancialSituationIdByName(
            financialSituationName, generalDataLists);
    final healthConditionId = ProfileDataMappers.getHealthConditionIdByName(
        healthConditionName, generalDataLists);

    // Convert income string to number
    int? income;
    try {
      income = monthlyIncomeStr.isNotEmpty ? int.parse(monthlyIncomeStr) : null;
    } catch (e) {
      print('DEBUG: Income parsing error: $e');
      income = null;
    }

    cubit.updateProfileWorkData(
      qualificationId: qualificationId?.toString(),
      income: income,
      job: jobTitle.isNotEmpty ? jobTitle : null,
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

    // Convert Arabic text to API values
    final maritalStatusValue =
        ProfileDataMappers.mapMaritalStatusToApiValue(maritalStatus);
    final typeOfMarriageValue =
        ProfileDataMappers.mapTypeOfMarriageToApiValue(typeOfMarriage);

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
      childrenNumber = childrenStr.isNotEmpty ? int.parse(childrenStr) : null;
    } catch (e) {
      // Handle children number parsing error
    }

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
    final jobTitle = controllers[AppLocalizations.of(context)!.job]?.text ?? '';
    final monthlyIncomeStr =
        controllers[AppLocalizations.of(context)!.monthlyIncome]?.text ?? '';
    final healthConditionName =
        controllers[AppLocalizations.of(context)!.healthStatus]?.text ?? '';

    // Convert income string to number
    int? income =
        monthlyIncomeStr.isNotEmpty ? int.tryParse(monthlyIncomeStr) : null;

    cubit.updateProfileWorkData(
      qualificationId: qualificationName.isNotEmpty ? qualificationName : null,
      income: income,
      job: jobTitle.isNotEmpty ? jobTitle : null,
      healthConditionId:
          healthConditionName.isNotEmpty ? healthConditionName : null,
      financialSituationId:
          financialSituationName.isNotEmpty ? financialSituationName : null,
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
    final religiousCommitment =
        controllers[AppLocalizations.of(context)!.religiousCommitment]?.text ??
            '';
    final prayer =
        controllers[AppLocalizations.of(context)!.prayer]?.text ?? '';
    final smokingStr =
        controllers[AppLocalizations.of(context)!.smoking]?.text ?? '';
    final hijab = controllers[AppLocalizations.of(context)!.hijab]?.text ?? '';
    final beard = controllers[AppLocalizations.of(context)!.beard]?.text ?? '';

    print('DEBUG: Religion Update - Raw values:');
    print('DEBUG: Religious Commitment: "$religiousCommitment"');
    print('DEBUG: Prayer: "$prayer"');
    print('DEBUG: Smoking: "$smokingStr"');
    print('DEBUG: Hijab: "$hijab"');
    print('DEBUG: Beard: "$beard"');

    // Convert localized text to API values
    final religiousCommitmentValue =
        ProfileDataMappers.mapReligiousCommitmentToApiValue(
            religiousCommitment);
    final prayerValue = ProfileDataMappers.mapPrayerToApiValue(prayer);
    final smoking = ProfileDataMappers.mapSmokingToInt(smokingStr);
    final hijabValue = ProfileDataMappers.mapHijabToApiValue(hijab);
    final beardValue = ProfileDataMappers.mapBeardToApiValue(beard);

    print('DEBUG: Religion Update - Mapped values:');
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
