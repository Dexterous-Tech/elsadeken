part of 'sign_up_lists_cubit.dart';

@immutable
sealed class SignUpListsState {}

final class SignUpListsStateInitial extends SignUpListsState {}

final class NationalitiesLoading extends SignUpListsState {}

final class NationalitiesFailure extends SignUpListsState {
  final String error;

  NationalitiesFailure(this.error);
}

final class NationalitiesSuccess extends SignUpListsState {
  final List<NationalCountryResponseModel> nationalitiesList;

  NationalitiesSuccess(this.nationalitiesList);
}

final class CountriesLoading extends SignUpListsState {}

final class CountriesFailure extends SignUpListsState {
  final String error;

  CountriesFailure(this.error);
}

final class CountriesSuccess extends SignUpListsState {
  final List<NationalCountryResponseModel> countriesList;

  CountriesSuccess(this.countriesList);
}

final class CitiesLoading extends SignUpListsState {}

final class CitiesFailure extends SignUpListsState {
  final String error;

  CitiesFailure(this.error);
}

final class CitiesSuccess extends SignUpListsState {
  final List<CityResponseModels> citiesList;

  CitiesSuccess(this.citiesList);
}

final class SkinColorsLoading extends SignUpListsState {}

final class SkinColorsFailure extends SignUpListsState {
  final String error;

  SkinColorsFailure(this.error);
}

final class SkinColorsSuccess extends SignUpListsState {
  final List<GeneralInfoResponseModels> generalList;

  SkinColorsSuccess(this.generalList);
}

final class PhysiquesLoading extends SignUpListsState {}

final class PhysiquesFailure extends SignUpListsState {
  final String error;

  PhysiquesFailure(this.error);
}

final class PhysiquesSuccess extends SignUpListsState {
  final List<GeneralInfoResponseModels> generalList;

  PhysiquesSuccess(this.generalList);
}

final class QualificationsLoading extends SignUpListsState {}

final class QualificationsFailure extends SignUpListsState {
  final String error;

  QualificationsFailure(this.error);
}

final class QualificationsSuccess extends SignUpListsState {
  final List<GeneralInfoResponseModels> generalList;

  QualificationsSuccess(this.generalList);
}

final class FinancialSituationsLoading extends SignUpListsState {}

final class FinancialSituationsFailure extends SignUpListsState {
  final String error;

  FinancialSituationsFailure(this.error);
}

final class FinancialSituationsSuccess extends SignUpListsState {
  final List<GeneralInfoResponseModels> generalList;

  FinancialSituationsSuccess(this.generalList);
}

final class HealthConditionsLoading extends SignUpListsState {}

final class HealthConditionsFailure extends SignUpListsState {
  final String error;

  HealthConditionsFailure(this.error);
}

final class HealthConditionsSuccess extends SignUpListsState {
  final List<GeneralInfoResponseModels> generalList;

  HealthConditionsSuccess(this.generalList);
}
