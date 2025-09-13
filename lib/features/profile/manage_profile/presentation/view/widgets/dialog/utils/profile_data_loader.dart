import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

/// Utility class for loading required data for profile dialog
class ProfileDataLoader {
  /// Load all required data based on field data types
  static void loadRequiredData(
    SignUpListsCubit signUpListsCubit,
    List<ManageProfileField> fields,
  ) {
    final fieldsRequiringData = fields.where((field) => field.dataType != null);
    final Set<ManageProfileFieldDataType> dataTypesToLoad =
        fieldsRequiringData.map((field) => field.dataType!).toSet();

    for (final dataType in dataTypesToLoad) {
      switch (dataType) {
        case ManageProfileFieldDataType.nationality:
          signUpListsCubit.getNationalities();
          break;
        case ManageProfileFieldDataType.country:
          signUpListsCubit.getCountries();
          break;
        case ManageProfileFieldDataType.skinColor:
          signUpListsCubit.getSkinColors();
          break;
        case ManageProfileFieldDataType.physique:
          signUpListsCubit.getPhysiques();
          break;
        case ManageProfileFieldDataType.qualification:
          signUpListsCubit.getQualification();
          break;
        case ManageProfileFieldDataType.financialSituation:
          signUpListsCubit.getFinancialSituations();
          break;
        case ManageProfileFieldDataType.healthCondition:
          signUpListsCubit.getHealthConditions();
          break;
        case ManageProfileFieldDataType.city:
          // Cities will be loaded when country is selected
          break;
      }
    }
  }

  /// Load cities for a specific country
  static void loadCitiesForCountry(
    SignUpListsCubit signUpListsCubit,
    int countryId,
  ) {
    signUpListsCubit.getCites(countryId.toString());
  }
}
