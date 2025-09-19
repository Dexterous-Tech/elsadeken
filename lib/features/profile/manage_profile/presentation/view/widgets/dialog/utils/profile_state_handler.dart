import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/utils/profile_data_loader.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Utility class for handling state updates from cubits
class ProfileStateHandler {
  /// Handle SignUpListsState updates
  static void handleSignUpListsState(
    SignUpListsState state,
    Function() setState, {
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
  }) {
    if (state is NationalitiesSuccess) {
      nationalitiesList.clear();
      nationalitiesList.addAll(state.nationalitiesList);
      setState();
    } else if (state is CountriesSuccess) {
      countriesList.clear();
      countriesList.addAll(state.countriesList);
      setState();
    } else if (state is CitiesSuccess) {
      citiesList.clear();
      citiesList.addAll(state.citiesList);
      setState();
    } else if (state is SkinColorsSuccess) {
      generalDataLists['skinColors'] = state.generalList;
      setState();
    } else if (state is PhysiquesSuccess) {
      generalDataLists['physiques'] = state.generalList;
      setState();
    } else if (state is QualificationsSuccess) {
      generalDataLists['qualifications'] = state.generalList;
      setState();
    } else if (state is FinancialSituationsSuccess) {
      generalDataLists['financialSituations'] = state.generalList;
      setState();
    } else if (state is HealthConditionsSuccess) {
      generalDataLists['healthConditions'] = state.generalList;
      setState();
    } else if (state is IncomesSuccess) {
      generalDataLists['incomes'] = state.generalList;
      setState();
    }
  }

  /// Handle UpdateProfileState updates
  static void handleUpdateProfileState(
    BuildContext context,
    UpdateProfileState state,
  ) {
    if (state is UpdateProfileLoginDataLoading ||
        state is UpdateProfileLocationDataLoading ||
        state is UpdateProfileMarriageDataLoading ||
        state is UpdateProfilePhysicalDataLoading ||
        state is UpdateProfileReligiousDataLoading ||
        state is UpdateProfileWorkDataLoading ||
        state is UpdateProfileAboutMeDataLoading ||
        state is UpdateProfileAboutPartnerDataLoading) {
      // Show loading dialog and keep the edit dialog open in background
      loadingDialog(context);
    } else if (state is UpdateProfileLoginDataFailure ||
        state is UpdateProfileLocationDataFailure ||
        state is UpdateProfileMarriageDataFailure ||
        state is UpdateProfilePhysicalDataFailure ||
        state is UpdateProfileReligiousDataFailure ||
        state is UpdateProfileWorkDataFailure ||
        state is UpdateProfileAboutMeDataFailure ||
        state is UpdateProfileAboutPartnerDataFailure) {
      // Close loading dialog first
      Navigator.pop(context);

      // Get error message
      String errorMessage = '';
      if (state is UpdateProfileLoginDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileLocationDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileMarriageDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfilePhysicalDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileReligiousDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileWorkDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileAboutMeDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileAboutPartnerDataFailure)
        errorMessage = state.error;

      // Show error dialog
      errorDialog(
        context: context,
        error: errorMessage,
        onPressed: () {
          Navigator.pop(context); // Close error dialog
          // Edit dialog remains open for user to try again
        },
      );
    } else if (state is UpdateProfileLoginDataSuccess ||
        state is UpdateProfileLocationDataSuccess ||
        state is UpdateProfileMarriageDataSuccess ||
        state is UpdateProfilePhysicalDataSuccess ||
        state is UpdateProfileReligiousDataSuccess ||
        state is UpdateProfileWorkDataSuccess ||
        state is UpdateProfileAboutMeDataSuccess ||
        state is UpdateProfileAboutPartnerDataSuccess) {
      // Close loading dialog first
      Navigator.pop(context);

      // Show success dialog
      successDialog(
        context: context,
        message: AppLocalizations.of(context)!.dataUpdatedSuccessfully,
        onPressed: () {
          Navigator.pop(context); // Close success dialog
          Navigator.pop(context); // Close edit dialog
          // User returns to manage profile screen with updated data
        },
      );
    }
  }

  /// Handle field changes (like loading cities when country is selected)
  static void handleFieldChange(
    ManageProfileField field,
    String? value,
    BuildContext context, {
    required Map<String, TextEditingController> controllers,
    required Map<String, String?> selectedValues,
    required SignUpListsCubit? signUpListsCubit,
    required Function() setState,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
    required Map<String, dynamic> validationFlags,
  }) {
    // Handle dependent fields (like loading cities when country is selected)
    if (field.dataType == ManageProfileFieldDataType.country &&
        value != null &&
        signUpListsCubit != null) {
      // Find the country ID from the selected country name
      final countryId = _getCountryIdByName(value, countriesList);

      if (countryId != null) {
        // Load cities for the selected country
        ProfileDataLoader.loadCitiesForCountry(signUpListsCubit, countryId);

        // Reset city field when country changes
        final cityController = controllers[AppLocalizations.of(context)!.city];
        if (cityController != null) {
          cityController.clear();
          selectedValues[AppLocalizations.of(context)!.city] = null;

          // Set flag that country has changed and city needs to be selected
          validationFlags['countryChanged'] = true;
          validationFlags['citySelected'] = false;
          print('DEBUG: Country changed - flags set: $validationFlags');

          setState(); // Trigger rebuild to update UI

          // No warning snackbar here - user can choose city later
        }
      }
    } else if (field.dataType == ManageProfileFieldDataType.city &&
        value != null) {
      // When city is selected, clear the validation flag
      validationFlags['citySelected'] = true;
      print('DEBUG: City selected - flags before: $validationFlags');
      if (validationFlags['countryChanged'] == true) {
        // Clear the country changed flag since city is now selected
        validationFlags['countryChanged'] = false;
        print('DEBUG: City selected - flags after: $validationFlags');
        setState();
      }
    }
  }

  /// Check if country-city validation is required
  static bool isCountryCityValidationRequired(
      Map<String, dynamic> validationFlags) {
    print('DEBUG: Validation flags: $validationFlags');
    print('DEBUG: countryChanged: ${validationFlags['countryChanged']}');
    print('DEBUG: citySelected: ${validationFlags['citySelected']}');
    final result = validationFlags['countryChanged'] == true &&
        validationFlags['citySelected'] != true;
    print('DEBUG: Validation required: $result');
    return result;
  }

  /// Helper method to get country ID by name
  static int? _getCountryIdByName(
      String countryName, List<NationalCountryResponseModel> countriesList) {
    try {
      final country = countriesList.firstWhere(
        (country) => country.name == countryName,
      );
      return country.id;
    } catch (e) {
      print('DEBUG: Country not found: $e');
      return null;
    }
  }
}
